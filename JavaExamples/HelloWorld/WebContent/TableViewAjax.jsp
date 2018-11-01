<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import = "zyk.db.*" %>
    

<%
Base myBase = new Base(request,response);
TableView myTableView = new TableView(request.getParameter("TableName"),myBase);
response.setContentType("application/json");  

//myBase.printPage(myTableView.getSingleColumn((request.getParameter("TableField"))));

%>
