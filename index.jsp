<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<%@ include file="navbar.jsp" %>

<div class="container text-center mt-5">
    <h1 class="display-5 text-primary mb-4">Welcome to the Library Management System</h1>
    <p class="lead text-secondary mb-5">
        Manage books, members, and transactions efficiently with an easy-to-use web interface.
    </p>

    <div class="row justify-content-center">
        <div class="col-md-3 mb-3">
            <a href="books.jsp" class="btn btn-outline-primary btn-lg w-100">📖Manage Books</a>
        </div>
        <div class="col-md-3 mb-3">
            <a href="members.jsp" class="btn btn-outline-success btn-lg w-100">👥 Manage Members</a>
        </div>
        <div class="col-md-3 mb-3">
            <a href="transactions.jsp" class="btn btn-outline-warning btn-lg w-100">🔁 Manage Transactions</a>
        </div>
    </div>

    <footer class="mt-5 text-muted">
        <p>Developed using JSP, Servlets, and JDBC</p>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
    