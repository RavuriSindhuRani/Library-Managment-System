package com.example.library.servlet;



import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import com.example.library.util.DBUtil;

@WebServlet("/MemberServlet")
public class MemberServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");
        try (Connection conn = DBUtil.getConnection()) {
            if ("add".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO members(name, email) VALUES (?, ?)");
                ps.setString(1, req.getParameter("name"));
                ps.setString(2, req.getParameter("email"));
                ps.executeUpdate();
                res.sendRedirect("members.jsp");

            } else if ("update".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("UPDATE members SET name=?, email=? WHERE member_id=?");
                ps.setString(1, req.getParameter("name"));
                ps.setString(2, req.getParameter("email"));
                ps.setInt(3, Integer.parseInt(req.getParameter("member_id")));
                ps.executeUpdate();
                res.sendRedirect("members.jsp");

            } else if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM members WHERE member_id=?");
                ps.setInt(1, Integer.parseInt(req.getParameter("member_id")));
                ps.executeUpdate();
                res.sendRedirect("members.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        try (Connection conn = DBUtil.getConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM members");
            req.setAttribute("memberList", rs);
            RequestDispatcher rd = req.getRequestDispatcher("members.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
