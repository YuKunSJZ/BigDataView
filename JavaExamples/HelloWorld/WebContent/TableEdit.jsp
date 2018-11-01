<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import = "zyk.db.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<%
Base myBase = new Base(request,response);
myBase.printPage("<title>"+ myBase.request.getParameter("Table") +"</title>");
myBase.printPage("<link rel=\"shortcut icon\" href=\"image/logo.png\" type=\"image/png\" />");
%>

</head>
<body>
<%
if (myBase.request.getParameter("TableAction") !=null && myBase.request.getParameter("TableAction").equals("Add")){
	TableEdit myTableEdit = new TableEdit(myBase.request.getParameter("Table"),myBase);
	myTableEdit.getTableAddPrint();

}else{
	TableEdit myTableEdit = new TableEdit(myBase.request.getParameter("Table"),myBase);
	myTableEdit.setTableFieldValue();
	myTableEdit.Save();
	if (myTableEdit.success){
		myBase.response.sendRedirect("http://localhost:8080/HelloWorld/TableView.jsp?Table=" + myBase.request.getParameter("Table"));
	}
}
%>
</body>
</html>