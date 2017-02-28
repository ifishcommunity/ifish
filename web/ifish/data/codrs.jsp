<%-- 
    Document   : codrs
    Created on : Nov 18, 2015, 11:53:59 AM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.InputStream"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.FileUploadException"%>
<%@ page import="org.apache.commons.fileupload.FileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page import="com.project.main.log.DbLogsAction"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.master.Tracker"%>
<%@ page import="com.project.ifish.master.DbTracker"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.data.CODRS"%>
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_CODRS, AppMenu.PRIV_ADD);
%>
<!-- Jsp Block -->
<%!
public String drawList(List<CODRS> list) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("70%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("1", "5%");
    jsplist.addHeader("Picture Date", "15%");
    jsplist.addHeader("Picture Name", "15%");
    jsplist.addHeader("Species", "25%");
    jsplist.addHeader("TL (cm)", "10%");
    jsplist.addHeader("Notes", "30%");

    jsplist.setLinkRow(-1);
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    String result = "";
    Date landingDate = new Date();

    Vector listBoat = DbBoat.listAll();
    Hashtable hBoat = new Hashtable();
    if(listBoat != null && listBoat.size() > 0) {
        for(int i=0; i<listBoat.size(); i++) {
            Boat boat = (Boat) listBoat.get(i);
            hBoat.put(boat.getOID(), boat);
        }
    }

    Vector listFish = DbFish.listAll();
    Hashtable hFish = new Hashtable();
    if(listFish != null && listFish.size() > 0) {
        for(int i = 0; i < listFish.size(); i++) {
            Fish fish = (Fish) listFish.get(i);
            hFish.put(fish.getOID(), fish);
        }
    }

    for(int i = 0; i < list.size(); i++) {
        CODRS codrs = (CODRS) list.get(i);
        
        if(i == 0) {
            try {
                Partner partner = DbPartner.fetchExc(codrs.getPartnerId());
                landingDate = codrs.getLandingDate();
                result = "<div>"
                    + "Partner Nmae : <b>" + partner.getName() + "</b><br />"
                    + "Landing Date : <b>" + JSPFormater.formatDate(codrs.getLandingDate()) + "</b><br />"
                    + "Fishing Gear : <b>" + codrs.getFishingGear() + "</b><br />"
                    + "Fishing Ground : <b>" + codrs.getWpp1() + "&nbsp;" + codrs.getWpp2() + "&nbsp;" + codrs.getWpp3() + "&nbsp;" + codrs.getOtherFishingGround() + "</b><br />"
                    + "Fishery Type : <b>" + codrs.getFisheryType() + "</b><br />"
                    + "&nbsp;</div>";
            } catch(Exception e) {
                System.out.println(e.toString());
            }
        }

        if(i > 0 && (codrs.getDataQuality() == -1 || codrs.getDataQuality() == 0)) {
            Boat boat = (Boat) hBoat.get(codrs.getBoatId());
            if(boat == null) boat = new Boat();

            Fish fish = (Fish) hFish.get(codrs.getFishId());
            if(fish == null) fish = new Fish();

            String cmColor = "black";
            if(codrs.getCm() > fish.getLmax()) {
                cmColor = "red";
            }

            Vector rowx = new Vector();
            rowx.add("<div align=\"center\">"+(i+4)+"</div>");
            rowx.add(JSPFormater.formatDate(codrs.getPictureDate()));
            rowx.add(codrs.getPictureName());
            if(fish.isFamilyID() == 1) {
                rowx.add(fish.getFishFamily()+" other");
            } else {
                rowx.add(fish.getFishGenus()+" "+fish.getFishSpecies());
            }
            rowx.add(JSPFormater.formatNumber(codrs.getCm(), "#"));
            if(fish.getOID() == 0) {
                rowx.add("<div align=\"left\" style=\"color: red;\">Specimen name incorrect</div>");
            } else {
                if(codrs.getCm() == 0) {
                    rowx.add("<div align=\"left\" style=\"color: red;\">Total length 0</div>");
                } else if(codrs.getCm() > fish.getLmax()) {
                    rowx.add("<div align=\"left\" style=\"color: blue;\">Specimen total length more than L-Max</div>");
                } else if(codrs.getCm() > fish.getLargestSpecimenCm()) {
                    rowx.add("New largest specimen");
                } else if(landingDate.equals(codrs.getPictureDate())) {
                    rowx.add("<div align=\"left\" style=\"color: blue;\">Picture Date same as in Landing Date</div>");
                } else {
                    rowx.add("");
                }
            }
            
            lstData.add(rowx);
        }
    }
    
    if(list.size() > 0) {
        result += jsplist.draw(index);
    }

    return result;
}
%>
<%
/* GET REQUEST FROM HIDDEN TEXT */
int iJSPCommand = JSPRequestValue.requestCommand(request);
long menuId = 0;
String file2 = "";
String fisheryType = "";
long partnerId = 0;
String submit = "";
boolean isMultipart = ServletFileUpload.isMultipartContent(request);

