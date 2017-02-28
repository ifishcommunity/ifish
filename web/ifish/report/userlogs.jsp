<%-- 
    Document   : userlogs
    Created on : Jan 19, 2015, 11:05:33 AM
    Author     : gwawan
--%>
<%@page import="com.project.main.log.DbLogsAction"%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.main.log.LogsAction"%>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Tracker"%>
<%@ page import = "com.project.ifish.master.DbTracker"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_USER_LOGS, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_USER_LOGS, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_USER_LOGS, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%!
public String drawList(Vector objectClass, int offset) {
    JSPList jspList = new JSPList();
    jspList.setAreaWidth("100%");
    jspList.setListStyle("listgen");
    jspList.setTitleStyle("tablehdr");
    jspList.setCellStyle("tablecell");
    jspList.setCellStyle1("tablecell1");
    jspList.setHeaderStyle("tablehdr");

    jspList.addHeader("Login ID", "15%");
    jspList.addHeader("Full Name", "20%");
    jspList.addHeader("Date Time", "15%");
    jspList.addHeader("Activity", "25%");
    jspList.addHeader("Table", "25%");

    jspList.setLinkRow(-1);
    jspList.setLinkSufix("");
    Vector lstData = jspList.getData();
    jspList.reset();
    int index = -1;
    Vector rowx = new Vector();
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs

    Hashtable hUser = new Hashtable();
    Vector listActivity = DbUser.list(0, 0, "", "");
    if(listActivity != null && listActivity.size() > 0) {
        for(int i=0; i<listActivity.size(); i++) {
            User userx = (User) listActivity.get(i);
            hUser.put(userx.getOID(), userx);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        LogsAction logsAction = (LogsAction) objectClass.get(i);
        long lDateTime = logsAction.getDateTime().getTime();
        Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));
        rowx = new Vector();

        User userx = (User) hUser.get(logsAction.getUserId());
        if(userx == null) userx = new User();

        rowx.add(String.valueOf(userx.getLoginId()));
        rowx.add(String.valueOf(userx.getFullName()));
        rowx.add(String.valueOf(JSPFormater.formatDate(dateByTimeZone, "yyyy-MM-dd HH:mm:ss")));
        rowx.add(JSPCommand.strJspCommand[logsAction.getCmdAction()]);
        rowx.add(logsAction.getTableName());

        lstData.add(rowx);
    }

    return jspList.draw(index);
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String whereClause = "";
String order = " " + DbLogsAction.colNames[DbLogsAction.COL_DATE_TIME] + " DESC";
Vector list = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

Vector listUser = DbUser.list(0, 0, "", DbUser.colNames[DbUser.COL_FULL_NAME]);
Vector keyUser = new Vector();
Vector valUser = new Vector();
if(listUser != null && listUser.size() > 0) {
    for(int i=0; i<listUser.size(); i++) {
        User userx = (User) listUser.get(i);
        keyUser.add(String.valueOf(userx.getOID()));
        valUser.add(userx.getFullName()+" ("+userx.getLoginId()+")");
    }
}

/* GET REQUEST FROM HIDDEN TEXT */
int jspCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
long oidUser = JSPRequestValue.requestLong(request, "oid_user");
int offset = JSPRequestValue.requestInt(request, "offset");

if(oidUser != 0) {
    whereClause = DbLogsAction.colNames[DbLogsAction.COL_USER_ID] + " = " + oidUser;
}

/* control list */
Control control = new Control();
int vectSize = 0;
if(jspCommand != JSPCommand.NONE) {
    vectSize = DbLogsAction.getCount(whereClause);
    start = control.actionList(jspCommand, start, vectSize, recordToGet);
    list = DbLogsAction.list(start, recordToGet, whereClause, order);
}
/* end */
%>
<!-- End of JSP Block -->
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
    <%if (!privReportUserLogs) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    var offset = new Date().getTimezoneOffset();

    function cmdList(){
        document.frmUserLogs.start.value=0;
        document.frmUserLogs.offset.value=offset;
        document.frmUserLogs.command.value="<%=JSPCommand.LIST%>";
        document.frmUserLogs.action="userlogs.jsp";
        document.frmUserLogs.submit();
    }

    function cmdListFirst(){
        document.frmUserLogs.offset.value=offset;
        document.frmUserLogs.command.value="<%=JSPCommand.FIRST%>";
        document.frmUserLogs.action="userlogs.jsp";
        document.frmUserLogs.submit();
    }

    function cmdListPrev(){
        document.frmUserLogs.offset.value=offset;
        document.frmUserLogs.command.value="<%=JSPCommand.PREV%>";
        document.frmUserLogs.action="userlogs.jsp";
        document.frmUserLogs.submit();
    }

    function cmdListNext(){
        document.frmUserLogs.offset.value=offset;
        document.frmUserLogs.command.value="<%=JSPCommand.NEXT%>";
        document.frmUserLogs.action="userlogs.jsp";
        document.frmUserLogs.submit();
    }

    function cmdListLast(){
        document.frmUserLogs.offset.value=offset;
        document.frmUserLogs.command.value="<%=JSPCommand.LAST%>";
        document.frmUserLogs.action="userlogs.jsp";
        document.frmUserLogs.submit();
    }
<!--
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
//-->
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
                          <form name="frmUserLogs" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=jspCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Report</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">User Logs</span></td>
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
                                            <td width="10%">User Name&nbsp;</td>
                                            <td width="30%"><%=JSPCombo.draw("oid_user", "select...", String.valueOf(oidUser), keyUser, valUser, "") %>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList()">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <%if(jspCommand != JSPCommand.NONE) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3"><%=list.size()>0?drawList(list, offset):"Data not found"%></td>
                                        </tr>
                                        <%}%>
                                        <tr>
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
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
                          </form>
                      <!-- #EndEditable --></td>
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