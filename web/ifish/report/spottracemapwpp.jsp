<%-- 
    Document   : rptspottracewpp
    Created on : Nov 19, 2015, 9:22:18 AM
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
<%@ page import="com.project.ifish.data.FindMeSpot"%>
<%@ page import="com.project.ifish.data.DbFindMeSpot"%>
<%@ page import="com.project.ifish.master.Tracker"%>
<%@ page import="com.project.ifish.master.DbTracker"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.session.SessSpotTrace"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%
int jspCommand = JSPRequestValue.requestCommand(request);
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
int dailyAvgPosition = JSPRequestValue.requestInt(request, "daily_avg_position");
int offset = JSPRequestValue.requestInt(request, "offset");
String programSite = JSPRequestValue.requestString(request, "program_site");

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
}// else {
//    whereBoat = DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " not ilike '" + IFishConfig.SITE_OTHERS + "'";
//}
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

String whereClause = DbFindMeSpot.colNames[DbFindMeSpot.COL_MESSAGE_TYPE] + " not like 'POWER_OFF'";
Vector list = new Vector(1, 1);
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

if(jspCommand == JSPCommand.LIST && isBoatChecked) {
    if(dailyAvgPosition == 1) {
        list = SessSpotTrace.getMapDailyAvgPosition(0, 0, whereClause);
    } else {
        list = SessSpotTrace.getMap(0, 0, whereClause);
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
    <%if (!privReportSpotTrace) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdList() {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracemapwpp.offset.value=offset;
        document.frmspottracemapwpp.command.value="<%=JSPCommand.LIST%>";
        document.frmspottracemapwpp.action="spottracemapwpp.jsp";
        document.frmspottracemapwpp.submit();
    }

    function cmdMap(ps) {
        var offset = new Date().getTimezoneOffset();
        document.frmspottracemapwpp.offset.value=offset;
        document.frmspottracemapwpp.command.value="<%=JSPCommand.NONE%>";
        document.frmspottracemapwpp.program_site.value=ps;
        document.frmspottracemapwpp.action="spottracemapwpp.jsp";
        document.frmspottracemapwpp.submit();
    }

    function checkboxAll(val) {
        <%
        for (int x = 0; x < listSelectedBoat.size(); x++) {
            Boat boat = (Boat) listSelectedBoat.get(x);
            out.println("document.frmspottracemapwpp.boat_" + boat.getOID() + ".checked = val.checked;");
        }
        %>
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
                        if(dailyAvgPosition == 1) {
                            out.println("new google.maps.LatLng("+findMeSpot.getDailyAvgLatitude()+", "+findMeSpot.getDailyAvgLongitude()+")");
                        } else {
                            out.println("new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+")");
                        }
                    } else {
                        if(dailyAvgPosition == 1) {
                            out.println("new google.maps.LatLng("+findMeSpot.getDailyAvgLatitude()+", "+findMeSpot.getDailyAvgLongitude()+"), ");
                        } else {
                            out.println("new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+"), ");
                        }
                    }
                }
            }
            %>
          ];

          var mapOptions = {
            zoom: 5,
            maxZoom: 21,
            center: new google.maps.LatLng(-4, 117), //center of Indonesia
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

                    if(dailyAvgPosition == 1) {
                        out.println("marker = new google.maps.Marker({position: new google.maps.LatLng("+findMeSpot.getDailyAvgLatitude()+", "+findMeSpot.getDailyAvgLongitude()+"), icon: circle, map: map, title: '"+tracker.getTrackerName()+" - "+JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")+" ("+findMeSpot.getDailyAvgLatitude()+", "+findMeSpot.getDailyAvgLongitude()+")'});");
                    } else {
                        out.println("marker = new google.maps.Marker({position: new google.maps.LatLng("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+"), icon: circle, map: map, title: '"+tracker.getTrackerName()+" - "+JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")+" ("+findMeSpot.getLatitude()+", "+findMeSpot.getLongitude()+")'});");
                    }
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
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                        <form name="frmspottracemapwpp" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="offset" value="<%=offset%>">
                          <input type="hidden" name="program_site" value="<%=programSite%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl1">Spot Trace</span>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Map With WPP</span></td>
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
                                            <td width="10%">Boat Name&nbsp;&nbsp;<input type="checkbox" name="boat_all" value="1" onclick="javascript:checkboxAll(this)" <%=isBoatChecked?"checked":""%>>All</td>
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

                                                        out.println("<div style=\"width:240px;float:left;margin-right:5px;margin-bottom:0px;text-align:left;\"><input type=\"checkbox\" name=\""+fieldName+"\" value=\"1\""+chk+">"+boat.getName()+" ("+(boat.getTrackerStatus()==IFishConfig.STATUS_ACTIVE?t.getTrackerName():"<strike>"+t.getTrackerName()+"</strike>")+")</div>");
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
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracemapwpp.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottracemapwpp.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
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
                                            <td width="10%">Daily Avg. Position</td>
                                            <td width="30%"><input type="checkbox" name="daily_avg_position" value="1" <%=dailyAvgPosition==1?"checked":""%>>&nbsp;Yes</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3"></td>
                                        </tr>
                                        <%if(jspCommand == JSPCommand.LIST) {%>
                                        <tr align="left" valign="top">
                                            <%if(list.size()>0) {%>
                                            <td colspan="3" height="900px"><div id="map-canvas"></div>&nbsp;</td>
                                            <%} else {%>
                                            <td colspan="3">Data not found&nbsp;</td>
                                            <%}%>
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
