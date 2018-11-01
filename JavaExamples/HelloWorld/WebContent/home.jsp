<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="zyk.db.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	response.setCharacterEncoding("utf-8");
response.setHeader("iso-8859-1", "utf-8");
request.setCharacterEncoding("utf-8");
Boolean loginAction = Boolean.parseBoolean(request.getParameter("login"));
// out.println("request.login=" + request.getParameter("login"));
// out.println("loginAction=" + loginAction);
User myUser = new User();
myUser.setUserContry(request);
out.println("Contry=" + myUser.contry + "<br/>");
out.println("Lauguage=" + myUser.language + "<br/>");
if (loginAction){
	String name = request.getParameter("name");
	String psd=request.getParameter("psd");
	out.println("Name:" + name);
	out.println("psd" + psd);
	Cookie myCookie = new Cookie("logedon","1") ;
	myCookie.setMaxAge(15*60);
	response.addCookie(myCookie);
} else{
	out.println(User.getCurrentTime());

	StringBuilder strB = new StringBuilder();
	strB.append("<form name=\"form1\" method=\"POST\" action=\"home.jsp?login=true\">");
	strB.append("	<input type=\"text\" name=\"name\">");
	strB.append("	<input type=\"text\" name=\"psd\">");
	strB.append("	<input type=\"submit\" name=\"提交\">");
	strB.append("	<input type=\"reset\" name=\"重置\">");
	strB.append("</form>");
	out.println(strB.toString());
	response.getWriter().write("");
}


%>
<jsp:setProperty name="bb" property="firstName" value="小强" />
<jsp:setProperty name="bb" property="lastName" value="王"/>
<jsp:setProperty name="bb" property="age" value="10"/>


<p>学生的名字：
	<jsp:getProperty name="bb" property="firstName"/>
</p>
<p>学生的姓：
	<jsp:getProperty name="bb" property="lastName"/>
</p>
<p>学生年龄：
	<jsp:getProperty name="bb" property="age"/>
</p>

</body>
</html>