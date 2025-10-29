<%@ page import="java.util.*, dao.ProductDAO, model.Product" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Barcode Billing - Dress Shop</title>
    <script src="https://unpkg.com/html5-qrcode"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
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
        .navbar h1 { font-size: 22px; margin: 0; }
        .navbar a {
            color: white; background-color: #004d40; padding: 8px 15px;
            border-radius: 6px; text-decoration: none; transition: 0.3s;
        }
        .navbar a:hover { background-color: #00695c; }
        .container {
            width: 90%; max-width: 1000px; margin: 40px auto;
            background: white; padding: 30px; border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
        }
        h2 { text-align: center; color: #00796b; margin-bottom: 30px; }
        #reader { width: 280px; margin: 0 auto; display: none; }
        .controls { text-align: center; margin-bottom: 20px; }
        .controls button {
            background-color: #00796b; color: white; border: none;
            padding: 10px 20px; margin: 5px; border-radius: 6px;
            cursor: pointer; font-weight: 600; transition: 0.3s;
        }
        .controls button:hover { background-color: #004d40; }
        #manualInput {
            display: flex; justify-content: center; gap: 10px; flex-wrap: wrap;
            margin-bottom: 20px;
        }
        #manualInput input {
            padding: 8px; border-radius: 6px; border: 1px solid #ccc;
        }
        #manualInput button {
            background-color: #00796b; color: white; border: none;
            padding: 8px 15px; border-radius: 6px; cursor: pointer; font-weight: 600;
        }
        table { width: 100%; border-collapse: collapse; margin-bottom: 15px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #00796b; color: white; }
        #total {
            text-align: right; font-size: 18px; font-weight: bold; margin: 15px;
        }
        #scan-result { text-align: center; margin: 15px; color: #333; font-weight: bold; }
    </style>
