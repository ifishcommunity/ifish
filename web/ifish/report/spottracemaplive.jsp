<%--
    Document   : spottracemaplive
    Created on : Mar 24, 2016, 8:37:07 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
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
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.FileUploadException"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ include file="../../main/javainit.jsp"%>
<!-- Jsp Block -->
<%
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
int offset = JSPRequestValue.requestInt(request, "offset");

/* get list tracker */
Vector listTracker = DbTracker.listAll();
Hashtable hTracker = new Hashtable();
if(listTracker != null && listTracker.size() > 0) {
    for(int i=0; i<listTracker.size(); i++) {
        Tracker t = (Tracker) listTracker.get(i);
        hTracker.put(t.getTrackerId(), t);
    }
}

/* get list boat */
Vector listSelectedBoat = DbBoat.list(0, 0, DbBoat.colNames[DbBoat.COL_TRACKER_ID]+"!=0", DbBoat.colNames[DbBoat.COL_HOME_PORT]+", "+DbBoat.colNames[DbBoat.COL_NAME]);
/* end */

Date startDate = new Date();
if(sStartDate.length() == 0) {
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -7);
    startDate = cal.getTime();
}

if(sStartDate.length() > 0) {
    startDate = JSPFormater.formatDate(sStartDate, "dd/MM/yyyy");
}

Date endDate = new Date();
if(sEndDate.length() > 0) {
    endDate = JSPFormater.formatDate(sEndDate, "dd/MM/yyyy");
}

String whereClause = DbFindMeSpot.colNames[DbFindMeSpot.COL_MESSAGE_TYPE] + " not like 'POWER_OFF'";

if(listSelectedBoat != null && listSelectedBoat.size() > 0) {
    String whereTracker = "";
    for(int i = 0; i < listSelectedBoat.size(); i++) {
        Boat boat = (Boat) listSelectedBoat.get(i);
            if(whereTracker.length() > 0) {
                whereTracker += " or ";
            }
            whereTracker += "b." + DbBoat.colNames[DbBoat.COL_OID] + " = " + boat.getOID();
    }

    if(whereTracker.length() > 0) {
        whereClause += " and (" + whereTracker + ")";
    }
}

if(ignoreDate != 1) {
    //the data's saved on UTC timezone, so need to use interval between UTC timezone and local timezone, and data's will show on local timezone
    int intervalHour = offset / 60;
    whereClause += " and " + DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
            + " between timestamp '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00' + interval '" + intervalHour + "h'"
            + " and timestamp '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59' + interval '" + intervalHour + "h'";
}

Vector list = SessSpotTrace.getMap(0, 0, whereClause);
%>

<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    function cmdList() {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracemaplive.offset.value=offset;
        document.frmspottracemaplive.command.value="<%=JSPCommand.LIST%>";
        document.frmspottracemaplive.action="spottracemaplive.jsp";
        document.frmspottracemaplive.submit();
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
                    if(i == list.size()-1) {
                        out.println("new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+")");
                    } else {
                        out.println("new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+"), ");
                    }
                }
            }
            %>
          ];

          var mapOptions = {
            zoom: 6,
            maxZoom: 21,
            center: new google.maps.LatLng(-5, 122), //center of Indonesia
            panControl: false
          };

          var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

          load571(map);
          load572(map);
          load573(map);
          load711(map);
          load712(map);
          load713(map);
          load714(map);
          load715(map);
          load716(map);
          load717(map);
          load718(map);
          loadMoUBox(map);
          loadJPDA(map);
          loadMPAKepAsia(map);
          loadMPAKepAyau(map);
          loadMPATelukMayalibit(map);
          loadMPASelatDampier(map);
          loadMPAKepMisool(map);
          loadMPAKepKofiauBoo(map);
          loadMPAWaigeoSebelahBarat(map);
          loadMPAKepKeiKecil(map);
          loadMPAKaimana(map);
          loadMPATelukCendrawasih(map);
          loadMPATogean(map);
          loadMPAWakatobi(map);
          loadMPATakaBoneRate(map);
          loadMPASawu(map);

           var circle ={
               path: google.maps.SymbolPath.CIRCLE,
               fillColor: 'red',
               fillOpacity: .5,
               scale: 3.5,
               strokeColor: 'red',
               strokeWeight: 0
           };

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

                    Tracker tracker = (Tracker)hTracker.get(findMeSpot.getTrackerId());
                    if(tracker == null) tracker = new Tracker();

                    out.println("marker = new google.maps.Marker({position: new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+"), icon: circle, map: map, title: '"+tracker.getTrackerName()+" - "+JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")+" ("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+")'});");
                    out.println("google.maps.event.addListener(marker, 'click', function() {infowindow"+i+".open(map,marker);});");
                }
            }
          %>
        }
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
    <script src="../main/wpp.js"></script>
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
                  <!--%@ include file="../main/menu.jsp"%-->
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                        <form name="frmspottracemaplive" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="offset" value="<%=offset%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="container">
                                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="10%">&nbsp;</td>
                                            <td width="10%">&nbsp;</td>
                                            <td width="40%">&nbsp;</td>
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
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracemaplive.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracemaplive.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
                                                        <td>
                                                            <input type="checkbox" name="ignore_date" value="1" <%=ignoreDate==1?"checked":""%>>
                                                        </td>
                                                        <td>
                                                            &nbsp;ignore
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td width="60%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <%if(list.size()>0) {%>
                                            <td colspan="5" height="720px"><div id="map-canvas"></div>&nbsp;</td>
                                            <%} else {%>
                                            <td colspan="5">Data not found&nbsp;</td>
                                            <%}%>
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
            <script>
                //Auto reload every 30 minutes (minute * second * milisecond)
                setTimeout(function() {document.forms[0].submit();}, (30 * 60 * 1000));
            </script>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>
