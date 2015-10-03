
<%@ page import ="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<html>
<head>
<title>Public area</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/main.css">
</head>
<body id="cas">
	<div id="container">
		<jsp:include page="/header.jsp" />
		<div id="content">
			<div class="box" id="login">		
<%
    String user = request.getParameter("uname");    

    Boolean error = false;

	if (user.isEmpty()) {
		error = true;
	}

	if (!error) {	
    	Class.forName("com.mysql.jdbc.Driver");
    	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/insecureCat",
            "catAdmin", "catPass");
    	Statement st = con.createStatement();
        ResultSet rs = st.executeUpdate("select securityQuestion from catlovers where uname = '" + user + "'");
    	while (rs.next()) {
            String securityQuestion = rs.getString("securityQuestion");
			%>
				<h2>Answer your security question</h2>
				<form id="fm1" method="post" action="resetpassword.jsp">
					<section class="row">
                        <label> <% securityQuestion %></label>
                        <input type="text" name="answer" value="" />
					</section>
					<section class="row btn-row">
						<input type="hidden" name="uname" value="<% user %>" />
                        <input type="submit" value="Submit" />
                        <input type="reset" value="Reset" />
					</section>
				</form>
			<%
    	} else {
			%>
        	<h2>No such user has been registered!</h2>
			<%
    	}
	} else {
		%>
		<h2>The user name was empty!</h2>
		<%
		}
%>
			</div>
		</div>
	</div>
</body>
</html>