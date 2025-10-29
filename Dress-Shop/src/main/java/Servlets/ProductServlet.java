package Servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import model.Product;
import dao.ProductDAO;
import java.io.*;
import java.math.BigDecimal;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");

        if ("findBySku".equals(action)) {
            String sku = request.getParameter("sku");
            Product p = ProductDAO.findBySku(sku);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();

            if (p == null) {
                out.print("{}");
            } else {
                out.print("{"
                        + "\"id\":" + p.getId() + ","
                        + "\"sku\":\"" + p.getSku() + "\","
                        + "\"name\":\"" + p.getName() + "\","
                        + "\"price\":" + p.getPrice()
                        + "}");
            }
            out.flush();
        } else {
            response.sendError(400, "Invalid action");
        }
    }

    // ✅ Create new product
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String sku = request.getParameter("sku");
        String name = request.getParameter("name");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stock");

        try {
            BigDecimal price = new BigDecimal(priceStr);
            int stock = Integer.parseInt(stockStr);

            Product p = new Product();
            p.setSku(sku);
            p.setName(name);
            p.setPrice(price);
            p.setStock(stock);

            boolean success = ProductDAO.createProduct(p);
            if (success) {
                response.sendRedirect("products.jsp");
            } else {
                response.getWriter().println("<h3> Failed to create product. Please try again.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
