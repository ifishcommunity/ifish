<%-- 
    Document   : srcboatpicture
    Created on : Jul 22, 2016, 2:37:55 PM
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
<%!
public String drawList(Vector objectClass, String fileDir) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("75%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Tracker ID", "15%");
    jsplist.addHeader("Tracker Start Date", "20%");
    jsplist.addHeader("Tracker End Date", "20%");
    jsplist.addHeader("Picture (Click on the picture to enlarge it)", "42%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    for (int i = 0; i < objectClass.size(); i++) {
        Boat boat = (Boat) objectClass.get(i);

        String encryptedTrackerName = UUID.nameUUIDFromBytes(String.valueOf(boat.getTrackerId()+IFishConfig.UUID_KEY).getBytes()).toString();
        encryptedTrackerName = encryptedTrackerName.substring(encryptedTrackerName.length()-12);

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
        rowx.add(encryptedTrackerName);
        rowx.add(JSPFormater.formatDate(boat.getTrackerStartDate(), "MMMM d, yyyy"));
        rowx.add(JSPFormater.formatDate(boat.getTrackerStatus()==IFishConfig.STATUS_ACTIVE?new Date():boat.getTrackerEndDate(), "MMMM d, yyyy"));
        String sPhoto = "not available";
        if(boat.getPictureCensored() > 0) {
            try {
                File file = DbFile.fetchExc(boat.getPictureCensored());
                if(file.getOID() > 0) {
                    String url = fileDir + "/" + file.getName();
                    sPhoto = "<a href=\"" + url + "\" target=\"blank\"><img style=\"margin-bottom:2px;\" src=\"" + url + "\" height=\"100\" border=\"0\" title=\"\"></a>";
                }
            } catch(Exception e) {}
        }
        rowx.add("<center>"+sPhoto+"</center>");

        lstData.add(rowx);
    }

    return jsplist.draw(index);
}
%>
<%
int jspCommand = JSPRequestValue.requestCommand(request);
String srcTrackerName = JSPRequestValue.requestString(request, "src_tracker_name");
Vector listBoat = DbBoat.list(0, 0, DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" > 0", "");

Vector selectedBoat = new Vector();
if(listBoat != null && listBoat.size() > 0 && jspCommand == JSPCommand.LIST) {
    for(int i = 0; i < listBoat.size(); i++) {
        Boat b = (Boat) listBoat.get(i);

        String encryptedTrackerName = UUID.nameUUIDFromBytes(String.valueOf(b.getTrackerId()+IFishConfig.UUID_KEY).getBytes()).toString();
        encryptedTrackerName = encryptedTrackerName.substring(encryptedTrackerName.length()-12);

        if(encryptedTrackerName.equals(srcTrackerName)) {
            selectedBoat.add(b);
        }
    }
}
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

    function cmdList() {
        document.frmualdsrcboat.command.value="<%=JSPCommand.LIST%>";
        document.frmualdsrcboat.program_site.value=ps;
        document.frmualdsrcboat.action="srcboatpicture.jsp";
        document.frmualdsrcboat.submit();
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
                        <form name="frmualdsrcboat" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">UALD</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Search Boat Picture</span></td>
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
                                <td class="container">
                                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Tracker ID&nbsp;</td>
                                            <td width="30%"><input name="src_tracker_name" value="<%=srcTrackerName%>" size="30"/>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <%if(jspCommand == JSPCommand.LIST) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=selectedBoat.size()>0?drawList(selectedBoat, fileDir):"Data not found"%></td>
                                        </tr>
                                        <%if(selectedBoat.size()==0){%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <%}%>
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
