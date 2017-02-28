<%--
    Document   : rptdeepslope
    Created on : Nov 20, 2015, 4:16:19 PM
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
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.FileUploadException"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
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
    jsplist.addHeader("Approach", "9%");
    jsplist.addHeader("Landing Date", "7%");
    jsplist.addHeader("Boat Name / Supplier", "12%");
    jsplist.addHeader("Boat Home Port", "9%");
    jsplist.addHeader("Image Location on NAS", "18%");
    jsplist.addHeader("Fishing Gear", "6%");
    jsplist.addHeader("Major Fishing Area", "8%");
    jsplist.addHeader("Number of Fish", "7%");
    jsplist.addHeader("Estimated Weight (kg)", "7%");
    jsplist.addHeader("Upload By", "8%");
    jsplist.addHeader("Action", "6%");

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
        rowx.add(IFishConfig.strApproachType[deepslope.getApproach()]);
        rowx.add(JSPFormater.formatDate(deepslope.getLandingDate(), "MMM d, yyyy"));
        if(boat.getOID() != 0) {
            rowx.add(boat.getName());
        } else {
            rowx.add(deepslope.getSupplier());
        }
        rowx.add(boat.getHomePort());
        if(deepslope.getApproach() == IFishConfig.APPROACH_CODRS) {
            rowx.add(sdf.format(deepslope.getLandingDate())+"-"+boat.getName().trim().replaceAll("\\ ", ""));
        } else {
            rowx.add("");
        }
        rowx.add(deepslope.getFishingGear());
        rowx.add("<div align=\"center\">" + deepslope.getWpp1() + " " + deepslope.getWpp2() + " " + deepslope.getWpp3() + " " + deepslope.getOtherFishingGround() + "</div>");
        rowx.add("<div align=\"center\">" + total + "</div>");
        rowx.add("<div align=\"center\">" + JSPFormater.formatNumber((estimatedWeight/1000), "#") + "</div>");
        rowx.add(user.getFullName());
        if(deepslope.getApproach() == IFishConfig.APPROACH_CODRS) {
            String action = "<a href=\"javascript:cmdDownload('"+deepslope.getOID()+"')\"><img src=\""+rootSystem+"/images/export_excel.png\" border=\"0\" alt=\"Download\"></a>";
            if(userId == user.getOID() && false) {
                action += "&nbsp;&nbsp;<a href=\"javascript:cmdDelete('"+deepslope.getOID()+"', 'CODRS-"+boat.getName().trim().replaceAll("\\ ", "")+"-"+sdf.format(deepslope.getLandingDate())+".xls"+"')\"><img src=\""+rootSystem+"/images/delete.png\" border=\"0\" alt=\"Delete\"></a>";
            }
            rowx.add("<div align=\"center\">" + action + "</div>");
        } else {
            rowx.add("");
        }

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
int approach = JSPRequestValue.requestInt(request, "approach");
long partnerId = JSPRequestValue.requestLong(request, "partner_id");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
long landingId = JSPRequestValue.requestLong(request, "landing_id");

Vector valApproach = new Vector();
Vector keyApproach = new Vector();
valApproach.add(IFishConfig.strApproachType[IFishConfig.APPROACH_SWMS]);
keyApproach.add(String.valueOf(IFishConfig.APPROACH_SWMS));
valApproach.add(IFishConfig.strApproachType[IFishConfig.APPROACH_MDCU]);
keyApproach.add(String.valueOf(IFishConfig.APPROACH_MDCU));
valApproach.add(IFishConfig.strApproachType[IFishConfig.APPROACH_CODRS]);
keyApproach.add(String.valueOf(IFishConfig.APPROACH_CODRS));

/* get list of Partner */
String wherePartner = "";
if(user.getPartnerId() != 0) {
    wherePartner = DbPartner.colNames[DbPartner.COL_OID] + " = " + user.getPartnerId();
}
Vector listPartner = DbPartner.list(0, 0, wherePartner, DbPartner.colNames[DbPartner.COL_NAME]);
Vector valPartner = new Vector();
Vector keyPartner = new Vector();
if(user.getPartnerId() == 0) {
    valPartner.add("all");
    keyPartner.add("0");
}
if(listPartner != null && listPartner.size() > 0) {
    for(int i=0; i<listPartner.size(); i++) {
        Partner p = (Partner) listPartner.get(i);
        valPartner.add(String.valueOf(p.getName()));
        keyPartner.add(String.valueOf(p.getOID()));
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

if(partnerId > 0) {
    whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_PARTNER_ID] + " = " + partnerId;
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

if(approach > -1) {
    if(whereClause.length() > 0) {
        whereClause += " and " + DbDeepSlope.colNames[DbDeepSlope.COL_APPROACH] + " = " + approach;
    } else {
        whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_APPROACH] + " = " + approach;
    }
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
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privReportDeepSlope) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdDelete(oid, name) {
        if(confirm("Are you sure to delete this data ("+name+")?")) {
        document.frmrptdeepslope.start.value="0";
        document.frmrptdeepslope.landing_id.value=oid;
        document.frmrptdeepslope.command.value="<%=JSPCommand.DELETE%>";
        document.frmrptdeepslope.command_list.value="<%=JSPCommand.LIST%>";
        document.frmrptdeepslope.action="rptdeepslope.jsp";
        document.frmrptdeepslope.submit();
        }
    }

    function cmdDownload(oid) {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.report.CODRSDataXml?landing_id="+oid);
    }

    function cmdList() {
        document.frmrptdeepslope.start.value="0";
        document.frmrptdeepslope.command_list.value="<%=JSPCommand.LIST%>";
        document.frmrptdeepslope.action="rptdeepslope.jsp";
        document.frmrptdeepslope.submit();
    }

    function cmdListFirst(){
        document.frmrptdeepslope.command_list.value="<%=JSPCommand.FIRST%>";
        document.frmrptdeepslope.action="rptdeepslope.jsp";
        document.frmrptdeepslope.submit();
    }

    function cmdListPrev(){
        document.frmrptdeepslope.command_list.value="<%=JSPCommand.PREV%>";
        document.frmrptdeepslope.action="rptdeepslope.jsp";
        document.frmrptdeepslope.submit();
    }

    function cmdListNext(){
        document.frmrptdeepslope.command_list.value="<%=JSPCommand.NEXT%>";
        document.frmrptdeepslope.action="rptdeepslope.jsp";
        document.frmrptdeepslope.submit();
    }

    function cmdListLast(){
        document.frmrptdeepslope.command_list.value="<%=JSPCommand.LAST%>";
        document.frmrptdeepslope.action="rptdeepslope.jsp";
        document.frmrptdeepslope.submit();
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
                        <form name="frmrptdeepslope" method="post" action="">
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
                                    <font class="tit1">&raquo; </font><span class="lvl2">Deep Slope</span></td>
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
                                            <td width="10%">Approach&nbsp;</td>
                                            <td width="30%"><%=JSPCombo.draw("approach", null, String.valueOf(approach), keyApproach, valApproach, "") %>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Partner Name&nbsp;</td>
                                            <td width="30%"><%=JSPCombo.draw("partner_id", null, String.valueOf(partnerId), keyPartner, valPartner, "") %>&nbsp;</td>
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
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrptdeepslope.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrptdeepslope.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
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
