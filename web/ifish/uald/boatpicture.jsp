<%-- 
    Document   : boatpicture
    Created on : Jul 4, 2016, 1:24:47 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.main.db.*" %>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%
int jspCommand = JSPRequestValue.requestCommand(request);
String programSite = JSPRequestValue.requestString(request, "program_site");

if(programSite.length() == 0) { //default
    programSite = IFishConfig.SITE_BALI;
}

String where = DbBoat.colNames[DbBoat.COL_TRACKER_ID] + " > 0"
        + " and " + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '%" + programSite + "%'";
Vector listBoat = DbBoat.list(0, 0, where, DbBoat.colNames[DbBoat.COL_NAME]);
%>

<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privUALD) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function cmdMap(ps) {
        document.frmualdboat.command.value="<%=JSPCommand.NONE%>";
        document.frmualdboat.program_site.value=ps;
        document.frmualdboat.action="boatpicture.jsp";
        document.frmualdboat.submit();
    }
</script>
<!-- #EndEditable -->
</head>
<body onload="javascript:initialize()">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr>
    <td valign="top">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr>
          <td height="76">
            <!-- #BeginEditable "header" -->
            <%@ include file="../../main/hmenu.jsp"%>
            <%@ include file = "../../calendar/calendarframe.jsp" %>
            <!-- #EndEditable -->
          </td>
        </tr>
        <tr>
          <td valign="top">
            <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
              <!--DWLayoutTable-->
              <tr>
                <td width="165" valign="top" background="<%=rootSystem%>/images/leftbg.gif">
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                        <form name="frmualdboat" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="program_site" value="<%=programSite%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">UALD</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Boat Picture By Site</span></td>
                                    <td width="40%" height="23">
                                      <%@ include file = "../../main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr>
                                <td height="5"></td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="17" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_BALI)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_BALI%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_BALI%>')" class="tablink"><%=IFishConfig.SITE_BALI%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_KUPANG)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_KUPANG%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_KUPANG%>')" class="tablink"><%=IFishConfig.SITE_KUPANG%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_KEMA)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_KEMA%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_KEMA%>')" class="tablink"><%=IFishConfig.SITE_KEMA%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_PROBOLINGGO)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_PROBOLINGGO%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_PROBOLINGGO%>')" class="tablink"><%=IFishConfig.SITE_PROBOLINGGO%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_LUWUK)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_LUWUK%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_LUWUK%>')" class="tablink"><%=IFishConfig.SITE_LUWUK%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_TANJUNG_LUAR)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_TANJUNG_LUAR%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_TANJUNG_LUAR%>')" class="tablink"><%=IFishConfig.SITE_TANJUNG_LUAR%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10">Click on the picture to enlarge it.</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="container">
                                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3">
                                                <%
                                                if(listBoat != null && listBoat.size() > 0) {
                                                    for(int i = 0; i < listBoat.size(); i++) {
                                                        Boat boat = (Boat)listBoat.get(i);
                                                        if(boat.getPictureCensored() > 0) {
                                                            File file = DbFile.fetchExc(boat.getPictureCensored());
                                                            if(file.getOID() > 0) {
                                                                String url = fileDir + "/" + file.getName();
                                                                out.println("<div style=\"float:left;margin-right:10px;margin-bottom:10px;text-align:center;\"><a href=\"" + url + "\" target=\"blank\"><img style=\"margin-bottom:2px;\" src=\"" + url + "\" height=\"100\" border=\"0\" title=\"\"></a></div>");
                                                            }
                                                        }
                                                    }
                                                }
                                                %>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                         </table>
                        </form><!-- #EndEditable --> </td>
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
            <%@ include file="../../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
