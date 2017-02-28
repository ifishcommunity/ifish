<%-- 
    Document   : rptcodrsdetail
    Created on : Apr 25, 2016, 8:41:54 AM
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
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.data.DeepSlope"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.data.DbSizing"%>
<%@ page import="com.project.ifish.session.SessDeepSlope"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawList(String rootSystem, Vector objectClass, int start, long userId) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Landing Date", "8%");
    jsplist.addHeader("Boat Name", "12%");
    jsplist.addHeader("Boat Home Port", "10%");
    jsplist.addHeader("Image Location on NAS", "18%");
    jsplist.addHeader("Fishing Gear", "7%");
    jsplist.addHeader("Major Fishing Area", "8%");
    jsplist.addHeader("Number of Fish", "7%");
    jsplist.addHeader("Estimated Weight (kg)", "7%");
    jsplist.addHeader("Upload By", "10%");
    jsplist.addHeader("Status", "5%");
    jsplist.addHeader("Action", "5%");

    Vector lstData = jsplist.getData();
    jsplist.reset();
    Vector rowx = new Vector();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

    Vector listBoat = DbBoat.listAll();
    Hashtable hBoat = new Hashtable();
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat boat = (Boat) listBoat.get(i);
            hBoat.put(boat.getOID(), boat);
        }
    }

    Vector listPartner = DbPartner.listAll();
    Hashtable hPartner = new Hashtable();
    if(listPartner != null && listPartner.size() > 0) {
        for(int i = 0; i < listPartner.size(); i++) {
            Partner partner = (Partner) listPartner.get(i);
            hPartner.put(partner.getOID(), partner);
        }
    }

    Vector listUser = DbUser.listAll();
    Hashtable hUser = new Hashtable();
    if(listUser != null && listUser.size() > 0) {
        for(int i = 0; i < listUser.size(); i++) {
            User user = (User) listUser.get(i);
            hUser.put(user.getOID(), user);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        DeepSlope deepslope = (DeepSlope) objectClass.get(i);

        Boat boat = (Boat) hBoat.get(deepslope.getBoatId());
        if(boat == null) boat = new Boat();

        User user = (User) hUser.get(deepslope.getUserId());
        if(user == null) user = new User();

        int total = DbSizing.getCount(deepslope.getOID());
        double estimatedWeight = SessDeepSlope.getEstimatedWeight(deepslope.getOID());

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
        rowx.add(JSPFormater.formatDate(deepslope.getLandingDate(), "MMM d, yyyy"));
        rowx.add(boat.getName());
        rowx.add(boat.getHomePort());
        rowx.add(sdf.format(deepslope.getLandingDate())+"-"+boat.getName().trim().replaceAll("\\ ", ""));
        rowx.add(deepslope.getFishingGear());
        rowx.add("<div align=\"center\">" + deepslope.getWpp1() + " " + deepslope.getWpp2() + " " + deepslope.getWpp3() + " " + deepslope.getOtherFishingGround() + "</div>");
        rowx.add("<div align=\"center\">" + total + "</div>");
        rowx.add("<div align=\"center\">" + JSPFormater.formatNumber((estimatedWeight/1000), "#") + "</div>");
        rowx.add(user.getFullName());
        
        String action = "<a href=\"javascript:cmdDownload('"+deepslope.getOID()+"')\"><img src=\""+rootSystem+"/images/export_excel.png\" border=\"0\" alt=\"Download\"></a>";
        if(userId == user.getOID() && deepslope.getApproach() == IFishConfig.APPROACH_CODRS && false) {
            action += "&nbsp;&nbsp;<a href=\"javascript:cmdDelete('"+deepslope.getOID()+"', 'CODRS-"+boat.getName().trim().replaceAll("\\ ", "")+"-"+sdf.format(deepslope.getLandingDate())+".xls"+"')\"><img src=\""+rootSystem+"/images/delete.png\" border=\"0\" alt=\"Delete\"></a>";
        }
        rowx.add(deepslope.getDocStatus());
        rowx.add("<div align=\"center\">" + action + "</div>");
        lstData.add(rowx);
    }

    return jsplist.draw(-1);
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String whereClause = "";
String orderClause = DbDeepSlope.colNames[DbDeepSlope.COL_LANDING_DATE] + " desc, " + DbDeepSlope.colNames[DbDeepSlope.COL_CODRS_FILE_NAME] + " desc";
Vector list = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

int jspCommand = JSPRequestValue.requestCommand(request);
int jspCommandList = JSPRequestValue.requestInt(request, "command_list");
int start = JSPRequestValue.requestInt(request, "start");
String programSite = JSPRequestValue.requestString(request, "program_site");
long boatId = JSPRequestValue.requestLong(request, "boat_id");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
long landingId = JSPRequestValue.requestLong(request, "landing_id");

Vector valSite = new Vector();
Vector keySite = new Vector();
valSite.add(IFishConfig.SITE_BALI);
keySite.add(IFishConfig.SITE_BALI);
valSite.add(IFishConfig.SITE_KEMA);
keySite.add(IFishConfig.SITE_KEMA);
valSite.add(IFishConfig.SITE_KUPANG);
keySite.add(IFishConfig.SITE_KUPANG);
valSite.add(IFishConfig.SITE_LUWUK);
keySite.add(IFishConfig.SITE_LUWUK);
valSite.add(IFishConfig.SITE_PROBOLINGGO);
keySite.add(IFishConfig.SITE_PROBOLINGGO);
valSite.add(IFishConfig.SITE_TANJUNG_LUAR);
keySite.add(IFishConfig.SITE_TANJUNG_LUAR);

Date startDate = new Date();
if(sStartDate.length() > 0) {
    startDate = JSPFormater.formatDate(sStartDate, "dd/MM/yyyy");
}

Date endDate = new Date();
if(sEndDate.length() > 0) {
    endDate = JSPFormater.formatDate(sEndDate, "dd/MM/yyyy");
}

Vector listBoat = new Vector();
if(programSite.length() > 0) {
    String whereBoat = DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '" + programSite + "'";
    listBoat = DbBoat.list(0, 0, whereBoat, DbBoat.colNames[DbBoat.COL_PROGRAM_SITE]+","+DbBoat.colNames[DbBoat.COL_NAME]);
    String whereDeepSlope = "";

    if(boatId > 0) {
        whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_BOAT_ID]+"="+boatId;
    } else {
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat boat = (Boat) listBoat.get(i);
            if(whereDeepSlope.length() == 0) {
                whereDeepSlope = DbDeepSlope.colNames[DbDeepSlope.COL_BOAT_ID] + " = " + boat.getOID();
            } else {
                whereDeepSlope += " or " + DbDeepSlope.colNames[DbDeepSlope.COL_BOAT_ID] + " = " + boat.getOID();
            }
        }
    }
    whereClause = "(" + whereDeepSlope + ")";
    }
} else {
    listBoat = DbBoat.list(0, 0, "", DbBoat.colNames[DbBoat.COL_PROGRAM_SITE]+","+DbBoat.colNames[DbBoat.COL_NAME]);
    if(boatId > 0) {
        whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_BOAT_ID]+"="+boatId;
    }
}

