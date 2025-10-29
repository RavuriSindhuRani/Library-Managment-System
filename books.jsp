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
    <title>Manage Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="text-center mb-4 text-primary">📚 Manage Books</h2>

    <!-- Add Book Form -->
    <div class="card p-4 shadow-sm mb-4">
        <h5>Add New Book</h5>
        <form action="BookServlet" method="post" class="row g-3">
            <div class="col-md-5">
                <input type="text" name="title" class="form-control" placeholder="Book Title" required>
            </div>
            <div class="col-md-5">
                <input type="text" name="author" class="form-control" placeholder="Author" required>
            </div>
            <div class="col-md-2">
                <button type="submit" name="action" value="add" class="btn btn-success w-100">Add</button>
            </div>
        </form>
    </div>

    <!-- Book Table -->
    <div class="card p-4 shadow-sm">
        <h5>Book List</h5>
        <table class="table table-striped table-hover mt-3">
            <thead class="table-primary">
                <tr>
                    <th>ID</th><th>Title</th><th>Author</th><th>Available</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBUtil.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery("SELECT * FROM books")) {
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("book_id") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("author") %></td>
                    <td><%= rs.getBoolean("available") ? "✅" : "❌" %></td>
                    <td>
                        <form action="BookServlet" method="post" class="d-inline">
                            <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                            <button type="submit" name="action" value="delete" class="btn btn-danger btn-sm">Delete</button>
                        </form>
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
 
</body>
</html>
    