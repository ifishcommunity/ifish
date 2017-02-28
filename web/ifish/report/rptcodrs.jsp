<%-- 
    Document   : rptcodrs
    Created on : Apr 6, 2016, 11:21:49 AM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.ArrayList"%>
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
<%@ page import="com.project.ifish.session.CODRSSummary"%>
<%@ page import="com.project.ifish.session.SessDeepSlope"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawList(List objectClass) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%", "2", "1");
    jsplist.addHeader("Boat Name", "17%", "2", "1");
    jsplist.addHeader("Boat Home Port", "20%", "2", "1");
    jsplist.addHeader("Number of Fish", "60%", "1", "12");
    jsplist.addHeader("Jan", "5%", "0", "0");
    jsplist.addHeader("Feb", "5%", "0", "0");
    jsplist.addHeader("Mar", "5%", "0", "0");
    jsplist.addHeader("Apr", "5%", "0", "0");
    jsplist.addHeader("May", "5%", "0", "0");
    jsplist.addHeader("Jun", "5%", "0", "0");
    jsplist.addHeader("Jul", "5%", "0", "0");
    jsplist.addHeader("Aug", "5%", "0", "0");
    jsplist.addHeader("Sep", "5%", "0", "0");
    jsplist.addHeader("Oct", "5%", "0", "0");
    jsplist.addHeader("Nov", "5%", "0", "0");
    jsplist.addHeader("Dec", "5%", "0", "0");

    Vector lstData = jsplist.getData();
    jsplist.reset();
    Vector rowx = new Vector();

    for (int i = 0; i < objectClass.size(); i++) {
        CODRSSummary codrss = (CODRSSummary) objectClass.get(i);

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
        rowx.add(codrss.getBoatName());
        rowx.add(codrss.getBoatHomePort());
        rowx.add("<div align=\"center\">" + codrss.getJan() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getFeb() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getMar() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getApr() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getMay() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getJun() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getJul() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getAug() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getSep() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getOct() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getNov() + "</div>");
        rowx.add("<div align=\"center\">" + codrss.getDec() + "</div>");

        lstData.add(rowx);
    }

    return jsplist.drawList();
}
%>
<%
int jspCommand = JSPRequestValue.requestCommand(request);
int period = JSPRequestValue.requestInt(request, "period");
String programSite = JSPRequestValue.requestString(request, "program_site");

int startPeriod = 2015;
Date today = new Date(); // your date
Calendar cal = Calendar.getInstance();
cal.setTime(today);
int endPeriod = cal.get(Calendar.YEAR);

List list = new ArrayList();
if(jspCommand == JSPCommand.LIST) {
    list = SessDeepSlope.codrsSummary(period, programSite);
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

    function cmdList() {
        document.frmrptcodrs.command.value="<%=JSPCommand.LIST%>";
        document.frmrptcodrs.action="rptcodrs.jsp";
        document.frmrptcodrs.submit();
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
                        <form name="frmrptcodrs" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">CODRS By Period</span></td>
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
                                        <tr align="left" valign="top">
                                            <td width="10%">Period</td>
                                            <td width="30%">
                                                <select name="period">
                                                    <%for(int i = startPeriod; i<=endPeriod; i++) {%>
                                                    <option value="<%=i%>" <%=period==i?"selected":""%>><%=i%></option>
                                                    <%}%>
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
                                        <%if(jspCommand == JSPCommand.LIST) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=list.size()>0?drawList(list):"Data not found"%></td>
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
