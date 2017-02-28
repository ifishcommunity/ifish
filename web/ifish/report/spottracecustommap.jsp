<%-- 
    Document   : spottracecustommap
    Created on : Dec 31, 2014, 16:06:16 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.PrintWriter"%>
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
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.FileUploadException"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawList(Vector list, int offset) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("60%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "5%");
    jsplist.addHeader("Date & Time", "19%");
    jsplist.addHeader("Message Type", "25%");
    jsplist.addHeader("Latitude", "13%");
    jsplist.addHeader("Longitude", "13%");
    jsplist.addHeader("Battery State", "15%");
    jsplist.addHeader("Select", "10%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs

    for (int i = 0; i < list.size(); i++) {
        FindMeSpot findMeSpot = (FindMeSpot) list.get(i);
        long lDateTime = findMeSpot.getDateTime().getTime();
        Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
        rowx.add(JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss"));
        rowx.add(findMeSpot.getMessageType());
        rowx.add("<div align=\"right\">" + String.valueOf(findMeSpot.getLatitude()) + "</div>");
        rowx.add("<div align=\"right\">" + String.valueOf(findMeSpot.getLongitude()) + "</div>");
        rowx.add(findMeSpot.getBatteryState());
        rowx.add("<center><input type=\"checkbox\" name=\"chk_"+i+"\" id=\"chk_"+i+"\" value=\"1\"></center>");

        lstData.add(rowx);
    }

    return jsplist.draw(index);
}
%>
<%
int jspCommand = JSPRequestValue.requestCommand(request);
long oidTracker = JSPRequestValue.requestLong(request, "oid_tracker");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
int offset = JSPRequestValue.requestInt(request, "offset");
double latitudeCenter = 0;
double longitudeCenter = 0;

/* get list tracker */
Vector listBoat = DbBoat.list(0, 0, DbBoat.colNames[DbBoat.COL_TRACKER_ID]+"!=0", "");
Hashtable hBoat = new Hashtable();
if(listBoat != null && listBoat.size() > 0) {
    for(int i = 0; i < listBoat.size(); i++) {
        Boat boat = (Boat) listBoat.get(i);
        hBoat.put(boat.getTrackerId(), boat);
    }
}

Vector listUserTracker = DbUserTracker.list(0, 0, DbUserTracker.colNames[DbUserTracker.COL_USER_ID]+"="+user.getOID(), "");
Vector listTracker = DbTracker.list(0, 0, DbTracker.colNames[DbTracker.COL_STATUS]+"="+1, "");
Vector valTracker = new Vector();
Vector keyTracker = new Vector();
if(listUserTracker != null && listUserTracker.size() > 0) {
    for(int i=0; i<listUserTracker.size(); i++) {
        UserTracker userTracker = (UserTracker) listUserTracker.get(i);
        if(listTracker != null && listTracker.size() > 0) {
            for(int j=0; j<listTracker.size(); j++) {
                Tracker tracker = (Tracker) listTracker.get(j);
                if(tracker.getTrackerId() == userTracker.getTrackerId()) {
                    Boat boat = (Boat) hBoat.get(tracker.getTrackerId());
                    if(boat == null) boat = new Boat();
                    String boatName = tracker.getStatus()==1?(boat.getOID()!=0?" ("+boat.getName()+")":""):"(Inactive)";
                    valTracker.add(String.valueOf(tracker.getTrackerName()+" "+boatName));
                    keyTracker.add(String.valueOf(tracker.getTrackerId()));
                }
            }
        }
    }
}

Hashtable hTracker = new Hashtable();
if(listTracker != null && listTracker.size() > 0) {
    for(int i=0; i<listTracker.size(); i++) {
        Tracker t = (Tracker) listTracker.get(i);
        hTracker.put(t.getTrackerId(), t);
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

String where = "";
Vector list = new Vector();
//Vector selectedList = new Vector();
if(oidTracker != 0) {
    where = DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID] + " = " + oidTracker;

}

if(ignoreDate != 1) {
    //the data's saved on UTC timezone, so need to use interval between UTC timezone and local timezone, and data's will show on local timezone
    int intervalHour = offset / 60;
    if(where.length() > 0) {
        where += " and " + DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
                + " between timestamp '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' + interval '" + intervalHour + "h'"
                + " and timestamp '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' + interval '" + intervalHour + "h'";
    } else {
        where = DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
                + " between timestamp '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' + interval '" + intervalHour + "h'"
                + " and timestamp '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' + interval '" + intervalHour + "h'";
    }
}

if(where.length() > 0) {
    where += " and " + DbFindMeSpot.colNames[DbFindMeSpot.COL_MESSAGE_TYPE] + " not like 'POWER_OFF'";
} else {
    where = DbFindMeSpot.colNames[DbFindMeSpot.COL_MESSAGE_TYPE] + " not like 'POWER_OFF'";
}

if(jspCommand == JSPCommand.LIST) {
    list = DbFindMeSpot.list(0, 0, where, DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]);
    if(session.getValue("MAP_LIST") != null) session.removeValue("MAP_LIST");
    session.putValue("MAP_LIST", list);
} else if(jspCommand == JSPCommand.REFRESH) {
    Vector tmpList = (Vector) session.getValue("MAP_LIST");
    list = new Vector();
    for (int i = 0; i < tmpList.size(); i++) {
        int n = JSPRequestValue.requestInt(request, "chk_" + i);
        if (n == 1) {
            FindMeSpot findMeSpot = (FindMeSpot) tmpList.get(i);
            list.add(findMeSpot);
        }
    }
    if(session.getValue("MAP_LIST") != null) session.removeValue("MAP_LIST");
    session.putValue("MAP_LIST", list);
} else if(jspCommand == JSPCommand.DOWNLOAD) {
    Vector tmpList = (Vector) session.getValue("MAP_LIST");
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

String lastStatus = "";
if(list.size() == 0) {
    FindMeSpot findMeSpot = DbFindMeSpot.getLatestStatus(oidTracker);
    lastStatus = "Last active " + JSPFormater.formatDate(findMeSpot.getDateTime(), "MMMM dd, yyyy") + "<br /> Battery State: " + findMeSpot.getBatteryState() + "<br /> Message: " + findMeSpot.getMessageContent();
}

/* download map */
String mapPath = "";
if(list != null && list.size() > 0) {
    for(int i = 0; i < list.size(); i++) {
        FindMeSpot findMeSpot = (FindMeSpot) list.get(i);
        if(mapPath.length() > 0) {
            mapPath += "|" + findMeSpot.getLatitude() + "," + findMeSpot.getLongitude();
        } else {
            mapPath += findMeSpot.getLatitude() + "," + findMeSpot.getLongitude();
        }
    }
}
String urlDownloadMap = "http://maps.googleapis.com/maps/api/staticmap?size=640x640&zoom=8&path=color:0xff0000ff|weight:3|"+mapPath+"&sensor=false";
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
        document.frmspottracecustommap.offset.value=offset;
        document.frmspottracecustommap.command.value="<%=JSPCommand.LIST%>";
        document.frmspottracecustommap.action="spottracecustommap.jsp";
        document.frmspottracecustommap.submit();
    }
    function cmdRefresh() {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracecustommap.offset.value=offset;
        document.frmspottracecustommap.command.value="<%=JSPCommand.REFRESH%>";
        document.frmspottracecustommap.action="spottracecustommap.jsp";
        document.frmspottracecustommap.submit();
    }
    function cmdDownload() {
        <%
        if(urlDownloadMap.length() <= 2048){
            out.println("window.open(\""+urlDownloadMap+"\");");
        } else {
            out.println("alert(\"Static Map URLs are restricted to 2048 characters in size. Please remove some point.\")");
        }
        %>
    }
    function cmdDownloadCSV() {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracecustommap.offset.value=offset;
        document.frmspottracecustommap.command.value="<%=JSPCommand.DOWNLOAD%>";
        document.frmspottracecustommap.action="spottracecustommap.jsp";
        document.frmspottracecustommap.submit();
    }
</script>
    <style>
      html, body, #map-canvas {
        height: 100%;
        margin: 0px;
        padding: 0px
      }
    </style>
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp"></script>
    <script src="../../main/v3_ll_grat.js"></script>
    <script>
        // This example creates a 2-pixel-wide red polyline showing
        // the path of William Kingsford Smith's first trans-Pacific flight between
        // Oakland, CA, and Brisbane, Australia.

        function initialize() {
          var flightPlanCoordinates = [
            <%
            if(list != null && list.size() > 0) {
                for(int i=0; i<list.size(); i++) {
                    FindMeSpot findMeSpot = (FindMeSpot) list.get(i);
                    latitudeCenter += findMeSpot.getLatitude();
                    longitudeCenter += findMeSpot.getLongitude();
                    if(i == list.size()-1) {
                        out.println("new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+")");
                    } else {
                        out.println("new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+"),");
                    }
                }
                latitudeCenter = latitudeCenter/list.size();
                longitudeCenter = longitudeCenter/list.size();
            }
            %>
          ];

          var mapOptions = {
            zoom: 8,
            maxZoom: 21,
            center: new google.maps.LatLng(<%=latitudeCenter%>, <%=longitudeCenter%>),
            panControl: false
          };

          var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

          var grid = new Graticule(map, true);

          var marker;
          <%
            int localTimeZone = offset * -1;
            long ONE_MINUTE_IN_MILLIS=60000;//millisecs
            if(list != null && list.size() > 0) {
                for(int i=0; i<list.size(); i++) {
                    FindMeSpot findMeSpot = (FindMeSpot) list.get(i);
                    long lDateTime = findMeSpot.getDateTime().getTime();
                    Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));
                    out.println("marker = new google.maps.Marker({position: new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+"), map: map, title: '"+JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")+" ("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+")'});");
                    out.println("google.maps.event.addListener(marker, 'click', function del_"+i+"() {if($(\"#chk_"+i+"\").prop('checked') == true){document.frmspottracecustommap.chk_"+i+".checked=false;}else{document.frmspottracecustommap.chk_"+i+".checked=true;}});");
                }
            }
          %>

          var flightPath = new google.maps.Polyline({
            path: flightPlanCoordinates,
            geodesic: true,
            strokeColor: '#FF0000',
            strokeOpacity: 1.0,
            strokeWeight: 2
          });

          flightPath.setMap(map);
        }

    google.maps.event.addDomListener(window, 'load', initialize);
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
                        <form name="frmspottracecustommap" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=jspCommand%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Spot Trace</span></td>
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
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="100">Tracker Name&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td width="200">Date & Time&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="100"><%=JSPCombo.draw("oid_tracker", null, String.valueOf(oidTracker), keyTracker, valTracker, "") %>&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td width="200">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracecustommap.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracecustommap.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
                                                        <td>
                                                            <input type="checkbox" name="ignore_date" value="1" <%=ignoreDate==1?"checked":""%>>
                                                        </td>
                                                        <td>
                                                            &nbsp;ignore
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="10">&nbsp;</td>
                                            <td>
                                                <input type="submit" name="showmap" value="Show Map" onClick="javascript:cmdList(this)">&nbsp;
                                                <input type="submit" name="reloadmap" value="Reload Map" onClick="javascript:cmdRefresh(this)">&nbsp;
                                                <b>Click <a href="javascript:cmdDownloadCSV()">here</a> to download this data.</b>
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <%if(jspCommand == JSPCommand.LIST || jspCommand == JSPCommand.REFRESH || jspCommand == JSPCommand.DOWNLOAD) {%>
                                        <tr align="left" valign="top">
                                            <%if(list.size()>0) {%>
                                            <td colspan="5" height="400px"><div id="map-canvas"></div>&nbsp;</td>
                                            <%} else {%>
                                            <td colspan="3">Data not found&nbsp;</td>
                                            <%}%>
                                        </tr>
                                        <%if(list.size()==0){%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=lastStatus%></td>
                                        </tr>
                                        <%}%>
                                        <%}%>
                                        <%if(jspCommand == JSPCommand.LIST || jspCommand == JSPCommand.REFRESH || jspCommand == JSPCommand.DOWNLOAD) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="5"><%=list.size()>0?drawList(list, offset):""%></td>
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
