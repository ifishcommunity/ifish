<%-- 
    Document   : spottrace
    Created on : Oct 10, 2014, 10:52:40 AM
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
<%@ page import="com.project.ifish.data.FindMeSpot"%>
<%@ page import="com.project.ifish.master.CmdTracker" %>
<%@ page import="com.project.ifish.master.JspTracker" %>
<%@ page import="com.project.ifish.master.Tracker" %>
<%@ page import="com.project.ifish.master.DbTracker" %>
<%@ page import="com.project.ifish.data.DbFindMeSpot"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_SPOT_TRACE, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_SPOT_TRACE, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_SPOT_TRACE, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
public String drawList(int iJSPCommand, int start, JspTracker frmObject, Vector objectClass, long oidTracker, int offset, boolean priv) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Tracker Name", "10%");
    jsplist.addHeader("Tracker ID", "8%");
    jsplist.addHeader("Auth Code", "8%");
    jsplist.addHeader("Feed ID", "20%");
    jsplist.addHeader("Attach On", "17%");
    jsplist.addHeader("Unit Status", "8%");
    jsplist.addHeader("Notes", "26%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    Vector listBoat = DbBoat.list(0, 0, DbBoat.colNames[DbBoat.COL_TRACKER_ID]+">0 and "+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+"=1", "");
    Hashtable hBoat = new Hashtable();
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat b = (Boat) listBoat.get(i);
            hBoat.put(b.getTrackerId(), b);
        }
    }

    Vector valStatus = new Vector();
    valStatus.add(IFishConfig.strStatus[IFishConfig.STATUS_INACTIVE]);
    valStatus.add(IFishConfig.strStatus[IFishConfig.STATUS_ACTIVE]);
    valStatus.add(IFishConfig.strStatus[IFishConfig.STATUS_BROKEN]);
    valStatus.add(IFishConfig.strStatus[IFishConfig.STATUS_LOST]);

    Vector keyStatus = new Vector();
    keyStatus.add(String.valueOf(IFishConfig.STATUS_INACTIVE));
    keyStatus.add(String.valueOf(IFishConfig.STATUS_ACTIVE));
    keyStatus.add(String.valueOf(IFishConfig.STATUS_BROKEN));
    keyStatus.add(String.valueOf(IFishConfig.STATUS_LOST));

    for (int i = 0; i < objectClass.size(); i++) {
        Tracker tracker = (Tracker) objectClass.get(i);

        Boat boat = (Boat) hBoat.get(tracker.getTrackerId());
        if(boat == null) boat = new Boat();

        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (start + i + 1) + "</div>");

        if (tracker.getOID() == oidTracker
                && (iJSPCommand == JSPCommand.EDIT || iJSPCommand == JSPCommand.ASK
                || (iJSPCommand == JSPCommand.EDIT && frmObject.errorSize() > 0)
                || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0))){
            rowx.add("<input type=\"text\" size=\"11\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_TRACKER_NAME] + "\" value=\"" + tracker.getTrackerName() + "\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_TRACKER_NAME));
            rowx.add("<input type=\"text\" size=\"7\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_TRACKER_ID] + "\" value=\"" + tracker.getTrackerId() + "\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_TRACKER_ID));
            rowx.add("<input type=\"text\" size=\"7\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_AUTH_CODE] + "\" value=\"" + tracker.getAuthCode() + "\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_AUTH_CODE));
            rowx.add("<input type=\"text\" size=\"33\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_FEED_ID] + "\" value=\"" + tracker.getFeedId() + "\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_FEED_ID));
            rowx.add(tracker.getOID()!=0?boat.getName():"");
            rowx.add(JSPCombo.draw(JspTracker.fieldNames[JspTracker.JSP_STATUS], null, String.valueOf(tracker.getStatus()), keyStatus, valStatus));
            rowx.add("<input type=\"text\" size=\"33\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_NOTES] + "\" value=\"" + tracker.getNotes() + "\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_NOTES));
        } else {
            rowx.add("<a href=\"javascript:cmdEdit('" + tracker.getOID() + "')\">" + tracker.getTrackerName() + "</a>");
            rowx.add(String.valueOf(tracker.getTrackerId()));
            rowx.add(tracker.getAuthCode());
            if(priv) {
                rowx.add("<a href=\"http://share.findmespot.com/shared/faces/viewspots.jsp?glId=" + tracker.getFeedId() + "\" target=\"blank\" title=\"Click here to view from www.spottrace.com\">" + tracker.getFeedId() + "</a>");
            } else {
                rowx.add(tracker.getFeedId());
            }
            rowx.add(boat.getOID()!=0?boat.getName() + " (" + boat.getHomePort() + ")":"");
            rowx.add(IFishConfig.strStatus[tracker.getStatus()]);
            rowx.add(tracker.getNotes());
        }

        lstData.add(rowx);
    }

    if (oidTracker == 0 && (iJSPCommand == JSPCommand.ADD || (iJSPCommand == JSPCommand.SAVE && frmObject.errorSize() > 0))) {
        rowx = new Vector();
        rowx.add("");
        rowx.add("<input type=\"text\" size=\"11\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_TRACKER_NAME] + "\" value=\"\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_TRACKER_NAME));
        rowx.add("<input type=\"text\" size=\"7\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_TRACKER_ID] + "\" value=\"\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_TRACKER_ID));
        rowx.add("<input type=\"text\" size=\"7\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_AUTH_CODE] + "\" value=\"\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_AUTH_CODE));
        rowx.add("<input type=\"text\" size=\"33\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_FEED_ID] + "\" value=\"\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_FEED_ID));
        rowx.add("");
        rowx.add(JSPCombo.draw(JspTracker.fieldNames[JspTracker.JSP_STATUS], null, "0", keyStatus, valStatus, ""));
        rowx.add("<input type=\"text\" size=\"33\" name=\"" + JspTracker.fieldNames[JspTracker.JSP_NOTES] + "\" value=\"\" class=\"formElemen\">" + "</div> * "+frmObject.getErrorMsg(JspTracker.JSP_NOTES));
        lstData.add(rowx);
    }

    return jsplist.draw(index);
}
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
long oidTracker = JSPRequestValue.requestLong(request, "hidden_tracker_id");
int offset = JSPRequestValue.requestInt(request, "offset");
String srcTrackerName = JSPRequestValue.requestString(request, "src_tracker_name");

/*variable declaration*/
int recordToGet = 10;
String msgString = "";
int iErrCode = JSPMessage.NONE;
String whereClause = "";
if(srcTrackerName.length() > 0) {
    whereClause = DbTracker.colNames[DbTracker.COL_TRACKER_NAME] + " ilike '%" + srcTrackerName + "%'";
}
String orderClause = DbTracker.colNames[DbTracker.COL_TRACKER_NAME];

if(iJSPCommand == JSPCommand.START || iJSPCommand == JSPCommand.STOP) {
    DbFindMeSpot dbFindMeSpot = new DbFindMeSpot();
    switch(iJSPCommand) {
        case JSPCommand.START:
            dbFindMeSpot.startService();
            break;
        case JSPCommand.STOP:
            dbFindMeSpot.stopService();
            break;
    }
    iJSPCommand = JSPCommand.NONE;
}

boolean serviceStatus = DbFindMeSpot.running;

CmdTracker ctrlTracker = new CmdTracker(request);
JSPLine ctrLine = new JSPLine();
Vector listTracker = new Vector(1, 1);

/*switch statement */
iErrCode = ctrlTracker.action(iJSPCommand, oidTracker, user.getOID());
/* end switch*/

JspTracker jspTracker = ctrlTracker.getForm();
msgString = ctrlTracker.getMessage();

/*count list All Tracker*/
int vectSize = 0;
if(listJSPCommand != JSPCommand.NONE) {
    vectSize = DbTracker.getCount(whereClause);
    start = ctrlTracker.actionList(listJSPCommand, start, vectSize, recordToGet);
    listTracker = DbTracker.list(start, recordToGet, whereClause, orderClause);
}
    /* end switch list*/
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
<%if (!privMasterSpotTrace) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
<%}%>

var offset = new Date().getTimezoneOffset();

function cmdStartService() {
    document.frmspottrace.command.value="<%=JSPCommand.START%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdStopService() {
    document.frmspottrace.command.value="<%=JSPCommand.STOP%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdAdd(){
    document.frmspottrace.hidden_tracker_id.value="0";
    document.frmspottrace.command.value="<%=JSPCommand.ADD%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdAsk(oid){
    document.frmspottrace.hidden_tracker_id.value=oid;
    document.frmspottrace.command.value="<%=JSPCommand.ASK%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdConfirmDelete(oid){
    document.frmspottrace.hidden_tracker_id.value=oid;
    document.frmspottrace.command.value="<%=JSPCommand.DELETE%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdSave(){
    document.frmspottrace.command.value="<%=JSPCommand.SAVE%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdEdit(oid){
    document.frmspottrace.hidden_tracker_id.value=oid;
    document.frmspottrace.command.value="<%=JSPCommand.EDIT%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdCancel(oid){
    document.frmspottrace.hidden_tracker_id.value=oid;
    document.frmspottrace.command.value="<%=JSPCommand.EDIT%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdBack(){
    document.frmspottrace.command.value="<%=JSPCommand.BACK%>";
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdList(){
    document.frmspottrace.offset.value=offset;
    document.frmspottrace.list_command.value="<%=JSPCommand.LIST%>";
    document.frmspottrace.command.value="<%=JSPCommand.NONE%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdListFirst(){
    document.frmspottrace.offset.value=offset;
    document.frmspottrace.list_command.value="<%=JSPCommand.FIRST%>";
    document.frmspottrace.command.value="<%=JSPCommand.NONE%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdListPrev(){
    document.frmspottrace.offset.value=offset;
    document.frmspottrace.list_command.value="<%=JSPCommand.PREV%>";
    document.frmspottrace.command.value="<%=JSPCommand.NONE%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdListNext(){
    document.frmspottrace.offset.value=offset;
    document.frmspottrace.list_command.value="<%=JSPCommand.NEXT%>";
    document.frmspottrace.command.value="<%=JSPCommand.NONE%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdListLast(){
    document.frmspottrace.offset.value=offset;
    document.frmspottrace.list_command.value="<%=JSPCommand.LAST%>";
    document.frmspottrace.command.value="<%=JSPCommand.NONE%>";
    document.frmspottrace.action="spottrace.jsp";
    document.frmspottrace.submit();
}
function cmdManualUpload() {
    window.open("spottracemanual.jsp",  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
}
function spottraceBarcode() {
    window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.SpotTraceBarcodePdf");
}
//-------------- script control line -------------------
function MM_swapImgRestore() { //v3.0
    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
        if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.0
    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
    if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
        if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

</script>

<!-- #EndEditable -->
</head>
<body onLoad="MM_preloadImages('<%=rootSystem%>/images/home2.gif','<%=rootSystem%>/images/logout2.gif')">
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
                        <form name="frmspottrace" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="hidden_tracker_id" value="<%=oidTracker%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Master</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Spot Trace</span></td>
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
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td height="8"  colspan="3">
                                                <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" width="10%">&nbsp;</td>
                                                        <td height="5" valign="middle" width="40%">&nbsp;</td>
                                                        <td height="5" valign="middle" width="50%">&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">
                                                            <table width="100%" border="0" cellspacing="2" cellpadding="0" bgcolor="#ACF394" class="container" class="page">
                                                                <tr align="left" valign="top">
                                                                    <td height="5" valign="middle" width="50%">This process is used to running Spot Trace services. To operate this service, follow steps bellow :</td>
                                                                    <td height="5" valign="middle" width="50%" rowspan="3">
                                                                        <h3>Service status is <%=serviceStatus?"<font style='color:green;'><u>RUNNING</u></font>":"<font style='color:red;'><u>STOPPED</u></font>"%></h3>
                                                                        <% if(privAdd) { %>
                                                                        <% if(!serviceStatus) { %>
                                                                        <input type="button" name="btnstart" value="  Start  " onClick="javascript:cmdStartService()" class="formElemen">
                                                                        <% } else { %>
                                                                        <input type="button" name="btnstop" value="  Stop  " onClick="javascript:cmdStopService()" class="formElemen">
                                                                        <% } %>
                                                                        <% } %>
                                                                    </td>
                                                                </tr>
                                                                <tr align="left" valign="top">
                                                                    <td height="5" valign="middle" colspan="2">- Click start button to start Spot Trace service process</td>
                                                                </tr>
                                                                <tr align="left" valign="top">
                                                                    <td height="5" valign="middle" colspan="2">- Click stop button to stop Spot Trace service process</td>
                                                                </tr>
                                                                <% if(privAdd && 1==2) { %>
                                                                <tr align="left" valign="top">
                                                                    <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                                </tr>
                                                                <tr>
                                                                    <td colspan="3" valign="top"><font face="arial"><b>Use this button to upload the data from Spot Trace (XML) manually >>> </b><input type="button" name="btnupload" value="MANUAL UPLOAD" onClick="javascript:cmdManualUpload()"></font></td>
                                                                </tr>
                                                                <% } %>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td>Tracker Name&nbsp;</td>
                                                        <td><input type="text" name="src_tracker_name" value="<%=srcTrackerName%>" size="30" on>&nbsp;&nbsp;<input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)"></td>
                                                        <td>&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td width="10%">&nbsp;</td>
                                                        <td width="30%">&nbsp;</td>
                                                        <td width="60%">&nbsp;</td>
                                                    </tr>
                                                    <%
                                                    if(listTracker.size() > 0) {
                                                    %>
                                                    <tr align="left" valign="top">
                                                        <td height="22" valign="middle" colspan="3"><%=drawList(iJSPCommand, start, jspTracker, listTracker, oidTracker, offset, privAdd)%> </td>
                                                    </tr>
                                                    <%
                                                    }
                                                    %>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                    </tr>
                                                    <%if ((iJSPCommand == JSPCommand.ADD) || (iJSPCommand == JSPCommand.SAVE && iErrCode != 0) || (iJSPCommand == JSPCommand.EDIT) || (iJSPCommand == JSPCommand.ASK)) {%>
                                                    <tr align="left" valign="top" >
                                                        <td colspan="3" class="command">
                                                            <%
                                                                ctrLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                                ctrLine.initDefault();
                                                                ctrLine.setTableWidth("80%");
                                                                String scomDel = "javascript:cmdAsk('" + oidTracker + "')";
                                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidTracker + "')";
                                                                String scancel = "javascript:cmdEdit('" + oidTracker + "')";
                                                                ctrLine.setBackCaption("Back to List");
                                                                ctrLine.setJSPCommandStyle("buttonlink");

                                                                ctrLine.setOnMouseOut("MM_swapImgRestore()");
                                                                ctrLine.setOnMouseOverSave("MM_swapImage('save','','" + rootSystem + "/images/save2.gif',1)");
                                                                ctrLine.setSaveImage("<img src=\"" + rootSystem + "/images/save.gif\" name=\"save\" height=\"22\" border=\"0\">");

                                                                ctrLine.setOnMouseOverBack("MM_swapImage('back','','" + rootSystem + "/images/cancel2.gif',1)");
                                                                ctrLine.setBackImage("<img src=\"" + rootSystem + "/images/cancel.gif\" name=\"back\" height=\"22\" border=\"0\">");

                                                                ctrLine.setOnMouseOverDelete("MM_swapImage('delete','','" + rootSystem + "/images/delete2.gif',1)");
                                                                ctrLine.setDeleteImage("<img src=\"" + rootSystem + "/images/delete.gif\" name=\"delete\" height=\"22\" border=\"0\">");

                                                                ctrLine.setOnMouseOverEdit("MM_swapImage('edit','','" + rootSystem + "/images/cancel2.gif',1)");
                                                                ctrLine.setEditImage("<img src=\"" + rootSystem + "/images/cancel.gif\" name=\"edit\" height=\"22\" border=\"0\">");


                                                                ctrLine.setWidthAllJSPCommand("90");
                                                                ctrLine.setErrorStyle("warning");
                                                                ctrLine.setErrorImage(rootSystem + "/images/error.gif\" width=\"20\" height=\"20");
                                                                ctrLine.setQuestionStyle("warning");
                                                                ctrLine.setQuestionImage(rootSystem + "/images/error.gif\" width=\"20\" height=\"20");
                                                                ctrLine.setInfoStyle("success");
                                                                ctrLine.setSuccessImage(rootSystem + "/images/success.gif\" width=\"20\" height=\"20");

                                                                if (privDelete) {
                                                                    ctrLine.setConfirmDelJSPCommand(sconDelCom);
                                                                    ctrLine.setDeleteJSPCommand(scomDel);
                                                                    ctrLine.setEditJSPCommand(scancel);
                                                                } else {
                                                                    ctrLine.setConfirmDelCaption("");
                                                                    ctrLine.setDeleteCaption("");
                                                                    ctrLine.setEditCaption("");
                                                                }

                                                                if (privAdd == false && privEdit == false) {
                                                                    ctrLine.setSaveCaption("");
                                                                }

                                                                if (privAdd == false) {
                                                                    ctrLine.setAddCaption("");
                                                                }
                                                            %>
                                                            <%=ctrLine.drawImageOnly(iJSPCommand, iErrCode, msgString)%></td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                    </tr>
                                                    <%}%>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">
                                                            <span class="command">
                                                                <%
                                                                ctrLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                                ctrLine.initDefault();
                                                                ctrLine.setFirstImage("<img name=\"Image23x\" border=\"0\" src=\"" + rootSystem + "/images/first.gif\" alt=\"First\">");
                                                                ctrLine.setPrevImage("<img name=\"Image24x\" border=\"0\" src=\"" + rootSystem + "/images/prev.gif\" alt=\"Prev\">");
                                                                ctrLine.setNextImage("<img name=\"Image25x\" border=\"0\" src=\"" + rootSystem + "/images/next.gif\" alt=\"Next\">");
                                                                ctrLine.setLastImage("<img name=\"Image26x\" border=\"0\" src=\"" + rootSystem + "/images/last.gif\" alt=\"Last\">");
                                                                ctrLine.setFirstOnMouseOver("MM_swapImage('Image23x','','" + rootSystem + "/images/first2.gif',1)");
                                                                ctrLine.setPrevOnMouseOver("MM_swapImage('Image24x','','" + rootSystem + "/images/prev2.gif',1)");
                                                                ctrLine.setNextOnMouseOver("MM_swapImage('Image25x','','" + rootSystem + "/images/next2.gif',1)");
                                                                ctrLine.setLastOnMouseOver("MM_swapImage('Image26x','','" + rootSystem + "/images/last2.gif',1)");
                                                                %>
                                                                <%=ctrLine.drawImageListLimit(listJSPCommand, vectSize, start, recordToGet)%>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <% if (iJSPCommand != JSPCommand.EDIT && iJSPCommand != JSPCommand.ADD && iJSPCommand != JSPCommand.ASK && iErrCode == 0 && privAdd) {%>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3"></td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="22" valign="middle"><a href="javascript:cmdAdd()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new21','','<%=rootSystem%>/images/new2.gif',1)"><img src="<%=rootSystem%>/images/new.gif" name="new21" width="71" height="22" border="0"></a></td>
                                                        <td height="5" valign="middle" colspan="2"><b><% if(listTracker.size() > 0) { %><a href="javascript:spottraceBarcode()">Download SpotTrace Barcode</a><% } %></b></td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">&nbsp;</td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3"><b><u>Feed ID</u></b></td>
                                                    </tr>
                                                    <tr align="left" valign="top">
                                                        <td height="5" valign="middle" colspan="3">
                                                            &nbsp;&nbsp;The Feed ID is part of Shared Page URL
                                                            <br />&nbsp;&nbsp;Shared Page URL : http://share.spottrace.com/shared/faces/viewspots.jsp?glId=0XapxKiqW4RCHYhVkaCBpaHT3cNMUcEef
                                                            <br />&nbsp;&nbsp;The Feed ID in the above Shared Page URL is: <b>0XapxKiqW4RCHYhVkaCBpaHT3cNMUcEef</b>
                                                        </td>
                                                    </tr>
                                                    <% }%>
                                                </table>
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
