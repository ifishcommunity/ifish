<%--
    Document   : fishedit
    Created on : Jan 28, 2015, 2:42:26 PM
    Author     : gwawan
--%>
<%@page import="com.project.ifish.master.DbBoat"%>
<%@page import="com.project.ifish.master.Boat"%>
<%@page import="com.project.ifish.data.DeepSlope"%>
<%@page import="com.project.ifish.data.DbDeepSlope"%>
<%@page import="com.project.ifish.data.Sizing"%>
<%@page import="com.project.ifish.data.DbSizing"%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Fish"%>
<%@ page import = "com.project.ifish.master.DbFish"%>
<%@ page import = "com.project.ifish.master.JspFish"%>
<%@ page import = "com.project.ifish.master.CmdFish"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%
/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
int iJSPCommandPicture = JSPRequestValue.requestInt(request, "command_picture");
long oidFish = JSPRequestValue.requestLong(request, "fish_oid");
int start = JSPRequestValue.requestInt(request, "start");
long oidPicture = JSPRequestValue.requestLong(request, "picture_oid");
String picType = JSPRequestValue.requestString(request, "pic_type");

String sMsgUpload = (String)session.getAttribute("msg_upload");
String sPicType = (String)session.getAttribute("pic_type");
String sOidFile = (String)session.getAttribute("oid_file");

/* VARIABLE DECLARATION */
JSPLine jspLine = new JSPLine();
CmdFish cmdFish = new CmdFish(request);
int excCode = JSPMessage.NONE;
String msgString = "";

/** switch statement */
int iErrCode = cmdFish.action(iJSPCommand, oidFish, user.getOID());
JspFish jspFish = cmdFish.getForm();
Fish fish = cmdFish.getFish();
msgString = cmdFish.getMessage();
if(oidFish == 0) {
    oidFish = fish.getOID();
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

                if(picType.equals(IFishConfig.IMAGE_LARGEST)) {
                    fish.setLargestSpecimenPicture(0);
                    DbFish.updateExc(fish);
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
        if(sMsgUpload.length() > 0) {
            msgUpload = Integer.parseInt(sMsgUpload);
        }
    }

    if (sPicType.equals(IFishConfig.IMAGE_LARGEST) && sOidFile.length() > 0) {
        oidPicture = Long.parseLong(sOidFile);
        fish.setLargestSpecimenPicture(oidPicture);
        DbFish.updateExc(fish);

        session.removeAttribute("pic_type");
        session.removeAttribute("oid_file");
    }
} catch(Exception e) {
    System.out.println(e.toString());
}

/** list of pictures */
Vector listPictures = DbFile.list(0, 0, DbFile.colNames[DbFile.COL_REF_ID]+"="+fish.getOID()+" and "+DbFile.colNames[DbFile.COL_FILE_ID]+"!="+fish.getLargestSpecimenPicture(), DbFile.colNames[DbFile.COL_NAME]);
if(listPictures != null && listPictures.size() > 0) {
    for(int i = 0; i < listPictures.size(); i++) {
        File filex = (File)listPictures.get(i);
        if (JSPRequestValue.requestLong(request, "rb_picture") == filex.getOID() && iJSPCommand == JSPCommand.SAVE && iErrCode == 0) {
            fish.setDefaultPictureId(filex.getOID());
            long oid = DbFish.updateExc(fish);
        }
    }
}

