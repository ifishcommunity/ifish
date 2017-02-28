<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Boat"%>
<%@ page import = "com.project.ifish.master.DbBoat"%>
<%@ page import = "com.project.ifish.master.Partner"%>
<%@ page import = "com.project.ifish.master.DbPartner"%>
<%@ page import = "com.project.ifish.master.Tracker"%>
<%@ page import = "com.project.ifish.master.DbTracker"%>
<%@ page import = "com.project.ifish.master.JspBoat"%>
<%@ page import = "com.project.ifish.master.Boat"%>
<%@ page import = "com.project.ifish.master.DbBoat"%>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../ifish/main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%
/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
long userId = JSPRequestValue.requestLong(request, "user_oid");
int start = JSPRequestValue.requestInt(request, "start");
String programSite = JSPRequestValue.requestString(request, "program_site");

/* VARIABLE DECLARATION */
JSPLine jspLine = new JSPLine();
User appUser = new User();
CmdUser cmdUser = new CmdUser(request);
JspUser jspuser = cmdUser.getForm();
int excCode = JSPMessage.NONE;
String msgString = "";

String whereBoat = "";
if(programSite.length() > 0) {
    whereBoat = DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '" + programSite + "'";
}// else {
//    whereBoat = DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " not ilike '" + IFishConfig.SITE_OTHERS + "'";
//}
Vector listBoat = DbBoat.list(0, 0, whereBoat, DbBoat.colNames[DbBoat.COL_PROGRAM_SITE]);

if (iJSPCommand == JSPCommand.SAVE) {
    jspuser.requestEntityObject(appUser);
    String pwd = JSPRequestValue.requestString(request, JspUser.colNames[JspUser.JSP_PASSWORD]);
    String repwd = JSPRequestValue.requestString(request, JspUser.colNames[JspUser.JSP_CONFIRM_PASSWORD]);
    if (!pwd.equals(repwd)) {
        excCode = JSPMessage.ERR_PWDSYNC;
        msgString = JSPMessage.getMessage(excCode);
    }
}

if(excCode == JSPMessage.NONE) {
    excCode = cmdUser.action(iJSPCommand, userId, user.getOID());
    msgString = cmdUser.getMessage();
    appUser = cmdUser.getUser();

    if (userId == 0) {
        userId = appUser.getOID();
    }

    if (jspuser.getErrors().size() < 1) {
        msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
    }
}

if (iJSPCommand == JSPCommand.SAVE) {
    DbUserBoat.deleteByUser(appUser.getOID());
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat boat = (Boat) listBoat.get(i);
            long oidx = JSPRequestValue.requestLong(request, JspUser.colNames[JspUser.JSP_BOAT_ID] + "_" + boat.getOID());
            if(oidx != 0) {
                try {
                    UserBoat ub = new UserBoat();
                    ub.setUserId(appUser.getOID());
                    ub.setBoatId(boat.getOID());
                    DbUserBoat.insert(ub);
                } catch(Exception e) {
                }
            }
        }
    }
}

Vector listUserBoat = DbUserBoat.list(0, 0, DbUserBoat.colNames[DbUserBoat.COL_USER_ID]+"="+appUser.getOID(), "");

/** list of partner */
Vector listPartner = DbPartner.list(0, 0, "", DbPartner.colNames[DbPartner.COL_TYPE]+", "+DbPartner.colNames[DbPartner.COL_NAME]);
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

/** list of group */
Vector listGroup = DbGroup.list(0, 0, "", DbGroup.colNames[DbGroup.COL_GROUP_NAME]);
Vector keyGroup = new Vector();
Vector valGroup = new Vector();
keyGroup.add("0");
valGroup.add("select...");
if(listGroup != null && listGroup.size() > 0) {
    for(int i = 0; i < listGroup.size(); i++) {
        Group g = (Group) listGroup.get(i);
        keyGroup.add(String.valueOf(g.getOID()));
        valGroup.add(g.getGroupName());
    }
}

