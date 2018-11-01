<%@page import="javax.xml.ws.Response"%>
<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@ page language="java" import="java.util.*,java.sql.ResultSet" pageEncoding="GB18030"%>
<%@page import="zyk.db.*"%>

<%--
<%@page import="com.wangjin.shop.DB.SalesItem"%>
<%@page import="com.wangjin.shop.DB.ProductMgr"%>
<%@page import="com.wangjin.shop.DB.OrderMgr"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%
	ArrayList<String> saledproduct = new ArrayList<String>();
	ArrayList<Integer> count = new ArrayList<Integer>();
	ArrayList<SalesItem> salesItems = OrderMgr.getInstance().getItems2();//连接数据库部分
	for (Iterator<SalesItem> it = salesItems.iterator(); it.hasNext();) {
		SalesItem si = it.next();
		saledproduct.add(si.getProduct().getName());//取出数据存入Arraylist
		count.add(si.getCount());
	}
	int size = saledproduct.size();
	Integer[] count1 = new Integer[size];
	String[] product = new String[size];
	for (int i = 0; i < size; i++) {
		product[i] = (String) saledproduct.get(i);
		count1[i] = (Integer) count.get(i);
	}
%>
 --%>
<!DOCTYPE html>
<html style="height: 100%">
   <head>
       <meta charset="utf-8">
   </head>
   <body style="height: 100%; margin: 0">
       <div id="container" style="height: 100%"></div>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/echarts-all-3.js"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/extension/dataTool.min.js"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/map/js/china.js"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/map/js/world.js"></script>
       <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=ZUONbpqGBsYGXNIYHicvbAbM"></script>
       <script type="text/javascript" src="http://echarts.baidu.com/gallery/vendors/echarts/extension/bmap.min.js"></script>
       <script type="text/javascript">
       </script>
       
<%
       	AccessDB myADB = new AccessDB(AccessDB.DBList.ODS_DB);
       StringBuilder myStr = new StringBuilder();
       myStr.append("select ");
       myStr.append(" id ");
       myStr.append(",invest_id ");
       myStr.append(",capitalAmount ");
       myStr.append(",roundOrder ");
       myStr.append(",industry ");
       myStr.append("from fund_round ");
       myStr.append("; ");


       out.println(myStr.toString());
       out.println(myADB.getDB());
       out.println(myADB.getDBURL());
       ResultSet myRs = myADB.sql2RS(myStr.toString());
       while (myRs.next()){
       	out.println(myRs.getString("roundOrder"));
       }
       %>

   </body>
</html>
