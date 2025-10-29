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
    <title>Manage Members</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="text-center mb-4 text-success">👥 Manage Members</h2>

    <!-- Add Member Form -->
    <div class="card p-4 shadow-sm mb-4">
        <h5>Add New Member</h5>
        <form action="MemberServlet" method="post" class="row g-3">
            <div class="col-md-5">
                <input type="text" name="name" class="form-control" placeholder="Member Name" required>
            </div>
            <div class="col-md-5">
                <input type="email" name="email" class="form-control" placeholder="Email" required>
            </div>
            <div class="col-md-2">
                <button type="submit" name="action" value="add" class="btn btn-success w-100">Add</button>
            </div>
        </form>
    </div>

    <!-- Members Table -->
    <div class="card p-4 shadow-sm">
        <h5>Member List</h5>
        <table class="table table-striped table-hover mt-3">
            <thead class="table-success">
                <tr>
                    <th>ID</th><th>Name</th><th>Email</th><th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection conn = DBUtil.getConnection();
                         Statement st = conn.createStatement();
                         ResultSet rs = st.executeQuery("SELECT * FROM members")) {
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("member_id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td>
                        <form action="MemberServlet" method="post" class="d-inline">
                            <input type="hidden" name="member_id" value="<%= rs.getInt("member_id") %>">
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
 