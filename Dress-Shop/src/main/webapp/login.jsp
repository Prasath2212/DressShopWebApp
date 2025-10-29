<%@ page session="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dress-Shop Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #74ebd5, #ACB6E5);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            padding: 40px 35px;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 400px;
            text-align: center;
            backdrop-filter: blur(10px);
            animation: fadeIn 0.8s ease-in-out;
        }

        h2 {
            color: #00796b;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .icon {
            width: 60px;
            margin-bottom: 10px;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: stretch;
        }

        label {
            text-align: left;
            margin-bottom: 6px;
            font-weight: 600;
            color: #444;
        }

        input[type="text"], input[type="password"] {
            padding: 12px;
            margin-bottom: 18px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #00796b;
            box-shadow: 0 0 6px rgba(0,121,107,0.3);
        }

        input[type="submit"] {
            background-color: #00796b;
            color: white;
            border: none;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }

        input[type="submit"]:hover {
            background-color: #004d40;
            transform: translateY(-2px);
        }

        .error {
            color: #d32f2f;
            font-weight: bold;
            text-align: center;
            margin-top: 15px;
        }

        .footer {
            margin-top: 20px;
            color: #666;
            font-size: 14px;
        }

        .footer a {
            color: #00796b;
            text-decoration: none;
            font-weight: 600;
        }

        .footer a:hover {
            text-decoration: underline;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 480px) {
            .container {
                padding: 30px 25px;
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="https://cdn-icons-png.flaticon.com/512/679/679720.png" alt="Login Icon" class="icon">
        <h2>Dress Shop Login</h2>
        
        <form action="login" method="post">
            <label for="username"> Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>

            <label for="password"> Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>

            <input type="submit" value="Login">
        </form>

        <% String errorMessage = (String) request.getAttribute("errorMessage");
           if (errorMessage != null) { %>
               <p class="error"><%= errorMessage %></p>
        <% } %>

        <div class="footer">
            <p>New here? <a href="register.jsp">Create an account</a></p>
        </div>
    </div>
</body>
</html>
