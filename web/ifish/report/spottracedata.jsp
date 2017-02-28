<%-- 
    Document   : spottracedata
    Created on : Oct 19, 2014, 7:37:16 AM
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
public String drawList(Hashtable hTracker, Vector objectClass, int start, int offset) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Tracker Id", "12%");
    jsplist.addHeader("Tracker Name", "12%");
    jsplist.addHeader("Message Type", "12%");
    jsplist.addHeader("Latitude", "7%");
    jsplist.addHeader("Longitude", "7%");
    jsplist.addHeader("Date & Time", "12%");
    jsplist.addHeader("Battery State", "10%");
    jsplist.addHeader("Message", "25%");

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

        Tracker tracker = (Tracker)hTracker.get(findMeSpot.getTrackerId());
        if(tracker == null) tracker = new Tracker();

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (i + 1 + start) + "</div>");
        rowx.add(String.valueOf(findMeSpot.getTrackerId()));
        rowx.add(tracker.getTrackerName());
        rowx.add(findMeSpot.getMessageType());
        rowx.add("<div align=\"right\">" + String.valueOf(findMeSpot.getLatitude()) + "</div>");
        rowx.add("<div align=\"right\">" + String.valueOf(findMeSpot.getLongitude()) + "</div>");
        rowx.add(JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss"));
        rowx.add(findMeSpot.getBatteryState());
        rowx.add(findMeSpot.getMessageContent());

        lstData.add(rowx);
    }

    return jsplist.draw(index);
}
%>
<%
int jspCommand = JSPRequestValue.requestCommand(request);
int jspCommandDownload = JSPRequestValue.requestInt(request, "command_download");
int start = JSPRequestValue.requestInt(request, "start");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
int offset = JSPRequestValue.requestInt(request, "offset");
String programSite = JSPRequestValue.requestString(request, "program_site");

/* VARIABLE DECLARATION */
int recordToGet = 15;
String whereClause = "";
Vector list = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

/* get list tracker */
Vector listTracker = DbTracker.listAll();
Hashtable hTracker = new Hashtable();
if(listTracker != null && listTracker.size() > 0) {
    for(int i=0; i<listTracker.size(); i++) {
        Tracker t = (Tracker) listTracker.get(i);
        hTracker.put(t.getTrackerId(), t);
    }
}

Vector listUserBoat = DbUserBoat.list(0, 0, DbUserBoat.colNames[DbUserBoat.COL_USER_ID]+"="+user.getOID(), "");
String whereBoat = DbBoat.colNames[DbBoat.COL_TRACKER_ID]+"!=0";
if(programSite.length() > 0) {
    whereBoat += " and " + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '" + programSite + "'";
} else {
    whereBoat = DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " not ilike '" + IFishConfig.SITE_OTHERS + "'";
}
Vector listBoat = DbBoat.list(0, 0, whereBoat, DbBoat.colNames[DbBoat.COL_HOME_PORT]+", "+DbBoat.colNames[DbBoat.COL_NAME]);
Vector listSelectedBoat = new Vector();
if(listBoat != null && listBoat.size() > 0) {
    for(int j=0; j<listBoat.size(); j++) {
        Boat boat = (Boat) listBoat.get(j);
        if(listUserBoat != null && listUserBoat.size() > 0) {
            for(int i=0; i<listUserBoat.size(); i++) {
                UserBoat userBoat = (UserBoat) listUserBoat.get(i);
                if(boat.getOID() == userBoat.getBoatId()) {
                    listSelectedBoat.add(boat);
                }
            }
        }
    }
}
/* end */

Date startDate = new Date();
if(sStartDate.length() > 0) {
    startDate = JSPFormater.formatDate(sStartDate, "dd/MM/yyyy");
}

Date endDate = new Date();
if(sEndDate.length() > 0) {
    endDate = JSPFormater.formatDate(sEndDate, "dd/MM/yyyy");
}

