package zyk.db;

import java.util.LinkedHashMap;
import zyk.db.AccessDB.DBList;
import java.sql.*;

/**
*   创建时间：2018年10月25日上午10:50:13
*   项目名称：test  
*@author zyk  
*   说明：
*/
public class Table {
	public String tableName;
	public String tableSchema;
	public String tableAlias;
	public LinkedHashMap<String,Field> fieldDict;
	private Base myBase;
	
	public Table(String _Table,Base _base) throws SQLException {
		myBase = _base;
		this.tableName = _Table;
		fieldDict = new LinkedHashMap<String,Field>();
		setTable();
		setField();
	}
	
	private void setTable() throws SQLException {
		StringBuilder mySql = new StringBuilder() ;
		mySql.append("SELECT ");
		mySql.append(" TableName ");
		mySql.append(",TableAlias");
		mySql.append(",TableSchema ");
		mySql.append("FROM Tables ");
		mySql.append("WHERE TableName = '" + this.tableName + "' ");
		mySql.append(";");
		
		AccessDB myAdb = new AccessDB(DBList.TEST_DB,myBase);
		ResultSet myRs = myAdb.sql2RS(mySql.toString());
		while (myRs.next()) {
			this.tableName = myRs.getString("TableName");
			this.tableSchema = myRs.getString("TableSchema");
			this.tableAlias = myRs.getString("TableAlias");
		}

	}
	
	private void setField() throws SQLException {
		StringBuilder mySql = new StringBuilder();
		mySql.append("SELECT ");
		mySql.append("FieldName ");
		mySql.append(",FieldAlias ");
		mySql.append(",FieldSequence ");
		mySql.append(",DataType ");
		mySql.append(",DataLength ");
		mySql.append(",DefaultValue ");
		mySql.append("from TableFields ");
		mySql.append("where TableName = '" + this.tableName + "'");
		mySql.append("order by FieldSequence ");
		mySql.append(";");
		
		AccessDB myAdb = new AccessDB(DBList.TEST_DB,myBase);
		ResultSet myRs = myAdb.sql2RS(mySql.toString());
		while (myRs.next()) {
			Field myField = new Field();
			myField.tableName = this.tableName;
			myField.fieldName = myRs.getString("FieldName");
			myField.fieldAlias = myRs.getString("FieldAlias");
			myField.DataType= parseFieldDataType(myRs.getString("DataType"));
			myField.defalutValue = myRs.getString("DefaultValue");
//			try {
//				myBase.printPage(myField.DataType.toString());
//			} catch (IOException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
			myField.dataLength = myRs.getInt("DataLength");
			if (fieldDict != null) {
				fieldDict.put(myRs.getString("FieldName"), myField);
			}
		}
	}
	
	private Base.DataTypeEnum parseFieldDataType(String _dataTypeStr) {
		switch(_dataTypeStr) {
		case "varchar":
			return  Base.DataTypeEnum.STRING;
			
		case "datetime":
			return  Base.DataTypeEnum.DATETIME;
			
		case "int":
			return Base.DataTypeEnum.INTEGER;
		case "link":
			return Base.DataTypeEnum.LINK;
		default:
			return Base.DataTypeEnum.STRING;
		}
	}

	
	public void testPrint() {
		System.out.println(this.tableName);
		System.out.println(fieldDict.keySet().toString());
		System.out.println(fieldDict.get("name").tableName);
	}
}
