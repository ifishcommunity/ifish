<%-- 
    Document   : smedit
    Created on : Nov 26, 2015, 12:02:34 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.main.log.LogsAction"%>
<%@ page import="com.project.main.log.DbLogsAction"%>
<%@ page import="com.project.ifish.data.DeepSlope"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.data.JspDeepSlope"%>
<%@ page import="com.project.ifish.data.CmdDeepSlope"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.master.DbPartnerBoat"%>
<%@ page import="com.project.general.File"%>
<%@ page import="com.project.general.DbFile"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
public String drawListLogs(Vector objectClass) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("50%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "5%");
    jsplist.addHeader("Date Time", "40%");
    jsplist.addHeader("User", "35%");
    jsplist.addHeader("Action", "20%");

    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    Vector listUser = DbUser.list(0, 0, "", "");
    Hashtable hUser = new Hashtable();
    if(listUser != null && listUser.size() > 0) {
        for (int i = 0; i < listUser.size(); i++) {
            User user = (User) listUser.get(i);
            hUser.put(user.getOID(), user);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        try {
        LogsAction logsAction = (LogsAction) objectClass.get(i);
        rowx = new Vector();

        User userx = (User)hUser.get(logsAction.getUserId());
        if(userx == null) userx = new User();

        rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
        rowx.add(JSPFormater.formatDate(logsAction.getDateTime(), "yyyy-MM-dd HH:mm:ss"));
        rowx.add(userx.getFullName());
        rowx.add(JSPCommand.strJspCommand[logsAction.getCmdAction()]);

        lstData.add(rowx);
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    }

    return jsplist.draw(index);
}
%>
<%
/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
int iJSPCommandLoad = JSPRequestValue.requestInt(request, "command_load");
long oidLanding = JSPRequestValue.requestLong(request, "landing_oid");
int start = JSPRequestValue.requestInt(request, "start");

/* VARIABLE DECLARATION *//*variable declaration*/
String msgString = "";
int iErrCode = JSPMessage.NONE;
CmdDeepSlope ctrlDeepSlope = new CmdDeepSlope(request);
JspDeepSlope jspDeepSlope = ctrlDeepSlope.getForm();
JSPLine jspLine = new JSPLine();

/*switch statement */
iErrCode = ctrlDeepSlope.action(iJSPCommand, oidLanding, user.getOID());
DeepSlope deepslope = ctrlDeepSlope.getDeepSlope();
msgString = ctrlDeepSlope.getMessage();
if(oidLanding == 0) {
    oidLanding = deepslope.getOID();
}
/* end switch*/

/** list of action logs */
Vector docHistory = new Vector();
if(oidLanding != 0) {
    docHistory = DbLogsAction.listLogs(0, 5, oidLanding);
}

/** list of partner */
Vector listPartner = DbPartner.list(0, 0, DbPartner.colNames[DbPartner.COL_TYPE]+" like '"+IFishConfig.PARTNER_COMPANY+"'", "");
Vector keyPartner = new Vector();
Vector valPartner = new Vector();
keyPartner.add("0");
valPartner.add("select...");
if(listPartner != null && listPartner.size() > 0) {
    for(int i = 0; i < listPartner.size(); i++) {
        Partner p = (Partner) listPartner.get(i);
        keyPartner.add(String.valueOf(p.getOID()));
        valPartner.add(p.getName());
    }
}

/** list of boat */
if(iJSPCommandLoad == JSPCommand.LOAD) {
    deepslope.setPartnerId(JSPRequestValue.requestLong(request, JspDeepSlope.fieldNames[JspDeepSlope.JSP_PARTNER_ID]));
}

Vector listBoat = DbPartnerBoat.listBoat(deepslope.getPartnerId());
Vector keyBoat = new Vector();
Vector valBoat = new Vector();
keyBoat.add("0");
valBoat.add("select...");
if(listBoat != null && listBoat.size() > 0) {
    for(int i = 0; i < listBoat.size(); i++) {
        Boat boat = (Boat) listBoat.get(i);
        keyBoat.add(String.valueOf(boat.getOID()));
        valBoat.add(boat.getName());
    }
}

/** Landing Location */
Vector keyLandingLocation = new Vector();
Vector valLandingLocation = new Vector();
keyLandingLocation.add("");
valLandingLocation.add("select...");
keyLandingLocation.add("Benoa Bali");
valLandingLocation.add("Benoa Bali");
keyLandingLocation.add("Tenau Kupang NTT");
valLandingLocation.add("Tenau Kupang NTT");
keyLandingLocation.add("Luwuk Sulawesi Tengah");
valLandingLocation.add("Luwuk Sulawesi Tengah");

/** Fishing Ground */
Vector keyFishingGround = new Vector();
Vector valFishingGround = new Vector();
keyFishingGround.add("");
valFishingGround.add("select...");
keyFishingGround.add("573");
valFishingGround.add("WPP 573");
keyFishingGround.add("712");
valFishingGround.add("WPP 712");
keyFishingGround.add("713");
valFishingGround.add("WPP 713");
keyFishingGround.add("714");
valFishingGround.add("WPP 714");
keyFishingGround.add("715");
valFishingGround.add("WPP 715");
keyFishingGround.add("716");
valFishingGround.add("WPP 716");
keyFishingGround.add("718");
valFishingGround.add("WPP 718");

/** Fishing Gear */
Vector keyFishingGear = new Vector();
Vector valFishingGear = new Vector();
keyFishingGear.add("");
valFishingGear.add("select...");
keyFishingGear.add("Dropline");
valFishingGear.add("Dropline");
keyFishingGear.add("Longline");
valFishingGear.add("Longline");
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

    function cmdEdit(oid){
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.EDIT%>";
        document.frmsmartmeasuring.action="smedit.jsp";
        document.frmsmartmeasuring.submit();
    }

    <%if (privAdd) {%>
    function cmdAdd(){
        document.frmsmartmeasuring.landing_oid.value=0;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.ADD%>";
        document.frmsmartmeasuring.action="smedit.jsp";
        document.frmsmartmeasuring.submit();
    }
    <%}%>

    <%if (privAdd || privEdit) {%>
    function cmdSave(){
        document.frmsmartmeasuring.command.value="<%=JSPCommand.SAVE%>";
        document.frmsmartmeasuring.action="smedit.jsp";
        document.frmsmartmeasuring.submit();
    }
    <%}%>

    <% if (privDelete) {%>
    function cmdDelete(oid){
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.ASK%>";
        document.frmsmartmeasuring.action="smedit.jsp";
        document.frmsmartmeasuring.submit();
    }

    function cmdConfirmDelete(oid){
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.DELETE%>";
        document.frmsmartmeasuring.action="smedit.jsp";
        document.frmsmartmeasuring.submit();
    }
    <%}%>

    function cmdBack(oid){
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.LIST%>";
        document.frmsmartmeasuring.action="smlist.jsp";
        document.frmsmartmeasuring.submit();
    }

    function cmdOffLoading(oid) {
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.EDIT%>";
        document.frmsmartmeasuring.action="smoffloadingedit.jsp";
        document.frmsmartmeasuring.submit();
    }

    function cmdSizing(oid) {
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.EDIT%>";
        document.frmsmartmeasuring.action="smsizingedit.jsp";
        document.frmsmartmeasuring.submit();
    }

    function cmdPictures(oid) {
        document.frmsmartmeasuring.landing_oid.value=oid;
        document.frmsmartmeasuring.command.value="<%=JSPCommand.EDIT%>";
        document.frmsmartmeasuring.action="smlandingpictures.jsp";
        document.frmsmartmeasuring.submit();
    }

    function cmdLoadForm(oid) {
        document.frmsmartmeasuring.landing_oid.value=oid;
        if(oid == 0) {
            document.frmsmartmeasuring.command.value="<%=JSPCommand.ADD%>";
        } else {
            document.frmsmartmeasuring.command.value="<%=JSPCommand.EDIT%>";
        }
        document.frmsmartmeasuring.command_load.value="<%=JSPCommand.LOAD%>";
        document.frmsmartmeasuring.action="smedit.jsp";
        document.frmsmartmeasuring.submit();
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
            <%@ include file ="../../calendar/calendarframe.jsp"%>
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
                        <form name="frmsmartmeasuring" method="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="command_load" value="<%=iJSPCommandLoad%>">
                          <input type="hidden" name="landing_oid" value="<%=oidLanding%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_USER_ID]%>" value="<%=deepslope.getOID()==0?user.getOID():deepslope.getUserId()%>">
                          <input type="hidden" name="<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_APPROACH]%>" value="<%=IFishConfig.APPROACH_SWMS%>">
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
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;Main&nbsp;&nbsp;</div>
                                            </td>
                                            <% if(deepslope.getOID() > 0) { %>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdOffLoading('<%=deepslope.getOID()%>')" class="tablink">Off-Loading</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdSizing('<%=deepslope.getOID()%>')" class="tablink">Sizing</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdPictures('<%=oidLanding%>')" class="tablink">Pictures</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <% } %>
                                            <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="container">
                                    <table width="100%" cellpadding="1" cellspacing="1" border="0">
                                        <tr align="left" valign="top">
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Partner (data owner)</td>
                                            <td width="35%"><%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_PARTNER_ID], null, String.valueOf(deepslope.getPartnerId()), keyPartner, valPartner, "onChange=\"javascript:cmdLoadForm('"+oidLanding+"')\"") %>
                                            *&nbsp;<%=jspDeepSlope.getErrorMsg(JspDeepSlope.JSP_PARTNER_ID)%></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Landing Date</td>
                                            <td width="35%"><input name="<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_LANDING_DATE]%>" value="<%=JSPFormater.formatDate((deepslope.getLandingDate() == null) ? new Date() : deepslope.getLandingDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsmartmeasuring.<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_LANDING_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Landing Date"></a>
                                            </td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Landing Location</td>
                                            <td width="35%"><%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_LANDING_LOCATION], null, deepslope.getLandingLocation(), keyLandingLocation, valLandingLocation, "")%></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Fishing Ground (WPP)</td>
                                            <td width="35%"><%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_WPP1], null, deepslope.getWpp1(), keyFishingGround, valFishingGround, "")%>&nbsp;
                                                <%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_WPP2], null, deepslope.getWpp2(), keyFishingGround, valFishingGround, "")%>&nbsp;
                                                <%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_WPP3], null, deepslope.getWpp3(), keyFishingGround, valFishingGround, "")%>&nbsp;
                                            </td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Other Fishing Ground</td>
                                            <td width="35%"><input type="text" name="<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_OTHER_FISHING_GROUND]%>" value="<%=deepslope.getOtherFishingGround()%>" size="30"></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Boat/Supplier</td>
                                            <td width="35%"><%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_BOAT_ID], null, String.valueOf(deepslope.getBoatId()), keyBoat, valBoat, "")%>
                                                / <input type="text" name="<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_SUPPLIER]%>" value="<%=deepslope.getSupplier()%>" size="30">
                                            </td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Fishing Gear</td>
                                            <td width="35%"><%=JSPCombo.draw(JspDeepSlope.fieldNames[JspDeepSlope.JSP_FISHING_GEAR], null, deepslope.getFishingGear(), keyFishingGear, valFishingGear, "")%></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Brought by</td>
                                            <td width="35%"><input type="text" name="<%=JspDeepSlope.fieldNames[JspDeepSlope.JSP_BROUGHT_BY]%>" value="<%=deepslope.getBroughtBy()%>"></td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="4">
                                                <%
                                                            jspLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                            jspLine.initDefault();
                                                            jspLine.setTableWidth("80%");
                                                            String scomDel = "javascript:cmdDelete('" + oidLanding + "')";
                                                            String sconDelCom = "javascript:cmdConfirmDelete('" + oidLanding + "')";
                                                            String scancel = "javascript:cmdEdit('" + oidLanding + "')";
                                                            jspLine.setBackCaption("Back to List");
                                                            jspLine.setJSPCommandStyle("buttonlink");

                                                            jspLine.setOnMouseOut("MM_swapImgRestore()");
                                                            jspLine.setOnMouseOverSave("MM_swapImage('save','','" + rootSystem + "/images/save2.gif',1)");
                                                            jspLine.setSaveImage("<img src=\"" + rootSystem + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

                                                            jspLine.setOnMouseOverBack("MM_swapImage('back','','" + rootSystem + "/images/cancel2.gif',1)");
                                                            jspLine.setBackImage("<img src=\"" + rootSystem + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

                                                            jspLine.setOnMouseOverDelete("MM_swapImage('delete','','" + rootSystem + "/images/delete2.gif',1)");
                                                            jspLine.setDeleteImage("<img src=\"" + rootSystem + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

                                                            jspLine.setOnMouseOverEdit("MM_swapImage('edit','','" + rootSystem + "/images/cancel2.gif',1)");
                                                            jspLine.setEditImage("<img src=\"" + rootSystem + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");

                                                            jspLine.setOnMouseOverAddNew("MM_swapImage('edit','','" + rootSystem + "/images/add2.gif',1)");
                                                            jspLine.setAddNewImage("<img src=\"" + rootSystem + "/images/add.gif\" name=\"edit\" height=\"22\" border=\"0\">");

                                                            jspLine.setWidthAllJSPCommand("90");
                                                            jspLine.setErrorStyle("warning");
                                                            jspLine.setErrorImage(rootSystem + "/images/error.gif\" width=\"20\" height=\"20");
                                                            jspLine.setQuestionStyle("warning");
                                                            jspLine.setQuestionImage(rootSystem + "/images/error.gif\" width=\"20\" height=\"20");
                                                            jspLine.setInfoStyle("success");
                                                            jspLine.setSuccessImage(rootSystem + "/images/success.gif\" width=\"20\" height=\"20");

                                                            if (privDelete) {
                                                                jspLine.setConfirmDelJSPCommand(sconDelCom);
                                                                jspLine.setDeleteJSPCommand(scomDel);
                                                                jspLine.setEditJSPCommand(scancel);
                                                            } else {
                                                                jspLine.setConfirmDelCaption("");
                                                                jspLine.setDeleteCaption("");
                                                                jspLine.setEditCaption("");
                                                            }

                                                            if (privAdd == false && privEdit == false) {
                                                                jspLine.setSaveCaption("");
                                                            }

                                                            if (privAdd == false) {
                                                                jspLine.setAddCaption("");
                                                            }
                                                %>
                                                <%= jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" class="command">&nbsp;</td>
                                        </tr>
                                        <% if(docHistory.size() > 0) { %>
                                        <tr>
                                            <td colspan="4" class="command"><b>History Logs</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="4"><%=drawListLogs(docHistory)%></td>
                                        </tr>
                                        <% } %>
                                    </table>
                                </td>
                            </tr>
                         </table>
                        </form>
                        <%
                        session.setAttribute("msg_upload", "");
                        %>
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
