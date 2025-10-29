<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.example.library.util.DBUtil" %>
<%@ include file="navbar.jsp" %>
<%
  String user = (String) session.getAttribute("username");
  if (user == null) {
      response.sendRedirect("Login.jsp");
  }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Transactions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="text-center mb-4 text-warning">🔁 Manage Transactions</h2>

    <%-- Success Messages --%>
    <%
        String msg = request.getParameter("msg");
        if ("issued".equals(msg)) {
    %>
        <div class="alert alert-success text-center" role="alert">
            ✅ Book issued successfully!
        </div>
    <%
        } else if ("returned".equals(msg)) {
    %>
        <div class="alert alert-info text-center" role="alert">
            🔁 Book returned successfully!
        </div>
    <%
        }
    %>

    <!-- Issue Book Form -->
    <div class="card p-4 shadow-sm mb-4">
        <h5>Issue Book</h5>
        <form action="TransactionServlet" method="post" class="row g-3">
            <div class="col-md-4">
                <input type="number" name="book_id" class="form-control" placeholder="Book ID" required>
            </div>
            <div class="col-md-4">
                <input type="number" name="member_id" class="form-control" placeholder="Member ID" required>
            </div>
            <div class="col-md-2">
                <button type="submit" name="action" value="issue" class="btn btn-warning text-white w-100">Issue</button>
            </div>
        </form>
    </div>

    <!-- Transaction Table -->
    <div class="card p-4 shadow-sm">
        <h5>Transaction History</h5>
        <table class="table table-striped table-hover mt-3">
            <thead class="table-warning">
                <tr>
                    <th>ID</th><th>Book ID</th><th>Member ID</th><th>Issue Date</th><th>Return Date</th><th>Fine</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBUtil.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery("SELECT * FROM transactions")) {

                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("trans_id") %></td>
                    <td><%= rs.getInt("book_id") %></td>
                    <td><%= rs.getInt("member_id") %></td>
                    <td><%= rs.getDate("issue_date") %></td>
                    <td><%= rs.getDate("return_date") %></td>
                    <td><%= rs.getDouble("fine") %></td>
                    <td>
                        <%-- Show return button only if book not yet returned --%>
                        <% if (rs.getDate("return_date") == null) { %>
                        <form action="TransactionServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="return">
                            <input type="hidden" name="trans_id" value="<%= rs.getInt("trans_id") %>">
                            <button type="submit" class="btn btn-sm btn-success">Return</button>
                        </form>
                        <% } else { %>
                        <span class="text-muted">Returned</span>
                        <% } %>
                    </td>
                </tr>
                <% } } catch(Exception e) { e.printStackTrace(); } %>
            </tbody>
        </table>
    </div>

    <div class="text-center mt-4">
        <a href="index.jsp" class="btn btn-secondary">⬅ Back to Home</a>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
                   