<%@ page import="java.util.*, dao.ProductDAO, model.Product" %>
<%@ page session="true" %>
<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}
List<Product> products = ProductDAO.listAll();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Products & Billing - Dress Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f9ff, #cbf3f0);
            margin: 0;
            padding: 0;
        }
        .navbar {
            background-color: #00796b;
            color: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .navbar h1 {
            font-size: 24px;
            margin: 0;
        }
        .navbar a {
            background-color: #004d40;
            color: white;
            padding: 8px 15px;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.3s;
        }
        .navbar a:hover {
            background-color: #00695c;
        }
        .container {
            width: 90%;
            max-width: 1100px;
            margin: 40px auto;
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #00796b;
            font-size: 28px;
            margin-bottom: 10px;
        }
        .subtitle {
            text-align: center;
            color: #555;
            font-size: 16px;
            margin-bottom: 30px;
        }
        .add-btn {
            display: inline-block;
            background-color: #00796b;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
            margin-bottom: 30px;
        }
        .add-btn:hover {
            background-color: #004d40;
        }
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
            gap: 30px;
        }
        .product-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
            transition: all 0.3s ease;
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: contain;
            margin-bottom: 15px;
            border-radius: 8px;
        }
        .product-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .product-sku {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .product-price {
            font-size: 16px;
            color: #00796b;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .product-stock {
            font-size: 14px;
            color: #444;
        }

        /* Billing Section */
        .billing-section {
            margin-top: 60px;
            text-align: center;
        }
        .billing-inputs input {
            padding: 8px;
            margin: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        .billing-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .billing-table th, .billing-table td {
            border: 1px solid #ddd;
            padding: 10px;
        }
        .billing-table th {
            background-color: #00796b;
            color: white;
        }
        .total-box {
            margin-top: 15px;
            font-size: 18px;
            font-weight: 600;
            text-align: right;
        }
        .checkout-btn {
            margin-top: 10px;
            padding: 10px 25px;
            border: none;
            border-radius: 6px;
            background-color: #00796b;
            color: white;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Dress Shop Products</h1>
        <a href="dashboard.jsp">Dashboard</a>
    </div>

    <div class="container">
        <h2>Available Products</h2>
        <p class="subtitle">Explore all items currently available in stock.</p>
        <div style="text-align:center;">
            <a href="createproduct.jsp" class="add-btn">Add New Product</a>
        </div>

        <% if (products != null && !products.isEmpty()) { %>
        <div class="product-grid">
            <% for(Product p : products) { %>
            <div class="product-card">
                <img src="https://cdn-icons-png.flaticon.com/512/3534/3534033.png" class="product-image">
                <div class="product-name"><%= p.getName() %></div>
                <div class="product-sku">SKU: <%= p.getSku() %></div>
                <div class="product-price"><%= p.getPrice() %></div>
                <div class="product-stock">Stock: <%= p.getStock() %> pcs</div>
            </div>
            <% } %>
        </div>
        <% } else { %>
        <div class="no-products">
            <p>No products found. Please add some products to your inventory.</p>
        </div>
        <% } %>

        <!--  Billing Section -->
        <div class="billing-section">
            <h2>Billing Section</h2>
            <div class="billing-inputs">
                <input type="text" id="sku" placeholder="Enter SKU">
                <input type="text" id="name" placeholder="Name" readonly>
                <input type="number" id="price" placeholder="Price" readonly>
                <input type="number" id="qty" value="1" min="1">
                <button id="addBtn" class="checkout-btn">Add</button>
            </div>

            <table class="billing-table" id="billTable">
                <thead>
                    <tr>
                        <th>SKU</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Qty</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>

            <div class="total-box">
                Total: <span id="totalAmount">0.00</span>
            </div>
            <button class="checkout-btn">Checkout</button>
        </div>
    </div>

    <script>
        let total = 0;

        // Fetch product by SKU
        document.getElementById("sku").addEventListener("change", function() {
            const sku = this.value.trim();
            if (sku === "") return;

            fetch(`ProductServlet?action=findBySku&sku=${sku}`)
                .then(res => res.json())
                .then(data => {
                    if (data && data.name) {
                        document.getElementById("name").value = data.name;
                        document.getElementById("price").value = data.price;
                    } else {
                        alert("Product not found!");
                        document.getElementById("name").value = "";
                        document.getElementById("price").value = "";
                    }
                })
                .catch(() => alert("Error fetching product details."));
        });

        // Add to bill
        document.getElementById("addBtn").addEventListener("click", function() {
            const sku = document.getElementById("sku").value.trim();
            const name = document.getElementById("name").value;
            const price = parseFloat(document.getElementById("price").value);
            const qty = parseInt(document.getElementById("qty").value);

            if (!sku || !name || isNaN(price) || qty <= 0) {
                alert("Please enter valid product details.");
                return;
            }

            const subtotal = price * qty;
            total += subtotal;

            const row = `
                <tr>
                    <td>${sku}</td>
                    <td>${name}</td>
                    <td>${price.toFixed(2)}</td>
                    <td>${qty}</td>
                    <td>${subtotal.toFixed(2)}</td>
                </tr>`;
            document.querySelector("#billTable tbody").insertAdjacentHTML("beforeend", row);
            document.getElementById("totalAmount").innerText = total.toFixed(2);

            // Clear SKU input
            document.getElementById("sku").value = "";
            document.getElementById("name").value = "";
            document.getElementById("price").value = "";
            document.getElementById("qty").value = 1;
        });
    </script>
</body>
</html>
