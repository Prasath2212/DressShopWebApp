<%@ page import="model.User" %>
<%@ page session="true" %>
<%
  User user = (User) session.getAttribute("user");
  if(user == null) { 
      response.sendRedirect("login.jsp"); 
      return; 
  }
%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <title>New Sale</title>
  <link rel="stylesheet" href="assets/css/style.css"/>
  <script src="assets/js/app.js"></script>
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      background: #f9f9f9;
      padding: 20px;
    }
    h2 {
      color: #00796b;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      text-align: center;
    }
    button {
      background-color: #00796b;
      color: white;
      border: none;
      padding: 10px 16px;
      border-radius: 6px;
      cursor: pointer;
      margin-top: 10px;
    }
    button:hover {
      background-color: #004d40;
    }
    input {
      padding: 8px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    #total {
      font-weight: bold;
      color: #00796b;
    }
  </style>
</head>
<body>

  <h2>New Sale - Cashier: <%= user.getUsername() %></h2>

  <div>
    <h3>Scanner (camera)  optional</h3>
    <div id="scanner" style="width:320px;height:240px;border:1px solid #ccc"></div>
    <button onclick="startScanner()">Start Scanner</button>
  </div>

  <div>
    <h3>Manual SKU</h3>
    <input id="skuInput" placeholder="Enter SKU or barcode"/>
    <button onclick="manualAdd()">Add</button>
  </div>

  <h3>Cart</h3>
  <table id="cartTable">
    <tr><th>SKU</th><th>Name</th><th>Price</th><th>Qty</th><th>Subtotal</th></tr>
  </table>
  <p>Total: <span id="total">0.00</span></p>
  <button onclick="checkout()">Checkout</button>

  <script>

  async function manualAdd() {
    const sku = document.getElementById("skuInput").value.trim();
    if (!sku) return alert("Please enter a SKU.");

    const res = await fetch(`product?action=findBySku&sku=${sku}`);
    const product = await res.json();

    if (!product || !product.sku) {
      alert("Product not found!");
      return;
    }

    const table = document.getElementById("cartTable");
    const row = table.insertRow(-1);
    const subtotal = parseFloat(product.price).toFixed(2);

    row.innerHTML = `
      <td>${product.sku}</td>
      <td>${product.name}</td>
      <td>${product.price}</td>
      <td contenteditable="true">1</td>
      <td>${subtotal}</td>
    `;

    updateTotal();
  }


  function updateTotal() {
    const rows = document.querySelectorAll("#cartTable tr:not(:first-child)");
    let total = 0;
    rows.forEach(row => {
      const cells = row.querySelectorAll("td");
      if (cells.length > 0) {
        const price = parseFloat(cells[2].textContent);
        const qty = parseInt(cells[3].textContent);
        total += price * qty;
        cells[4].textContent = (price * qty).toFixed(2);
      }
    });
    document.getElementById("total").textContent = total.toFixed(2);
  }

  async function checkout() {
    const rows = document.querySelectorAll("#cartTable tr:not(:first-child)");
    const items = [];

    rows.forEach(row => {
      const cells = row.querySelectorAll("td");
      if (cells.length > 0) {
        const sku = cells[0].textContent;
        const name = cells[1].textContent;
        const price = parseFloat(cells[2].textContent);
        const qty = parseInt(cells[3].textContent);
        items.push({
          product: { sku, name },
          quantity: qty,
          price
        });
      }
    });

    if (items.length === 0) {
      alert("No items in cart!");
      return;
    }

    const res = await fetch("sale", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ items })
    });

    const data = await res.json();
    if (data.saleId) {
      alert(" Sale created successfully! Invoice #" + data.saleId);
      location.reload();
    } else {
      alert(" Error: " + (data.error || "Unknown error"));
    }
  }

  // Update total when qty changes
  document.addEventListener("input", (e) => {
    if (e.target.closest("#cartTable td[contenteditable]")) {
      updateTotal();
    }
  });
  </script>
</body>
</html>
