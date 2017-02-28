<%-- 
    Document   : rptoffloading
    Created on : Oct 19, 2014, 7:25:44 AM
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
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.data.OffLoading"%>
<%@ page import="com.project.ifish.data.DbOffLoading"%>
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
public String drawList(Vector objectClass, int start) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Received Date", "10%");
    jsplist.addHeader("Family", "12%");
    jsplist.addHeader("Latin Name", "20%");
    jsplist.addHeader("Pcs", "5%");
    jsplist.addHeader("NW", "5%");
    jsplist.addHeader("Temperature", "10%");
    jsplist.addHeader("Condition", "10%");
    jsplist.addHeader("Grade", "10%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    Vector lstLinkData = jsplist.getLinkData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    Vector listFish = DbFish.listAll();
    Hashtable hFish = new Hashtable();
    if(listFish != null && listFish.size() > 0) {
        for(int i = 0; i < listFish.size(); i++) {
            Fish fish = (Fish) listFish.get(i);
            hFish.put(fish.getOID(), fish);
        }
    }

    double pcs = 0;
    double nw = 0;

    for (int i = 0; i < objectClass.size(); i++) {
        OffLoading offLoading = (OffLoading) objectClass.get(i);
        Fish fish = (Fish) hFish.get(offLoading.getFishId());
        if(fish == null) fish = new Fish();
        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
        rowx.add(JSPFormater.formatDate(offLoading.getReceivedDate(), "yyyy-MM-dd HH:mm:ss"));
        rowx.add(fish.getFishFamily());
        rowx.add(fish.getFishGenus() + " " + fish.getFishSpecies());
        rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(offLoading.getPcs(), "#") + "</div>");
        rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(offLoading.getNw(), "#.##") + "</div>");
        rowx.add("<div align=\"right\">" + String.valueOf(offLoading.getTemperature()) + "</div>");
        rowx.add(offLoading.getCondition());
        rowx.add(offLoading.getGrade());

        pcs += offLoading.getPcs();
        nw += offLoading.getNw();

        lstData.add(rowx);
    }

    rowx = new Vector();
    rowx.add("");
    rowx.add("");
    rowx.add("<div align=\"center\">T O T A L</div>");
    rowx.add("");
    rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(pcs, "#") + "</div>");
    rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(nw, "#.##") + "</div>");
    rowx.add("");
    rowx.add("");
    rowx.add("");
    lstData.add(rowx);

    return jsplist.draw(index);
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String whereClause = "";
String orderClause = "";
Vector list = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

int jspCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
long partnerId = JSPRequestValue.requestLong(request, "partner_id");
String sStartDate = JSPRequestValue.requestString(request, "start_date");
String sEndDate = JSPRequestValue.requestString(request, "end_date");
int ignoreDate = JSPRequestValue.requestInt(request, "ignore_date");

/* get list of Partner */
String wherePartner = "";
if(user.getPartnerId() != 0) {
    wherePartner = DbPartner.colNames[DbPartner.COL_OID] + " = " + user.getPartnerId();
}
Vector listPartner = DbPartner.list(0, 0, wherePartner, DbPartner.colNames[DbPartner.COL_NAME]);
Vector valPartner = new Vector();
Vector keyPartner = new Vector();
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
    whereClause = DbOffLoading.colNames[DbOffLoading.COL_PARTNER_ID] + " = " + partnerId;
}

if(ignoreDate != 1) {
    if(whereClause.length() > 0) {
        whereClause += " and " + DbOffLoading.colNames[DbOffLoading.COL_RECEIVED_DATE]
                + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00'"
                + " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59'";
    } else {
        whereClause = DbOffLoading.colNames[DbOffLoading.COL_RECEIVED_DATE]
                + " between '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + " 00:00:00'"
                + " and '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + " 23:59:59'";
    }
}

/* control list */
Control control = new Control();
int vectSize = 0;
if(jspCommand != JSPCommand.NONE) {
    vectSize = DbOffLoading.getCount(whereClause);
    start = control.actionList(jspCommand, start, vectSize, recordToGet);
    list = DbOffLoading.list(start, recordToGet, whereClause, orderClause);
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
    <%if (false) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function cmdList() {
        document.frmrptoffloading.start.value="0";
        document.frmrptoffloading.command.value="<%=JSPCommand.LIST%>";
        document.frmrptoffloading.action="rptoffloading.jsp";
        document.frmrptoffloading.submit();
    }

    function cmdListFirst(){
        document.frmrptoffloading.command.value="<%=JSPCommand.FIRST%>";
        document.frmrptoffloading.action="rptoffloading.jsp";
        document.frmrptoffloading.submit();
    }

    function cmdListPrev(){
        document.frmrptoffloading.command.value="<%=JSPCommand.PREV%>";
        document.frmrptoffloading.action="rptoffloading.jsp";
        document.frmrptoffloading.submit();
    }

    function cmdListNext(){
        document.frmrptoffloading.command.value="<%=JSPCommand.NEXT%>";
        document.frmrptoffloading.action="rptoffloading.jsp";
        document.frmrptoffloading.submit();
    }

    function cmdListLast(){
        document.frmrptoffloading.command.value="<%=JSPCommand.LAST%>";
        document.frmrptoffloading.action="rptoffloading.jsp";
        document.frmrptoffloading.submit();
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
                        <form name="frmrptoffloading" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=jspCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Off-Loading</span></td>
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
                                            <td width="10%">Partner Name&nbsp;</td>
                                            <td width="30%"><%=JSPCombo.draw("partner_id", null, String.valueOf(partnerId), keyPartner, valPartner, "") %>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Received Date&nbsp;</td>
                                            <td width="30%">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td>
                                                            <input name="start_date" value="<%=JSPFormater.formatDate((startDate == null) ? new Date() : startDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrptoffloading.start_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Start Date"></a>
                                                        </td>
                                                        <td>
                                                            &nbsp;&nbsp;until&nbsp;&nbsp;
                                                        </td>
                                                        <td>
                                                            <input name="end_date" value="<%=JSPFormater.formatDate((endDate == null) ? new Date() : endDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                        </td>
                                                        <td>
                                                            <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmrptoffloading.end_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="End Date"></a></td>
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
                                        <%if(jspCommand != JSPCommand.NONE) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=list.size()>0?drawList(list, start):"Data not found"%></td>
                                        </tr>
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
