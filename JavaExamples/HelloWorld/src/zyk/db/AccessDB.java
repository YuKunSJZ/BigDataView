package zyk.db;

import java.io.IOException;
import java.sql.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
*   创建时间：2018年10月16日上午11:28:24
*   项目名称：test  
*@author zyk  
*   说明：
*/
public class AccessDB {
	
	DBList DBName;
	String DB_URL;
//	static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
	static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
	String USER = "root";
	static final String PASS = "mysqldb";
	Connection conn = null;
	Statement stmt = null;
	HttpServletRequest request;
	HttpServletResponse response;
	public Boolean ShowSQL;
	private Base myBase; 

	
	public enum DBList{
		TEST_DB ,
		DW_DB,
		DM_DB,
		ODS_DB;
	}	
	
	public AccessDB() {
		new AccessDB(DBList.DW_DB);
	}
	
	public AccessDB(DBList myDBName) {
		this.DBName = myDBName;
		setDBURL();
		
	}
	
	public AccessDB(DBList myDBName,Base _base) {
		myBase = _base;
		this.DBName = myDBName;
		this.request=_base.request;
		this.ShowSQL=Boolean.parseBoolean(this.request.getParameter("ShowSQL"));
		setDBURL();
		
	}
	


	public DBList getDB() {
		return DBName;
	}
	
	public String getDBURL() {
		return DB_URL;
	}
	
	private void setDBURL() {
		this.DB_URL = "jdbc:mysql://172.16.7.16:3306/"+ this.DBName +"?useSSL=true&serverTimezone=Hongkong";
	}
	
	private void getConnection() {
		try {
			Class.forName(JDBC_DRIVER);
	        this.conn = DriverManager.getConnection(DB_URL,USER,PASS);
		}catch(Exception e) {		
				e.printStackTrace();
			}
		}
	
	public boolean executeSQL(String _sql) {
		boolean isSuccess = false;
		getConnection();
		try {
			if (ShowSQL) {
				myBase.printPage("<xmp>" + _sql + "</xmp>");
			}
			this.stmt = this.conn.createStatement();
			this.stmt.execute(_sql);
			isSuccess = true;
			
		} catch (SQLException e) {

			try {
				myBase.response.getWriter().write("<xmp>" + _sql + "</xmp>");
				e.printStackTrace(myBase.response.getWriter());

			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
		return isSuccess;

	}
	
	public ResultSet sql2RS(String _sql){
		getConnection();
		try {
			if (ShowSQL) {
				myBase.printPage("<xmp>" + _sql + "</xmp>");
			}
			this.stmt = conn.createStatement();
			ResultSet myResult = this.stmt.executeQuery(_sql);
			return myResult;
			
		} catch (Exception e) {
			myBase.printPage("<xmp>" + _sql + "</xmp>");
			try {
				e.printStackTrace(myBase.response.getWriter());
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

		}
		return null;
	}
	
	public void close() throws SQLException {
		conn.close();
	}
	/*
    public static void main(String[] args) {
    	Connection conn = null;
    	Statement stmt = null;
    	try {
        	//DriverManager.registerDriver(new com.mysql.jdbc.Driver()); 
        	Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL,USER,PASS);
            
            stmt = conn.createStatement();
            String sql ;
            sql = "select sysid from m_dim_product_finance";
            String sql2 = "create table test_db.aaa (id integer);";
            stmt.execute(sql2);
            ResultSet rs = stmt.executeQuery(sql);
            
            while(rs.next()) {
            	System.out.println(rs.getString("sysid"));
            }
            
            rs.close();
            stmt.close();
            conn.close();

    	}catch (Exception e) {
    		System.out.println(e.toString());
    	}
    	
    }
	*/
	

}
