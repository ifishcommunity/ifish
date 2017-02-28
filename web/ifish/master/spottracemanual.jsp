<%-- 
    Document   : spottracemanual
    Created on : Nov 10, 2014, 10:20:46 AM
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
<%@ page import="com.project.ifish.data.DbFindMeSpot"%>
<%@ page import="com.project.ifish.master.DbTracker"%>
<%@ page import="com.project.ifish.master.Tracker"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_MASTER_SPOT_TRACE, AppMenu.PRIV_ADD);
%>
<%!
String formatDate(Date date, String format) {
    String sdate = JSPFormater.formatDate(date, format);
    sdate += "-0000";
    sdate = sdate.substring(0, 10) + "T" + sdate.substring(11, sdate.length());
    return sdate;
}
%>
<%
String sTrackerDate = JSPRequestValue.requestString(request, "tracker_date");
String submit = JSPRequestValue.requestString(request, "submit");
String msgStatus = "";
Date trackerDate = new Date();
if(sTrackerDate.length() > 0) {
    trackerDate = JSPFormater.formatDate(sTrackerDate, "dd/MM/yyyy");
}

if(submit.equals("Download Data")) {
    Vector list = DbTracker.list(0, 0, DbTracker.colNames[DbTracker.COL_STATUS] + "=" + 1, "");

    if(list != null && list.size() > 0) {
        for (int i = 0; i < list.size(); i++) {
            Tracker tracker = (Tracker) list.get(i);
            boolean status = false;
            String url = "https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/public/feed/" + tracker.getFeedId() + "/message.xml?startDate=" + formatDate(new Date(), "yyyy-MM-dd 00:00:00") + "&endDate=" + formatDate(new Date(), "yyyy-MM-dd 23:59:59");
            try {
                status = DbFindMeSpot.XML2DBv2(url);
                DbFindMeSpot.setAvgLocation();
                msgStatus = "Download is complete.";
            } catch (Exception e) {
                System.out.println("(" + new Date() + "): " + e.toString());
            }
            System.out.println("(" + new Date() + ") [Latest] Tracker: " + tracker.getTrackerName() + " " + (status == true ? "Done" : "Fail"));
        }
    }

    // reset command
    submit = "";
}
%>
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privMasterSpotTrace || !privAdd) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function showLoading() {
        document.all.loading.style.display="block";
    }
</script>
<!-- #EndEditable -->
</head>
<body>
    <%@ include file = "../../calendar/calendarframe.jsp" %>
    <form name="frmspottrace" method="post" action="">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="top">
                <td class="container">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr align="left" valign="top">
                            <td width="10%">&nbsp;</td>
                            <td width="30%">&nbsp;</td>
                            <td width="60%">&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3"><h3>Spot Trace Manual Download</h3></td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3">Select date to download</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3">
                                <input name="tracker_date" value="<%=JSPFormater.formatDate((trackerDate == null) ? new Date() : trackerDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                &nbsp;<a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmspottrace.tracker_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Tracker Date"></a>
                                &nbsp;<input type="submit" name="submit" value="Download Data" onclick="javascript:showLoading()">
                            </td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3">&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3"><div id="loading"><img src="<%=rootSystem%>/images/loading.gif"></div><%=msgStatus%></td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3">&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="3">&nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
    <script language="javascript">
        document.all.loading.style.display="none";
    </script>
</body>
</html>
