package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.*;
import dao.DBUtil;

public class SaleDAO {

    // ✅ Create new sale with invoice number
    public static int createSale(int userId, BigDecimal total, List<SaleItem> items) throws SQLException {
        Connection con = DBUtil.getConnection();
        con.setAutoCommit(false); // transactional safety

        int saleId = -1;
        try {
            // ✅ Step 1: Insert into sales table
            String sql = "INSERT INTO sales (invoice_no, user_id, total, created_at) VALUES (?, ?, ?, NOW())";
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // Unique invoice number
            String invoiceNo = "INV" + System.currentTimeMillis();

            ps.setString(1, invoiceNo);
            ps.setInt(2, userId);
            ps.setBigDecimal(3, total);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                saleId = rs.getInt(1);
            }
            rs.close();
            ps.close();

            // ✅ Step 2: Insert sale items
            // Using sku/name directly, not product_id (so manual entries also work)
            PreparedStatement psi = con.prepareStatement(
                "INSERT INTO sale_items (sale_id, sku, name, quantity, price) VALUES (?, ?, ?, ?, ?)"
            );

            for (SaleItem item : items) {
                psi.setInt(1, saleId);
                psi.setString(2, item.getSku());
                psi.setString(3, item.getName());
                psi.setInt(4, item.getQuantity());
                psi.setBigDecimal(5, item.getPrice());
                psi.addBatch();
            }

            psi.executeBatch();
            psi.close();

            con.commit();

            System.out.println("✅ Sale created successfully | Invoice: " + invoiceNo + " | Sale ID: " + saleId);

        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw new SQLException("❌ Failed to create sale", e);
        } finally {
            con.setAutoCommit(true);
            con.close();
        }

        return saleId;
    }

    // ✅ Fetch sale details by ID (for invoice display)
    public static Sale findById(int saleId) {
        Sale sale = null;
        try (Connection con = DBUtil.getConnection()) {

            // Step 1️⃣: Fetch sale record
            PreparedStatement ps = con.prepareStatement(
                "SELECT id, invoice_no, user_id, total, created_at FROM sales WHERE id = ?"
            );
            ps.setInt(1, saleId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                sale = new Sale();
                sale.setId(rs.getInt("id"));
                sale.setInvoiceNo(rs.getString("invoice_no"));
                sale.setUserId(rs.getInt("user_id"));
                sale.setTotal(rs.getBigDecimal("total"));
                sale.setCreatedAt(rs.getTimestamp("created_at"));
            }
            rs.close();
            ps.close();

            if (sale == null) return null;

            // Step 2️⃣: Fetch sale items
            PreparedStatement psi = con.prepareStatement(
                "SELECT sku, name, quantity, price FROM sale_items WHERE sale_id = ?"
            );
            psi.setInt(1, saleId);
            ResultSet rsi = psi.executeQuery();

            List<SaleItem> items = new ArrayList<>();
            while (rsi.next()) {
                SaleItem item = new SaleItem();
                item.setSku(rsi.getString("sku"));
                item.setName(rsi.getString("name"));
                item.setQuantity(rsi.getInt("quantity"));
                item.setPrice(rsi.getBigDecimal("price"));
                items.add(item);
            }

            rsi.close();
            psi.close();

            sale.setItems(items);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return sale;
    }
}
