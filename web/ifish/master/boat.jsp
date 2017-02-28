<%-- 
    Document   : boat
    Created on : Aug 24, 2015, 11:49:39 PM
    Author     : gwawan
--%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Boat"%>
<%@ page import = "com.project.ifish.master.DbBoat"%>
<%@ page import = "com.project.ifish.master.CmdBoat"%>
<%@ page import = "com.project.ifish.master.Tracker"%>
<%@ page import = "com.project.ifish.master.DbTracker"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT, AppMenu.PRIV_DELETE);
%>
<!-- JSP Block -->
<%!
public String drawList(Vector objectClass) {
    JSPList jspList = new JSPList();
    jspList.setAreaWidth("100%");
    jspList.setListStyle("listgen");
    jspList.setTitleStyle("tablehdr");
    jspList.setCellStyle("tablecell");
    jspList.setCellStyle1("tablecell1");
    jspList.setHeaderStyle("tablehdr");

    jspList.addHeader("Code", "6%");
    jspList.addHeader("Gear Type", "10%");
    jspList.addHeader("Name", "12%");
    jspList.addHeader("Home Port<br />(as on license)", "12%");
    jspList.addHeader("Length (m)", "6%");
    jspList.addHeader("Width (m)", "6%");
    jspList.addHeader("Year Built", "6%");
    jspList.addHeader("GT", "4%");
    jspList.addHeader("Captain", "12%");
    jspList.addHeader("Owner", "12%");
    jspList.addHeader("SpotTrace", "7%");
    jspList.addHeader("Tracker Status", "7%");

    jspList.setLinkRow(0);
    jspList.setLinkSufix("");
    Vector lstData = jspList.getData();
    Vector lstLinkData = jspList.getLinkData();
    jspList.setLinkPrefix("javascript:cmdEdit('");
    jspList.setLinkSufix("')");
    jspList.reset();
    int index = -1;

    Vector listSpotTrace = DbTracker.listAll();
    Hashtable hSpotTrace = new Hashtable();
    if(listSpotTrace != null && listSpotTrace.size() > 0) {
        for(int i = 0; i < listSpotTrace.size(); i++) {
            Tracker t = (Tracker) listSpotTrace.get(i);
            hSpotTrace.put(t.getTrackerId(), t);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        Boat boat = (Boat) objectClass.get(i);
        Vector rowx = new Vector();

        Tracker spotTrace = (Tracker) hSpotTrace.get(boat.getTrackerId());
        if(spotTrace == null) spotTrace = new Tracker();

        rowx.add(boat.getCode());
        rowx.add(boat.getGearType());
        rowx.add(boat.getName());
        rowx.add(boat.getHomePort());
        rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(boat.getLength(), "#.#") + "</div");
        rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(boat.getWidth(), "#.#") + "</div");
        rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(boat.getYearBuilt(), "#.#") + "</div");
        rowx.add("<div align=\"right\">" + JSPFormater.formatNumber(boat.getGrossTonnage(), "#.#") + "</div");
        rowx.add(boat.getCaptain());
        rowx.add(boat.getOwner());
        rowx.add(spotTrace.getTrackerName());
        rowx.add(boat.getTrackerId()>0?IFishConfig.strStatus[boat.getTrackerStatus()]:"");

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(boat.getOID()));
    }

    return jspList.draw(index);
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String where = "";
String order = DbBoat.colNames[DbBoat.COL_CODE] + ", " + DbBoat.colNames[DbBoat.COL_NAME];
Vector listBoat = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
int start = JSPRequestValue.requestInt(request, "start");
String srcName = JSPRequestValue.requestString(request, "src_name");
String srcHomePort = JSPRequestValue.requestString(request, "src_home_port");
String srcProgramSite = JSPRequestValue.requestString(request, "src_program_site");
int srcIsSpotTrace = JSPRequestValue.requestInt(request, "src_is_spottrace");

if(srcName.length() > 0) {
    where = DbBoat.colNames[DbBoat.COL_NAME] + " ilike '%" + srcName + "%'";
}

if(srcHomePort.length() > 0) {
    if(where.length() == 0) {
        where = DbBoat.colNames[DbBoat.COL_HOME_PORT] + " ilike '%" + srcHomePort + "%'";
    } else {
        where += " and " + DbBoat.colNames[DbBoat.COL_HOME_PORT] + " ilike '%" + srcHomePort + "%'";
    }
}

if(srcProgramSite.length() > 0) {
    if(where.length() == 0) {
        where = DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '%" + srcProgramSite + "%'";
    } else {
        where += " and " + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '" + srcProgramSite + "'";
    }
}

if(srcIsSpotTrace == 1) {
    if(where.length() == 0) {
        where = DbBoat.colNames[DbBoat.COL_TRACKER_ID] + " > 0 ";
    } else {
        where += " and " + DbBoat.colNames[DbBoat.COL_TRACKER_ID] + " > 0 ";
    }
}

if (listJSPCommand == JSPCommand.NONE) {
    listJSPCommand = JSPCommand.LIST;
}