/** get default picture url */
File fileDefaultPicture = new File();
if(fish.getDefaultPictureId() != 0) {
    try {
        fileDefaultPicture = DbFile.fetchExc(fish.getDefaultPictureId());
    } catch(Exception e){
        System.out.println(e.toString());
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
    <%if (!privMasterFish) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function cmdEdit(oid){
        document.jspfishedit.fish_oid.value=oid;
        document.jspfishedit.command.value="<%=JSPCommand.EDIT%>";
        document.jspfishedit.action="fishedit.jsp";
        document.jspfishedit.submit();
    }

    <%if (privAdd) {%>
    function cmdAdd(){
        document.jspfishedit.fish_oid.value=0;
        document.jspfishedit.command.value="<%=JSPCommand.ADD%>";
        document.jspfishedit.action="fishedit.jsp";
        document.jspfishedit.submit();
    }
    <%}%>

    <%if (privAdd || privEdit) {%>
    function cmdSave(){
        document.jspfishedit.command.value="<%=JSPCommand.SAVE%>";
        document.jspfishedit.action="fishedit.jsp";
        document.jspfishedit.submit();
    }
    <%}%>

    <% if (privDelete) {%>
    function cmdDelete(oid){
        document.jspfishedit.fish_oid.value=oid;
        document.jspfishedit.command.value="<%=JSPCommand.ASK%>";
        document.jspfishedit.action="fishedit.jsp";
        document.jspfishedit.submit();
    }

    function cmdConfirmDelete(oid){
        document.jspfishedit.fish_oid.value=oid;
        document.jspfishedit.command.value="<%=JSPCommand.DELETE%>";
        document.jspfishedit.action="fishedit.jsp";
        document.jspfishedit.submit();
    }
    <%}%>

    function cmdBack(oid){
        document.jspfishedit.fish_oid.value=oid;
        document.jspfishedit.command.value="<%=JSPCommand.LIST%>";
        document.jspfishedit.action="fish.jsp";
        document.jspfishedit.submit();
    }

    function cmdAddPic(picType) {
        document.jspfishedit.command.value="<%=JSPCommand.EDIT%>";
        window.open("../../upload/uploadfile.jsp?title=Picture&ref_id=<%=fish.getOID()%>&frm_name=jspfishedit&pic_type="+picType,  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdEditPic(oid) {
        document.jspfishedit.command.value="<%=JSPCommand.EDIT%>";
        window.open("../../upload/editfile.jsp?oid_file="+oid+"&frm_name=jspfishedit",  null, "height=150,width=400, status=yes,toolbar=no,menubar=no,location=no, scrollbars=yes");
    }

    function cmdDelPic(oid, picType){
        if(confirm("Are you sure you want to delete this picture?")) {
            document.jspfishedit.command.value="<%=JSPCommand.EDIT%>";
            document.jspfishedit.command_picture.value="<%=JSPCommand.DELETE%>";
            document.jspfishedit.picture_oid.value=oid;
            document.jspfishedit.pic_type.value=picType;
            document.jspfishedit.action="fishedit.jsp";
            document.jspfishedit.submit();
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
                          <form name="jspfishedit" method="post" action="">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="command_picture" value="<%=iJSPCommandPicture%>">
                          <input type="hidden" name="fish_oid" value="<%=oidFish%>">
                          <input type="hidden" name="picture_oid" value="<%=oidPicture%>">
                          <input type="hidden" name="pic_type" value="<%=picType%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_CODE]%>" value="<%=fish.getFishCode()%>">
                          <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Master</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Fish Library</span></td>
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
                                    <table width="100%" cellpadding="1" cellspacing="1" border="0">
                                        <tr>
                                            <td width="13%">Is a Family ID</td>
                                            <td width="22%"><input type="checkbox" name="<%=JspFish.fieldNames[JspFish.JSP_IS_FAMILY_ID]%>" value="1" <%=fish.isFamilyID()==1?"checked":""%>> Yes</td>
                                            <td width="13%">Code</td>
                                            <td width="5%"><input type="text" size="8" disabled value="<%=fish.getFishCode()%>"></td>
                                            <td width="12%">&nbsp;</td>
                                            <td width="35%">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>Fish ID</td>
                                            <td><input type="text" size="8" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_ID] %>" value="<%=fish.getFishID()%>" class="formElemen"></td>
                                            <td>Lmat</td>
                                            <td><input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_LMAT] %>" value="<%=fish.getLmat()%>" class="formElemen" style="text-align: right;" size="2"> cm</td>
                                            <td>Lmat (male)&nbsp;&nbsp;<input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_LMATM] %>" value="<%=fish.getLmatM()%>" class="formElemen" style="text-align: right;" size="2"> cm</td>
                                            <td rowspan="10" align="center"><%=fileDefaultPicture.getOID() != 0 ? "<img src=\""+(fileDir + "/" + fileDefaultPicture.getName())+"\" alt=\""+fileDefaultPicture.getName()+"\" title=\""+fileDefaultPicture.getNotes()+"\" height=\"180\">":""%>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>Pyhlum</td>
                                            <td>
                                                <input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_PHYLUM] %>" value="<%=fish.getFishPhylum()%>" class="formElemen">
                                                *&nbsp;<%= jspFish.getErrorMsg(jspFish.JSP_FISH_PHYLUM) %></td>
                                            <td>Lopt</td>
                                            <td colspan="2"><input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_LOPT] %>" value="<%=fish.getLopt()%>" class="formElemen" style="text-align: right;" size="2"> cm</td>
                                        </tr>
                                        <tr>
                                            <td>Class</td>
                                            <td>
                                                <input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_CLASS] %>" value="<%=fish.getFishClass()%>" class="formElemen">
                                                *&nbsp;<%= jspFish.getErrorMsg(jspFish.JSP_FISH_CLASS) %></td>
                                            <td>Linf</td>
                                            <td colspan="2"><input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_LINF] %>" value="<%=fish.getLinf()%>" class="formElemen" style="text-align: right;" size="2"> cm</td>
                                        </tr>
                                        <tr>
                                            <td>Order</td>
                                            <td>
                                                <input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_ORDER] %>" value="<%=fish.getFishOrder()%>" class="formElemen">
                                                *&nbsp;<%= jspFish.getErrorMsg(jspFish.JSP_FISH_ORDER) %></td>
                                            <td>Lmax</td>
                                            <td colspan="2"><input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_LMAX] %>" value="<%=fish.getLmax()%>" class="formElemen" style="text-align: right;" size="2"> cm</td>
                                        </tr>
                                        <tr>
                                            <td>Family</td>
                                            <td>
                                                <input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_FAMILY] %>" value="<%=fish.getFishFamily()%>" class="formElemen">
                                                *&nbsp;<%= jspFish.getErrorMsg(jspFish.JSP_FISH_FAMILY) %></td>
                                            <td>Reported Trade Limit</td>
                                            <td colspan="2"><input type="text" size="8" style="text-align: right;" name="<%=JspFish.fieldNames[JspFish.JSP_REPORTED_TRADE_LIMIT_WEIGHT] %>" value="<%=fish.getReportedTradeLimitWeight()%>" class="formElemen"> gram</td>
                                        </tr>
                                        <tr>
                                            <td>Genus</td>
                                            <td>
                                                <input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_GENUS] %>" value="<%=fish.getFishGenus()%>" class="formElemen">
                                                *&nbsp;<%= jspFish.getErrorMsg(jspFish.JSP_FISH_GENUS) %></td>
                                            <td>Var A</td>
                                            <td colspan="2"><input type="text" size="8" style="text-align: right;" name="<%=JspFish.fieldNames[JspFish.JSP_VAR_A] %>" value="<%=fish.getVarA()%>" class="formElemen"></td>
                                        </tr>
                                        <tr>
                                            <td>Species</td>
                                            <td>
                                                <input type="text" name="<%=JspFish.fieldNames[JspFish.JSP_FISH_SPECIES] %>" value="<%=fish.getFishSpecies()%>" class="formElemen">
                                                *&nbsp;<%= jspFish.getErrorMsg(jspFish.JSP_FISH_SPECIES) %></td>
                                            <td>Var B</td>
                                            <td colspan="2"><input type="text" size="8" style="text-align: right;" name="<%=JspFish.fieldNames[JspFish.JSP_VAR_B] %>" value="<%=fish.getVarB()%>" class="formElemen"></td>
                                        </tr>
                                        <tr>
                                            <td>English Name</td>
                                            <td>
                                                <input type="text" size="35" name="<%=JspFish.fieldNames[JspFish.JSP_ENGLISH_NAME] %>" value="<%=fish.getEnglishName()%>" class="formElemen">
                                            </td>
                                            <td>Length Type for A and B</td>
                                            <td colspan="2">
                                                <select name="<%=JspFish.fieldNames[JspFish.JSP_LENGTH_BASIS]%>">
                                                    <option value="<%=IFishConfig.LENGTH_BASIS_TL%>" <%=fish.getLengthBasis().equals(IFishConfig.LENGTH_BASIS_TL)?"selected":""%>><%=IFishConfig.LENGTH_BASIS_TL%></option>
                                                    <option value="<%=IFishConfig.LENGTH_BASIS_FL%>" <%=fish.getLengthBasis().equals(IFishConfig.LENGTH_BASIS_FL)?"selected":""%>><%=IFishConfig.LENGTH_BASIS_FL%></option>
                                                    <option value="<%=IFishConfig.LENGTH_BASIS_SL%>" <%=fish.getLengthBasis().equals(IFishConfig.LENGTH_BASIS_SL)?"selected":""%>><%=IFishConfig.LENGTH_BASIS_SL%></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Hawaiian Name</td>
                                            <td>
                                                <input type="text" size="35" name="<%=JspFish.fieldNames[JspFish.JSP_HAWAIIAN_NAME] %>" value="<%=fish.getHawaiianName()%>" class="formElemen">
                                            </td>
                                            <td>Converted Trade Limit</td>
                                            <td colspan="2"><input type="text" size="8" style="text-align: right;" name="<%=JspFish.fieldNames[JspFish.JSP_CONVERTED_TRADE_LIMIT_L] %>" value="<%=fish.getConvertedTradeLimitL()%>" class="formElemen"> cm</td>
                                        </tr>
                                        <tr>
                                            <td>Market Fishes of Indonesia</td>
                                            <td>
                                                <input type="text" size="35" name="<%=JspFish.fieldNames[JspFish.JSP_MARKET_FISHES_OF_INDONESIA] %>" value="<%=fish.getMarketFishesOfIndonesia()%>" class="formElemen">
                                            </td>
                                            <td>Plotted Trade Limit</td>
                                            <td colspan="2"><input type="text" size="8" style="text-align: right;" name="<%=JspFish.fieldNames[JspFish.JSP_PLOTTED_TRADE_LIMIT_TL] %>" value="<%=fish.getPlottedTradeLimitTL()%>" class="formElemen"> cm (TL)</td>
                                        </tr>
                                        <tr>
                                            <td>Other Indonesian Names</td>
                                            <td>
                                                <input type="text" size="35" name="<%=JspFish.fieldNames[JspFish.JSP_OTHER_INDONESIAN_NAMES] %>" value="<%=fish.getOtherIndonesianNames()%>" class="formElemen">
                                            </td>
                                            <td>Conversion Factor (TL to FL)</td>
                                            <td colspan="2"><input type="text" size="8" style="text-align: right;" name="<%=JspFish.fieldNames[JspFish.JSP_CONVERSION_FACTOR_TL2FL] %>" value="<%=JSPFormater.formatNumber(fish.getConversionFactorTL2FL(), "#.###")%>" class="formElemen"></td>
                                            <td align="center">Default picture</td>
                                        </tr>
                                        <%if(fish.getLargestSpecimenId() != 0) {%>
                                        <tr>
                                            <td>Largest Specimen <%if(fish.getLargestSpecimenPicture()==0) {%><a href="javascript:cmdAddPic('<%=IFishConfig.IMAGE_LARGEST%>')"><img src="../../images/image_add.png" width="16" title="Add new picture" alt="Add new picture" name="add_picture" border="0"></a>
                                                <%if(msgUpload == DbFile.MSG_UPLOAD_EXIST) {out.println("<div class=\"warning\">" + DbFile.msgUpload[msgUpload] + "</div>");}}%></td>
                                            <td colspan="5">&nbsp;
                                                <%
                                                if(fish.getLargestSpecimenPicture() != 0) {
                                                    File file = DbFile.fetchExc(fish.getLargestSpecimenPicture());
                                                    if(file.getOID() != 0) {
                                                        String url = fileDir + "/" + file.getName();
                                                        out.println("<div style=\"float:left;margin-right:10px;margin-bottom:10px;text-align:center;\"><a href=\"" + url + "\" target=\"blank\"><img style=\"margin-bottom:2px;\" src=\"" + url + "\" height=\"80\" border=\"0\" title=\"" + file.getNotes() + "\"></a>"
                                                                + "<br/><a href=\"javascript:cmdEditPic('" + file.getOID() + "')\"><img src=\"../../images/image_edit.png\" name=\"editpic_ls\" border=\"0\" width=\"16\" title=\"Edit picture\"></a>"
                                                                + "&nbsp;&nbsp;&nbsp;<a href=\"javascript:cmdDelPic('" + file.getOID() + "', '" + IFishConfig.IMAGE_LARGEST + "')\"><img src=\"../../images/image_delete.png\" name=\"delpic_ls\" border=\"0\" width=\"16\" title=\"Delete picture\"></a></div>");
                                                    }
                                                }
                                                if(fish.getLargestSpecimenId() != 0) {
                                                    Sizing sizing = DbSizing.fetchExc(fish.getLargestSpecimenId());
                                                    if(sizing.getOID() != 0) {
                                                        DeepSlope deepslope = DbDeepSlope.fetchExc(sizing.getLandingId());
                                                        out.println("<div style=\"float:left;margin-right:10px;margin-bottom:10px;text-align:left;\">Total Length in Photo: "+JSPFormater.formatNumber(sizing.getCm(), "#")+" cm"
                                                                + "<br />Data Source: " + IFishConfig.strApproachType[deepslope.getApproach()]
                                                                + "<br />General Catch Area: <input type=\"text\" size=\"20\" name=\""+JspFish.fieldNames[JspFish.JSP_LARGEST_SPECIMEN_CATCH_AREA]+"\" value=\""+fish.getLargestSpecimenCatchArea()+"\" class=\"formElemen\"></div>");
                                                    }
                                                }
                                                %>
                                            </td>
                                        </tr>
                                        <%} else {%>
                                        <tr>
                                            <td valign="top">Largest Specimen</td>
                                            <td colspan="5"><i>data not available</i></td>
                                        </tr>
                                        <%}%>


                                        <%if(fish.getOID() != 0) {%>
                                        <tr>
                                            <td>Pictures of Fish <a href="javascript:cmdAddPic('')"><img src="../../images/image_add.png" width="16" title="Add new picture" alt="Add new picture" name="add_picture" border="0"></a>
                                                <%if(msgUpload == DbFile.MSG_UPLOAD_EXIST) {out.println("<div class=\"warning\">" + DbFile.msgUpload[msgUpload] + "</div>");}%></td>
                                            <td colspan="5">&nbsp;
                                                <%
                                                if(listPictures != null && listPictures.size() > 0) {
                                                    for(int i = 0; i < listPictures.size(); i++) {
                                                        String strChecked = "";
                                                        File file = (File) listPictures.get(i);
                                                        if(file.getOID() == fish.getDefaultPictureId()) {
                                                            strChecked = " checked";
                                                        }
                                                        String url = fileDir + "/" + file.getName();
                                                        out.println("<div style=\"float:left;margin-right:10px;margin-bottom:10px;text-align:center;\"><a href=\"" + url + "\" target=\"blank\"><img style=\"margin-bottom:2px;\" src=\"" + url + "\" height=\"80\" border=\"0\" title=\"" + file.getNotes() + "\"></a>"
                                                                + "<br/><input type=\"radio\" name=\"rb_picture\" value=\"" + file.getOID() + "\""+strChecked+">"
                                                                + "&nbsp;&nbsp;&nbsp;<a href=\"javascript:cmdEditPic('" + file.getOID() + "')\"><img src=\"../../images/image_edit.png\" name=\"editpic_" + i + "\" border=\"0\" width=\"16\" title=\"Edit picture\"></a>"
                                                                + "&nbsp;&nbsp;&nbsp;<a href=\"javascript:cmdDelPic('" + file.getOID() + "', '')\"><img src=\"../../images/image_delete.png\" name=\"delpic_" + i + "\" border=\"0\" width=\"16\" title=\"Delete picture\"></a></div>");
                                                    }
                                                }
                                                %>
                                            </td>
                                        </tr>
                                        <%} else {%>
                                        <tr>
                                            <td valign="top">Pictures of Fish</td>
                                            <td colspan="5"><i>click save to add some pictures</i></td>
                                        </tr>
                                        <%}%>
                                        <tr>
                                            <td colspan="6" class="command">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <%
                                                jspLine.setLocationImg(rootSystem + "/images/ctr_line");
                                                jspLine.initDefault();
                                                jspLine.setTableWidth("80%");
                                                String scomDel = "javascript:cmdDelete('" + oidFish + "')";
                                                String sconDelCom = "javascript:cmdConfirmDelete('" + oidFish + "')";
                                                String scancel = "javascript:cmdEdit('" + oidFish + "')";
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