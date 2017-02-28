<%@ page language="java" %>  
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.main.entity.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ include file = "main/javainit.jsp" %>

<%
appSessUser = (QrUserSession)session.getValue("ADMIN_LOGIN");
try {
    if (appSessUser != null && appSessUser.isLoggedIn() == true) {
        if (session.getValue("ADMIN_LOGIN") != null) {
            appSessUser.doLogout();
            session.removeValue("ADMIN_LOGIN");
        }
    }
    response.sendRedirect(rootSystem);
} catch (Exception exc) {
    System.out.println(" ==> Exception during logout user");
}
%>
