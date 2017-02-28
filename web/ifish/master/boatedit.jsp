<%-- 
    Document   : boatedit
    Created on : Aug 25, 2015, 9:06:12 AM
    Author     : gwawan
--%>
<%@page import="com.project.ifish.master.JspFish"%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Boat"%>
<%@ page import = "com.project.ifish.master.DbBoat"%>
<%@ page import = "com.project.ifish.master.JspBoat"%>
<%@ page import = "com.project.ifish.master.CmdBoat"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.master.Tracker"%>
<%@ page import="com.project.ifish.master.DbTracker"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%
/* VARIABLE DECLARATION */
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
int iJSPCommandPicture = JSPRequestValue.requestInt(request, "command_picture");
long boatId = JSPRequestValue.requestLong(request, "boat_oid");
int start = JSPRequestValue.requestInt(request, "start");
long oidPicture = JSPRequestValue.requestLong(request, "picture_oid");
String picType = JSPRequestValue.requestString(request, "pic_type");

String sMsgUpload = (String)session.getAttribute("msg_upload");
String sPicType = (String)session.getAttribute("pic_type");
String sOidFile = (String)session.getAttribute("oid_file");

CmdBoat ctrlBoat = new CmdBoat(request);
JspBoat jspBoat = ctrlBoat.getForm();
int iErrCode = ctrlBoat.action(iJSPCommand, boatId, user.getOID());
String msgString = ctrlBoat.getMessage();
Boat boat = ctrlBoat.getBoat();
if(boatId == 0) {
    boatId = boat.getOID();
}

/** delete picture */
if(iJSPCommandPicture == JSPCommand.DELETE && oidPicture != 0) {
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
                iJSPCommandPicture = JSPCommand.NONE;

                if(picType.equals(IFishConfig.IMAGE_ORIGINAL)) {
                    boat.setPictureOriginal(0);
                    DbBoat.updateExc(boat);
                } else if(picType.equals(IFishConfig.IMAGE_CENSORED)) {
                    boat.setPictureCensored(0);
                    DbBoat.updateExc(boat);
                }
            } catch(Exception e) {
                System.out.println(e.toString());
            }
        }
    }
}

/** upload process */
int msgUpload = 0;
try {
    if(sMsgUpload != null) {
        if (sMsgUpload.length() > 0) {
            msgUpload = Integer.parseInt(sMsgUpload);
            session.removeAttribute("msg_upload");
        }
    }
    
    if (sPicType.equals(IFishConfig.IMAGE_ORIGINAL) && sOidFile.length() > 0) {
        oidPicture = Long.parseLong(sOidFile);
        boat.setPictureOriginal(oidPicture);
        DbBoat.updateExc(boat);
        
        session.removeAttribute("pic_type");
        session.removeAttribute("oid_file");
    }

    if (sPicType.equals(IFishConfig.IMAGE_CENSORED) && sOidFile.length() > 0) {
        oidPicture = Long.parseLong(sOidFile);
        boat.setPictureCensored(oidPicture);
        DbBoat.updateExc(boat);

        session.removeAttribute("pic_type");
        session.removeAttribute("oid_file");
    }
} catch (Exception e) {
}

/** list of partner */
Vector listPartner = DbPartner.list(0, 0, "", DbPartner.colNames[DbPartner.COL_NAME]);
Vector valPartner = new Vector();
valPartner.add("select...");
Vector keyPartner = new Vector();
keyPartner.add("0");
if(listPartner != null && listPartner.size() > 0) {
    for(int i = 0; i < listPartner.size(); i++) {
        Partner p = (Partner) listPartner.get(i);
        valPartner.add(p.getName());
        keyPartner.add(String.valueOf(p.getOID()));
    }
}

