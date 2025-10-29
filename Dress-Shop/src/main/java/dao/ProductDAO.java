package dao;

import model.Product;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class ProductDAO {

    //  Get all products
    public static List<Product> listAll() {
        List<Product> list = new ArrayList<>();
        try (Connection c = DBUtil.getConnection()) {
            ResultSet rs = c.createStatement().executeQuery("SELECT * FROM products");
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setSku(rs.getString("sku"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setStock(rs.getInt("stock"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    
    public static Product findBySku(String sku) {
        if (sku == null || sku.trim().isEmpty()) return null;

        try (Connection c = DBUtil.getConnection()) {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM products WHERE LOWER(sku) = LOWER(?)");
            ps.setString(1, sku.trim());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setSku(rs.getString("sku"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setStock(rs.getInt("stock"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    
    
    
	/*
	 * // ✅ Find product by SKU public static Product findBySku(String sku) { try
	 * (Connection c = DBUtil.getConnection()) { PreparedStatement ps =
	 * c.prepareStatement("SELECT * FROM products WHERE sku = ?"); ps.setString(1,
	 * sku); ResultSet rs = ps.executeQuery(); if (rs.next()) { Product p = new
	 * Product(); p.setId(rs.getInt("id")); p.setSku(rs.getString("sku"));
	 * p.setName(rs.getString("name")); p.setPrice(rs.getBigDecimal("price"));
	 * p.setStock(rs.getInt("stock")); return p; } } catch (Exception e) {
	 * e.printStackTrace(); } return null; }
	 */
    
    
    
    
 // ✅ Create new product
    public static boolean createProduct(Product product) {
        String sql = "INSERT INTO products (sku, name, price, stock) VALUES (?, ?, ?, ?)";
        try (Connection c = DBUtil.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, product.getSku());
            ps.setString(2, product.getName());
            ps.setBigDecimal(3, product.getPrice());
            ps.setInt(4, product.getStock());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    //  Find product by ID (needed for invoices)
    public static Product findById(int id) {
        try (Connection c = DBUtil.getConnection()) {
            PreparedStatement ps = c.prepareStatement("SELECT * FROM products WHERE id = ?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setSku(rs.getString("sku"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setStock(rs.getInt("stock"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Decrease stock safely
    public static boolean decreaseStock(int productId, int qty) throws SQLException {
        try (Connection c = DBUtil.getConnection()) {
            PreparedStatement ps = c.prepareStatement(
                "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?"
            );
            ps.setInt(1, qty);
            ps.setInt(2, productId);
            ps.setInt(3, qty);
            int updated = ps.executeUpdate();
            return updated > 0;
        }
    }
}
