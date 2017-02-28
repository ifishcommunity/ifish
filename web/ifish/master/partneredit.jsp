<%--
    Document   : partneredit
    Created on : Apr 22, 2015, 4:21:23 AM
    Author     : gwawan
--%>
<%@page import="com.project.ifish.master.PartnerBoat"%>
<%@page import="com.project.ifish.master.DbPartnerBoat"%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Partner"%>
<%@ page import = "com.project.ifish.master.DbPartner"%>
<%@ page import = "com.project.ifish.master.JspPartner"%>
<%@ page import = "com.project.ifish.master.CmdPartner"%>
<%@ page import = "com.project.ifish.master.Boat"%>
<%@ page import = "com.project.ifish.master.DbBoat"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_PARTNER, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_PARTNER, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_PARTNER, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%
/* VARIABLE DECLARATION */
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
long partnerId = JSPRequestValue.requestLong(request, "partner_oid");
int start = JSPRequestValue.requestInt(request, "start");
String programSite = JSPRequestValue.requestString(request, "program_site");

CmdPartner ctrlPartner = new CmdPartner(request);
JspPartner jspPartner = ctrlPartner.getForm();
int iErrCode = ctrlPartner.action(iJSPCommand, partnerId, user.getOID());
String msgString = ctrlPartner.getMessage();
Partner partner = ctrlPartner.getPartner();
if(partnerId == 0) {
    partnerId = partner.getOID();
}

String where = DbBoat.colNames[DbBoat.COL_TRACKER_ID] + "!=0";
if(programSite.length() > 0) {
    where += " and " + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '" + programSite + "'";
}
Vector listBoat = DbBoat.list(0, 0, where, DbBoat.colNames[DbBoat.COL_NAME]);

if (iJSPCommand == JSPCommand.SAVE) {
    DbPartnerBoat.deleteByPartner(partnerId);
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat boat = (Boat) listBoat.get(i);
            long oidx = JSPRequestValue.requestLong(request, "boat_" + boat.getOID());
            if(oidx != 0) {
                try {
                    PartnerBoat pb = new PartnerBoat();
                    pb.setPartnerId(partnerId);
                    pb.setBoatId(boat.getOID());
                    DbPartnerBoat.insert(pb);
                } catch(Exception e) {
                }
            }
        }
    }
}

