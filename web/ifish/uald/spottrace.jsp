<%-- 
    Document   : spottrace
    Created on : Jul 4, 2016, 12:18:31 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.ifish.data.FindMeSpot" %>
<%@ page import="com.project.ifish.data.DbFindMeSpot" %>
<%@ page import="com.project.ifish.master.DbTracker"%>
<%@ page import="com.project.ifish.master.Tracker"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawList(Vector objectClass, int start, int offset) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("75%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Tracker ID", "10%");
    jsplist.addHeader("Message Type", "15%");
    jsplist.addHeader("Latitude", "8%");
    jsplist.addHeader("Longitude", "8%");
    jsplist.addHeader("Date & Time", "15%");
    jsplist.addHeader("Battery State", "10%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs

    for (int i = 0; i < objectClass.size(); i++) {
        FindMeSpot findMeSpot = (FindMeSpot) objectClass.get(i);
        long lDateTime = findMeSpot.getDateTime().getTime();
        Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));

        String encryptedTrackerName = UUID.nameUUIDFromBytes(String.valueOf(findMeSpot.getTrackerId()+IFishConfig.UUID_KEY).getBytes()).toString();
        encryptedTrackerName = encryptedTrackerName.substring(encryptedTrackerName.length()-12);

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (i + 1 + start) + "</div>");
        rowx.add(encryptedTrackerName);
        rowx.add(findMeSpot.getMessageType());
        rowx.add("<div align=\"right\">" + String.valueOf(findMeSpot.getLatitude()) + "</div>");
        rowx.add("<div align=\"right\">" + String.valueOf(findMeSpot.getLongitude()) + "</div>");
        rowx.add(JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss"));
        rowx.add(findMeSpot.getBatteryState());

        lstData.add(rowx);
    }

    return jsplist.draw(index);
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String whereClause = "";
Vector list = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

int jspCommand = JSPRequestValue.requestCommand(request);
int jspCommandDownload = JSPRequestValue.requestInt(request, "command_download");
int start = JSPRequestValue.requestInt(request, "start");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
int offset = JSPRequestValue.requestInt(request, "offset");

Date startDate = new Date();
if(sStartDate.length() > 0) {
    startDate = JSPFormater.formatDate(sStartDate, "dd/MM/yyyy");
}

Date endDate = new Date();
if(sEndDate.length() > 0) {
    endDate = JSPFormater.formatDate(sEndDate, "dd/MM/yyyy");
}

if(ignoreDate != 1) {
    //the data's saved on UTC timezone, so need to use interval between UTC timezone and local timezone, and data's will show on local timezone
    int intervalHour = offset / 60;
    if(whereClause.length() > 0) {
        whereClause += " and " + DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
                + " between timestamp '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' + interval '" + intervalHour + "h'"
                + " and timestamp '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' + interval '" + intervalHour + "h'";
    } else {
        whereClause = DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
                + " between timestamp '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' + interval '" + intervalHour + "h'"
                + " and timestamp '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' + interval '" + intervalHour + "h'";
    }
}

/* get list tracker */
Vector listTracker = DbTracker.listAll();
Hashtable hTracker = new Hashtable();
if(listTracker != null && listTracker.size() > 0) {
    for(int i=0; i<listTracker.size(); i++) {
        Tracker t = (Tracker) listTracker.get(i);
        hTracker.put(t.getTrackerId(), t);
    }
}

/* control list */
int vectSize = 0;
if((jspCommand == JSPCommand.LIST || jspCommand == JSPCommand.FIRST || jspCommand == JSPCommand.PREV || jspCommand == JSPCommand.NEXT || jspCommand == JSPCommand.LAST)) {
    Control control = new Control();
    vectSize = DbFindMeSpot.getCount(whereClause);
    start = control.actionList(jspCommand, start, vectSize, recordToGet);
    list = DbFindMeSpot.list(start, recordToGet, whereClause, DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]);
}
/* end */

