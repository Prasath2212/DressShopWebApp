package Servlets;

import dao.UserDAO;
import util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
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
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(password);

        try {
            if (userDAO.userExists(username)) {
                request.setAttribute("errorMessage", "Username already exists. Please try another.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            } else if (userDAO.registerUser(username, hashedPassword)) {
                request.setAttribute("successMessage", "Registration successful! You can now login.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Something went wrong. Try again later.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
