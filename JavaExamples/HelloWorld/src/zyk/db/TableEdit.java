package zyk.db;

import java.io.IOException;
import java.sql.SQLException;

import zyk.db.AccessDB.DBList;

/**
*   创建时间：2018年10月30日上午11:33:12
*   项目名称：test  
*@author zyk  
*   说明：
*/
public class TableEdit {
	public TableEdit(String _tableName,Base _base) throws SQLException {
		this.myBase=_base;
		this.TableName = _tableName;
		this.myTableView = new TableView(_tableName,_base);
	}
	
	private Base myBase;
	public String TableName;
	public String TableAction;
	public TableView myTableView;
	private boolean isChanged = false;
	public boolean success = false;
	
	public void AddRecord() {
		this.TableAction="Add";
	}
	
	public void EditRecord() {
		this.TableAction="Edit";
	}
	
	public void getTableAddPrint() throws SQLException, IOException {
		myBase.request.removeAttribute("TableAction");
		myBase.printPage("<h3>添加记录到-> " + this.TableName + "</h3>" );
		myBase.printPage("<form action=\"TableEdit.jsp\" method=\"get\">");
		for (String myField:myTableView.getTable().fieldDict.keySet()) {
			myBase.printPage(myField + ":  ");
			myBase.printPage("<input type=\"text\" name=\"" + myField + "\" />");
			myBase.printPage("<br/>");
		}
		myBase.printPage("<input style=\"display:none\"type=\"text\" name=\"Table\" value=\""+this.TableName +"\" />");
		myBase.printPage("<input type=\"submit\" value=\"保存\" />");

		myBase.printPage("</form>");
	}
	
	public void setTableFieldValue() {
		StringBuilder sql = new StringBuilder();
		sql.append("insert into " + TableName + " (");
		for (String tableField:myTableView.getTable().fieldDict.keySet()) {
			if (myBase.request.getParameter(tableField) != "") {
				myTableView.getTable().fieldDict.get(tableField).Value = myBase.request.getParameter(tableField);
				isChanged = true;
			}		
		}
	}
	
	private String setTableInsertSQL() {
		StringBuilder sql = new StringBuilder();


		if (isChanged) {
			StringBuilder sqlField = new StringBuilder();
			StringBuilder sqlValues = new StringBuilder();
			int counter = 0;
			for (String tableField:myTableView.getTable().fieldDict.keySet()) {
				if (counter == 0) {
					sqlField.append(myTableView.getTable().fieldDict.get(tableField).fieldName + " ");
					sqlValues.append("'" + myTableView.getTable().fieldDict.get(tableField).Value + "' ");
				}else {
					sqlField.append(", ");
					sqlField.append(myTableView.getTable().fieldDict.get(tableField).fieldName);
					sqlValues.append(", ");
					sqlValues.append("'" + myTableView.getTable().fieldDict.get(tableField).Value + "' ");
				}

				counter = counter+1;
			}
			
			sql.append("insert into " + TableName + " ( ");
			sql.append(sqlField.toString());
			sql.append(" ) ");
			sql.append(" values (");
			sql.append(sqlValues.toString());
			sql.append(" ); "); 

		}
		
		return sql.toString();
	}
	
	public void Save() throws SQLException, IOException {
		AccessDB myAdb = new AccessDB(DBList.TEST_DB,myBase);
		success = myAdb.executeSQL(setTableInsertSQL());
	}

	

}