</head>
<body>

    <div class="navbar">
        <h1>Barcode Billing System</h1>
        <a href="dashboard.jsp">Dashboard</a>
    </div>

    <div class="container">
        <h2>Billing Section</h2>

        <div class="controls">
            <button id="startScanBtn" onclick="startScanner()">Start Scanner</button>
            <button id="stopScanBtn" style="display:none;" onclick="stopScanner()">Stop Scanner</button>
        </div>

        <div id="reader"></div>
        <p id="scan-result"></p>

        <!-- Manual Entry Section -->
        <div id="manualInput">
            <input type="text" id="manualSku" placeholder="SKU">
            <input type="text" id="manualName" placeholder="Name">
            <input type="number" id="manualPrice" placeholder="Price" step="0.01">
            <input type="number" id="manualQty" placeholder="Qty" value="1" min="1">
            <button onclick="addManualProduct()">Add</button>
        </div>

        <!-- Table -->
        <table id="cartTable">
            <tr>
                <th>SKU</th>
                <th>Name</th>
                <th>Price</th>
                <th>Qty</th>
                <th>Subtotal</th>
            </tr>
        </table>

        <div id="total">Total: 0.00</div>

        <div style="text-align:center;">
            <button onclick="checkout()">Checkout</button>
        </div>
    </div>

    <!-- ======== SCRIPT SECTION ======== -->
    <script>
    let html5QrCode;

    // ========== Barcode Scanner ==========
    async function startScanner() {
      if (!html5QrCode) html5QrCode = new Html5Qrcode("reader");
      document.getElementById("reader").style.display = "block";
      document.getElementById("startScanBtn").style.display = "none";
      document.getElementById("stopScanBtn").style.display = "inline";

      try {
        await html5QrCode.start(
          { facingMode: "environment" },
          { fps: 10, qrbox: { width: 250, height: 250 } },
          async (decodedText) => {
            document.getElementById("scan-result").innerText = "Scanned: " + decodedText;
            await addProductToCart(decodedText);
          }
        );
      } catch (err) {
        console.error("Error starting scanner:", err);
        alert("Failed to access camera. Please allow permission.");
      }
    }

    async function stopScanner() {
      if (html5QrCode) {
        await html5QrCode.stop();
        document.getElementById("reader").style.display = "none";
        document.getElementById("startScanBtn").style.display = "inline";
        document.getElementById("stopScanBtn").style.display = "none";
        document.getElementById("scan-result").innerText = "";
      }
    }

    // ========== Product Add (Scanner) ==========
    async function addProductToCart(sku) {
      try {
        const res = await fetch(`ProductServlet?action=findBySku&sku=${sku}`);
        const product = await res.json();

        if (!product || !product.sku) {
          alert("Product not found!");
          return;
        }
        insertRow(product.sku, product.name, parseFloat(product.price), 1);
      } catch (e) {
        console.error(e);
        alert("Error fetching product details.");
      }
    }

    //  FIXED MANUAL ADD FUNCTION
    function addManualProduct() {
      const sku = document.getElementById("manualSku").value.trim();
      const name = document.getElementById("manualName").value.trim();
      const priceStr = document.getElementById("manualPrice").value.trim();
      const qtyStr = document.getElementById("manualQty").value.trim();

      const price = parseFloat(priceStr);
      const qty = parseInt(qtyStr);

      if (!sku || !name || isNaN(price) || isNaN(qty) || price <= 0 || qty <= 0) {
        alert("Please enter valid product details (non-empty and positive numbers).");
        return;
      }

      insertRow(sku, name, price, qty);

      document.getElementById("manualSku").value = "";
      document.getElementById("manualName").value = "";
      document.getElementById("manualPrice").value = "";
      document.getElementById("manualQty").value = 1;
      document.getElementById("manualSku").focus();
    }

    // ========== Add Row & Merge Duplicates ==========
    function insertRow(sku, name, price, qty) {
      const table = document.getElementById("cartTable");
      const rows = Array.from(table.rows).slice(1);
      let existingRow = rows.find(r => r.cells[0].textContent === sku);

      if (existingRow) {
        const oldQty = parseInt(existingRow.cells[3].textContent);
        const newQty = oldQty + qty;
        existingRow.cells[3].textContent = newQty;
        existingRow.cells[4].textContent = (price * newQty).toFixed(2);
      } else {
        const row = table.insertRow(-1);
        const subtotal = (price * qty).toFixed(2);
        row.innerHTML = `
          <td>${sku}</td>
          <td>${name}</td>
          <td>${price.toFixed(2)}</td>
          <td contenteditable="true">${qty}</td>
          <td>${subtotal}</td>
        `;
      }

      updateTotal();
    }

    // ========== Update Total ==========
    function updateTotal() {
      const rows = document.querySelectorAll("#cartTable tr:not(:first-child)");
      let total = 0;
      rows.forEach(row => {
        const cells = row.querySelectorAll("td");
        const price = parseFloat(cells[2].textContent);
        const qty = parseInt(cells[3].textContent);
        const subtotal = price * qty;
        cells[4].textContent = subtotal.toFixed(2);
        total += subtotal;
      });
      document.getElementById("total").textContent = "Total: " + total.toFixed(2);
    }

    // ========== Checkout ==========
    async function checkout() {
      const rows = document.querySelectorAll("#cartTable tr:not(:first-child)");
      const items = [];

      rows.forEach(row => {
        const cells = row.querySelectorAll("td");
        items.push({
          sku: cells[0].textContent,
          name: cells[1].textContent,
          price: parseFloat(cells[2].textContent),
          quantity: parseInt(cells[3].textContent),
          subtotal: parseFloat(cells[4].textContent)
        });
      });

      if (items.length === 0) return alert("No items in cart!");

      const res = await fetch("SalesServlet", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ items })
      });

      const data = await res.json();
      if (data.saleId) {
        alert("Sale successful! Invoice #" + data.saleId);
        generateInvoice(data.saleId, items);
        location.reload();
      } else {
        alert("Error: " + (data.error || "Unknown issue"));
      }
    }

    // ========== PDF Invoice ==========
    function generateInvoice(invoiceNo, items) {
      const { jsPDF } = window.jspdf;
      const doc = new jsPDF();
      const username = "<%= username %>";
      const date = new Date().toLocaleString();
      let y = 20;

      doc.setFontSize(18);
      doc.text("INVOICE", 90, y);
      y += 10;

      doc.setFontSize(12);
      doc.text("Barcode Billing System", 14, y); y += 6;
      doc.text("Cashier: " + username, 14, y); y += 6;
      doc.text("Date: " + date, 14, y); y += 6;
      doc.text("Invoice No: " + invoiceNo, 14, y); y += 10;

      doc.text("SKU", 14, y);
      doc.text("Name", 50, y);
      doc.text("Qty", 120, y);
      doc.text("Price", 140, y);
      doc.text("Subtotal", 170, y);
      y += 8;
      doc.line(14, y, 200, y);
      y += 8;

      let total = 0;
      items.forEach(item => {
        doc.text(item.sku, 14, y);
        doc.text(item.name.substring(0, 20), 50, y);
        doc.text(String(item.quantity), 120, y);
        doc.text(item.price.toFixed(2), 140, y);
        doc.text(item.subtotal.toFixed(2), 170, y);
        total += item.subtotal;
        y += 8;
      });

      y += 10;
      doc.line(14, y, 200, y);
      y += 10;
      doc.setFontSize(14);
      doc.text("Total: " + total.toFixed(2), 150, y);
      y += 20;
      doc.setFontSize(10);
      doc.text("Thank you for shopping with us!", 70, y);
      doc.save(`Invoice_${invoiceNo}.pdf`);
    }

    document.addEventListener("input", e => {
      if (e.target.closest("#cartTable td[contenteditable]")) updateTotal();
    });
    </script>
</body>
</html>