if(jspCommandDownload == JSPCommand.DOWNLOAD) {
    Vector tmpList = DbFindMeSpot.list(0, 0, whereClause, "");
    response.setContentType("application/csv");
    response.setHeader("content-disposition","filename=SpotTraceData.csv"); //Filename
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs
    PrintWriter outx = response.getWriter();
    String content = DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_NAME]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_MESSAGE_TYPE]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_LATITUDE]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_LONGITUDE]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_BATTERY_STATE];
    outx.println(content); //Content
    if(tmpList != null && tmpList.size() > 0) {
        for(int i = 0; i < tmpList.size(); i++) {
            FindMeSpot findMeSpot = (FindMeSpot) tmpList.get(i);
            long lDateTime = findMeSpot.getDateTime().getTime();
            Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));

            Tracker tracker = (Tracker)hTracker.get(findMeSpot.getTrackerId());
            if(tracker == null) tracker = new Tracker();

            String encryptedTrackerName = UUID.nameUUIDFromBytes(tracker.getTrackerName().getBytes()).toString();
            encryptedTrackerName = encryptedTrackerName.substring(encryptedTrackerName.length()-12);
            content = encryptedTrackerName
                    +","+findMeSpot.getMessageType()
                    +","+String.valueOf(findMeSpot.getLatitude())
                    +","+String.valueOf(findMeSpot.getLongitude())
                    +","+JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")
                    +","+findMeSpot.getBatteryState();
            outx.println(content); //Content
        }
    }
    outx.flush();
    outx.close();
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
        var offset = new Date().getTimezoneOffset();
        document.frmualdspottrace.start.value="0";
        document.frmualdspottrace.offset.value=offset;
        document.frmualdspottrace.command.value="<%=JSPCommand.LIST%>";
        document.frmualdspottrace.command_download.value="<%=JSPCommand.NONE%>";
        document.frmualdspottrace.action="spottrace.jsp";
        document.frmualdspottrace.submit();
    }

    function cmdListFirst(){
        document.frmualdspottrace.command.value="<%=JSPCommand.FIRST%>";
        document.frmualdspottrace.command_download.value="<%=JSPCommand.NONE%>";
        document.frmualdspottrace.action="spottrace.jsp";
        document.frmualdspottrace.submit();
    }

    function cmdListPrev(){
        document.frmualdspottrace.command.value="<%=JSPCommand.PREV%>";
        document.frmualdspottrace.command_download.value="<%=JSPCommand.NONE%>";
        document.frmualdspottrace.action="spottrace.jsp";
        document.frmualdspottrace.submit();
    }

    function cmdListNext(){
        document.frmualdspottrace.command.value="<%=JSPCommand.NEXT%>";
        document.frmualdspottrace.command_download.value="<%=JSPCommand.NONE%>";
        document.frmualdspottrace.action="spottrace.jsp";
        document.frmualdspottrace.submit();
    }

    function cmdListLast(){
        document.frmualdspottrace.command.value="<%=JSPCommand.LAST%>";
        document.frmualdspottrace.command_download.value="<%=JSPCommand.NONE%>";
        document.frmualdspottrace.action="spottrace.jsp";
        document.frmualdspottrace.submit();
    }

    function cmdDownloadCSV() {
        var offset = new Date().getTimezoneOffset();
        document.frmualdspottrace.offset.value=offset;
        document.frmualdspottrace.command.value="<%=JSPCommand.LIST%>";
        document.frmualdspottrace.command_download.value="<%=JSPCommand.DOWNLOAD%>";
        document.frmualdspottrace.action="spottrace.jsp";
        document.frmualdspottrace.submit();
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
                        <form name="frmualdspottrace" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="command_download" value="">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">UALD</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Spot Trace Data</span>
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
                                            <td width="10%">Date & Time&nbsp;</td>
                                            <td width="30%">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmualdspottrace.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmualdspottrace.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
                                                        <td>
                                                            <input type="checkbox" name="ignore_date" value="1" <%=ignoreDate==1?"checked":""%>>
                                                        </td>
                                                        <td>
                                                            &nbsp;ignore
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <%if(jspCommand == JSPCommand.LIST || jspCommand == JSPCommand.FIRST || jspCommand == JSPCommand.PREV || jspCommand == JSPCommand.NEXT || jspCommand == JSPCommand.LAST) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=list.size()>0?drawList(list, start, offset):"Data not found"%></td>
                                        </tr>
                                        <%if(list.size()==0){%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <%}%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <span class="command">
                                                    <%
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
                                        <%if(list.size()>0) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><b>Click <a href="javascript:cmdDownloadCSV()">here</a> to download this data.</b></td>
                                        </tr>
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
