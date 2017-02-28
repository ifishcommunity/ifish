<%-- 
    Document   : sizingedit
    Created on : Apr 29, 2015, 11:56:13 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.main.log.LogsAction"%>
<%@ page import="com.project.main.log.DbLogsAction"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.data.DeepSlope"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.data.Sizing"%>
<%@ page import="com.project.ifish.data.DbSizing"%>
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
public String drawList(Vector objectClass, int start) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("30%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "10%");
    jsplist.addHeader("Species", "70%");
    jsplist.addHeader("Cm", "20%");

    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    Vector listFish = DbFish.listAll();
    Hashtable hFish = new Hashtable();
    if(listFish != null && listFish.size() > 0) {
        for(int i=0; i<listFish.size(); i++) {
            Fish fish = (Fish) listFish.get(i);
            hFish.put(fish.getOID(), fish);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        Sizing sizing = (Sizing) objectClass.get(i);
        rowx = new Vector();

        Fish fish = (Fish) hFish.get(sizing.getFishId());
        if(fish == null) fish = new Fish();

        rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");
        if(fish.isFamilyID() == 1) {
            rowx.add(fish.getFishFamily());
        } else {
            rowx.add(fish.getFishGenus()+" "+fish.getFishSpecies().toLowerCase());
        }
        rowx.add("<div align=\"center\">" + JSPFormater.formatNumber(sizing.getCm(), "#") + "</div>");

        lstData.add(rowx);
    }

    return jsplist.draw(index);
}
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
int start = JSPRequestValue.requestInt(request, "start");
long oidLanding = JSPRequestValue.requestLong(request, "landing_oid");

int recordToGet = 15;
String whereClause = DbSizing.colNames[DbSizing.COL_LANDING_ID] + " = " + oidLanding;
String orderClause = "";
JSPLine jspLine = new JSPLine();

DeepSlope deepSlope = new DeepSlope();
Partner partner = new Partner();
Boat boat = new Boat();
if(oidLanding != 0) {
    try {
        deepSlope = DbDeepSlope.fetchExc(oidLanding);
        if(deepSlope.getOID() > 0) {
            partner = DbPartner.fetchExc(deepSlope.getPartnerId());
            boat = DbBoat.fetchExc(deepSlope.getBoatId());
        }
    } catch(Exception e) {}
}

/* control list */
Control control = new Control();
int vectSize = DbSizing.getCount(whereClause);
start = control.actionList(listJSPCommand, start, vectSize, recordToGet);
Vector listSizing = DbSizing.list(start, recordToGet, whereClause, orderClause);
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privDataSWMS) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function cmdAdd() {
        window.open("smsizingadd.jsp?landing_oid=<%=oidLanding%>",  null, "height=600,width=800, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdListFirst(){
        document.frmsizing.list_command.value="<%=JSPCommand.FIRST%>";
        document.frmsizing.action="smsizingedit.jsp";
        document.frmsizing.submit();
    }

    function cmdListPrev(){
        document.frmsizing.list_command.value="<%=JSPCommand.PREV%>";
        document.frmsizing.action="smsizingedit.jsp";
        document.frmsizing.submit();
    }

    function cmdListNext(){
        document.frmsizing.list_command.value="<%=JSPCommand.NEXT%>";
        document.frmsizing.action="smsizingedit.jsp";
        document.frmsizing.submit();
    }

    function cmdListLast(){
        document.frmsizing.list_command.value="<%=JSPCommand.LAST%>";
        document.frmsizing.action="smsizingedit.jsp";
        document.frmsizing.submit();
    }

    function cmdMain(oid) {
        document.frmsizing.landing_oid.value=oid;
        document.frmsizing.command.value="<%=JSPCommand.EDIT%>";
        document.frmsizing.action="smedit.jsp";
        document.frmsizing.submit();
    }

    function cmdOffLoading(oid) {
        document.frmsizing.landing_oid.value=oid;
        document.frmsizing.command.value="<%=JSPCommand.EDIT%>";
        document.frmsizing.list_command.value="<%=JSPCommand.FIRST%>";
        document.frmsizing.action="smoffloadingedit.jsp";
        document.frmsizing.submit();
    }

    function cmdPictures(oid) {
        document.frmsizing.landing_oid.value=oid;
        document.frmsizing.command.value="<%=JSPCommand.EDIT%>";
        document.frmsizing.action="smlandingpictures.jsp";
        document.frmsizing.submit();
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
                        <form name="frmsizing" method="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="landing_oid" value="<%=oidLanding%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Data Entry</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">SWMS</span></td>
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
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdMain('<%=oidLanding%>')" class="tablink">Main</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdOffLoading('<%=oidLanding%>')" class="tablink">Off-Loading</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;Sizing&nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdPictures('<%=oidLanding%>')" class="tablink">Pictures</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="container">
                                    <table width="100%" cellpadding="1" cellspacing="1" border="0">
                                        <tr>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Partner (data owner)</td>
                                            <td width="35%">: <%=partner.getName()%>&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Landing Date</td>
                                            <td width="35%">: <%=JSPFormater.formatDate(deepSlope.getLandingDate(), "MMMM d, yyyy")%>&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Landing Location</td>
                                            <td width="35%">: <%=deepSlope.getLandingLocation()%></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Boat/Supplier</td>
                                            <td width="35%">: <%=boat.getOID() != 0 ? boat.getName() : deepSlope.getSupplier()%></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="4"><%=listSizing.size()>0?drawList(listSizing, start):"Data not found"%></td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="4">
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
                                                    <%=jspLine.drawImageListLimit(listJSPCommand, vectSize, start, recordToGet)%>
                                                </span>
                                            </td>
                                        </tr>
                                        <% if (privAdd) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="4"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../../images/new2.gif',1)"><img src="../../images/new.gif" name="new2" width="71" height="22" border="0"></a>&nbsp;</td>
                                        </tr>
                                        <%}%>
                                    </table>
                                </td>
                            </tr>
                         </table>
                        </form>
                        <!-- #EndEditable --> </td>
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