List<CODRS> listCODRS = new ArrayList<CODRS>();

if (isMultipart) {
    FileItemFactory factory = new DiskFileItemFactory();
    ServletFileUpload upload = new ServletFileUpload(factory);
    List items = null;
    try {
        items = upload.parseRequest(request);
    } catch (FileUploadException e) {
        e.printStackTrace();
    }

    Iterator itr = items.iterator();
    while (itr.hasNext()) {
        FileItem item = (FileItem) itr.next();

            if (item.getFieldName().equals("menu_idx")) {
                menuId = Long.parseLong(item.getString());
            }

            if (item.getFieldName().equals("file2")) {
                file2 = FilenameUtils.getName(item.getName());
            }

            if (item.getFieldName().equals("fishery_type")) {
                fisheryType = item.getString();
            }

            if (item.getFieldName().equals("partner_id")) {
                partnerId = Long.parseLong(item.getString());
            }

            if (item.getFieldName().equals("submit")) {
                submit = item.getString();
            }
    }

    itr = items.iterator();
    while (itr.hasNext()) {
        FileItem item = (FileItem) itr.next();
        if (!item.isFormField()) {
             InputStream is = item.getInputStream();
             if(item.getFieldName().equals("file2") && item.getSize() > 0) {
                 listCODRS = DbDeepSlope.CODRSDeepSlopeReviewV2(is, user.getOID(), partnerId, file2, fisheryType);
                 session.putValue("LIST_CODRS_NEW", listCODRS);;
             }
        }
    }
}

/* get list partner */
List<Partner> listPartner = DbPartner.listFishermen();
Vector valPartner = new Vector();
Vector keyPartner = new Vector();
valPartner.add("select...");
keyPartner.add("0");
if(listPartner != null && listPartner.size() > 0) {
    for(int i = 0; i < listPartner.size(); i++) {
        Partner partner = (Partner) listPartner.get(i);
        valPartner.add(String.valueOf(partner.getName()));
        keyPartner.add(String.valueOf(partner.getOID()));
    }
}

// check if any data error
boolean hasDataError = false;
for(int i = 0; i < listCODRS.size(); i++) {
    CODRS codrs = (CODRS) listCODRS.get(i);
    System.out.println(codrs.getPictureName()+" - fishid: " + codrs.getFishId() + " - status: "+codrs.getDataQuality());
    if(codrs.getDataQuality() == 0) {
        hasDataError = true;
    }
}

