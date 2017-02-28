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
<%
/* VARIABLE DECLARATION */
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
long groupId = JSPRequestValue.requestLong(request, "group_oid");
int start = JSPRequestValue.requestInt(request, "start");

CmdGroup ctrlGroup = new CmdGroup(request);
JspGroup jspGroup = ctrlGroup.getForm();
int iErrCode = ctrlGroup.action(iJSPCommand, groupId, user.getOID());
String msgString = ctrlGroup.getMessage();
Group appGroup = ctrlGroup.getGroup();
if(groupId == 0) {
    groupId = appGroup.getOID();
}

if (iJSPCommand == JSPCommand.SAVE) {
    DbGroupDetail.deleteByGroup(appGroup.getOID());

    for (int i = 0; i < AppMenu.strMenuDashboard1.length; i++) {
        for (int x = 0; x < AppMenu.strMenuDashboard2[i].length; x++) {
            if (JSPRequestValue.requestInt(request, "menuDashboard2_" + i + "" + x) == 1) {
                GroupDetail groupDetail = new GroupDetail();
                groupDetail.setMn1(AppMenu.MENU_DASHBOARD_CONSTANT+ i);
                groupDetail.setMn2(x);
                groupDetail.setGroupId(appGroup.getOID());
                try {
                    DbGroupDetail.insertExc(groupDetail);
                    msgString = "Data has been saved";
                } catch (Exception e) {
                }
            }
        }
    }

    for (int i = 0; i < AppMenu.strMenuGeneral1.length; i++) {
        for (int x = 0; x < AppMenu.strMenuGeneral2[i].length; x++) {
            if (JSPRequestValue.requestInt(request, "menuAdm2_" + i + "" + x) == 1) {
                GroupDetail groupDetail = new GroupDetail();
                groupDetail.setMn1(AppMenu.MENU_GENERAL_CONSTANT + i);
                groupDetail.setMn2(x);
                groupDetail.setGroupId(appGroup.getOID());
                groupDetail.setCmdAdd(JSPRequestValue.requestInt(request, "menuAdm2_add" + i + "" + x));
                groupDetail.setCmdEdit(JSPRequestValue.requestInt(request, "menuAdm2_edit" + i + "" + x));
                groupDetail.setCmdDelete(JSPRequestValue.requestInt(request, "menuAdm2_delete" + i + "" + x));
                try {
                    DbGroupDetail.insertExc(groupDetail);
                    msgString = "Data has been saved";
                } catch (Exception e) {
                }
            }
        }
    }

    for (int i = 0; i < AppMenu.strMenuIFish1.length; i++) {
        for (int x = 0; x < AppMenu.strMenuIFish2[i].length; x++) {
            if (JSPRequestValue.requestInt(request, "menuIFish2_" + i + "" + x) == 1) {
                GroupDetail groupDetail = new GroupDetail();
                groupDetail.setMn1(AppMenu.MENU_IFISH_CONSTANT + i);
                groupDetail.setMn2(x);
                groupDetail.setGroupId(appGroup.getOID());
                groupDetail.setCmdAdd(JSPRequestValue.requestInt(request, "menuIFish2_add" + i + "" + x));
                groupDetail.setCmdEdit(JSPRequestValue.requestInt(request, "menuIFish2_edit" + i + "" + x));
                groupDetail.setCmdDelete(JSPRequestValue.requestInt(request, "menuIFish2_delete" + i + "" + x));
                try {
                    DbGroupDetail.insertExc(groupDetail);
                    msgString = "Data has been saved";
                } catch (Exception e) {
                }
            }
        }
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

    <%if (jspGroup.errorSize() > 0) {%>
    window.location="#go";
    <%}%>
        
    <% if (privAdd) {%>
    function cmdAdd(){
        document.frmGroup.group_oid.value="0";
        document.frmGroup.command.value="<%=JSPCommand.ADD%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }
    <%}%>

    function cmdEdit(oid){
        document.frmGroup.group_oid.value=oid;
        document.frmGroup.command.value="<%=JSPCommand.EDIT%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }

    <% if (privAdd || privEdit) {%>
    function cmdSave(){
        document.frmGroup.command.value="<%=JSPCommand.SAVE%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }

    <%}%>

    <% if (privDelete) {%>
    function cmdDelete(oid){
        document.frmGroup.group_oid.value=oid;
        document.frmGroup.command.value="<%=JSPCommand.ASK%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }
    function cmdConfirmDelete(oid){
        document.frmGroup.group_oid.value=oid;
        document.frmGroup.command.value="<%=JSPCommand.DELETE%>";
        document.frmGroup.action="groupedit.jsp";
        document.frmGroup.submit();
    }
    <%}%>
    function cmdBack(oid){
        document.frmGroup.group_oid.value=oid;
        document.frmGroup.command.value="<%=JSPCommand.LIST%>";
        document.frmGroup.action="grouplist.jsp";
        document.frmGroup.submit();
    }

<%
    for (int i = 0; i < AppMenu.strMenuDashboard1.length; i++) {
        out.println("function setCheckedAllDashboard" + i + "(val) {");
        for (int x = 0; x < AppMenu.strMenuDashboard2[i].length; x++) {
            out.println("document.frmGroup.menuDashboard2_" + (i + "" + x) + ".checked = val.checked;");
        }
        out.println("}");
    }

    for (int i = 0; i < AppMenu.strMenuDashboard1.length; i++) {
        for (int x = 0; x < AppMenu.strMenuDashboard2[i].length; x++) {
            out.println("function setCheckedAllDashboard" + i + "" + x + "(val) {");
            out.println("document.frmGroup.menuDashboard2_" + (i + "" + x) + ".checked = val.checked;");
            out.println("}");
        }
    }

    for (int i = 0; i < AppMenu.strMenuGeneral1.length; i++) {
        out.println("function setCheckedAllAdm" + i + "(val) {");
        for (int x = 0; x < AppMenu.strMenuGeneral2[i].length; x++) {
            out.println("document.frmGroup.menuAdm2_" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuAdm2_add" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuAdm2_edit" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuAdm2_delete" + (i + "" + x) + ".checked = val.checked;");
        }
        out.println("}");
    }

    for (int i = 0; i < AppMenu.strMenuGeneral1.length; i++) {
        for (int x = 0; x < AppMenu.strMenuGeneral2[i].length; x++) {
            out.println("function setCheckedAllAdm" + i + "" + x + "(val) {");
            out.println("document.frmGroup.menuAdm2_" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuAdm2_add" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuAdm2_edit" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuAdm2_delete" + (i + "" + x) + ".checked = val.checked;");
            out.println("}");
        }
    }

    for (int i = 0; i < AppMenu.strMenuIFish1.length; i++) {
        out.println("function setCheckedAllIFish" + i + "(val) {");
        for (int x = 0; x < AppMenu.strMenuIFish2[i].length; x++) {
            out.println("document.frmGroup.menuIFish2_" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuIFish2_add" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuIFish2_edit" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuIFish2_delete" + (i + "" + x) + ".checked = val.checked;");
        }
        out.println("}");
    }

    for (int i = 0; i < AppMenu.strMenuIFish1.length; i++) {
        for (int x = 0; x < AppMenu.strMenuIFish2[i].length; x++) {
            out.println("function setCheckedAllIFish" + i + "" + x + "(val) {");
            out.println("document.frmGroup.menuIFish2_" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuIFish2_add" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuIFish2_edit" + (i + "" + x) + ".checked = val.checked;");
            out.println("document.frmGroup.menuIFish2_delete" + (i + "" + x) + ".checked = val.checked;");
            out.println("}");
        }
    }
%>
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
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="group_oid" value="<%=groupId%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
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
                                    <table width="100%">
                                        <tr>
                                            <td width="13%">Group Name</td>
                                            <td width="87%"><input type="text" name="<%=jspGroup.colNames[jspGroup.JSP_GROUP_NAME]%>" value="<%=appGroup.getGroupName()%>" class="formElemen" size="30">
                                                * &nbsp;<%= jspGroup.getErrorMsg(jspGroup.JSP_GROUP_NAME)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%" valign="top">Description</td>
                                            <td width="87%"><textarea name="<%=jspGroup.colNames[jspGroup.JSP_DESCRIPTION]%>" cols="40" rows="3" class="formElemen"><%=appGroup.getDescription()%></textarea></td>
                                        </tr>
                                        <tr>
                                            <td width="13%" valign="top" height="14" nowrap>Registration Date</td>
                                            <td width="87%" height="14"><%=JSPDate.drawDate(JspGroup.colNames[JspGroup.JSP_REG_DATE], appGroup.getRegDate(), "formElemen", 0, -30)%> </td>
                                        </tr>
                                        <tr>
                                            <td width="13%" valign="top" height="14" nowrap>Select Module</td>
                                            <td width="87%" height="14">
                                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                                    <tr>
                                                        <td colspan="2"><b>MENU DASHBOARD</b></td>
                                                    </tr>
                                                    <%for (int j = 0; j < AppMenu.strMenuDashboard1.length; j++) {%>
                                                    <tr>
                                                        <td colspan="2"><input type="checkbox" name="checkboxDashboard<%=j%>" onClick="<%="javascript:setCheckedAllDashboard"+j+"(this)"%>">&nbsp;<b><%=AppMenu.strMenuDashboard1[j]%></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="97%"><table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                        <%
                                                        for (int x = 0; x < AppMenu.strMenuDashboard2[j].length; x++) {
                                                            String where = DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbGroupDetail.colNames[DbGroupDetail.COL_MN_1] + "=" + (AppMenu.MENU_DASHBOARD_CONSTANT + j) + " and " + DbGroupDetail.colNames[DbGroupDetail.COL_MN_2] + "=" + x;
                                                            Vector vx = DbGroupDetail.list(0, 0, where, "");
                                                            GroupDetail groupDetail = new GroupDetail();
                                                            if (vx != null && vx.size() > 0) {
                                                                groupDetail = (GroupDetail) vx.get(0);
                                                            }
                                                            %>
                                                            <tr>
                                                                <td width="1%"><input type="checkbox" name="menuDashboard2_<%=j%><%=x%>" onClick="<%="javascript:setCheckedAllDashboard"+j+""+x+"(this)"%>" value="1" <%if (groupDetail.getOID() != 0) {%> checked <%}%>></td>
                                                                <td width="34%">&nbsp;<%=AppMenu.strMenuDashboard2[j][x]%></td>
                                                                <td width="1%">&nbsp;</td>
                                                                <td width="4%">&nbsp;</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="4%">&nbsp;</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="4%">&nbsp;</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="4%">&nbsp;</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="44%">&nbsp;</td>
                                                            </tr>
                                                            <%}%>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="97%">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2"><b>MENU ADMINISTRATOR</b></td>
                                                    </tr>
                                                    <%for (int j = 0; j < AppMenu.strMenuGeneral1.length; j++) {%>
                                                    <tr>
                                                        <td colspan="2"><input type="checkbox" name="checkboxAdm<%=j%>" onClick="<%="javascript:setCheckedAllAdm"+j+"(this)"%>">&nbsp;<b><%=AppMenu.strMenuGeneral1[j]%></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="97%"><table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                        <%
                                                        for (int x = 0; x < AppMenu.strMenuGeneral2[j].length; x++) {
                                                            String where = DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbGroupDetail.colNames[DbGroupDetail.COL_MN_1] + "=" + (AppMenu.MENU_GENERAL_CONSTANT + j) + " and " + DbGroupDetail.colNames[DbGroupDetail.COL_MN_2] + "=" + x;
                                                            Vector vx = DbGroupDetail.list(0, 0, where, "");
                                                            GroupDetail groupDetail = new GroupDetail();
                                                            if (vx != null && vx.size() > 0) {
                                                                groupDetail = (GroupDetail) vx.get(0);
                                                            }
                                                            %>
                                                            <tr>
                                                                <td width="1%"><input type="checkbox" name="menuAdm2_<%=j%><%=x%>" onClick="<%="javascript:setCheckedAllAdm"+j+""+x+"(this)"%>" value="1" <%if (groupDetail.getOID() != 0) {%> checked <%}%>></td>
                                                                <td width="34%">&nbsp;<%=AppMenu.strMenuGeneral2[j][x]%></td>
                                                                <td width="1%"><input type="checkbox" name="menuAdm2_add<%=j%><%=x%>" value="1" <%if (groupDetail.getCmdAdd() == 1) {%> checked <%}%>></td>
                                                                <td width="4%">&nbsp;Add</td>
                                                                <td width="1%"><input type="checkbox" name="menuAdm2_edit<%=j%><%=x%>" value="1" <%if (groupDetail.getCmdEdit() == 1) {%> checked <%}%>></td>
                                                                <td width="4%">&nbsp;Edit</td>
                                                                <td width="1%"><input type="checkbox" name="menuAdm2_delete<%=j%><%=x%>" value="1" <%if (groupDetail.getCmdDelete() == 1) {%> checked <%}%>></td>
                                                                <td width="4%">&nbsp;Delete</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="4%">&nbsp;</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="44%">&nbsp;</td>
                                                            </tr>
                                                            <%}%>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="97%">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="2"><b>MENU I-FISH COMMUNITY</b></td>
                                                    </tr>
                                                    <%for (int j = 0; j < AppMenu.strMenuIFish1.length; j++) {%>
                                                    <tr>
                                                        <td colspan="2"><input type="checkbox" name="checkboxIFish<%=j%>" onClick="<%="javascript:setCheckedAllIFish"+j+"(this)"%>">&nbsp;<b><%=AppMenu.strMenuIFish1[j]%></b></td>
                                                    </tr>
                                                    <tr>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="97%"><table width="95%" border="0" cellspacing="0" cellpadding="0">
                                                        <%
                                                        for (int x = 0; x < AppMenu.strMenuIFish2[j].length; x++) {
                                                            String where = DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_ID] + "=" + appGroup.getOID() + " and " + DbGroupDetail.colNames[DbGroupDetail.COL_MN_1] + "=" + (AppMenu.MENU_IFISH_CONSTANT + j) + " and " + DbGroupDetail.colNames[DbGroupDetail.COL_MN_2] + "=" + x;
                                                            Vector vx = DbGroupDetail.list(0, 0, where, "");
                                                            GroupDetail groupDetail = new GroupDetail();
                                                            if (vx != null && vx.size() > 0) {
                                                                groupDetail = (GroupDetail) vx.get(0);
                                                            }
                                                            %>
                                                            <tr>
                                                                <td width="1%"><input type="checkbox" name="menuIFish2_<%=j%><%=x%>" onClick="<%="javascript:setCheckedAllIFish"+j+""+x+"(this)"%>" value="1" <%if (groupDetail.getOID() != 0) {%> checked <%}%>></td>
                                                                <td width="34%">&nbsp;<%=AppMenu.strMenuIFish2[j][x]%></td>
                                                                <td width="1%"><input type="checkbox" name="menuIFish2_add<%=j%><%=x%>" value="1" <%if (groupDetail.getCmdAdd() == 1) {%> checked <%}%>></td>
                                                                <td width="4%">&nbsp;Add</td>
                                                                <td width="1%"><input type="checkbox" name="menuIFish2_edit<%=j%><%=x%>" value="1" <%if (groupDetail.getCmdEdit() == 1) {%> checked <%}%>></td>
                                                                <td width="4%">&nbsp;Edit</td>
                                                                <td width="1%"><input type="checkbox" name="menuIFish2_delete<%=j%><%=x%>" value="1" <%if (groupDetail.getCmdDelete() == 1) {%> checked <%}%>></td>
                                                                <td width="4%">&nbsp;Delete</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="4%">&nbsp;</td>
                                                                <td width="1%">&nbsp</td>
                                                                <td width="44%">&nbsp;</td>
                                                            </tr>
                                                            <%}%>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <%}%>
                                                    <tr>
                                                        <td width="3%">&nbsp;</td>
                                                        <td width="97%">&nbsp;</td>
                                                    </tr>
                                                </table>
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
                                                  String scomDel = "javascript:cmdDelete('" + groupId + "')";
                                                  String sconDelCom = "javascript:cmdConfirmDelete('" + groupId + "')";
                                                  String scancel = "javascript:cmdEdit('" + groupId + "')";
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