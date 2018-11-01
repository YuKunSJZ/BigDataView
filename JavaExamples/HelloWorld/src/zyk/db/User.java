package zyk.db;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
*   ����ʱ�䣺2018��10��23������11:45:24
*   ��Ŀ���ƣ�test  
*@author zyk  
*   ˵����
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
//		G	ʱ����ʶ��	AD
//		y	4λ�����	2001
//		M	��	July or 07
//		d	��	10
//		h	12Сʱ�ƣ� A.M./P.M. (1~12)	12
//		H	24Сʱ��	22
//		m	����	30
//		s	��	55
//		S	����	234
//		E	����	Tuesday
//		D	һ���е�ĳ��	360
//		F	һ������ĳ���ڵ�ĳ��	2 (second Wed. in July)
//		w	һ���е�ĳ����	40
//		W	һ�����е�ĳ����	1
//		a	A.M./P.M. ���	PM
//		k	һ���е�ĳ��Сʱ (1~24)	24
//		K	һ���е�ĳ��Сʱ��A.M./P.M. (0~11)	10
//		z	ʱ��	Eastern Standard Time
//		'	�ı��ָ�	Delimiter
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