if(ignoreDate != 1) {
    if(whereClause.length() > 0) {
        whereClause += " and " + DbDeepSlope.colNames[DbDeepSlope.COL_LANDING_DATE]
                + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00'"
                + " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59'";
    } else {
        whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_LANDING_DATE]
                + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00'"
                + " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59'";
    }
}

if(whereClause.length() > 0) {
    whereClause += " and " + DbDeepSlope.colNames[DbDeepSlope.COL_APPROACH] + " = 2";
} else {
    whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_APPROACH] + " = 2";
}

if(jspCommand == JSPCommand.DELETE) {
    DbDeepSlope.deleteRecursiveCODRS(request, landingId);
    jspCommand = JSPCommand.NONE;
}

/* control list */
Control control = new Control();
int vectSize = 0;
if(jspCommandList != JSPCommand.NONE) {
    vectSize = DbDeepSlope.getCount(whereClause);
    start = control.actionList(jspCommandList, start, vectSize, recordToGet);
    list = DbDeepSlope.list(start, recordToGet, whereClause, orderClause);
}
/* end */

// List of Boat by Program Site
Vector valBoat = new Vector();
Vector keyBoat = new Vector();
valBoat.add("All");
keyBoat.add("0");
if(listBoat != null && listBoat.size() > 0) {
    for(int i=0; i<listBoat.size(); i++) {
        Boat boat = (Boat) listBoat.get(i);
        valBoat.add(boat.getName()+" ("+boat.getProgramSite()+")");
        keyBoat.add(String.valueOf(boat.getOID()));
    }
}
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privReportCODRS) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdDelete(oid, name) {
        if(confirm("Are you sure to delete this data ("+name+")?")) {
        document.frmrptcodrsdetail.start.value="0";
        document.frmrptcodrsdetail.landing_id.value=oid;
        document.frmrptcodrsdetail.command.value="<%=JSPCommand.DELETE%>";
        document.frmrptcodrsdetail.command_list.value="<%=JSPCommand.LIST%>";
        document.frmrptcodrsdetail.action="rptcodrsdetail.jsp";
        document.frmrptcodrsdetail.submit();
        }
    }

    function cmdDownload(oid) {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.report.CODRSDataXml?landing_id="+oid);
    }

    function cmdList() {
        document.frmrptcodrsdetail.start.value="0";
        document.frmrptcodrsdetail.command_list.value="<%=JSPCommand.LIST%>";
        document.frmrptcodrsdetail.action="rptcodrsdetail.jsp";
        document.frmrptcodrsdetail.submit();
    }

    function cmdListFirst(){
        document.frmrptcodrsdetail.command_list.value="<%=JSPCommand.FIRST%>";
        document.frmrptcodrsdetail.action="rptcodrsdetail.jsp";
        document.frmrptcodrsdetail.submit();
    }

    function cmdListPrev(){
        document.frmrptcodrsdetail.command_list.value="<%=JSPCommand.PREV%>";
        document.frmrptcodrsdetail.action="rptcodrsdetail.jsp";
        document.frmrptcodrsdetail.submit();
    }

    function cmdListNext(){
        document.frmrptcodrsdetail.command_list.value="<%=JSPCommand.NEXT%>";
        document.frmrptcodrsdetail.action="rptcodrsdetail.jsp";
        document.frmrptcodrsdetail.submit();
    }

    function cmdListLast(){
        document.frmrptcodrsdetail.command_list.value="<%=JSPCommand.LAST%>";
        document.frmrptcodrsdetail.action="rptcodrsdetail.jsp";
        document.frmrptcodrsdetail.submit();
    }