// Store data into database
String uploadStatus = "";
if(submit.equals("Upload Data")) {
    listCODRS = (List<CODRS>)session.getAttribute("LIST_CODRS_NEW");
    if(listCODRS != null && listCODRS.size() > 0) {
        uploadStatus = DbDeepSlope.CODRSDeepSlopeUploadV2(listCODRS);
        session.removeAttribute("LIST_CODRS_NEW");
    }
    
    listCODRS = new ArrayList<CODRS>(); // reset the list
}
%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript"  language="javascript">
    <%if (!privDataCODRS) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>
    function showLoading() {
        document.all.loading.style.display="block";
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
                        <form name="frmuploadlandingxls" method="post" action="" enctype="multipart/form-data">
                          <input type="hidden" name="command" value="<%=iJSPCommand%>">
                          <input type="hidden" name="menu_idx" value="<%=menuId%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Data Entry</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">CODRS</span></td>
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
                                        <tr align="left" valign="top">
                                            <td width="100">&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td width="100">&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td width="100">&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="100">Select data sheet to be uploaded *&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td width="100">Partner Name *&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td width="100">Fishery Type *&nbsp;</td>
                                            <td width="10">&nbsp;</td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td><input type="file" name="file2"></td>
                                            <td>&nbsp;</td>
                                            <td><%=JSPCombo.draw("partner_id", null, String.valueOf(partnerId), keyPartner, valPartner, "") %></td>
                                            <td>&nbsp;</td>
                                            <td>
                                                <select name="fishery_type">
                                                    <option value="" <%=fisheryType.equals("")?"selected":""%>>select...</option>
                                                    <option value="<%=IFishConfig.FISHERY_TYPE_SNAPPER%>" <%=fisheryType.equals(IFishConfig.FISHERY_TYPE_SNAPPER)?"selected":""%>><%=IFishConfig.FISHERY_TYPE_SNAPPER%></option>
                                                    <option value="<%=IFishConfig.FISHERY_TYPE_OTHERS%>" <%=fisheryType.equals(IFishConfig.FISHERY_TYPE_OTHERS)?"selected":""%>><%=IFishConfig.FISHERY_TYPE_OTHERS%></option>
                                                </select>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td>
                                                <input type="submit" name="submit" value="Review Data" onClick="javascript:showLoading()">&nbsp;
                                                <%if(isMultipart && !hasDataError && partnerId != 0 && listCODRS.size() > 0 && !fisheryType.equals("")) {%>
                                                <input type="submit" name="submit" value="Upload Data">&nbsp;
                                                <%}%>
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="7">&nbsp;</td>
                                        </tr>
                                        <%if(isMultipart) {%>
                                        <tr align="left" valign="top">
                                            <td colspan="3" class="info" height="20" valign="middle">&nbsp;
                                                <%
                                                if(submit.equals("Upload Data")) {
                                                    out.println(uploadStatus);
                                                }
                                                if(isMultipart && submit.equals("Review Data") && partnerId == 0) {out.println("Partner Name required!");}
                                                if(isMultipart && submit.equals("Review Data") && fisheryType.equals("")) {out.println("Fishery Type required!");}
                                                if(isMultipart && submit.equals("Review Data") && hasDataError) {out.println("List of data must be repaired!");}
                                                if(isMultipart && submit.equals("Review Data") && !hasDataError && partnerId != 0 && !fisheryType.equals("") && listCODRS.size() == 0) {out.println("No data to be store into database.");}
                                                if(isMultipart && submit.equals("Review Data") && !hasDataError && partnerId != 0 && !fisheryType.equals("") && listCODRS.size() > 0) {out.println(listCODRS.size()+" data ready to be store into database. Click Upload Data!");}
                                                %>
                                            </td>
                                            <td colspan="2">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="7">&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <%if(isMultipart) {%>
                                        <tr>
                                            <td colspan="7"><%=listCODRS.size()>0?drawList(listCODRS):""%>&nbsp;</td>
                                        </tr>
                                        <%}%>
                                        <tr align="left" valign="top">
                                            <td colspan="7">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="7"><b>Attention :</b>&nbsp;Only file with extension <b>xls</b> can be proceed.</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="7">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="7">Please click <a href="../../pub/CODRS-BoatName-yyyymmdd.xls">here</a> to download the blank data sheet.</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                         </table>
                        </form>
                        <script type="text/javascript"  language="javascript">
                            document.all.loading.style.display="none";
                        </script>
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