/** list of tracker */
Hashtable hTracker = new Hashtable();
Vector listTracker = DbTracker.listAll();
if(listTracker != null && listTracker.size() > 0) {
    for(int i = 0; i < listTracker.size(); i++) {
        Tracker t = (Tracker) listTracker.get(i);
        hTracker.put(t.getTrackerId(), t);
    }
}
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
    <%if (!privGeneralUser) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function cmdEdit(oid){
        document.jspuser.user_oid.value=oid;
        document.jspuser.command.value="<%=JSPCommand.EDIT%>";
        document.jspuser.action="useredit.jsp";
        document.jspuser.submit();
    }

    <%if (privAdd) {%>
    function cmdAdd(){
        document.jspuser.user_oid.value=0;
        document.jspuser.command.value="<%=JSPCommand.ADD%>";
        document.jspuser.action="useredit.jsp";
        document.jspuser.submit();
    }
    <%}%>

    <%if (privAdd || privEdit) {%>
    function cmdSave(){
        document.jspuser.command.value="<%=JSPCommand.SAVE%>";
        document.jspuser.action="useredit.jsp";
        document.jspuser.submit();
    }
    <%}%>

    <% if (privDelete) {%>
    function cmdDelete(oid){
        document.jspuser.user_oid.value=oid;
        document.jspuser.command.value="<%=JSPCommand.ASK%>";
        document.jspuser.action="useredit.jsp";
        document.jspuser.submit();
    }

    function cmdConfirmDelete(oid){
        document.jspuser.user_oid.value=oid;
        document.jspuser.command.value="<%=JSPCommand.DELETE%>";
        document.jspuser.action="useredit.jsp";
        document.jspuser.submit();
    }
    <%}%>

    function cmdBack(oid){
        document.jspuser.user_oid.value=oid;
        document.jspuser.command.value="<%=JSPCommand.LIST%>";
        document.jspuser.action="userlist.jsp";
        document.jspuser.submit();
    }

    function cmdChangeImage(oid){
        document.jspuser.user_oid.value=oid;
        document.jspuser.command.value="<%=JSPCommand.NONE%>";
        document.jspuser.action="userimage.jsp";
        document.jspuser.submit();
    }

    function cmdProgramSite(ps) {
        document.jspuser.program_site.value=ps;
        document.jspuser.command.value="<%=JSPCommand.EDIT%>";
        document.jspuser.action="useredit.jsp";
        document.jspuser.submit();
    }

    function checkboxAll(val) {
        <%
        for (int x = 0; x < listBoat.size(); x++) {
            Boat boat = (Boat) listBoat.get(x);
            out.println("document.jspuser." + JspUser.colNames[JspUser.JSP_BOAT_ID] + "_" + boat.getOID() + ".checked = val.checked;");
        }
        %>
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
            <%@ include file="../main/hmenu.jsp"%>
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
                  <%@ include file="../ifish/main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                          <form name="jspuser" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="user_oid" value="<%=userId%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="program_site" value="<%=programSite%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">General</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">User</span></td>
                                    <td width="40%" height="23">
                                      <%@ include file = "../main/userpreview.jsp" %>
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
                                    <table width="100%" cellpadding="1" cellspacing="1" border="0">
                                        <tr>
                                            <td width="15%">Status</td>
                                            <td width="33%"><input type="checkbox" name="<%=JspUser.colNames[JspUser.JSP_STATUS]%>" value="1" <%=appUser.getStatus()==IFishConfig.STATUS_ACTIVE?"checked":""%>>&nbsp;Active</td>
                                            <td width="52%" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Is UALD?</td>
                                            <td width="33%"><input type="checkbox" name="<%=JspUser.colNames[JspUser.JSP_UALD]%>" value="1" <%=appUser.getUald()==IFishConfig.STATUS_ACTIVE?"checked":""%>>&nbsp;User of Anonymous Location Data (UALD)</td>
                                            <td width="52%" valign="top">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Full Name</td>
                                            <td width="33%">
                                                <input type="text" name="<%=JspUser.colNames[JspUser.JSP_FULL_NAME] %>" value="<%=appUser.getFullName()%>" class="formElemen" size="35">
                                                *&nbsp;<%= jspuser.getErrorMsg(jspuser.JSP_FULL_NAME) %></td>
                                            <td width="52%" rowspan="5" valign="top">&nbsp;
                                                <% if(appUser.getOID() != 0) { %>
                                                <a href="javascript:cmdChangeImage('<%=appUser.getOID()%>')"><img src="<%=rootSystem%>/<%=IFishConfig.IMG_PATH%>/<%=appUser.getLoginId()%>.jpg" height="120" border="0" title="click here to change picture" alt="no picture, click here to add a picture"></a>
                                                <% } %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Login ID</td>
                                            <td width="33%">
                                                <%if(appUser.getOID() == 0){%>
                                                <input type="text" name="<%=JspUser.colNames[JspUser.JSP_LOGIN_ID] %>" value="<%=appUser.getLoginId()%>" class="formElemen">
                                                *&nbsp;<%= jspuser.getErrorMsg(jspuser.JSP_LOGIN_ID) %>
                                                <%} else {%>
                                                <input type="text" name="x_login_id" value="<%=appUser.getLoginId()%>" class="formElemen" disabled>
                                                <input type="hidden" name="<%=JspUser.colNames[JspUser.JSP_LOGIN_ID] %>" value="<%=appUser.getLoginId()%>" class="formElemen">
                                                <%}%>
                                            </td>
                                        </tr>
                                        <%if(appUser.getOID() == 0) {%>
                                        <tr>
                                            <td width="15%">Password</td>
                                            <td width="33%">
                                                <input type="password" name="<%=JspUser.colNames[JspUser.JSP_PASSWORD]%>" class="formElemen" onFocus="this.value=''">
                                                *&nbsp;<%=jspuser.getErrorMsg(jspuser.JSP_PASSWORD)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Confirm Password</td>
                                            <td width="33%">
                                                <input type="password" name="<%=JspUser.colNames[JspUser.JSP_CONFIRM_PASSWORD]%>" class="formElemen">
                                            </td>
                                        </tr>
                                        <%} else {%>
                                        <input type="hidden" name="<%=JspUser.colNames[JspUser.JSP_PASSWORD]%>" value="<%=appUser.getPassword()%>">
                                        <input type="hidden" name="<%=JspUser.colNames[JspUser.JSP_CONFIRM_PASSWORD]%>" value="<%=appUser.getPassword()%>">
                                        <%}%>
                                        <tr>
                                            <td width="15%" valign="top">Notes</td>
                                            <td width="33%">
                                                <textarea name="<%=JspUser.colNames[JspUser.JSP_DESCRIPTION] %>" cols="48" rows="4" class="formElemen"><%=(appUser.getDescription() == null) ? "" : appUser.getDescription()%></textarea>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%" nowrap>Affiliate</td>
                                            <td width="33%"><%=JSPCombo.draw(JspUser.colNames[JspUser.JSP_PARTNER_ID], null, String.valueOf(appUser.getPartnerId()), keyPartner, valPartner, "") %></td>
                                        </tr>
                                        <tr>
                                            <td width="15%" nowrap>Group Privilege</td>
                                            <td width="33%"><%=JSPCombo.draw(JspUser.colNames[JspUser.JSP_GROUP_ID], null, String.valueOf(appUser.getGroupId()), keyGroup, valGroup, "") %></td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Spot Trace&nbsp;
                                                <input type="checkbox" name="<%=JspUser.colNames[JspUser.JSP_BOAT_ID]%>_ALL" value="1" onclick="javascript:checkboxAll(this)">All
                                            </td>
                                            <td colspan="2">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="17" height="10"></td>
                                                        <%if(programSite.equals("")) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;All&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('')" class="tablink">All</a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_BALI)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_BALI%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_BALI%>')" class="tablink"><%=IFishConfig.SITE_BALI%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_KUPANG)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_KUPANG%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_KUPANG%>')" class="tablink"><%=IFishConfig.SITE_KUPANG%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_KEMA)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_KEMA%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_KEMA%>')" class="tablink"><%=IFishConfig.SITE_KEMA%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_PROBOLINGGO)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_PROBOLINGGO%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_PROBOLINGGO%>')" class="tablink"><%=IFishConfig.SITE_PROBOLINGGO%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_LUWUK)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_LUWUK%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_LUWUK%>')" class="tablink"><%=IFishConfig.SITE_LUWUK%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_TANJUNG_LUAR)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_TANJUNG_LUAR%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_TANJUNG_LUAR%>')" class="tablink"><%=IFishConfig.SITE_TANJUNG_LUAR%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(programSite.equals(IFishConfig.SITE_OTHERS)) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;<%=IFishConfig.SITE_OTHERS%>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:cmdProgramSite('<%=IFishConfig.SITE_OTHERS%>')" class="tablink"><%=IFishConfig.SITE_OTHERS%></a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%" nowrap>&nbsp;</td>
                                            <td colspan="2">
                                                <%
                                                if(listBoat != null && listBoat.size() > 0) {
                                                    for(int i = 0; i < listBoat.size(); i++) {
                                                        Boat boat = (Boat) listBoat.get(i);
                                                        String fieldName = JspUser.colNames[JspUser.JSP_BOAT_ID] + "_" + boat.getOID();
                                                        String chk = "";
                                                        if(listUserBoat != null && listUserBoat.size() > 0) {
                                                            for(int j = 0; j < listUserBoat.size(); j++) {
                                                                UserBoat ub = (UserBoat) listUserBoat.get(j);
                                                                if(boat.getOID() == ub.getBoatId()) {
                                                                    chk = " checked";
                                                                }
                                                            }
                                                        }
                                                        Tracker tracker = (Tracker) hTracker.get(boat.getTrackerId());
                                                        if(tracker == null) tracker = new Tracker();
                                                        out.println("<div style=\"width:180px;float:left;margin-right:5px;margin-bottom:0px;text-align:left;\"><input type=\"checkbox\" name=\""+fieldName+"\" value=\"1\""+chk+">"+(chk.trim().equals("checked")?("<b>"+boat.getName()+" ("+tracker.getTrackerName()+")</b>"):(boat.getName()+" ("+tracker.getTrackerName()+")"))+"</div>");
                                                    }
                                                }
                                                %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="15%">Login Status</td>
                                            <td width="33%"><%=IFishConfig.strLoginStatus[appUser.getLoginStatus()]%></td>
                                            <td width="52%">&nbsp;</td>
                                          </tr>
                                          <tr>
                                              <td width="15%">Last Update Date</td>
                                              <td width="33%"><%=(appUser.getUpdateDate() == null) ? "-" : JSPFormater.formatDate(appUser.getUpdateDate(), "dd MMMM yyyy")%>
                                                  <input type="hidden" name="<%=JspUser.colNames[JspUser.JSP_UPDATE_DATE]%>2" value="<%=appUser.getUpdateDate()%>">
                                              </td>
                                              <td width="52%">&nbsp;</td>
                                          </tr>
                                          <tr>
                                              <td width="15%">Registered Date</td>
                                              <td width="33%"><%=(appUser.getRegDate() == null) ? "-" : JSPFormater.formatDate(appUser.getRegDate(), "dd MMMM yyyy")%></td>
                                              <td width="52%">&nbsp;</td>
                                          </tr>
                                          <tr>
                                              <td width="15%">Last Login Date</td>
                                              <td width="33%">
                                                  <%
                                                  if (appUser.getLastLoginDate() == null) {
                                                      out.println("-");
                                                  } else {
                                                      out.println(appUser.getLastLoginDate());
                                                  }%>
                                              </td>
                                              <td width="52%">&nbsp;</td>
                                          </tr>
                                          <tr>
                                              <td width="15%">Last Login IP</td>
                                              <td width="33%">
                                                  <%
                                                  if (appUser.getLastLoginIp() == null) {
                                                      out.println("-");
                                                  } else {
                                                      out.println(appUser.getLastLoginIp());
                                                  }%>
                                              </td>
                                              <td width="52%">&nbsp;</td>
                                          </tr>
                                          <tr>
                                              <td colspan="3" class="command">&nbsp;</td>
                                          </tr>
                                          <tr>
                                              <td colspan="3">
                                                  <%
                                                  jspLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                  jspLine.initDefault();
                                                  jspLine.setTableWidth("80%");
                                                  String scomDel = "javascript:cmdDelete('" + userId + "')";
                                                  String sconDelCom = "javascript:cmdConfirmDelete('" + userId + "')";
                                                  String scancel = "javascript:cmdEdit('" + userId + "')";
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
                                                  <%= jspLine.drawImageOnly(iJSPCommand, excCode, msgString)%>
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
            <%@ include file="../main/footer.jsp"%>
            <!-- #EndEditable -->
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<!-- #EndTemplate --></html>