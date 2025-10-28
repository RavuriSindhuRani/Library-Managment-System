package com.example.library.servlet;


import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import com.example.library.util.DBUtil;

@WebServlet("/TransactionServlet")
public class TransactionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");

        try (Connection conn = DBUtil.getConnection()) {

            if ("issue".equals(action)) {
                int bookId = Integer.parseInt(req.getParameter("book_id"));
                int memberId = Integer.parseInt(req.getParameter("member_id"));

                // Check if book is available
                PreparedStatement check = conn.prepareStatement("SELECT available FROM books WHERE book_id=?");
                check.setInt(1, bookId);
                ResultSet rs = check.executeQuery();

                if (rs.next() && rs.getBoolean("available")) {
                    // Insert transaction
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO transactions(book_id, member_id, issue_date) VALUES (?, ?, CURDATE())");
                    ps.setInt(1, bookId);
                    ps.setInt(2, memberId);
                    ps.executeUpdate();

                    // Mark book as unavailable
                    PreparedStatement update = conn.prepareStatement("UPDATE books SET available=FALSE WHERE book_id=?");
                    update.setInt(1, bookId);
                    update.executeUpdate();

                    // Redirect with success message
                    res.sendRedirect("transactions.jsp?msg=issued");
                    return; // Ensure no further code executes
                } else {
                    // Optional: redirect with error message if book not available
                    res.sendRedirect("transactions.jsp?msg=error");
                    return;
                }

            } else if ("return".equals(action)) {
                int transId = Integer.parseInt(req.getParameter("trans_id"));

                // Set return date
                PreparedStatement ps = conn.prepareStatement("UPDATE transactions SET return_date=CURDATE() WHERE trans_id=?");
                ps.setInt(1, transId);
                ps.executeUpdate();

                // Get book ID and issue date to calculate fine
                PreparedStatement getBook = conn.prepareStatement("SELECT book_id, issue_date FROM transactions WHERE trans_id=?");
                getBook.setInt(1, transId);
                ResultSet rs = getBook.executeQuery();

                if (rs.next()) {
                    int bookId = rs.getInt("book_id");
                    Date issueDate = rs.getDate("issue_date");

                    long days = (System.currentTimeMillis() - issueDate.getTime()) / (1000 * 60 * 60 * 24);
                    double fine = days > 14 ? (days - 14) * 2 : 0;

                    // Update fine
                    PreparedStatement fineUpdate = conn.prepareStatement("UPDATE transactions SET fine=? WHERE trans_id=?");
                    fineUpdate.setDouble(1, fine);
                    fineUpdate.setInt(2, transId);
                    fineUpdate.executeUpdate();

                    // Mark book as available
                    PreparedStatement updateBook = conn.prepareStatement("UPDATE books SET available=TRUE WHERE book_id=?");
                    updateBook.setInt(1, bookId);
                    updateBook.executeUpdate();
                }

                // Redirect with success message
                res.sendRedirect("transactions.jsp?msg=returned");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Optional: redirect with error message
            res.sendRedirect("transactions.jsp?msg=error");
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        try (Connection conn = DBUtil.getConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM transactions");
            req.setAttribute("transactionList", rs);
            RequestDispatcher rd = req.getRequestDispatcher("transactions.jsp");
            rd.forward(req, res);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
