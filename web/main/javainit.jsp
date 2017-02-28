
<%@ page import="java.util.*" %>
<%@ page import="com.project.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.general.*"%>
<%@ page import="com.project.general.QrUserSession"%>
<%@ page import="com.project.general.User"%>
<%@ page import="com.project.general.DbUser"%>
<%@ page import="com.project.general.*"%>
<%
//App Title
String titleSystem = "I-Fish (Community)";
String rootSystem = "/ifish";
String subSystem = rootSystem + "/ifish";
String printroot = rootSystem + "/servlet/com.project.ccs";
String fileDir = rootSystem + "/files";
boolean isSystemActive = true;
String sSystemDecimalSymbol = ".";
String sUserDecimalSymbol 	= ".";
String sUserDigitGroup 	= ",";
final int LANG_EN = 1;
final int LANG_ID = 0;
int lang = LANG_ID;
QrUserSession appSessUser = new QrUserSession();
User user = new User();

//footer
String footerPoweredBy = "";
String footerCopyright = "This website is licensed to the community under a <a href=\"http://creativecommons.org/licenses/by-sa/4.0/\" target=\"blank\">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</a> license.";
String footerUrl = "";
%>
<script type="text/javascript" src="<%=rootSystem%>/main/common.js"></script>
<script type="text/javascript" src="<%=rootSystem%>/main/jquery.min.js"></script>