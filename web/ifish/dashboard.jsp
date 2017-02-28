
<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.ifish.master.Partner" %>
<%@ page import="com.project.ifish.master.DbPartner" %>
<%@ page import="com.project.ifish.master.Boat" %>
<%@ page import="com.project.ifish.master.DbBoat" %>
<%@ page import="com.project.ifish.master.Tracker" %>
<%@ page import="com.project.ifish.master.DbTracker" %>
<%@ page import="com.project.ifish.data.FindMeSpot" %>
<%@ page import="com.project.ifish.data.DbFindMeSpot" %>
<%@ page import="com.project.ifish.session.SessSpotTrace" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="main/check.jsp"%>
<!-- Jsp Block -->
<%!
public String drawList(Vector objectClass) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("Landing Date", "20%");
    jsplist.addHeader("Partner", "25%");
    jsplist.addHeader("Boat", "22%");
    jsplist.addHeader("Brought By", "22%");
    jsplist.addHeader("Status", "11%");

    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    Vector listPartner = DbPartner.listAll();
    Hashtable hPartner = new Hashtable();
    if(listPartner != null && listPartner.size() > 0) {
        for(int i=0; i<listPartner.size(); i++) {
            Partner partner = (Partner) listPartner.get(i);
            hPartner.put(partner.getOID(), partner);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        com.project.insite.OffLoading offLoading = (com.project.insite.OffLoading) objectClass.get(i);
        rowx = new Vector();

        Partner partner = (Partner) hPartner.get(offLoading.getPartnerId());
        if(partner == null) partner = new Partner();

        rowx.add(JSPFormater.formatDate(offLoading.getReceivedDate(), "MMM d, yyyy"));
        rowx.add(partner.getName());
        rowx.add(offLoading.getBoat());
        rowx.add(offLoading.getBroughtBy());
        rowx.add(offLoading.getStatus()==0?"Open":"Done");

        lstData.add(rowx);
    }
    return jsplist.draw(index);
}

