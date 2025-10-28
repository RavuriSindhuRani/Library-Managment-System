package com.example.library.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.example.library.util.DBUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/BookServlet")
public class BookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");
        Connection conn = DBUtil.getConnection();

        try {
            if ("add".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("INSERT INTO books(title, author, available) VALUES (?, ?, TRUE)");
                ps.setString(1, req.getParameter("title"));
                ps.setString(2, req.getParameter("author"));
                ps.executeUpdate();
                res.sendRedirect("books.jsp");

            } else if ("update".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("UPDATE books SET title=?, author=? WHERE book_id=?");
                ps.setString(1, req.getParameter("title"));
                ps.setString(2, req.getParameter("author"));
                ps.setInt(3, Integer.parseInt(req.getParameter("book_id")));
                ps.executeUpdate();
                res.sendRedirect("books.jsp");

            } else if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM books WHERE book_id=?");
                ps.setInt(1, Integer.parseInt(req.getParameter("book_id")));
                ps.executeUpdate();
                res.sendRedirect("books.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        try (Connection conn = DBUtil.getConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM books");
            req.setAttribute("bookList", rs);
            RequestDispatcher rd = req.getRequestDispatcher("books.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
