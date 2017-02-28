<%-- 
    Document   : approval
    Created on : Dec 22, 2016, 1:14:45 PM
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
    jsplist.addHeader("Approach", "9%");
    jsplist.addHeader("Landing Date", "7%");
    jsplist.addHeader("Boat Name", "12%");
    jsplist.addHeader("Boat Home Port", "9%");
    jsplist.addHeader("Image Location on NAS", "18%");
    jsplist.addHeader("Fishing Gear", "6%");
    jsplist.addHeader("Major Fishing Area", "8%");
    jsplist.addHeader("Number of Fish", "7%");
    jsplist.addHeader("Estimated Weight (kg)", "7%");
    jsplist.addHeader("Upload By", "8%");
    jsplist.addHeader("Status", "6%");


    jsplist.setLinkRow(0);
    jsplist.setLinkSufix("");
    Vector lstData = jsplist.getData();
    Vector lstLinkData = jsplist.getLinkData();
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
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
        rowx.add(deepslope.getDocStatus());

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(deepslope.getOID()));
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
long userId = JSPRequestValue.requestLong(request, "user_id");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");
long landingId = JSPRequestValue.requestLong(request, "landing_id");
String docStatus = JSPRequestValue.requestString(request, "doc_status");

Vector valApproach = new Vector();
Vector keyApproach = new Vector();
//valApproach.add(IFishConfig.strApproachType[IFishConfig.APPROACH_SWMS]);
//keyApproach.add(String.valueOf(IFishConfig.APPROACH_SWMS));
//valApproach.add(IFishConfig.strApproachType[IFishConfig.APPROACH_MDCU]);
//keyApproach.add(String.valueOf(IFishConfig.APPROACH_MDCU));
valApproach.add(IFishConfig.strApproachType[IFishConfig.APPROACH_CODRS]);
keyApproach.add(String.valueOf(IFishConfig.APPROACH_CODRS));

Vector valUser = new Vector();
Vector keyUser = new Vector();
valUser.add("All");
keyUser.add("0");
List<User> listUser = QrUserSession.getCODRSUsers();
if(listUser != null && listUser.size() > 0) {
    for(int i=0; i<listUser.size(); i++) {
        User ux = (User)listUser.get(i);
        valUser.add(ux.getFullName());
        keyUser.add(String.valueOf(ux.getOID()));
    }
}

Date startDate = new Date();
if(sStartDate.length() > 0) {
    startDate = JSPFormater.formatDate(sStartDate, "dd/MM/yyyy");
}

Date endDate = new Date();
if(sEndDate.length() > 0) {
    endDate = JSPFormater.formatDate(sEndDate, "dd/MM/yyyy");
}

if(userId > 0) {
    whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_USER_ID] + " = " + userId;
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

if(docStatus.length() > 0) {
    if(whereClause.length() > 0) {
        whereClause += " and " + DbDeepSlope.colNames[DbDeepSlope.COL_DOC_STATUS] + " = '" + docStatus + "'";
    } else {
        whereClause = DbDeepSlope.colNames[DbDeepSlope.COL_DOC_STATUS] + " = '" + docStatus + "'";
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
    <%if (!privDataApproval) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdEdit(oid) {
        document.frmapproval.landing_id.value=oid;
        document.frmapproval.command.value="<%=JSPCommand.EDIT%>";
        document.frmapproval.action="approvaledit.jsp";
        document.frmapproval.submit();
    }

    function cmdList() {
        document.frmapproval.start.value="0";
        document.frmapproval.command_list.value="<%=JSPCommand.LIST%>";
        document.frmapproval.action="approval.jsp";
        document.frmapproval.submit();
    }

    function cmdListFirst(){
        document.frmapproval.command_list.value="<%=JSPCommand.FIRST%>";
        document.frmapproval.action="approval.jsp";
        document.frmapproval.submit();
    }

    function cmdListPrev(){
        document.frmapproval.command_list.value="<%=JSPCommand.PREV%>";
        document.frmapproval.action="approval.jsp";
        document.frmapproval.submit();
    }

    function cmdListNext(){
        document.frmapproval.command_list.value="<%=JSPCommand.NEXT%>";
        document.frmapproval.action="approval.jsp";
        document.frmapproval.submit();
    }

    function cmdListLast(){
        document.frmapproval.command_list.value="<%=JSPCommand.LAST%>";
        document.frmapproval.action="approval.jsp";
        document.frmapproval.submit();
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
                        <form name="frmapproval" method="post" action="">
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
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Data</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Approval</span></td>
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
                                            <td width="10%">Landing Date&nbsp;</td>
                                            <td width="30%">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmapproval.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmapproval.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
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
                                            <td width="10%">Upload By&nbsp;</td>
                                            <td width="30%"><%=JSPCombo.draw("user_id", null, String.valueOf(userId), keyUser, valUser, "") %>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Status&nbsp;</td>
                                            <td width="30%">
                                                <select name="doc_status">
                                                    <option value="" <%=docStatus.length()==0?"selected":""%>>All</option>
                                                    <option value="<%=IFishConfig.DOC_STATUS_DRAFT%>" <%=docStatus.equals(IFishConfig.DOC_STATUS_DRAFT)?"selected":""%>><%=IFishConfig.DOC_STATUS_DRAFT%></option>
                                                    <option value="<%=IFishConfig.DOC_STATUS_POSTED%>" <%=docStatus.equals(IFishConfig.DOC_STATUS_POSTED)?"selected":""%>><%=IFishConfig.DOC_STATUS_POSTED%></option>
                                                </select>
                                            </td>
                                            <td width="60%">&nbsp;</td>
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
