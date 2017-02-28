<%-- 
    Document   : uploadfile
    Created on : Mar 15, 2015, 3:01:52 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="com.project.general.DbFile" %>
<%
System.out.println("...in uploadfile");
String msgStatus = "";
boolean isMultipart = ServletFileUpload.isMultipartContent(request);
if (isMultipart) {
    try {
        InputStream inputStream = request.getInputStream();
        msgStatus = DbFile.XML2DB(inputStream);
    } catch(Exception e) {
        System.out.println(e.toString());
    }
}
out.println(msgStatus);
%>