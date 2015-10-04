<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%
	response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Protected area</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/main.css">
</head>
<body id="cas">
	<div id="container">
		<jsp:include page="/header.jsp" />
		<div id="content">
			<div class="box" id="login">
				<h2>PROTECTED AREA</h2>

				<h3>Single Sign On data</h3>
				<dl>
					<dt>Your user name:</dt>
					<dd><%= request.getRemoteUser()== null ? "null" : request.getRemoteUser() %></dd>
				</dl>

				<h3>Your Private Cat Picture</h3>
				<dl>
					<dt>A cute cat: </dt>
					<dd><img src="<%= request.getContextPath() %>/protected/images/private-<%= request.getRemoteUser()== null ? "null" : request.getRemoteUser() %>.jpg" /></dd>
				</dl>

				<h3>Your Public Cat Picture </h3>
				<dl>
					<dt>Another cute cat: </dt>
					<dd><img src="<%= request.getContextPath() %>/protected/images/public-<%= request.getRemoteUser()== null ? "null" : request.getRemoteUser() %>.jpg"/></dd>
				</dl>
				<h3>What do you want to do?</h3>
				<dl>
					<dt>Upload  </dt>
					<dd><a href="<%= request.getContextPath() %>/protected/myCatPhotos.jsp">new private and public cat pictures </a></dd>
					<dt>See other and comment on other  </dt>
					<dd><a href="<%= request.getContextPath() %>/protected/otherMembers.jsp">member's public cat pictures</a></dd>
					<dt>The cats are overpowing me take me: </dt>
					<dd><a href="<%= request.getContextPath() %>">back to other area</a></dd>
				</dl>
			</div>
		</div>
	</div>									
</body>
</html>