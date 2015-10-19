
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
	String user = (String)session.getAttribute("forgotpasswordUser");
	String state = (String)session.getAttribute("forgotpasswordState");
	String answer = request.getParameter("answer");
	String answeredToken = request.getParameter("token");
	String correctToken =(String)session.getAttribute("forgotpasswordToken");
	Boolean error = false;

	if (user == null || answer == null || state == null || answeredToken == null || correctToken == null) {
		error = true;
	} else if (user.isEmpty() || answer.isEmpty() || state.isEmpty() || answeredToken.isEmpty() || correctToken.isEmpty()) {
		error = true;
	} else if (!state.equals("forgotpassword1")) {
		error = true;
	} else if (!answeredToken.equals(correctToken)) {
		error = true;
	}

	if (!error) {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/insecureCat", "catAdmin", "catPass");
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery("select answer from catlovers where uname = '" + user + "'");
		if (rs.next()) {
			String correctAnswer = rs.getString("answer");
			if (correctAnswer.equals(answer)) {
				session.setAttribute("forgotpasswordState", "resetpassword");
			%>
				<h2>Reset Password</h2>
				<form id="fm1" method="post" action="resetpasswordNow.jsp">
                    <section class="row">
                        <label>New Password</label>
                        <input type="password" name="pass" value="" />
                    </section>
					<section class="row">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPass" value="" />
                    </section>
					<section class="row btn-row">
                        <input type="submit" value="Submit" />
                        <input type="reset" value="Reset" />
					</section>
				</form>
			<%
			}
			else {
			%>
				<h2>Error wrong answer!</h2>				
			<%
			}
		} else {
		%>
			<h2>Error contact catAdmin for help.</h2>
		<%
		}
	} else {
		%>
		<h2>There was a problem with the answers provied.</h2>
		<%
		}
%>
			</div>
		</div>
	</div>
</body>
</html>