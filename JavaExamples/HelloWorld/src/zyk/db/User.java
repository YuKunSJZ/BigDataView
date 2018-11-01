package zyk.db;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
*   创建时间：2018年10月23日上午11:45:24
*   项目名称：test  
*@author zyk  
*   说明：
*/

public class User {
	public enum TimeFormat{
		_24_dot_yyyyMMDDhhmmss,
		_12_dot_yyyyMMDDhhmmss,
		_24_slash_yyyyMMDDhhmmss,
		_12_slash_yyyyMMDDhhmmss
	}
	
	public String contry;
	public String language;
	public String numberFormat;
	
	
	public static String getCurrentTime() {
		return getCurrentTime(TimeFormat._24_slash_yyyyMMDDhhmmss);
	}
	
	public static String getCurrentTime(TimeFormat myfmt) {
//		G	时代标识符	AD
//		y	4位数年份	2001
//		M	月	July or 07
//		d	日	10
//		h	12小时制， A.M./P.M. (1~12)	12
//		H	24小时制	22
//		m	分钟	30
//		s	秒	55
//		S	毫秒	234
//		E	星期	Tuesday
//		D	一年中的某天	360
//		F	一个月中某星期的某天	2 (second Wed. in July)
//		w	一年中的某星期	40
//		W	一个月中的某星期	1
//		a	A.M./P.M. 标记	PM
//		k	一天中的某个小时 (1~24)	24
//		K	一天中的某个小时，A.M./P.M. (0~11)	10
//		z	时区	Eastern Standard Time
//		'	文本分隔	Delimiter
		SimpleDateFormat myDateFmt;
		switch(myfmt) {
		case _24_dot_yyyyMMDDhhmmss:
			myDateFmt = new SimpleDateFormat("yyyy.MM.dd HH:mm:ss");
			break;
		case _24_slash_yyyyMMDDhhmmss:
			myDateFmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

			break;
		case _12_dot_yyyyMMDDhhmmss:
			myDateFmt = new SimpleDateFormat("yyyy.MM.dd hh:mm:ss");
			break;
		case _12_slash_yyyyMMDDhhmmss:
			myDateFmt = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");

			break;
			
		default:
			myDateFmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			break;
		}
		
		return myDateFmt.format(new Date());
	}
	
	public static void setRefreshInterval(HttpServletResponse _response) {
		_response.setIntHeader("Refresh", 3);
	}
	
	public static void setHeader(HttpServletResponse _response,String _headerName,String _headerValue) {
		_response.setHeader(_headerName, _headerValue);
	}
	
	public void setUserContry(HttpServletRequest _request) {
		Locale locale = _request.getLocale();
		this.contry= locale.getCountry();
		this.language = locale.getLanguage();
	}


}
