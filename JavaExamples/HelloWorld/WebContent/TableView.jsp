<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import = "zyk.db.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<%
Base myBase = new Base(request,response);
String myTable = "Tables";
if (myBase.request.getParameter("Table") != null){
	myTable = myBase.request.getParameter("Table");
}
myBase.importScript("css/TableView.css",Base.StriptType.CSS);
myBase.importScript("js/TableView.js",Base.StriptType.JAVASCRIPT);
myBase.importScript("https://code.jquery.com/jquery-3.3.1.min.js",Base.StriptType.JAVASCRIPT);
myBase.printPage("<title>"+ myTable +"-瑞安金融大数据视图平台</title>");
myBase.printPage("<link rel=\"shortcut icon\" href=\"image/logo.png\" type=\"image/png\" />");
%>

</head>
<body>
<%
	// myBase.printPage("<table id=2> <tr><td>");
	// myBase.printPage("ddd");
	// myBase.printPage("</td></tr></table>");
	String strSearch = myBase.request.getParameter("strSerach");
	if ((strSearch != null) && (strSearch.length() > 0)) {
		myBase.response.sendRedirect("TableView.jsp?Table=" + strSearch);
	}


	TableView myTableView = new TableView(myTable, myBase);
	myTableView.buildPageSearch();
	myTableView.printTable();

	//TableView myTables = new TableView("Tables",myBase);
%>

</body>
</html>