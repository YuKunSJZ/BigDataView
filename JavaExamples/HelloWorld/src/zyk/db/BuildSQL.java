package zyk.db;

import java.sql.SQLException;

/**
*   创建时间：2018年11月1日下午5:40:54
*   项目名称：test  
*@author zyk  
*   说明：
*/
public class BuildSQL {
	public BuildSQL(Base _base) {
		myBase = _base;
		
	}
	public Table myTable;
	public boolean isTableViewPage = true;

	
	private Base myBase;
	private String limitStart ="0";
	private String limitEnd = "100";
	
	
	public void create(String _tableName) throws SQLException {
		myTable = new Table(_tableName, myBase);
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
	
	public String getSQL() {
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
		return strB.toString();
	}
	
	

}
