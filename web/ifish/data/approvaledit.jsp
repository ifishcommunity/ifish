<%-- 
    Document   : approvaledit
    Created on : Dec 22, 2016, 4:10:32 PM
    Author     : gwawan
--%>

<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="com.project.ifish.data.DbFindMeSpot"%>
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
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ page import="com.project.ifish.master.Boat"%>
<%@ page import="com.project.ifish.master.DbBoat"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.data.DeepSlope"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.data.Sizing"%>
<%@ page import="com.project.ifish.data.DbSizing"%>
<%@ page import="com.project.ifish.session.SessDeepSlope"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawListSummary(List objectClass, Hashtable hFish) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("90%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("ID#", "10%");
    jsplist.addHeader("Family", "25%");
    jsplist.addHeader("Species Name", "45%");
    jsplist.addHeader("Sample Size", "20%");

    jsplist.setLinkRow(-1);
    Vector lstData = jsplist.getData();
    jsplist.reset();
    
    for (int i = 0; i < objectClass.size(); i++) {
        List listx = (List) objectClass.get(i);
        long fishId = (Long)listx.get(0);
        int n = (Integer)listx.get(1);

        Fish fish = (Fish) hFish.get(fishId);
        if(fish == null) fish = new Fish();

        Vector rowx = new Vector();
        rowx.add("<div align=\"center\">" + (fish.getFishID()==0?"":fish.getFishID()) + "</div>");
        rowx.add(fish.getFishFamily());
        rowx.add(fish.getFishGenus() + " " + fish.getFishSpecies());
        rowx.add("<div align=\"center\">" + JSPFormater.formatNumber(n, "#") + "</div>");

        lstData.add(rowx);
    }
    return jsplist.draw(-1);
}

