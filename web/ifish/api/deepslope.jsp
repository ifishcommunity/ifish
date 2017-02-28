<%-- 
    Document   : deepslope
    Created on : Sep 18, 2015, 3:12:23 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.data.DbSizing" %>
<%
System.out.println("...in deepslope");
String msgStatus = "";
boolean isMultipart = ServletFileUpload.isMultipartContent(request);

if (isMultipart) {
    try {
        InputStream inputStream = request.getInputStream();
        msgStatus = DbDeepSlope.mDCUDeepSlope(inputStream);
    } catch(Exception e) {
        System.out.println(e.toString());
    }
}
out.println(msgStatus);
%>