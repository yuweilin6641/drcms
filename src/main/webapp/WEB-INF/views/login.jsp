<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="org.springframework.security.authentication.BadCredentialsException" %>

<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="ie6 ielt8"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="ie7 ielt8"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="ie8"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--> <html lang="en"> <!--<![endif]-->
<head>
<meta charset="utf-8">
<title>WISSUE System</title>

<link rel="stylesheet" type="text/css" href="/drcms/styles/login2.css" />
<link rel="shortcut icon" href="/drcms/images/favicon.ico" type="image/x-icon" /> 
</head>
<body>

<BR><BR><BR><BR><BR>
		<form action="j_spring_security_check" method="POST">
		<div class="wrapper">
    <dl class="form1">
			<div class="formtitle">WISSUE SYSTEM</div>
			<%
				try{
					String errorDesc = ((BadCredentialsException)session.getAttribute("SPRING_SECURITY_LAST_EXCEPTION")).getMessage();
					out.println("<h1><font color=red>Login Fail</font></h1>");
				}catch(Exception e){}
			%>
			<div class="input">
			<div class="inputtext"><label for="identity">Username</label></div>
			<div class="inputcontent">
				<input id="username" type='text' placeholder='Username' name='j_username' maxlength="40" />
			</div>
			<div class="inputtext"><label for="credential">Password</label></div>
			<div class="inputcontent">
				<input id="password" type='password' placeholder='Password' name='j_password'  maxlength="40" />
			</div>
			</div>
			<div class="buttons" >
			    <button type="submit" name="submit" class="btn btn-primary" value="Login">Login</button>
			</div>
			</dl>

	</div>
		</form>
</body>
</html>