/* control list */
CmdBoat cmdBoat = new CmdBoat(request);
int vectSize = DbBoat.getCount(where);
start = cmdBoat.actionList(listJSPCommand, start, vectSize, recordToGet);
listBoat = DbBoat.list(start, recordToGet, where, order);
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
    <%if (!privMasterBoat) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function addNew(){
        document.frmboat.boat_oid.value="0";
        document.frmboat.command.value="<%=JSPCommand.ADD%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }

    function cmdEdit(oid){
        document.frmboat.boat_oid.value=oid;
        document.frmboat.command.value="<%=JSPCommand.EDIT%>";
        document.frmboat.action="boatedit.jsp";
        document.frmboat.submit();
    }

    function cmdList(){
        document.frmboat.start.value="0";
        document.frmboat.list_command.value="<%=JSPCommand.LIST%>";
        document.frmboat.action="boat.jsp";
        document.frmboat.submit();
    }

    function cmdListFirst(){
        document.frmboat.list_command.value="<%=JSPCommand.FIRST%>";
        document.frmboat.action="boat.jsp";
        document.frmboat.submit();
    }

    function cmdListPrev(){
        document.frmboat.list_command.value="<%=JSPCommand.PREV%>";
        document.frmboat.action="boat.jsp";
        document.frmboat.submit();
    }

    function cmdListNext(){
        document.frmboat.list_command.value="<%=JSPCommand.NEXT%>";
        document.frmboat.action="boat.jsp";
        document.frmboat.submit();
    }

    function cmdListLast(){
        document.frmboat.list_command.value="<%=JSPCommand.LAST%>";
        document.frmboat.action="boat.jsp";
        document.frmboat.submit();
    }

    function listSpotTraceBoat() {
        window.open("<%=rootSystem%>/servlet/com.project.ifish.report.SpotTraceBoatPdf");
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
                          <form name="frmboat" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="0">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="boat_oid" value="">
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
                                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Program Site&nbsp;</td>
                                            <td width="30%">
                                                <select name="src_program_site">
                                                    <option value="" <%=srcProgramSite.equals("")?"selected":""%>>all</option>
                                                    <option value="<%=IFishConfig.SITE_BALI%>" <%=srcProgramSite.equals(IFishConfig.SITE_BALI)?"selected":""%>><%=IFishConfig.SITE_BALI%></option>
                                                    <option value="<%=IFishConfig.SITE_KEMA%>" <%=srcProgramSite.equals(IFishConfig.SITE_KEMA)?"selected":""%>><%=IFishConfig.SITE_KEMA%></option>
                                                    <option value="<%=IFishConfig.SITE_KUPANG%>" <%=srcProgramSite.equals(IFishConfig.SITE_KUPANG)?"selected":""%>><%=IFishConfig.SITE_KUPANG%></option>
                                                    <option value="<%=IFishConfig.SITE_PROBOLINGGO%>" <%=srcProgramSite.equals(IFishConfig.SITE_PROBOLINGGO)?"selected":""%>><%=IFishConfig.SITE_PROBOLINGGO%></option>
                                                    <option value="<%=IFishConfig.SITE_LUWUK%>" <%=srcProgramSite.equals(IFishConfig.SITE_LUWUK)?"selected":""%>><%=IFishConfig.SITE_LUWUK%></option>
                                                    <option value="<%=IFishConfig.SITE_SORONG%>" <%=srcProgramSite.equals(IFishConfig.SITE_SORONG)?"selected":""%>><%=IFishConfig.SITE_SORONG%></option>
                                                    <option value="<%=IFishConfig.SITE_TANJUNG_LUAR%>" <%=srcProgramSite.equals(IFishConfig.SITE_TANJUNG_LUAR)?"selected":""%>><%=IFishConfig.SITE_TANJUNG_LUAR%></option>
                                                    <option value="<%=IFishConfig.SITE_TIMIKA%>" <%=srcProgramSite.equals(IFishConfig.SITE_TIMIKA)?"selected":""%>><%=IFishConfig.SITE_TIMIKA%></option>
                                                    <option value="<%=IFishConfig.SITE_OTHERS%>" <%=srcProgramSite.equals(IFishConfig.SITE_OTHERS)?"selected":""%>><%=IFishConfig.SITE_OTHERS%></option>
                                                </select>
                                            </td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Name&nbsp;</td>
                                            <td width="30%"><input type="text" name="src_name" value="<%=srcName%>" size="30" on>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Home Port&nbsp;</td>
                                            <td width="30%"><input type="text" name="src_home_port" value="<%=srcHomePort%>" size="30" on>&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Has an SpotTrace?&nbsp;</td>
                                            <td width="30%"><input type="checkbox" name="src_is_spottrace" value="1" <%=srcIsSpotTrace==1?"checked":""%>>&nbsp;Yes</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <% if ((listBoat != null) && (listBoat.size() > 0)) {%>
                                        <tr align="left" valign="top">
                                            <td height="5" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3"><%=drawList(listBoat)%></td>
                                        </tr>
                                        <%} else {%>
                                        <tr>
                                            <td colspan="3">
                                                <div class="comment">Data not found</div>
                                            </td>
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
                                                    <%=jspLine.drawImageListLimit(listJSPCommand, vectSize, start, recordToGet)%>
                                                </span>
                                            </td>
                                        </tr>
                                        <% if (privAdd) {%>
                                        <tr>
                                            <td width="10%"><a href="javascript:addNew()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../../images/new2.gif',1)"><img src="../../images/new.gif" name="new" height="22" border="0"></a></td>
                                            <td colspan="2%" valign="top"><b><a href="javascript:listSpotTraceBoat()">List of Boat that Installed Spot Trace</a></b>&nbsp;&nbsp;</td>
                                        </tr>
                                        <%}%>
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