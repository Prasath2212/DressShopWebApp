package Servlets;

import java.io.*;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;

import com.google.gson.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import dao.ProductDAO;
import dao.SaleDAO;
import model.SaleItem;
import model.Product;
import model.User;

@WebServlet("/SalesServlet")
public class SalesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // ✅ 1. Validate session
            User user = (User) request.getSession().getAttribute("user");
            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"error\":\"User not logged in\"}");
                return;
            }

            // ✅ 2. Parse JSON body
            BufferedReader reader = request.getReader();
            JsonObject jsonBody = gson.fromJson(reader, JsonObject.class);
            JsonArray itemsArray = jsonBody.getAsJsonArray("items");

            List<SaleItem> items = new ArrayList<>();
            BigDecimal total = BigDecimal.ZERO;

            // ✅ 3. Loop through all items from frontend
            for (JsonElement el : itemsArray) {
                JsonObject obj = el.getAsJsonObject();

                String sku = obj.get("sku").getAsString();
                String name = obj.get("name").getAsString();
                int qty = obj.get("quantity").getAsInt();
                BigDecimal price = obj.get("price").getAsBigDecimal();

                Product p = ProductDAO.findBySku(sku);

                SaleItem item = new SaleItem();

                if (p != null) {
                    // ✅ Product found in DB
                    item.setProductId(p.getId());
                    item.setSku(p.getSku());
                    item.setName(p.getName());

                    // Optional: Decrease stock if enabled
                    try {
                        ProductDAO.decreaseStock(p.getId(), qty);
                    } catch (Exception ex) {
                        System.err.println("⚠️ Stock update failed for SKU: " + sku);
                    }
                } else {
                    // ✅ Manual entry (not in DB)
                    item.setProductId(0);
                    item.setSku(sku);
                    item.setName(name);
                }

                item.setQuantity(qty);
                item.setPrice(price);
                items.add(item);

                total = total.add(price.multiply(BigDecimal.valueOf(qty)));
            }

            if (items.isEmpty()) {
                out.print("{\"error\":\"No valid products to save\"}");
                return;
            }

            // ✅ 4. Save to DB
            int saleId = SaleDAO.createSale(user.getId(), total, items);

            // ✅ 5. Return JSON
            out.print("{\"success\":true, \"saleId\":" + saleId + "}");

        } catch (SQLException e) {
            e.printStackTrace();
            out.print("{\"error\":\"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