</script>
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
                <td width="165" height="100%" valign="top" background="<%=rootSystem%>/images/leftbg.gif">
                  <!-- #BeginEditable "menu" -->
                  <%@ include file="../main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                        <form name="frmrptcodrsdetail" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=jspCommand%>">
                          <input type="hidden" name="command_list" value="<%=jspCommandList%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="landing_id" value="0">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">CODRS By Landing</span></td>
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
                                        <tr>
                                            <td width="10%">Program Site</td>
                                            <td width="30%">
                                                <select name="program_site">
                                                    <option value="" <%=programSite.length()==0?"selected":""%>>All</option>
                                                    <option value="<%=IFishConfig.SITE_BALI%>" <%=programSite.equals(IFishConfig.SITE_BALI)?"selected":""%>><%=IFishConfig.SITE_BALI%></option>
                                                    <option value="<%=IFishConfig.SITE_KUPANG%>" <%=programSite.equals(IFishConfig.SITE_KUPANG)?"selected":""%>><%=IFishConfig.SITE_KUPANG%></option>
                                                    <option value="<%=IFishConfig.SITE_KEMA%>" <%=programSite.equals(IFishConfig.SITE_KEMA)?"selected":""%>><%=IFishConfig.SITE_KEMA%></option>
                                                    <option value="<%=IFishConfig.SITE_PROBOLINGGO%>" <%=programSite.equals(IFishConfig.SITE_PROBOLINGGO)?"selected":""%>><%=IFishConfig.SITE_PROBOLINGGO%></option>
                                                    <option value="<%=IFishConfig.SITE_LUWUK%>" <%=programSite.equals(IFishConfig.SITE_LUWUK)?"selected":""%>><%=IFishConfig.SITE_LUWUK%></option>
                                                    <option value="<%=IFishConfig.SITE_TANJUNG_LUAR%>" <%=programSite.equals(IFishConfig.SITE_TANJUNG_LUAR)?"selected":""%>><%=IFishConfig.SITE_TANJUNG_LUAR%></option>
                                                </select>
                                            </td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>

                                        <tr>
                                            <td width="10%">Boat Name</td>
                                            <td width="30%"><%=JSPCombo.draw("boat_id", null, String.valueOf(boatId), keyBoat, valBoat, "") %></td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Landing Date&nbsp;</td>
                                            <td width="30%">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrptcodrsdetail.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrptcodrsdetail.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
                                                        <td>
                                                            <input type="checkbox" name="ignore_date" value="1" <%=ignoreDate==1?"checked":""%>>
                                                        </td>
                                                        <td>
                                                            &nbsp;ignore
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <%if(jspCommandList != JSPCommand.NONE) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=list.size()>0?drawList(rootSystem, list, start, user.getOID()):"Data not found"%></td>
                                        </tr>
                                        <%}%>
                                        <tr align="left" valign="top">
                                            <td colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <span class="command_list">
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
                                                    <%=jspLine.drawImageListLimit(jspCommandList, vectSize, start, recordToGet)%>
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
