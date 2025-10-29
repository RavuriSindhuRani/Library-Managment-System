package com.example.library.servlet;



import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import com.example.library.util.DBUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = DBUtil.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT * FROM users WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ Successful login
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                response.sendRedirect("index.jsp");
            } else {
                // ❌ Invalid credentials
                request.setAttribute("error", "Invalid username or password");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
