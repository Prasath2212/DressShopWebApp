<%@ page session="true" %>
<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Product - Dress Shop</title>
    <style>
        body { font-family: Poppins, sans-serif; background: #f0f9ff; margin: 0; }
        .container {
            width: 400px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; color: #00796b; margin-bottom: 25px; }
        input[type=text], input[type=number] {
            width: 100%; padding: 10px; margin: 10px 0;
            border: 1px solid #ccc; border-radius: 6px;
        }
        button {
            width: 100%; padding: 10px;
            background: #00796b; color: white;
            border: none; border-radius: 6px; font-weight: 600;
        }
        button:hover { background: #004d40; cursor: pointer; }
        .back { text-align: center; margin-top: 15px; }
        .back a { color: #00796b; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
<div class="container">
    <h2>Add New Product</h2>
    <form action="ProductServlet" method="post">
        <input type="text" name="sku" placeholder="SKU (e.g., SKU005)" required>
        <input type="text" name="name" placeholder="Product Name" required>
        <input type="text" name="price" placeholder="Price" required>
        <input type="number" name="stock" placeholder="Stock Quantity" required>
        <button type="submit">Add Product</button>
    </form>
    <div class="back"><a href="products.jsp"> Back to Products</a></div>
</div>
</body>
</html>
