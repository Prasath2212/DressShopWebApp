<%@ page import="dao.SaleDAO, model.Sale, model.SaleItem" %>
<%
  String idStr = request.getParameter("id");
  if (idStr == null) { out.println("Sale ID missing"); return; }

  int id = Integer.parseInt(idStr);
  Sale sale = SaleDAO.findById(id);
  if (sale == null) { out.println("Sale not found"); return; }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Invoice</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 40px; background: #f7f9fc; }
    h2 { color: #2b5797; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background: #2b5797; color: #fff; }
    h3 { text-align: right; }
    button { background: #2b5797; color: white; border: none; padding: 8px 16px; border-radius: 5px; cursor: pointer; }
  </style>
</head>
<body>

  <h2>Invoice: <%= sale.getInvoiceNo() %></h2>
  <p>Date: <%= sale.getCreatedAt() %></p>

  <table>
    <tr><th>SKU</th><th>Name</th><th>Qty</th><th>Price</th><th>Subtotal</th></tr>
    <% for (SaleItem it : sale.getItems()) { %>
      <tr>
        <td><%= it.getProduct().getSku() %></td>
        <td><%= it.getProduct().getName() %></td>
        <td><%= it.getQuantity() %></td>
        <td><%= it.getPrice() %></td>
        <td><%= it.getPrice().multiply(new java.math.BigDecimal(it.getQuantity())) %></td>
      </tr>
    <% } %>
  </table>

  <h3>Total: <%= sale.getTotal() %></h3>
  <button onclick="window.print()">🖨️ Print</button>

</body>
</html>
