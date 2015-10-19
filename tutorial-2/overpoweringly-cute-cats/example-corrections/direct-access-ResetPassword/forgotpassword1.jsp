
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
	String catname = request.getParameter("catname");
	Boolean error = false;
	
	if (user == null || catname == null) {
		error = true;
	} else if (user.isEmpty() || catname.isEmpty()) {
		error = true;
	}
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/insecureCat", "catAdmin", "catPass");
	if (!error) {
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery("select securityQuestion from catlovers where uname = '" + user + "' and cat_name = '" + catname + "'");
		if (rs.next()) {
			session.setAttribute("forgotpasswordUser", user);
			session.setAttribute("forgotpasswordState", "forgotpassword1");
			String securityQuestion = rs.getString("securityQuestion");
			String securityQuestionString = "What is your pet's name?";
			if (securityQuestion.equals("iceCream")) {
				securityQuestionString = "What is your favorite ice cream flavor?";
			}
			if (securityQuestion.equals("cityBorn")) {
				securityQuestionString = "What city were you born?";
			}
			if (securityQuestion.equals("highSchool")) {
				securityQuestionString = "Where did you go to high school?";
			}
			%>
				<h2>Answer your security question</h2>
				<form id="fm1" method="post" action="resetpassword.jsp">
					<section class="row">
                        <label> <% out.print(securityQuestionString); %></label>
                        <input type="text" name="answer" value="" />
					</section>
					<section class="row btn-row">
                        <input type="submit" value="Submit" />
                        <input type="reset" value="Reset" />
					</section>
				</form>
			<%
		} else {
		%>
			<h2>The information does not match our records.</h2>
		<%
		}
		 st.close();
	} else {
		%>
		<h2>The user name  or cat name was empty!</h2>
		<%
		}
%>
			</div>
		</div>
	</div>
</body>
</html>
<%
 
  con.close();
%>