Vector listPartnerBoat = DbPartnerBoat.list(0, 0, DbPartnerBoat.colNames[DbPartnerBoat.COL_PARTNER_ID]+"="+partnerId, "");
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
    <%if (!privMasterPartner) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    <% if (privAdd) {%>
    function cmdAdd(){
        document.frmpartner.partner_oid.value="0";
        document.frmpartner.program_site.value="";
        document.frmpartner.command.value="<%=JSPCommand.ADD%>";
        document.frmpartner.action="partneredit.jsp";
        document.frmpartner.submit();
    }
    <%}%>

    function cmdEdit(oid){
        document.frmpartner.partner_oid.value=oid;
        document.frmpartner.program_site.value="<%=programSite%>";
        document.frmpartner.command.value="<%=JSPCommand.EDIT%>";
        document.frmpartner.action="partneredit.jsp";
        document.frmpartner.submit();
    }

    function cmdProgramSite(ps) {
        document.frmpartner.partner_oid.value="<%=partnerId%>";
        document.frmpartner.command.value="<%=JSPCommand.EDIT%>";
        document.frmpartner.program_site.value=ps;
        document.frmpartner.action="partneredit.jsp";
        document.frmpartner.submit();
    }

    <% if (privAdd || privEdit) {%>
    function cmdSave(){
        document.frmpartner.command.value="<%=JSPCommand.SAVE%>";
        document.frmpartner.program_site.value="<%=programSite%>";
        document.frmpartner.action="partneredit.jsp";
        document.frmpartner.submit();
    }
    <%}%>

    <% if (privDelete) {%>
    function cmdDelete(oid){
        document.frmpartner.partner_oid.value=oid;
        document.frmpartner.program_site.value="<%=programSite%>";
        document.frmpartner.command.value="<%=JSPCommand.ASK%>";
        document.frmpartner.action="partneredit.jsp";
        document.frmpartner.submit();
    }

    function cmdConfirmDelete(oid){
        document.frmpartner.partner_oid.value=oid;
        document.frmpartner.program_site.value="<%=programSite%>";
        document.frmpartner.command.value="<%=JSPCommand.DELETE%>";
        document.frmpartner.action="partneredit.jsp";
        document.frmpartner.submit();
    }
    <%}%>

    function cmdBack(oid){
        document.frmpartner.partner_oid.value=oid;
        document.frmpartner.program_site.value="<%=programSite%>";
        document.frmpartner.command.value="<%=JSPCommand.LIST%>";
        document.frmpartner.action="partner.jsp";
        document.frmpartner.submit();
    }

    function checkboxAll(val) {
        <%
        for (int x = 0; x < listBoat.size(); x++) {
            Boat boat = (Boat) listBoat.get(x);
            out.println("document.frmpartner." + "boat_" + boat.getOID() + ".checked = val.checked;");
        }
        %>
    }

    function boatBarcode() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.BoatBarcodePdf?partner_id=<%=partnerId%>&partner_name=<%=partner.getName()%>");
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
                  <%@ include file="../../ifish/main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                          <form name="frmpartner" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="partner_oid" value="<%=partnerId%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="program_site" value="">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Master</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Partner</span></td>
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
                                    <table width="100%">
                                        <tr>
                                            <td width="13%">Type</td>
                                            <td width="87%">
                                                <select name="<%=JspPartner.fieldNames[JspPartner.JSP_TYPE]%>">
                                                    <option value="<%=IFishConfig.PARTNER_FISHERMAN%>" <%=partner.getType().equals(IFishConfig.PARTNER_FISHERMAN)?"selected":""%>><%=IFishConfig.PARTNER_FISHERMAN%></option>
                                                    <option value="<%=IFishConfig.PARTNER_FISH_TRADER%>" <%=partner.getType().equals(IFishConfig.PARTNER_FISH_TRADER)?"selected":""%>><%=IFishConfig.PARTNER_FISH_TRADER%></option>
                                                    <option value="<%=IFishConfig.PARTNER_COMPANY%>" <%=partner.getType().equals(IFishConfig.PARTNER_COMPANY)?"selected":""%>><%=IFishConfig.PARTNER_COMPANY%></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <!--tr>
                                            <td width="13%">Code</td>
                                            <td width="87%"><input type="text" name="<%//=JspPartner.fieldNames[JspPartner.JSP_CODE]%>" value="<%//=partner.getCode()%>" class="formElemen" size="10">
                                                * &nbsp;<%//=jspPartner.getErrorMsg(JspPartner.JSP_CODE)%>
                                            </td>
                                        </tr-->
                                        <tr>
                                            <td width="13%">Name</td>
                                            <td width="87%"><input type="text" name="<%=JspPartner.fieldNames[JspPartner.JSP_NAME]%>" value="<%=partner.getName()%>" class="formElemen" size="50">
                                                * &nbsp;<%=jspPartner.getErrorMsg(JspPartner.JSP_NAME)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Address</td>
                                            <td width="87%"><textarea name="<%=JspPartner.fieldNames[JspPartner.JSP_ADDRESS]%>" class="formElemen" cols="50"><%=partner.getAddress()%></textarea></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Contact Person</td>
                                            <td width="87%"><input type="text" name="<%=JspPartner.fieldNames[JspPartner.JSP_CP]%>" value="<%=partner.getCp()%>" class="formElemen" size="30"></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Phone</td>
                                            <td width="87%"><input type="text" name="<%=JspPartner.fieldNames[JspPartner.JSP_PHONE]%>" value="<%=partner.getPhone()%>" class="formElemen" size="30"></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Email</td>
                                            <td width="87%"><input type="text" name="<%=JspPartner.fieldNames[JspPartner.JSP_EMAIL]%>" value="<%=partner.getEmail()%>" class="formElemen" size="30"></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Notes</td>
                                            <td width="87%"><textarea name="<%=JspPartner.fieldNames[JspPartner.JSP_NOTES]%>" class="formElemen" cols="50"><%=partner.getNotes()%></textarea></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Server Status</td>
                                            <td width="87%"><input type="checkbox" name="<%=JspPartner.fieldNames[JspPartner.JSP_SERVER_STATUS]%>" value="1" <%=partner.getServerStatus()==IFishConfig.STATUS_ACTIVE?"checked":""%>>&nbsp;Active</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Server IP</td>
                                            <td width="87%"><input type="text" name="<%=JspPartner.fieldNames[JspPartner.JSP_SERVER_IP]%>" value="<%=partner.getServerIP()%>" class="formElemen" size="15">&nbsp;(eg: 72.14.187.103)</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Token</td>
                                            <td width="87%"><input type="text" name="txt_token" value="<%=partner.getToken()%>" class="formElemen" size="50" readonly>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Boat Partnership&nbsp;&nbsp;&nbsp;<a href="javascript:boatBarcode()"><img src="<%=rootSystem%>/images/printer.png" border="0" width="16"></a></td>
                                            <td width="87%">&nbsp;
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="17" height="10"></td>
                                                        <%if (programSite.equals("")) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;All&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('')" class="tablink">All</a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if (programSite.equals(IFishConfig.SITE_BALI)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_BALI%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_BALI%>')" class="tablink"><%=IFishConfig.SITE_BALI%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if (programSite.equals(IFishConfig.SITE_KUPANG)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_KUPANG%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_KUPANG%>')" class="tablink"><%=IFishConfig.SITE_KUPANG%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if (programSite.equals(IFishConfig.SITE_KEMA)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_KEMA%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_KEMA%>')" class="tablink"><%=IFishConfig.SITE_KEMA%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if (programSite.equals(IFishConfig.SITE_PROBOLINGGO)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_PROBOLINGGO%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_PROBOLINGGO%>')" class="tablink"><%=IFishConfig.SITE_PROBOLINGGO%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if (programSite.equals(IFishConfig.SITE_LUWUK)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_LUWUK%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_LUWUK%>')" class="tablink"><%=IFishConfig.SITE_LUWUK%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if (programSite.equals(IFishConfig.SITE_TANJUNG_LUAR)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_TANJUNG_LUAR%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_TANJUNG_LUAR%>')" class="tablink"><%=IFishConfig.SITE_TANJUNG_LUAR%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="13%">&nbsp;</td>
                                            <td width="87%">
                                                <div style="width:120px;margin-right:10px;margin-bottom:10px;text-align:left;"><input type="checkbox" name="boat_all" value="1" onclick="javascript:checkboxAll(this)">All<br /></div>
                                                <%
                                                if(listBoat != null && listBoat.size() > 0) {
                                                    for(int i = 0; i < listBoat.size(); i++) {
                                                        Boat boat = (Boat) listBoat.get(i);
                                                        String fieldName = "boat_" + boat.getOID();
                                                        String chk = "";
                                                        if(listPartnerBoat != null && listPartnerBoat.size() > 0) {
                                                            for(int j = 0; j < listPartnerBoat.size(); j++) {
                                                                PartnerBoat pb = (PartnerBoat) listPartnerBoat.get(j);
                                                                if(boat.getOID() == pb.getBoatId()) {
                                                                    chk = " checked";
                                                                }
                                                            }
                                                        }
                                                        out.println("<div style=\"width:160px;float:left;margin-right:10px;margin-bottom:10px;text-align:left;\"><input type=\"checkbox\" name=\""+fieldName+"\" value=\"1\""+chk+">"+(chk.trim().equals("checked")?"<b>"+boat.getName()+"</b>":boat.getName())+"</div>");
                                                    }
                                                }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%" valign="top" height="14" nowrap>&nbsp;</td>
                                            <td width="87%" height="14">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="command">
                                                <%
                                                  jspLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                  jspLine.initDefault();
                                                  jspLine.setTableWidth("80%");
                                                  String scomDel = "javascript:cmdDelete('" + partnerId + "')";
                                                  String sconDelCom = "javascript:cmdConfirmDelete('" + partnerId + "')";
                                                  String scancel = "javascript:cmdEdit('" + partnerId + "')";
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
                                                <%=jspLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%>
                                            </td>
                                        </tr>
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