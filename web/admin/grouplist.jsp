<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %> 
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../ifish/main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%!
public String drawList(Vector objectClass) {

    JSPList ctrlist = new JSPList();
    ctrlist.setAreaWidth("60%");
    ctrlist.setListStyle("listgen");
    ctrlist.setTitleStyle("tablehdr");
    ctrlist.setCellStyle("tablecell");
    ctrlist.setCellStyle1("tablecell1");
    ctrlist.setHeaderStyle("tablehdr");
    ctrlist.addHeader("Group Name", "30%");
    ctrlist.addHeader("Description", "70%");

    ctrlist.setLinkRow(0);
    ctrlist.setLinkSufix("");

    Vector lstData = ctrlist.getData();

    Vector lstLinkData = ctrlist.getLinkData();

    ctrlist.setLinkPrefix("javascript:cmdEdit('");
    ctrlist.setLinkSufix("')");
    ctrlist.reset();

    for (int i = 0; i < objectClass.size(); i++) {
        Group appGroup = (Group) objectClass.get(i);

        Vector rowx = new Vector();
        rowx.add(String.valueOf(appGroup.getGroupName()));
        rowx.add(String.valueOf(appGroup.getDescription()));

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(appGroup.getOID()));
    }

    return ctrlist.draw();
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String order = " " + DbGroup.colNames[DbGroup.COL_GROUP_NAME];
Vector listGroup = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
int start = JSPRequestValue.requestInt(request, "start");
long appGroupOID = JSPRequestValue.requestLong(request, "group_oid");

if (listJSPCommand == JSPCommand.NONE) {
    listJSPCommand = JSPCommand.LIST;
}

/* control list */
CmdGroup ctrlGroup = new CmdGroup(request);
int vectSize = DbGroup.getCount("");
start = ctrlGroup.actionList(listJSPCommand, start, vectSize, recordToGet);
listGroup = DbGroup.list(start, recordToGet, "", order);
/* end */
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

    function addNew(){
        document.frmGroup.group_oid.value="0";
        document.frmGroup.command.value="<%=JSPCommand.ADD%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }

    function cmdEdit(oid){
        document.frmGroup.group_oid.value=oid;
        document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }

    function cmdListFirst(){
        document.frmGroup.list_command.value="<%=JSPCommand.FIRST%>";
        document.frmGroup.action="grouplist.jsp";
        document.frmGroup.submit();
    }

    function cmdListPrev(){
        document.frmGroup.list_command.value="<%=JSPCommand.PREV%>";
        document.frmGroup.action="grouplist.jsp";
        document.frmGroup.submit();
    }

    function cmdListNext(){
        document.frmGroup.list_command.value="<%=JSPCommand.NEXT%>";
        document.frmGroup.action="grouplist.jsp";
        document.frmGroup.submit();
    }

    function cmdListLast(){
        document.frmGroup.list_command.value="<%=JSPCommand.LAST%>";
        document.frmGroup.action="grouplist.jsp";
        document.frmGroup.submit();
    }
</script>
<script language="JavaScript">
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
                          <form name="frmGroup" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="0">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="group_oid" value="<%=appGroupOID%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">General</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">User Group</span></td>
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
                                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <% if ((listGroup != null) && (listGroup.size() > 0)) {%>
                                        <tr>
                                            <td colspan="2"><%=drawList(listGroup)%></td>
                                        </tr>
                                        <%} else {%>
                                        <tr>
                                            <td colspan="2">
                                                <div class="comment">Data not found</div>
                                            </td>
                                        </tr>
                                        <%}%>
                                        <tr>
                                            <td width="13%">&nbsp;</td>
                                            <td width="87%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
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
                                        <tr>
                                            <td colspan="2" height="20">
                                                <a href="javascript:addNew()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new2','','../images/new2.gif',1)"><img src="../images/new.gif" name="new2" width="71" height="22" border="0"></a>
                                            </td>
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