boolean isBoatChecked = false;
if(listSelectedBoat != null && listSelectedBoat.size() > 0) {
    String whereTracker = "";
    for(int i = 0; i < listSelectedBoat.size(); i++) {
        Boat boat = (Boat) listSelectedBoat.get(i);
        long chk = JSPRequestValue.requestLong(request, "boat_" + boat.getOID());
        if(chk != 0) {
            isBoatChecked = true;
            if(whereTracker.length() > 0) {
                whereTracker += " or ";
            }
            whereTracker += "b." + DbBoat.colNames[DbBoat.COL_OID] + " = " + boat.getOID();
        }
    }

    if(whereTracker.length() > 0) {
        whereClause = "(" + whereTracker + ")";
    }
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

/* control list */
int vectSize = 0;
if((jspCommand == JSPCommand.LIST || jspCommand == JSPCommand.FIRST || jspCommand == JSPCommand.PREV || jspCommand == JSPCommand.NEXT || jspCommand == JSPCommand.LAST)
        && isBoatChecked) {
    Control control = new Control();
    vectSize = SessSpotTrace.getCountMap(whereClause);
    start = control.actionList(jspCommand, start, vectSize, recordToGet);
    list = SessSpotTrace.getMap(start, recordToGet, whereClause);
}
/* end */

if(jspCommandDownload == JSPCommand.DOWNLOAD && isBoatChecked) {
    Vector tmpList = SessSpotTrace.getMap(0, 0, whereClause);
    response.setContentType("application/csv");
    response.setHeader("content-disposition","filename=SpotTraceReport.csv"); //Filename
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs
    PrintWriter outx = response.getWriter();
    String content = DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_NAME]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_MESSAGE_TYPE]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_LATITUDE]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_LONGITUDE]
            +","+DbFindMeSpot.colNames[DbFindMeSpot.COL_BATTERY_STATE];
    outx.println(content); //Content
    
    if(tmpList != null && tmpList.size() > 0) {
        for(int i = 0; i < tmpList.size(); i++) {
            FindMeSpot findMeSpot = (FindMeSpot) tmpList.get(i);
            long lDateTime = findMeSpot.getDateTime().getTime();
            Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));

            Tracker tracker = (Tracker)hTracker.get(findMeSpot.getTrackerId());
            if(tracker == null) tracker = new Tracker();

            content = findMeSpot.getTrackerId()
                    +","+tracker.getTrackerName()
                    +","+JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")
                    +","+findMeSpot.getMessageType()
                    +","+String.valueOf(findMeSpot.getLatitude())
                    +","+String.valueOf(findMeSpot.getLongitude())
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
    <%if (!privReportSpotTrace) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdList() {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracedata.start.value="0";
        document.frmspottracedata.offset.value=offset;
        document.frmspottracedata.command.value="<%=JSPCommand.LIST%>";
        document.frmspottracedata.command_download.value="<%=JSPCommand.NONE%>";
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function cmdListFirst(){
        document.frmspottracedata.command.value="<%=JSPCommand.FIRST%>";
        document.frmspottracedata.command_download.value="<%=JSPCommand.NONE%>";
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function cmdListPrev(){
        document.frmspottracedata.command.value="<%=JSPCommand.PREV%>";
        document.frmspottracedata.command_download.value="<%=JSPCommand.NONE%>";
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function cmdListNext(){
        document.frmspottracedata.command.value="<%=JSPCommand.NEXT%>";
        document.frmspottracedata.command_download.value="<%=JSPCommand.NONE%>";
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function cmdListLast(){
        document.frmspottracedata.command.value="<%=JSPCommand.LAST%>";
        document.frmspottracedata.command_download.value="<%=JSPCommand.NONE%>";
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function cmdDownloadCSV() {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracedata.offset.value=offset;
        document.frmspottracedata.command.value="<%=JSPCommand.LIST%>";
        document.frmspottracedata.command_download.value="<%=JSPCommand.DOWNLOAD%>";
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function cmdMap(ps) {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracedata.offset.value=offset;
        document.frmspottracedata.command.value="<%=JSPCommand.NONE%>";
        document.frmspottracedata.program_site.value=ps;
        document.frmspottracedata.action="spottracedata.jsp";
        document.frmspottracedata.submit();
    }

    function checkboxAll(val) {
        <%
        for (int x = 0; x < listSelectedBoat.size(); x++) {
            Boat boat = (Boat) listSelectedBoat.get(x);
            out.println("document.frmspottracedata.boat_" + boat.getOID() + ".checked = val.checked;");
        }
        %>
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
                        <form name="frmspottracedata" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="command_download" value="">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                          <input type="hidden" name="program_site" value="<%=programSite%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl1">Spot Trace</span>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Data</span></td>
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
                                            <%if(programSite.equals("")) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;All&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('')" class="tablink">All</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
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
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <%if(programSite.equals(IFishConfig.SITE_OTHERS)) {%>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_OTHERS%>&nbsp;&nbsp;</div>
                                            </td>
                                            <%} else {%>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMap('<%=IFishConfig.SITE_OTHERS%>')" class="tablink"><%=IFishConfig.SITE_OTHERS%></a>&nbsp;&nbsp;</div>
                                            </td>
                                            <%}%>
                                            <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
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
                                            <td width="10%">Tracker Name&nbsp;&nbsp;<input type="checkbox" name="boat_all" value="1" onclick="javascript:checkboxAll(this)" <%=isBoatChecked?"checked":""%>>All</td>
                                            <td colspan="2">
                                                <%
                                                if(listSelectedBoat != null && listSelectedBoat.size() > 0) {
                                                    for(int i = 0; i < listSelectedBoat.size(); i++) {
                                                        Boat boat = (Boat)listSelectedBoat.get(i);
                                                        String fieldName = "boat_" + boat.getOID();
                                                        long oidx = JSPRequestValue.requestLong(request, fieldName);
                                                        String chk = "";
                                                        if(oidx != 0) {
                                                            chk = " checked";
                                                        }

                                                        Tracker t = (Tracker)hTracker.get(boat.getTrackerId());
                                                        if(t == null) t = new Tracker();
                                                        
                                                        out.println("<div style=\"width:240px;float:left;margin-right:5px;margin-bottom:0px;text-align:left;\"><input type=\"checkbox\" name=\""+fieldName+"\" value=\"1\""+chk+">"+boat.getName()+" ("+t.getTrackerName()+")</div>");
                                                    }
                                                }
                                                %>
                                            </td>
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
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracedata.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracedata.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
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
                                            <td colspan="3"><%=list.size()>0?drawList(hTracker, list, start, offset):"Data not found"%></td>
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
