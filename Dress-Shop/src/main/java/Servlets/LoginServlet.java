package Servlets;

import dao.UserDAO;
import util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Username and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(password);

        try {
            if (userDAO.validate(username, hashedPassword)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                response.sendRedirect("dashboard.jsp");

            } else if (!userDAO.userExists(username)) {
                request.setAttribute("errorMessage", "User not found. Please register first.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);

            } else {
                request.setAttribute("errorMessage", "Invalid password. Please try again.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Something went wrong. Try again later.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
