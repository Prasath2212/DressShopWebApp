<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
    <style>
        body { font-family: Arial; background-color: #f7f9fc; }
        .container { width: 400px; margin: 100px auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
        h2 { text-align: center; }
        input { width: 100%; padding: 10px; margin: 8px 0; }
        button { width: 100%; padding: 10px; background-color: #007bff; border: none; color: white; font-size: 16px; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        .msg { text-align: center; color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Create Account</h2>
        <form action="RegisterServlet" method="post">
            <input type="text" name="username" placeholder="Enter Username" required>
            <input type="password" name="password" placeholder="Enter Password" required>
            <button type="submit">Register</button>
        </form>

        <div class="msg">
            <% if (request.getAttribute("errorMessage") != null) { %>
                <p><%= request.getAttribute("errorMessage") %></p>
            <% } else if (request.getAttribute("successMessage") != null) { %>
                <p class="success"><%= request.getAttribute("successMessage") %></p>
            <% } %>
        </div>

        <p style="text-align:center;">Already have an account? <a href="login.jsp">Login</a></p>
    </div>
</body>
</html>
