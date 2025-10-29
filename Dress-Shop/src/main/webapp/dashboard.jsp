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
    <title>Dashboard - Dress Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f0f7f8, #c8e6c9);
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
            color: white;
            text-decoration: none;
            background-color: #004d40;
            padding: 8px 15px;
            border-radius: 6px;
            transition: 0.3s;
        }

        .navbar a:hover {
            background-color: #00695c;
        }

        .container {
            max-width: 1000px;
            margin: 60px auto;
            text-align: center;
        }

        h2 {
            color: #333;
            font-size: 28px;
        }

        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: 0.3s;
            text-align: center;
            cursor: pointer;
        }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .card img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            margin-bottom: 15px;
            transition: transform 0.3s;
        }

        .card:hover img {
            transform: scale(1.1);
        }

        .card a {
            text-decoration: none;
            color: #00796b;
            font-size: 18px;
            font-weight: 600;
            display: block;
            margin-top: 10px;
        }

        .logout {
            margin-top: 60px;
        }

        .logout a {
            background-color: #e53935;
            color: white;
            padding: 12px 25px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }

        .logout a:hover {
            background-color: #c62828;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>Dress Shop Dashboard</h1>
        <a href="logout.jsp">Logout</a>
    </div>

    <div class="container">
        <h2>Welcome, <%= username %> </h2>
        <p>Choose an option to manage your shop efficiently:</p>

        <div class="card-container">
            <div class="card" onclick="window.location='products.jsp'">
                <img src="https://cdn-icons-png.flaticon.com/512/1170/1170678.png" alt="Products">
                <a href="products.jsp">View Products</a>
            </div>

            <div class="card" onclick="window.location='sale.jsp'">
                <img src="https://cdn-icons-png.flaticon.com/512/2331/2331970.png" alt="Sale">
                <a href="sale.jsp">Create Sale</a>
            </div>

            <div class="card" onclick="window.location='invoice.jsp'">
                <img src="https://cdn-icons-png.flaticon.com/512/138/138281.png" alt="Invoice">
                <a href="invoice.jsp">View Invoice</a>
            </div>

            <div class="card" onclick="window.location='profile.jsp'">
                <img src="https://cdn-icons-png.flaticon.com/512/456/456212.png" alt="Profile">
                <a href="profile.jsp">My Profile</a>
            </div>

            <div class="card" onclick="window.location='barcodeBilling.jsp'">
                <img src="https://cdn-icons-png.flaticon.com/512/991/991952.png" alt="Barcode Billing">
                <a href="barcodeBilling.jsp">Barcode Billing</a>
            </div>
        </div>

        <div class="logout">
            <a href="logout.jsp">Logout</a>
        </div>
    </div>
</body>
</html>