public String drawListDetail(Vector objectClass) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("90%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("ID#", "10%");
    jsplist.addHeader("Family", "25%");
    jsplist.addHeader("Species Name", "45%");
    jsplist.addHeader("CM", "20%");

    jsplist.setLinkRow(-1);
    Vector lstData = jsplist.getData();
    jsplist.reset();

    /* list of fish */
    Vector vFish = DbFish.listAll();
    Hashtable hFish = new Hashtable();
    if(vFish != null && vFish.size() > 0) {
        for(int i=0; i<vFish.size(); i++) {
            Fish fish = (Fish) vFish.get(i);
            hFish.put(fish.getOID(), fish);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        Sizing sizing = (Sizing) objectClass.get(i);

        Fish fish = (Fish) hFish.get(sizing.getFishId());
        if(fish == null) fish = new Fish();

        Vector rowx = new Vector();
        rowx.add("<div align=\"center\">" + (fish.getFishID()==0?"":fish.getFishID()) + "</div>");
        rowx.add(fish.getFishFamily());
        rowx.add(fish.getFishGenus() + " " + fish.getFishSpecies());
        rowx.add("<div align=\"center\">" + JSPFormater.formatNumber(sizing.getCm(), "#") + "</div>");

        lstData.add(rowx);
    }

    return jsplist.draw(-1);
}
%>
<%
/* VARIABLE DECLARATION */
SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
Control control = new Control();
int recordToGet = 15;
int vectSize = 0;
JSPLine jspLine = new JSPLine();
DeepSlope deepSlope = new DeepSlope();
Boat boat = new Boat();
User userUpload = new User();
User userPosting = new User();
int numberOfFish = 0;
int numberOfSpots = 0;
List<List> summarySizing = new ArrayList<List>();
Vector detailSizing = new Vector();

int jspCommand = JSPRequestValue.requestCommand(request);
int jspCommandList = JSPRequestValue.requestInt(request, "command_list");
int start = JSPRequestValue.requestInt(request, "start");
long landingId = JSPRequestValue.requestLong(request, "landing_id");
String selectTab = JSPRequestValue.requestString(request, "select_tab");

if(jspCommand == JSPCommand.DELETE && landingId > 0) {
    DbDeepSlope.deleteRecursiveCODRS(request, landingId);
    jspCommand = JSPCommand.EDIT;
    landingId = 0;

    String redirectURL = subSystem + "/data/approval.jsp?menu_idx=3";
    response.sendRedirect(redirectURL);
}

if(landingId > 0) {
    deepSlope = DbDeepSlope.fetchExc(landingId);
    boat = DbBoat.fetchExc(deepSlope.getBoatId());
    userUpload = DbUser.fetch(deepSlope.getUserId());
    userPosting = DbUser.fetch(deepSlope.getPostingUser());
    numberOfFish = DbSizing.getCount(deepSlope.getOID());
    numberOfSpots = DbFindMeSpot.getCount(boat.getTrackerId(), deepSlope.getFirstCODRSPictureDate(), deepSlope.getLandingDate());

    if(jspCommand == JSPCommand.POST) {
        deepSlope.setDocStatus(IFishConfig.DOC_STATUS_POSTED);
        deepSlope.setPostingUser(user.getOID());
        DbDeepSlope.updateExc(deepSlope);
        jspCommand = JSPCommand.EDIT;

        //Set largest specimen TL
        SessDeepSlope.setLargestSpecimen(deepSlope.getOID());

    } else if(jspCommand == JSPCommand.CANCEL) {
        deepSlope.setDocStatus(IFishConfig.DOC_STATUS_DRAFT);
        deepSlope.setPostingUser(user.getOID());
        DbDeepSlope.updateExc(deepSlope);
        jspCommand = JSPCommand.EDIT;

        //Rollback largest specimen TL
        SessDeepSlope.rollbackLargestSpecimen(request, deepSlope.getOID());
    }

    if(selectTab.equals("") || selectTab.equals("Summary")) {
        summarySizing = SessDeepSlope.summarySizing(landingId);
    }
        
    if(jspCommandList != JSPCommand.NONE) {
        vectSize = SessDeepSlope.getCountSizing(landingId);
        start = control.actionList(jspCommandList, start, vectSize, recordToGet);
        detailSizing = SessDeepSlope.listSizing(start, recordToGet, landingId);
    }
}

/* list of fish */
Vector vFish = DbFish.listAll();
Hashtable hFish = new Hashtable();
if(vFish != null && vFish.size() > 0) {
    for(int i=0; i<vFish.size(); i++) {
        Fish fish = (Fish) vFish.get(i);
        hFish.put(fish.getOID(), fish);
    }
}
%>

<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    <%if (!privDataApproval) {%>
        window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function selectTab(tabName) {
        document.frmapprovaledit.select_tab.value=tabName;
        document.frmapprovaledit.command.value="<%=JSPCommand.EDIT%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
    }

    function cmdPosting() {
        document.frmapprovaledit.command.value="<%=JSPCommand.POST%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
    }

    function cmdCancel() {
        if(confirm("Are you sure to cancel this data?")) {
        document.frmapprovaledit.command.value="<%=JSPCommand.CANCEL%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
        }
    }

    function cmdDelete() {
        if(confirm("Are you sure to delete this data?")) {
        document.frmapprovaledit.command.value="<%=JSPCommand.DELETE%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
        }
    }

    function cmdList() {
        document.frmapprovaledit.start.value="0";
        document.frmapprovaledit.command_list.value="<%=JSPCommand.LIST%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
    }

    function cmdListFirst(){
        document.frmapprovaledit.command_list.value="<%=JSPCommand.FIRST%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
    }

    function cmdListPrev(){
        document.frmapprovaledit.command_list.value="<%=JSPCommand.PREV%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
    }

    function cmdListNext(){
        document.frmapprovaledit.command_list.value="<%=JSPCommand.NEXT%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
    }

    function cmdListLast(){
        document.frmapprovaledit.command_list.value="<%=JSPCommand.LAST%>";
        document.frmapprovaledit.action="approvaledit.jsp";
        document.frmapprovaledit.submit();
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
            <%@ include file = "../../calendar/calendarframe.jsp" %>
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
                        <form name="frmapprovaledit" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=jspCommand%>">
                          <input type="hidden" name="command_list" value="<%=jspCommandList%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="landing_id" value="<%=landingId%>">
                          <input type="hidden" name="select_tab" value="<%=selectTab%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td class="title">
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom">
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Data</font>
                                    <font class="tit1">&raquo; </font><span class="lvl2">Approval</span></td>
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
                                            <td width="15%">&nbsp;</td>
                                            <td width="25%">&nbsp;</td>
                                            <td width="15%">&nbsp;</td>
                                            <td width="25%">&nbsp;</td>
                                            <td width="20%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Approach&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=IFishConfig.strApproachType[deepSlope.getApproach()]%></td>
                                            <td width="15%">Major Fishing Area&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=deepSlope.getWpp1() + " " + deepSlope.getWpp2() + " " + deepSlope.getWpp3() + " " + deepSlope.getOtherFishingGround()%></td>
                                            <td width="20%" rowspan="4">
                                                <h3>Data status is <%=deepSlope.getDocStatus().equals(IFishConfig.DOC_STATUS_POSTED)?"<font style='color:green;'><u>POSTED</u></font>":"<font style='color:red;'><u>DRAFT</u></font>"%></h3>
                                                <%if(deepSlope.getDocStatus().equals(IFishConfig.DOC_STATUS_POSTED) && user.getOID() == deepSlope.getPostingUser()) {%>
                                                <input type="button" name="btncancel" value="  CANCEL POSTING  " onClick="javascript:cmdCancel()" class="formElemen">
                                                <%}%>
                                                <%if(deepSlope.getDocStatus().equals(IFishConfig.DOC_STATUS_DRAFT)) {%>
                                                <input type="button" name="btnposting" value="  POSTING  " onClick="javascript:cmdPosting()" class="formElemen">
                                                <%}%>
                                                &nbsp;<br />
                                                <b>Notes :</b> Spots counting start from date of 1st CODRS picture until the landing date.&nbsp;
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Landing Date&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=JSPFormater.formatDate(deepSlope.getLandingDate(), "MMMM d, yyyy")%></td>
                                            <td width="15%">Number of Spots&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=numberOfSpots%> in <%=TimeUnit.DAYS.convert((deepSlope.getLandingDate().getTime()-deepSlope.getFirstCODRSPictureDate().getTime()), TimeUnit.MILLISECONDS)+1%> days</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Boat Name&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=boat.getName()+" ("+boat.getProgramSite()+")"%></td>
                                            <td width="15%">Number of Fish&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=numberOfFish%></td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Fishing Gear&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=deepSlope.getFishingGear()%></td>
                                            <td width="15%">Upload By&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=userUpload.getFullName()%></td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="15%">Image Location on NAS&nbsp;</td>
                                            <td width="25%">:&nbsp;<%=sdf.format(deepSlope.getLandingDate())+"-"+boat.getName().trim().replaceAll("\\ ", "")%></td>
                                            <td width="15%">
                                                <%if(deepSlope.getPostingUser()>0) {%>
                                                <%if(deepSlope.getDocStatus().equals(IFishConfig.DOC_STATUS_POSTED)){out.println("Posting by");} else {out.println("Canceled by");}%>
                                                <%}%>
                                            </td>
                                            <td width="25%"><%=deepSlope.getPostingUser() > 0?":&nbsp;"+userPosting.getFullName():""%></td>
                                            <td width="20%">
                                                <%if(deepSlope.getDocStatus().equals(IFishConfig.DOC_STATUS_DRAFT)) {%>
                                                <span style="color:red;"><a href="javascript:cmdDelete()">DELETE</a></span>
                                                <%}%>
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="5">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td colspan="5">
                                                <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="17" height="10"></td>
                                                        <%if(selectTab.equals("") || selectTab.equals("Summary")) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;Summary&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:selectTab('Summary')" class="tablink">Summary</a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="3" height="10"></td>
                                                        <%if(selectTab.equals("Detail")) {%>
                                                        <td class="tab">
                                                            <div align="center">&nbsp;&nbsp;Detail&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%} else {%>
                                                        <td class="tabin">
                                                            <div align="center">&nbsp;&nbsp;<a href="javascript:selectTab('Detail')" class="tablink">Detail</a>&nbsp;&nbsp;</div>
                                                        </td>
                                                        <%}%>
                                                        <td width="100%" class="tabheader"><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="10"></td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <%if(selectTab.equals("") || selectTab.equals("Summary")) {%>
                                            <td colspan="3">
                                            <%=drawListSummary(summarySizing, hFish)%>
                                            </td>
                                            <td colspan="2">
                                            <%
                                            String strMoreThanLmax = "";
                                            String strLargestSpecimen = "";
                                            if(detailSizing != null && detailSizing.size() > 0) {
                                                for(int i=0; i<detailSizing.size(); i++) {
                                                    Sizing sizing = (Sizing)detailSizing.get(i);
                                                    Fish fish = (Fish)hFish.get(sizing.getFishId());
                                                    if(fish == null) fish = new Fish();

                                                    if(fish.getOID() > 0 && fish.getFishID() != 0 && sizing.getCm() > fish.getLmax()) {
                                                        strMoreThanLmax += fish.getFishGenus()+" "+fish.getFishSpecies()+", TL = "+JSPFormater.formatNumber(sizing.getCm(), "#")+" cm<br/>";
                                                    }

                                                    if(fish.getOID() > 0 && fish.getFishID() != 0 && sizing.getCm() > fish.getLargestSpecimenCm()) {
                                                        strLargestSpecimen += fish.getFishGenus()+" "+fish.getFishSpecies()+", TL = "+JSPFormater.formatNumber(sizing.getCm(), "#")+" cm<br/>";
                                                    }
                                                }
                                            }
                                            %>
                                            <b>Specimen TL more than L-Max :</b><br/>
                                            <%=strMoreThanLmax%>
                                            <br/>&nbsp;<br/>
                                            <b>New largest specimen :</b><br/>
                                            <%=strLargestSpecimen%>
                                            </td>
                                            <%} else {%>
                                            <td colspan="3">
                                                <%=drawListDetail(detailSizing)%>
                                                <span class="command_list">
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
                                                    <%=jspLine.drawImageListLimit(jspCommandList, vectSize, start, recordToGet)%>
                                                </span>
                                            </td>
                                            <td colspan="2">&nbsp;</td>
                                            <%}%>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                         </table>
                        </form><!-- #EndEditable --> </td>
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
