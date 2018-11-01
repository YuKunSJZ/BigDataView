package zyk.db;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
*   创建时间：2018年10月23日下午1:34:51
*   项目名称：test  
*@author zyk  
*   说明：
*/
public class Test {
	public String testIterator() {
		List<String> ll = new LinkedList<String>();
		ll.add("first");
		ll.add("second");
		ll.add("third");
		ll.add("fourth");
		String msg="";
		for(Iterator<String> iterator=ll.iterator();iterator.hasNext();) {
			msg = (String)iterator.next() + "-" + msg;
		
		}
		return msg;

		
	}
	
	public void testHashMap() {
		/*
		Map map = new HashMap();
		　　Iterator iter = map.entrySet().iterator();
		　　while (iter.hasNext()) {
		　　Map.Entry entry = (Map.Entry) iter.next();
		　　Object key = entry.getKey();
		　　Object val = entry.getValue();

	}
	*/
		
		/*
		 * public static void main(String[] args) {
        Map<String, Integer> hashMap = Maps.newHashMap();
        Map<String, Integer> treeMap = Maps.newTreeMap();
        Map<String, Integer> linkedHashMap = Maps.newLinkedHashMap();
        System.out.println("--------------test hashMap");
        testMap(hashMap);
        System.out.println("--------------test treeMap");
        testMap(treeMap);
        System.out.println("--------------test linkedHashMap");
        testMap(linkedHashMap);
    }
 
    private static void testMap(Map<String, Integer> map) {
        map.put("asd", 1);
        map.put("2das", 2);
        map.put("3das", 3);
        map.put("4das", 4);
        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            System.out.println(entry.getKey() + ":" + entry.getValue());
        }
    }

		 */
		
	}
		
	
	public void testUploadFile() {
		/*
		File file;
		int maxFileSize = 5000 * 1024;
		int maxMemSize = 5000 * 1024;
		ServletContext context = pageContext.getServletContext();
		String filePath = context.getInitParameter("file-upload");

		//
		String contentType = request.getContentType();
		if ((contentType.indexOf("multipart/form-data") >= 0)) {
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(maxMemSize);
			factory.setRepository(new File(".\\temp"));
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setSizeMax(maxFileSize);
			try {
				List fileItems = upload.parseRequest(request);
				Iterator i = fileItems.iterator();
				out.println("<html>");
				out.println("<head>");
				out.println("<title>JSP File upload</title>");
				out.println("</head>");
				out.println("<body>");
				while (i.hasNext()) {
					FileItem fi = (FileItem) i.next();
					if (!fi.isFormField()) {
						String fieldName = fi.getFieldName();
						String fileName = fi.getName();
						boolean isInMemory = fi.isInMemory();
						long fizeInBytes = fi.getSize();

						if (fileName.lastIndexOf("\\") >= 0) {
							file = new File(filePath, fileName.substring(fileName.lastIndexOf("\\")));
							fi.write(file);
							out.println("Uploaded Filename:" + filePath + fileName + "<br/>");
						}

					}
				}

				out.println("<body>");
				out.println("</html>");

			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		*/
	}

}
