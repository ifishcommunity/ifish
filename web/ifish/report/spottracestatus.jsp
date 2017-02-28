<%--
    Document   : spottracestatus
    Created on : Sep 8, 2015, 11:17:32 AM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.main.db.*" %>
<%@ page import="com.project.ifish.data.FindMeSpot"%>
<%@ page import="com.project.ifish.data.DbFindMeSpot"%>
<%@ page import="com.project.ifish.master.Tracker"%>
<%@ page import="com.project.ifish.master.DbTracker"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.session.SessSpotTrace"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.FileUploadException"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawList(Vector objectClass, int start, int offset) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Tracker Name", "8%");
    jsplist.addHeader("Attach On", "17%");
    jsplist.addHeader("Last Active", "10%");
    jsplist.addHeader("Last Position", "12%");
    jsplist.addHeader("Battery State", "6%");
    jsplist.addHeader("Message Type", "10%");
    jsplist.addHeader("Message", "28%");
    jsplist.addHeader("Unit Status", "6%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs

    Vector listBoat = DbBoat.list(0, 0, DbBoat.colNames[DbBoat.COL_TRACKER_ID]+">0 and "+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+"=1", "");
    Hashtable hBoat = new Hashtable();
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat b = (Boat) listBoat.get(i);
            hBoat.put(b.getTrackerId(), b);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        try {
            Tracker tracker = (Tracker) objectClass.get(i);

            Boat boat = (Boat) hBoat.get(tracker.getTrackerId());
            if(boat == null) boat = new Boat();

            FindMeSpot findMeSpot = DbFindMeSpot.getLatestStatus(tracker.getTrackerId());

            long lDateTime = findMeSpot.getDateTime().getTime();
            Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));

            rowx = new Vector();
            rowx.add("<div align=\"center\">" + (i + 1 + start) + "</div>");
            rowx.add(tracker.getTrackerName());
            rowx.add(boat.getOID()!=0?boat.getName() + " (" + boat.getHomePort() + ")":"");
            rowx.add(findMeSpot.getOID() != 0 ? JSPFormater.formatDate(dateByTimeZone, "MMM d, yyyy HH:mm"):"-");
            rowx.add(String.valueOf(findMeSpot.getLatitude()) + ", " + findMeSpot.getLongitude());
            rowx.add(findMeSpot.getBatteryState());
            rowx.add(findMeSpot.getMessageType());
            rowx.add(findMeSpot.getMessageContent());
            rowx.add(IFishConfig.strStatus[tracker.getStatus()]);
            lstData.add(rowx);
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    }

    return jsplist.draw(index);
}
%>
<%
int jspCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int offset = JSPRequestValue.requestInt(request, "offset");
String srcTrackerName = JSPRequestValue.requestString(request, "src_tracker_name");

int recordToGet = 15;
int vectSize = 0;
Vector list = new Vector();

/* control list */
if(jspCommand != JSPCommand.NONE) {
    Control control = new Control();
    vectSize = SessSpotTrace.getCountUserBoat(user.getOID(), srcTrackerName);
    start = control.actionList(jspCommand, start, vectSize, recordToGet);
    list = SessSpotTrace.listUserBoat(start, recordToGet, user.getOID(), srcTrackerName);
}
/* end */
%>
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privReportSpotTrace) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdList() {
        var offset = new Date().getTimezoneOffset();
        document.frmrptfindmespot.start.value="0";
        document.frmrptfindmespot.offset.value=offset;
        document.frmrptfindmespot.command.value="<%=JSPCommand.LIST%>";
        document.frmrptfindmespot.action="spottracestatus.jsp";
        document.frmrptfindmespot.submit();
    }

    function cmdListFirst(){
        document.frmrptfindmespot.command.value="<%=JSPCommand.FIRST%>";
        document.frmrptfindmespot.action="spottracestatus.jsp";
        document.frmrptfindmespot.submit();
    }

    function cmdListPrev(){
        document.frmrptfindmespot.command.value="<%=JSPCommand.PREV%>";
        document.frmrptfindmespot.action="spottracestatus.jsp";
        document.frmrptfindmespot.submit();
    }

    function cmdListNext(){
        document.frmrptfindmespot.command.value="<%=JSPCommand.NEXT%>";
        document.frmrptfindmespot.action="spottracestatus.jsp";
        document.frmrptfindmespot.submit();
    }

    function cmdListLast(){
        document.frmrptfindmespot.command.value="<%=JSPCommand.LAST%>";
        document.frmrptfindmespot.action="spottracestatus.jsp";
        document.frmrptfindmespot.submit();
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
                        <form name="frmrptfindmespot" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl1">Spot Trace</span>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Status</span></td>
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
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td>Tracker Name&nbsp;</td>
                                            <td><input type="text" name="src_tracker_name" value="<%=srcTrackerName%>" size="30" on>&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <% if(jspCommand != JSPCommand.NONE) { %>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=list.size()>0?drawList(list, start, offset):"&nbsp;<br />Data not found"%></td>
                                        </tr>
                                        <% } %>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <span class="command">
                                                    <%
                                                    JSPLine jspLine = new JSPLine();
                                                    jspLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                    jspLine.initDefault();
                                                    jspLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + rootSystem + "/images/first.gif\" alt=\"First\">");
                                                    jspLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + rootSystem + "/images/prev.gif\" alt=\"Prev\">");
                                                    jspLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + rootSystem + "/images/next.gif\" alt=\"Next\">");
                                                    jspLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + rootSystem + "/images/last.gif\" alt=\"Last\">");
                                                    jspLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + rootSystem + "/images/first2.gif',1)");
                                                    jspLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + rootSystem + "/images/prev2.gif',1)");
                                                    jspLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + rootSystem + "/images/next2.gif',1)");
                                                    jspLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + rootSystem + "/images/last2.gif',1)");
                                                    %>
                                                    <%=jspLine.drawImageListLimit(jspCommand, vectSize, start, recordToGet)%>
                                                </span>
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