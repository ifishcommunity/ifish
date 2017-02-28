<%-- 
    Document   : changepp
    Created on : Jan 20, 2015, 2:07:38 PM
    Author     : gwawan
--%>
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../ifish/main/check.jsp"%>
<%
User appUser = new User();
try {
    appUser = DbUser.fetch(user.getOID());
} catch (Exception e) {
    out.println(e.toString());
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<!-- #EndEditable -->
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr>
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr>
          <td height="76">
            <!-- #BeginEditable "header" -->
            <%@ include file="../main/hmenu.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr>
          <td valign="top">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr>
                <td width="165" height="100%" valign="top" background="<%=rootSystem%>/images/leftbg.gif">
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../ifish/main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                          <form name="frmchangepp" method="post" enctype="multipart/form-data" action="savepp.jsp?user_oid=<%=user.getOID()%>">
                            <table width="100%" cellpadding="0" cellspacing="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1"><%=titleSystem%></font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Change Profile Picture</span></td>
                                    <td width="40%" height="23">
                                      <%@ include file = "../main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                                <td class="container">
                                    <table width="100%" cellpadding="0" cellspacing="2" border="0">
                                        <tr>
                                          <td width="16%">&nbsp;</td>
                                          <td width="81%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="2%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td width="16%"><img src="<%=rootSystem%>/<%=IFishConfig.IMG_PATH%>/<%=appUser.getLoginId()%>.jpg" height="120" border="0"></td>
                                            <td width="81%" valign="middle">
                                                <input type="file" name="<%=QrPictureSave.JSP_USER_PICTURE%>">&nbsp;&nbsp;<input type="submit" name="savepp" value="save picture">
                                            </td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="2%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                          <td width="16%">&nbsp;</td>
                                          <td width="81%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="2%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="16%">
                                                <a href="dashboard.jsp"><img src="<%=rootSystem%>/images/cancel.gif" border="0"></a>
                                            </td>
                                          <td width="81%">&nbsp;</td>
                                          <td width="1%">&nbsp;</td>
                                          <td width="2%">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            </table>
                          </form>
                      <!-- #EndEditable --> </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td height="25">
            <!-- #BeginEditable "footer" -->
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>