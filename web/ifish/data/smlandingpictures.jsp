<%-- 
    Document   : landingpictures
    Created on : Jun 25, 2015, 1:52:38 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.IFishConfig"%>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.main.db.*" %>
<%@ page import="com.project.ifish.data.Sizing"%>
<%@ page import="com.project.ifish.data.DbSizing"%>
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_ADD);
%>
<!-- Jsp Block -->
<%
int iCommand = JSPRequestValue.requestCommand(request);
int iCommandPicture = JSPRequestValue.requestInt(request, "command_picture");
long oidLanding = JSPRequestValue.requestLong(request, "landing_oid");
long oidPicture = JSPRequestValue.requestLong(request, "picture_oid");

String sMsgUpload = (String)session.getAttribute("msg_upload");
int msgUpload = 0;
if(sMsgUpload != null) {
    if(sMsgUpload.length() > 0) {
        msgUpload = Integer.parseInt(sMsgUpload);
        session.removeAttribute("msg_upload");
    }
}

/* delete picture */
if(iCommandPicture == JSPCommand.DELETE && oidPicture != 0) {
    File file = new File();
    try {
        file = DbFile.fetchExc(oidPicture);
    } catch(Exception e) {
        System.out.println(e.toString());
    }
    if(file.getOID() != 0) {
        String uploadPath = getServletContext().getRealPath("") + java.io.File.separator + DbFile.UPLOAD_DIRECTORY;
        String filePath = uploadPath + java.io.File.separator + file.getName();
        java.io.File storeFile = new java.io.File(filePath);
        if(storeFile != null) {
            try {
                storeFile.delete();
                DbFile.deleteExc(file.getOID());
                iCommandPicture = JSPCommand.NONE;
            } catch(Exception e) {
                System.out.println(e.toString());
            }
        }
    }
}

/** list of pictures */
Vector listPictures = DbFile.list(0, 0, DbFile.colNames[DbFile.COL_REF_ID]+"="+oidLanding, DbFile.colNames[DbFile.COL_NAME]);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privDataSWMS|| !privAdd) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function cmdAddPic() {
        document.frmlandingpictures.command.value="<%=JSPCommand.EDIT%>";
        window.open("../../upload/uploadfile.jsp?title=Picture&ref_id=<%=oidLanding%>&frm_name=frmlandingpictures",  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdEditPic(oid) {
        document.frmlandingpictures.command.value="<%=JSPCommand.EDIT%>";
        window.open("../../upload/editfile.jsp?oid_file="+oid+"&frm_name=frmlandingpictures",  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdDelPic(oid){
        if(confirm("Are you sure you want to delete this picture?")) {
            document.frmlandingpictures.picture_oid.value=oid;
            document.frmlandingpictures.command_picture.value="<%=JSPCommand.DELETE%>";
            document.frmlandingpictures.action="smlandingpictures.jsp";
            document.frmlandingpictures.submit();
        }
    }

    function cmdMain(oid) {
        document.frmlandingpictures.landing_oid.value=oid;
        document.frmlandingpictures.command.value="<%=JSPCommand.EDIT%>";
        document.frmlandingpictures.action="smedit.jsp";
        document.frmlandingpictures.submit();
    }

    function cmdOffLoading(oid) {
        document.frmlandingpictures.landing_oid.value=oid;
        document.frmlandingpictures.command.value="<%=JSPCommand.EDIT%>";
        document.frmlandingpictures.action="smoffloadingedit.jsp";
        document.frmlandingpictures.submit();
    }

    function cmdSizing(oid) {
        document.frmlandingpictures.landing_oid.value=oid;
        document.frmlandingpictures.command.value="<%=JSPCommand.EDIT%>";
        document.frmlandingpictures.action="smsizingedit.jsp";
        document.frmlandingpictures.submit();
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
                        <form name="frmlandingpictures" method="post" action="">
                          <input type="hidden" name="command" value="<%=iCommand%>">
                          <input type="hidden" name="command_picture" value="<%=iCommandPicture%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="landing_oid" value="<%=oidLanding%>">
                          <input type="hidden" name="picture_oid" value="<%=oidPicture%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Data Entry</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Landing</span></td>
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
                                            <td class="tabin">
                                                <div align="center">&nbsp;&nbsp;<a href="javascript:cmdSizing('<%=oidLanding%>')" class="tablink">Sizing</a>&nbsp;&nbsp;</div>
                                            </td>
                                            <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                            <td class="tab">
                                                <div align="center">&nbsp;&nbsp;Pictures&nbsp;&nbsp;</div>
                                            </td>
                                            <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td class="container">
                                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td width="5%">&nbsp;</td>
                                            <td width="95%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td><a href="javascript:cmdAddPic()"><img src="../../images/image_add_large.png" width="22" title="Add new picture" alt="Add new picture" name="add_picture" border="0"></a></td>
                                            <td><%if(msgUpload == DbFile.MSG_UPLOAD_EXIST) {out.println("<span class=\"warning\">&nbsp;&nbsp;" + DbFile.msgUpload[msgUpload] + "&nbsp;&nbsp;</span>");}%></td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <%if(oidLanding != 0) {%>
                                        <tr>
                                            <td colspan="2">
                                                <%
                                                if(listPictures != null && listPictures.size() > 0) {
                                                    for(int i = 0; i < listPictures.size(); i++) {
                                                        File file = (File) listPictures.get(i);
                                                        String url = fileDir + "/" + file.getName();
                                                        out.println("<div style=\"float:left;margin-right:10px;margin-bottom:10px;text-align:center;\"><a href=\"" + url + "\" target=\"blank\"><img style=\"margin-bottom:2px;\" src=\"" + url + "\" height=\"80\" border=\"0\" title=\"" + file.getNotes() + "\"></a>"
                                                                + "<br/><a href=\"javascript:cmdEditPic('" + file.getOID() + "')\"><img src=\"../../images/image_edit.png\" name=\"editpic_" + i + "\" border=\"0\" width=\"16\" title=\"Edit picture\"></a>"
                                                                + "&nbsp;&nbsp;&nbsp;<a href=\"javascript:cmdDelPic('" + file.getOID() + "')\"><img src=\"../../images/image_delete.png\" name=\"delpic_" + i + "\" border=\"0\" width=\"16\" title=\"Delete picture\"></a></div>");
                                                    }
                                                }
                                                %>
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