/** list of spottrace */
Vector listSpotTrace = DbTracker.list(0, 0, "", DbTracker.colNames[DbTracker.COL_TRACKER_NAME]);
Vector valSpotTrace = new Vector();
valSpotTrace.add("select...");
Vector keySpotTrace = new Vector();
keySpotTrace.add("0");
if(listSpotTrace != null && listSpotTrace.size() > 0) {
    for(int i = 0; i < listSpotTrace.size(); i++) {
        Tracker t = (Tracker) listSpotTrace.get(i);
        valSpotTrace.add(t.getTrackerName());
        keySpotTrace.add(String.valueOf(t.getTrackerId()));
    }
}

/** list of pictures */
Vector listPictures = DbFile.list(0, 0, DbFile.colNames[DbFile.COL_REF_ID]+"="+boatId, DbFile.colNames[DbFile.COL_NAME]);
File pictureOriginal = new File();
File pictureCensored = new File();
if(listPictures != null && listPictures.size() > 0) {
    for(int i = 0; i < listPictures.size(); i++) {
        File f = (File) listPictures.get(i);
        if(f.getOID() == boat.getPictureOriginal()) {
            pictureOriginal = f;
        } else if(f.getOID() == boat.getPictureCensored()) {
            pictureCensored = f;
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
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="JavaScript">
    <%if (!privMasterBoat) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    <% if (privAdd) {%>
    function cmdAdd(){
        document.frmboat.boat_oid.value="0";
        document.frmboat.command.value="<%=JSPCommand.ADD%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }
    <%}%>

    function cmdEdit(oid){
        document.frmboat.boat_oid.value=oid;
        document.frmboat.command.value="<%=JSPCommand.EDIT%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }

    <% if (privAdd || privEdit) {%>
    function cmdSave(){
        document.frmboat.command.value="<%=JSPCommand.SAVE%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }

    <%}%>

    <% if (privDelete) {%>
    function cmdDelete(oid){
        document.frmboat.boat_oid.value=oid;
        document.frmboat.command.value="<%=JSPCommand.ASK%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }
    function cmdConfirmDelete(oid){
        document.frmboat.boat_oid.value=oid;
        document.frmboat.command.value="<%=JSPCommand.DELETE%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }
    <%}%>
    function cmdBack(oid){
        document.frmboat.boat_oid.value=oid;
        document.frmboat.command.value="<%=JSPCommand.LIST%>";
        document.frmboat.action="boat.jsp";
        document.frmboat.submit();
    }

    function cmdAddPic(picType) {
        document.frmboat.command.value="<%=JSPCommand.EDIT%>";
        window.open("../../upload/uploadfile.jsp?title=Picture&ref_id=<%=boatId%>&pic_type="+picType+"&frm_name=frmboat",  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdEditPic(oid) {
        document.frmboat.command.value="<%=JSPCommand.EDIT%>";
        window.open("../../upload/editfile.jsp?oid_file="+oid+"&frm_name=frmboat",  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdDelPic(oid, picType){
        if(confirm("Are you sure you want to delete this picture?")) {
            document.frmboat.command.value="<%=JSPCommand.EDIT%>";
            document.frmboat.command_picture.value="<%=JSPCommand.DELETE%>";
            document.frmboat.picture_oid.value=oid;
            document.frmboat.pic_type.value=picType;
            document.frmboat.action="boatedit.jsp";
            document.frmboat.submit();
        }
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
                  <%@ include file="../../ifish/main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top">
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td><!-- #BeginEditable "content" -->
                          <form name="frmboat" method="post" action="">
                          <input type="hidden" name="command" value="">
                          <input type="hidden" name="command_picture" value="<%=iJSPCommandPicture%>">
                          <input type="hidden" name="picture_oid" value="<%=oidPicture%>">
                          <input type="hidden" name="pic_type" value="<%=picType%>">
                          <input type="hidden" name="boat_oid" value="<%=boatId%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Master</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Boat</span></td>
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
                                    <table width="100%" border="0">
                                        <tr>
                                            <td width="13%">Code</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_CODE]%>" value="<%=boat.getCode()%>" class="formElemen" size="10">
                                                * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_CODE)%>
                                            </td>
                                            <td width="52%" valign="top"><b>Original Picture</b>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Name</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_NAME]%>" value="<%=boat.getName()%>" class="formElemen" size="30">
                                                * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_NAME)%>
                                            </td>
                                            <td width="52%" valign="top" rowspan="9">
                                                <% if(boat.getOID() != 0 && privAdd && privEdit && privDelete) { %>
                                                <% if(pictureOriginal.getOID() == 0) { %>
                                                <% if(privAdd && privEdit && privDelete) { %>
                                                <a href="javascript:cmdAddPic('<%=IFishConfig.IMAGE_ORIGINAL%>')"><img src="../../images/image_add_large.png" width="22" title="Add new picture" alt="Add new picture" name="add_picture" border="0"></a>
                                                <% } %>
                                                <%if(msgUpload == DbFile.MSG_UPLOAD_EXIST) {out.println("<span class=\"warning\">&nbsp;&nbsp;" + DbFile.msgUpload[msgUpload] + "&nbsp;&nbsp;</span>");}%>
                                                <% } else { %>
                                                <a href="<%=fileDir + "/" + pictureOriginal.getName()%>" target="blank"><img src="<%=fileDir + "/" + pictureOriginal.getName()%>" alt="no picture, click here to add a picture" height="150px" border="0"></a>
                                                <% if(privAdd && privEdit && privDelete) { %>
                                                <br /><br /><a href="javascript:cmdEditPic('<%=pictureOriginal.getOID()%>')"><img src="../../images/image_edit.png" name="editpic" border="0" width="16" title="Edit picture"></a>
                                                &nbsp;&nbsp;&nbsp;<a href="javascript:cmdDelPic('<%=pictureOriginal.getOID()%>','<%=IFishConfig.IMAGE_ORIGINAL%>')"><img src="../../images/image_delete.png" name="delpic" border="0" width="16" title="Delete picture"></a>
                                                <% }}} %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Home Port</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_HOME_PORT]%>" value="<%=boat.getHomePort()%>" class="formElemen" size="30">
                                                (as on license) * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_HOME_PORT)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Program Site</td>
                                            <td width="34%">
                                                <select name="<%=JspBoat.fieldNames[JspBoat.JSP_PROGRAM_SITE]%>">
                                                    <option value="" <%=boat.getProgramSite().equals("")||boat.getOID()==0?"selected":""%>>select...</option>
                                                    <option value="<%=IFishConfig.SITE_BALI%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_BALI)?"selected":""%>><%=IFishConfig.SITE_BALI%></option>
                                                    <option value="<%=IFishConfig.SITE_KEMA%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_KEMA)?"selected":""%>><%=IFishConfig.SITE_KEMA%></option>
                                                    <option value="<%=IFishConfig.SITE_KUPANG%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_KUPANG)?"selected":""%>><%=IFishConfig.SITE_KUPANG%></option>
                                                    <option value="<%=IFishConfig.SITE_PROBOLINGGO%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_PROBOLINGGO)?"selected":""%>><%=IFishConfig.SITE_PROBOLINGGO%></option>
                                                    <option value="<%=IFishConfig.SITE_LUWUK%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_LUWUK)?"selected":""%>><%=IFishConfig.SITE_LUWUK%></option>
                                                    <option value="<%=IFishConfig.SITE_SORONG%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_SORONG)?"selected":""%>><%=IFishConfig.SITE_SORONG%></option>
                                                    <option value="<%=IFishConfig.SITE_TANJUNG_LUAR%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_TANJUNG_LUAR)?"selected":""%>><%=IFishConfig.SITE_TANJUNG_LUAR%></option>
                                                    <option value="<%=IFishConfig.SITE_TIMIKA%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_TIMIKA)?"selected":""%>><%=IFishConfig.SITE_TIMIKA%></option>
                                                    <option value="<%=IFishConfig.SITE_OTHERS%>" <%=boat.getProgramSite().equals(IFishConfig.SITE_OTHERS)?"selected":""%>><%=IFishConfig.SITE_OTHERS%></option>
                                                </select> * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_PROGRAM_SITE)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Gear Type</td>
                                            <td width="35%">
                                                <select name="<%=JspBoat.fieldNames[JspBoat.JSP_GEAR_TYPE]%>">
                                                    <option value="" <%=boat.getGearType().equals("")||boat.getOID()==0?"selected":""%>>select...</option>
                                                    <option value="<%=IFishConfig.GEAR_TYPE_DROPLINE%>" <%=boat.getGearType().equals(IFishConfig.GEAR_TYPE_DROPLINE)?"selected":""%>><%=IFishConfig.GEAR_TYPE_DROPLINE%></option>
                                                    <option value="<%=IFishConfig.GEAR_TYPE_LONGLINE%>" <%=boat.getGearType().equals(IFishConfig.GEAR_TYPE_LONGLINE)?"selected":""%>><%=IFishConfig.GEAR_TYPE_LONGLINE%></option>
                                                    <option value="<%=IFishConfig.GEAR_TYPE_OTHERS%>" <%=boat.getGearType().equals(IFishConfig.GEAR_TYPE_OTHERS)?"selected":""%>><%=IFishConfig.GEAR_TYPE_OTHERS%></option>
                                                </select> * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_GEAR_TYPE)%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Boat Length (m)</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_LENGTH]%>" value="<%=boat.getLength()%>" class="formElemen" size="10" style="text-align:right;"></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Boat Width (m)</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_WIDTH]%>" value="<%=boat.getWidth()%>" class="formElemen" size="10" style="text-align:right;"></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Year Built</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_YEAR_BUILT]%>" value="<%=boat.getYearBuilt()%>" class="formElemen" size="10" style="text-align:right;"></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Gross Tonnage</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_GROSS_TONNAGE]%>" value="<%=boat.getGrossTonnage()%>" class="formElemen" size="10" style="text-align:right;"> (as on license)</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Has an Engine?</td>
                                            <td width="35%">
                                                <input type="checkbox" name="<%=JspBoat.fieldNames[JspBoat.JSP_IS_ENGINE]%>" value="1" <%=boat.isEngine()==IFishConfig.STATUS_ACTIVE?"checked":""%>>&nbsp;Yes,
                                                &nbsp;Engine HP&nbsp;<input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_ENGINE_HP]%>" value="<%=boat.getEngineHP()%>" class="formElemen" size="10" style="text-align:right;">
                                            </td>
                                            <td width="52%" valign="top"><b>Censored Picture</b>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                            <td width="52%" valign="top" rowspan="11">
                                                <% if(boat.getOID() != 0) { %>
                                                <% if(pictureCensored.getOID() == 0) { %>
                                                <% if(privAdd && privEdit && privDelete) { %>
                                                <a href="javascript:cmdAddPic('<%=IFishConfig.IMAGE_CENSORED%>')"><img src="../../images/image_add_large.png" width="22" title="Add new picture" alt="Add new picture" name="add_picture" border="0"></a>
                                                <% } %>
                                                <%if(msgUpload == DbFile.MSG_UPLOAD_EXIST) {out.println("<span class=\"warning\">&nbsp;&nbsp;" + DbFile.msgUpload[msgUpload] + "&nbsp;&nbsp;</span>");}%>
                                                <% } else { %>
                                                <a href="<%=fileDir + "/" + pictureCensored.getName()%>" target="blank"><img src="<%=fileDir + "/" + pictureCensored.getName()%>" alt="no picture, click here to add a picture" height="150px" border="0"></a>
                                                <% if(privAdd && privEdit && privDelete) { %>
                                                <br /><br /><a href="javascript:cmdEditPic('<%=pictureCensored.getOID()%>')"><img src="../../images/image_edit.png" name="editpic" border="0" width="16" title="Edit picture"></a>
                                                &nbsp;&nbsp;&nbsp;<a href="javascript:cmdDelPic('<%=pictureCensored.getOID()%>','<%=IFishConfig.IMAGE_CENSORED%>')"><img src="../../images/image_delete.png" name="delpic" border="0" width="16" title="Delete picture"></a>
                                                <% }}} %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Owner</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_OWNER]%>" value="<%=boat.getOwner()%>" class="formElemen" size="30">
                                             * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_OWNER)%></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Owner Origin</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_OWNER_ORIGIN]%>" value="<%=boat.getOwnerOrigin()%>" class="formElemen" size="30"> (Town, District, Province)
                                             * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_OWNER_ORIGIN)%></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Captain</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_CAPTAIN]%>" value="<%=boat.getCaptain()%>" class="formElemen" size="30">
                                             * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_CAPTAIN)%></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Captain Origin</td>
                                            <td width="35%"><input type="text" name="<%=JspBoat.fieldNames[JspBoat.JSP_CAPTAIN_ORIGIN]%>" value="<%=boat.getCaptainOrigin()%>" class="formElemen" size="30"> (Town, District, Province)
                                             * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_CAPTAIN_ORIGIN)%></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">Affiliate</td>
                                            <td width="35%"><%=JSPCombo.draw(JspBoat.fieldNames[JspBoat.JSP_PARTNER_ID], null, String.valueOf(boat.getPartnerId()), keyPartner, valPartner, "") %></td>
                                        </tr>
                                        <tr>
                                            <td width="13%">SpotTrace</td>
                                            <td width="35%"><%=JSPCombo.draw(JspBoat.fieldNames[JspBoat.JSP_TRACKER_ID], null, String.valueOf(boat.getTrackerId()), keySpotTrace, valSpotTrace, "") %>&nbsp;
                                                 * &nbsp;<%=jspBoat.getErrorMsg(JspBoat.JSP_TRACKER_ID)%>
                                            <input type="checkbox" name="<%=JspBoat.fieldNames[JspBoat.JSP_TRACKER_STATUS]%>" value="1" <%=boat.getTrackerStatus()==IFishConfig.STATUS_ACTIVE?"checked":""%>>&nbsp;Active</td>
                                        </tr>
                                        <tr>
                                            <td width="13%">&nbsp;</td>
                                            <td width="35%">
                                                <div id="start_date">Start Date <input name="<%=JspBoat.fieldNames[JspBoat.JSP_TRACKER_START_DATE]%>" value="<%=JSPFormater.formatDate((boat.getTrackerStartDate() == null) ? new Date() : boat.getTrackerStartDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmboat.<%=JspBoat.fieldNames[JspBoat.JSP_TRACKER_START_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Tracker Start Date"></a></div>
                                                <div id="end_date">End Date <input name="<%=JspBoat.fieldNames[JspBoat.JSP_TRACKER_END_DATE]%>" value="<%=JSPFormater.formatDate((boat.getTrackerEndDate() == null) ? new Date() : boat.getTrackerEndDate(), "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly> <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmboat.<%=JspBoat.fieldNames[JspBoat.JSP_TRACKER_END_DATE]%>);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Tracker End Date"></a></div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="13%" valign="top" height="14" nowrap>&nbsp;</td>
                                            <td width="35%" height="14">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="command">
                                                <%
                                                  jspLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                  jspLine.initDefault();
                                                  jspLine.setTableWidth("80%");
                                                  String scomDel = "javascript:cmdDelete('" + boatId + "')";
                                                  String sconDelCom = "javascript:cmdConfirmDelete('" + boatId + "')";
                                                  String scancel = "javascript:cmdEdit('" + boatId + "')";
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