package zyk.db;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import zyk.db.AccessDB.DBList;

/**
*   创建时间：2018年10月25日下午3:36:08
*   项目名称：test  
*@author zyk  
*   说明：
*/
public class TableView {
	Base myBase;
	private Table myTable;
	public Table getTable() {
		return myTable;
	}

	private String limitStart ="0";
	private String limitEnd = "100";
	private boolean isTableViewPage = true;
	public TableView(String _tableName,Base _base) throws SQLException {
		myBase = _base;
		myTable = new Table(_tableName,_base);
		for (String tableField:myTable.fieldDict.keySet()) {
			if (myBase.request.getParameter(tableField) != null) {
				myTable.fieldDict.get(tableField).Value = myBase.request.getParameter(tableField);
			}
		}
		
		if (myBase.request.getParameter("limitStart") !=null ) {
			limitStart = myBase.request.getParameter("limitStart");
		}
		if (myBase.request.getParameter("limitEnd") !=null ) {
			limitEnd = myBase.request.getParameter("limitEnd");
		}
	}
		
	public void getConlumnName() throws IOException {
		myBase.printPage("<tr class=\"ColumnName\">");
		for(String fieldName:myTable.fieldDict.keySet()) {
			myBase.printPage("<td>" + myTable.fieldDict.get(fieldName).fieldAlias + "</td>" );
		}
		myBase.printPage("</tr>");

		myBase.printPage("<br/>");
	}
	
	public void getTableEditBanner() throws IOException {
		myBase.printPage("<div>当前视图："+myTable.tableName+"</div>");
		myBase.printPage("<form action=\"TableEdit.jsp\" method=\"get\">");
		myBase.printPage(" <input style=\"display:none\"  type=\"text\" name=\"Table\" value=\""+ myTable.tableName +"\" />");
		myBase.printPage(" <input style=\"display:none\"  type=\"text\" name=\"TableAction\" value=\"Add\" />");
		myBase.printPage(" <input type=\"submit\" value=\"添加记录\" />");
		myBase.printPage("</form>");

	}
	
	
	private ResultSet getTableResultSet() {
		StringBuilder strB = new StringBuilder();
		int i = 0;
		Field myField;
		
		strB.append("select ");
		for (String tableField : myTable.fieldDict.keySet()) {
			myField = myTable.fieldDict.get(tableField);

			if (i == 0) {
				strB.append(myField.fieldName + " ");
			}else {
				strB.append("," + myField.fieldName + " ");
			}
			i = i+1;
		}
		strB.append("from " + myTable.tableName + " ");
		if (isTableViewPage) {
			for (String tableField:this.myTable.fieldDict.keySet()) {
				int counter = 0;
				if(!myTable.fieldDict.get(tableField).Value.equals("null")) {
					if(counter==0 && strB.indexOf("where") < 0) {
						strB.append(" where ");
					}else {
						strB.append(" and ");
					}
					strB.append(tableField + "='" +myTable.fieldDict.get(tableField).Value + "' ");
					counter = counter+1;
				}
		}
		}
		strB.append("limit " + limitStart + " , " + limitEnd + " ");
		strB.append(";");
		
		AccessDB myAdb = new AccessDB(DBList.TEST_DB,myBase);
		return myAdb.sql2RS(strB.toString());
		
	}
	public void printTableLines(ResultSet _resultSet) throws SQLException, IOException {
		while (_resultSet.next()) {
			myBase.printPage("<tr>");
			for(String tableField:myTable.fieldDict.keySet()) {
				myBase.printPage("<td>");
				myBase.printPage(Base.Format(_resultSet.getString(tableField), myTable.fieldDict.get(tableField).DataType, myTable.fieldDict.get(tableField).dataLength));
				myBase.printPage("</td>");
			}
			myBase.printPage("</tr>");
		}
	}
	
	public List<String> getSingleColumn(String _Column) throws SQLException {
		isTableViewPage = false;
		ResultSet _resultSet = getTableResultSet();
		List<String> myList = new ArrayList<String>();
		while (_resultSet.next()) {
			myList.add(_resultSet.getString(_Column));
		}
		_resultSet.close();
		return myList;
	}
	
	
	public void buildPageSearch() throws IOException, SQLException {
		TableView myTableView = new TableView("Tables",myBase);
		List<String> myTables = myTableView.getSingleColumn("TableName");
		myBase.printPage("<h1>瑞安金融大数据视图平台</h1>");
		myBase.printPage("<div id=\"TableName\" >" );
		myBase.printPage("	<form name=\"TableSearch\" action=\"TableView.jsp\" method=\"get\" >");
		myBase.printPage("		<input id=\"TableNameSearch\" list=\"Tables\" type=\"Text\" name=\"Table\"/>");
		myBase.printPage("<datalist id=\"Tables\">");
		for(String tableName:myTables) {
			myBase.printPage("  <option value=\"" + tableName + "\" >");
		}
//		this.printPage("  <option value=\"Tables\">");
//		this.printPage("  <option value=\"TableFields\">");
//		this.printPage("  <option value=\"dm_new_customer\">");
		myBase.printPage("</datalist>");
		myBase.printPage("		<input id=\"submit\" type=\"submit\" value=\"打开视图\" />");
		myBase.printPage("	</form>");
		myBase.printPage("</div>" );
	}
	
	public void printTable() throws SQLException, IOException {
		myBase.printPage("<table>");
		getTableEditBanner();
		getConlumnName();
		printTableLines(getTableResultSet());
		myBase.printPage("</table>");

	}
	
	public void printTableEdit() throws SQLException, IOException {
		myBase.printPage("<table>");
		getTableEditBanner();
		getConlumnName();
		printTableLines(getTableResultSet());
		myBase.printPage("</table>");

	}

	
	
	public void testPrint() {
		myTable.testPrint();
	}

}