public String drawListSpotTrace(Vector objectClass, int offset) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("100%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "3%");
    jsplist.addHeader("Tracker Name", "8%");
    jsplist.addHeader("Attach On", "17%");
    jsplist.addHeader("Last Active", "10%");
    jsplist.addHeader("Last Position", "12%");
    jsplist.addHeader("Battery State", "6%");
    jsplist.addHeader("Message Type", "10%");
    jsplist.addHeader("Message", "28%");
    jsplist.addHeader("Unit Status", "6%");

    jsplist.setLinkRow(1);
    jsplist.setLinkPrefix("javascript:cmdEdit('");
    jsplist.setLinkSufix("')");
    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();
    int localTimeZone = offset * -1;
    long ONE_MINUTE_IN_MILLIS=60000;//millisecs

    Vector listBoat = DbBoat.list(0, 0, DbBoat.colNames[DbBoat.COL_TRACKER_ID]+">0 and "+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+"=1", "");
    Hashtable hBoat = new Hashtable();
    if(listBoat != null && listBoat.size() > 0) {
        for(int i = 0; i < listBoat.size(); i++) {
            Boat b = (Boat) listBoat.get(i);
            hBoat.put(b.getTrackerId(), b);
        }
    }

    int nomor = 1;
    for (int i = 0; i < objectClass.size(); i++) {
        try {
            Tracker tracker = (Tracker) objectClass.get(i);

            Boat boat = (Boat) hBoat.get(tracker.getTrackerId());
            if(boat == null) boat = new Boat();

            FindMeSpot findMeSpot = DbFindMeSpot.getLatestStatus(tracker.getTrackerId());

            long lDateTime = findMeSpot.getDateTime().getTime();
            Date dateByTimeZone = new Date(lDateTime + (localTimeZone * ONE_MINUTE_IN_MILLIS));

            if(findMeSpot.getBatteryState().equals("LOW")) {
                rowx = new Vector();
                rowx.add("<div align=\"center\">" + (nomor) + "</div>");
                rowx.add(tracker.getTrackerName());
                rowx.add(boat.getOID()!=0?boat.getName() + " (" + boat.getHomePort() + ")":"");
                rowx.add(findMeSpot.getOID() != 0 ? JSPFormater.formatDate(dateByTimeZone, "MMM d, yyyy HH:mm"):"-");
                rowx.add(String.valueOf(findMeSpot.getLatitude()) + ", " + findMeSpot.getLongitude());
                rowx.add(findMeSpot.getBatteryState());
                rowx.add(findMeSpot.getMessageType());
                rowx.add(findMeSpot.getMessageContent());
                rowx.add(IFishConfig.strStatus[tracker.getStatus()]);
                lstData.add(rowx);
                nomor++;
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    }

    return jsplist.draw(index);
}
%>
<%
int jspCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int offset = JSPRequestValue.requestInt(request, "offset");

int recordToGet = 10;

/* control list SM */
Control control = new Control();
int vectSize = com.project.insite.DbOffLoading.countLatestOffloading();
start = control.actionList(jspCommand, start, vectSize, recordToGet);
Vector listOffLoading = com.project.insite.DbOffLoading.listLatestOffLoading(start, recordToGet);

/** list of SpotTrace */
Vector listST = SessSpotTrace.listUserBoat(0, 0, user.getOID(), "");
%>
<!-- End of JSP Block -->
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" --> 
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
    function cmdDCFRote() {
        var copies = document.frm_main.frm_jsp_dcf_rote.value;
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.DataCollectionRote?frm_jsp_dcf_rote="+copies);
    }

    function cmdDCLRote() {
        var copies = document.frm_main.frm_jsp_dcl_rote.value;
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.DataCollectionLengthRote?frm_jsp_dcl_rote="+copies);
    }

    function cmdDCFTanjungLuar() {
        var copies = document.frm_main.frm_jsp_dcf_tanjungluar.value;
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.DataCollectionTanjungLuar?frm_jsp_dcf_tanjungluar="+copies);
    }

    function cmdDCLTanjungLuar() {
        var copies = document.frm_main.frm_jsp_dcl_tanjungluar.value;
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.DataCollectionLengthTanjungLuar?frm_jsp_dcl_tanjungluar="+copies);
    }

    function cmdDataSheet() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.DataSheetTanjungLuar");
    }

    function cmdList() {
        document.frm_main.start.value="0";
        document.frm_main.command.value="<%=JSPCommand.LIST%>";
        document.frm_main.action="dashboard.jsp";
        document.frm_main.submit();
    }

    function cmdListFirst(){
        document.frm_main.command.value="<%=JSPCommand.FIRST%>";
        document.frm_main.action="dashboard.jsp";
        document.frm_main.submit();
    }

    function cmdListPrev(){
        document.frm_main.command.value="<%=JSPCommand.PREV%>";
        document.frm_main.action="dashboard.jsp";
        document.frm_main.submit();
    }

    function cmdListNext(){
        document.frm_main.command.value="<%=JSPCommand.NEXT%>";
        document.frm_main.action="dashboard.jsp";
        document.frm_main.submit();
    }

    function cmdListLast(){
        document.frm_main.command.value="<%=JSPCommand.LAST%>";
        document.frm_main.action="dashboard.jsp";
        document.frm_main.submit();
    }

    function speciesPosterA3SM() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.SpeciesPosterA3SM");
    }

    function speciesPosterA4SM() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.SpeciesPosterA4SM");
    }

    function speciesPosterA3mDCU() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.SpeciesPosterA3mDCU");
    }

    function measuringBoard() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.resource.MeasuringBoardPdf");
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
                  <%@ include file="main/menu.jsp"%>
                  <!-- #EndEditable -->
                </td>
                <td width="100%" valign="top"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    
                    <tr> 
                      <td><!-- #BeginEditable "content" --> 
                        <form name="frm_main" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="<%=jspCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="offset" value="<%=offset%>">
                         <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr> 
                              <td class="title"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
                                  <tr valign="bottom"> 
                                    <td width="60%" height="23"><font color="#990000" class="lvl1">Dashboard</font></td>
                                    <td width="40%" height="23"> 
                                      <%@ include file = "../main/userpreview.jsp" %>
                                    </td>
                                  </tr>
                                </table>
                              </td>
                            </tr>
                            <tr> 
                              <td class="container"> 
                                <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                  <tr> 
                                    <td width="20%">&nbsp;</td>
                                    <td width="40%">&nbsp;</td>
                                    <td width="20%">&nbsp;</td>
                                    <td width="20%">&nbsp;</td>
                                  </tr>
                                  <tr> 
                                    <td valign="top" nowrap><a href="changepp.jsp"><img src="<%=rootSystem%>/<%=IFishConfig.IMG_PATH%>/<%=user.getLoginId()%>.jpg" height="120" border="0" title="click here to change picture" alt="no picture, click here to add a picture"></a><img src="<%=rootSystem%>/images/spacer.gif" width="10" height="8"></td>
                                    <td valign="top"><h3>Welcome to <%=titleSystem%></h3></td>
                                    <td valign="top" align="right">
                                      <%@ include file = "../main/calendar.jsp" %>
                                    </td>
                                    <td valign="top" align="right">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="4">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td colspan="4">
                                        <table width="100%" border="0" cellspacing="1" cellpadding="1">
                                            <tr>
                                                <td width="50%" valign="top">
                                                    <%if(privDashboardDownloadableResources) {%>
                                                    <h3>Downloadable resources :</h3>
                                                    <ol style="padding-left: 15px;">
                                                        <!--li style="padding-top: 5px;"><a href="../pub/PROTOCOLForFisheriesResourceUseDataCollectionInROTE-EN.pdf" target="blank">Protocol Rote (EN)</a></li-->
                                                        <!--li style="padding-top: 5px;"><a href="../pub/PROTOKOLUntukPendataanPenggunaanSumberDayaIkanROTE-ID.pdf" target="blank">Protocol Rote (ID)</a></li-->
                                                        <!--li style="padding-top: 5px;">Formulir Data Hasil Tangkapan (Rote) <input type="text" name="frm_jsp_dcf_rote" value="1" size="2" style="text-align: right;"> copies &nbsp;&nbsp;<input type="button" onclick="javascript:cmdDCFRote()" value="Download"></li-->
                                                        <!--li style="padding-top: 5px;">Formulir Data Panjang (Rote) <input type="text" name="frm_jsp_dcl_rote" value="1" size="2" style="text-align: right;"> copies &nbsp;&nbsp;<input type="button" onclick="javascript:cmdDCLRote()" value="Download"></li-->
                                                        <!--li style="padding-top: 5px;"><a href="../pub/DataSheetRote.xls">Data Sheet Rote</a></li-->
                                                        <!--li style="padding-top: 5px;">Formulir Data Hasil Tangkapan (Tanjung Luar) <input type="text" name="frm_jsp_dcf_tanjungluar" value="1" size="2" style="text-align: right;"> copies &nbsp;&nbsp;<input type="button" onclick="javascript:cmdDCFTanjungLuar()" value="Download"></li-->
                                                        <!--li style="padding-top: 5px;">Formulir Data Panjang (Tanjung Luar) <input type="text" name="frm_jsp_dcl_tanjungluar" value="1" size="2" style="text-align: right;"> copies &nbsp;&nbsp;<input type="button" onclick="javascript:cmdDCLTanjungLuar()" value="Download"></li-->
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/FormulirInformasiKapal.pdf" target="blank">Formulir Informasi Kapal</a></li>
                                                        <!--li style="padding-top: 5px;"><a href="javascript:speciesPosterA3SM()">Fish ID Guide for Smart Measuring (A3)</a></li-->
                                                        <!--li style="padding-top: 5px;"><a href="javascript:speciesPosterA4SM()">Fish ID Guide for Smart Measuring (A4)</a></li-->
                                                        <!--li style="padding-top: 5px;"><a href="javascript:speciesPosterA3mDCU()">Fish ID Guide for mDCU (A3)</a></li-->
                                                        <li style="padding-top: 5px;"><a href="javascript:measuringBoard()">Measuring Board</a></li>
                                                    </ol>
                                                    <%}%>
                                                    <%if(privDashboardPublication) {%>
                                                    <br />&nbsp;
                                                    <h3>Publications :</h3>
                                                    <ol style="padding-left: 15px;">
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/TNC_FishID.pdf" target="blank">Snapper Fisheries Target Species ID Guide</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/TNC_FishIDPoster.jpg" target="blank">Snapper Fisheries Target Species Poster</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/DeepSlopeSpeciesAssessmentTool.pdf" target="blank">Guide to Length Based Assessment Approach for Snapper Fisheries</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/DeepSlopeSpeciesIllustrationGuide.pdf" target="blank">Guide with Internet-sourced Images to support ID work on target species</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/IFishSnapperWPP573.pdf" target="blank">Length-based assessment of Snapper Fisheries in WPP 573, including the Timor Sea</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/IFishSnapperWPP714_715.pdf" target="blank">Length-based assessment of Snapper Fisheries in WPP 714 & 715, including the Maluku, Seram, Banda and Flores Seas</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/IFishSnapperWPP718.pdf" target="blank">Length-based assessment of Snapper Fisheries in WPP 718, including the Arafura Sea</a></li>
                                                        <!--li style="padding-top: 5px;"><a href="#">Length-based assessment of Snapper Fisheries in WPP 712 & 713, including the Java Sea and Makassar Strait</a></li-->
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/IFishGrouper.pdf" target="blank">Deep Slope Grouper Length Based Assessment report East Indonesia</a></li>
                                                        <li style="padding-top: 5px;"><a href="<%=rootSystem%>/pub/IFishEstimatedParameters.xls">Top 100 Species Estimated Parameters Values</a></li>
                                                    </ol>
                                                    <%}%>
                                                    &nbsp;
                                                </td>
                                                <td width="50%" valign="top">
                                                    <%if (privDashboardLandingUpdate) {%>
                                                    <h3>Landing update from Smart Weighing Scale System</h3>
                                                    <%=drawList(listOffLoading)%>
                                                    <span class="command">
                                                    <%
                                                    JSPLine jspLine = new JSPLine();
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
                                                    <%}%>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" valign="top">
                                                    <%if(privDashboardSpotTraceStatus) {%>
                                                    <h3>List of SpotTrace with LOW Battery State</h3>
                                                    <%=drawListSpotTrace(listST, offset)%>
                                                    <%}%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                  </tr>
                                  <tr>
                                    <td colspan="4">&nbsp;</td>
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
