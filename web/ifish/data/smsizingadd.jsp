<%-- 
    Document   : sizingadd
    Created on : Jun 25, 2015, 8:25:56 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.main.log.LogsAction"%>
<%@ page import="com.project.main.log.DbLogsAction"%>
<%@ page import="com.project.ifish.data.DeepSlope"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.master.Partner"%>
<%@ page import="com.project.ifish.master.DbPartner"%>
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ page import="com.project.ifish.data.Sizing"%>
<%@ page import="com.project.ifish.data.DbSizing"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS, AppMenu.PRIV_DELETE);
%>
<!-- Jsp Block -->
<%!
public String drawList(Vector objectClass) {
    JSPList jsplist = new JSPList();
    jsplist.setAreaWidth("30%");
    jsplist.setListStyle("listgen");
    jsplist.setTitleStyle("tablehdr");
    jsplist.setCellStyle("tablecell1");
    jsplist.setCellStyle1("tablecell");
    jsplist.setHeaderStyle("tablehdr");

    jsplist.addHeader("No", "10%");
    jsplist.addHeader("Species/Family Name", "70%");
    jsplist.addHeader("Cm", "20%");

    Vector lstData = jsplist.getData();
    jsplist.reset();
    int index = -1;
    Vector rowx = new Vector();

    Vector listFish = DbFish.listAll();
    Hashtable hFish = new Hashtable();
    if(listFish != null && listFish.size() > 0) {
        for(int i=0; i<listFish.size(); i++) {
            Fish fish = (Fish) listFish.get(i);
            hFish.put(fish.getOID(), fish);
        }
    }

    for (int i = 0; i < objectClass.size(); i++) {
        com.project.insite.Sizing sizing = (com.project.insite.Sizing) objectClass.get(i);
        rowx = new Vector();
        rowx.add("<div align=\"center\">" + (i + 1) + "</div>");
        rowx.add(sizing.getLatinName());
        rowx.add("<div align=\"right\">" + String.valueOf(sizing.getCm()) + "</div>");

        lstData.add(rowx);
    }
    return jsplist.draw(index);
}
%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
long oidLanding = JSPRequestValue.requestLong(request, "landing_oid");
String sLandingDate = JSPRequestValue.requestString(request, "landing_date");
String boatName = JSPRequestValue.requestString(request, "boat_name");

DeepSlope deepSlope = new DeepSlope();
Partner partner = new Partner();
if(oidLanding != 0) {
    try {
        deepSlope = DbDeepSlope.fetchExc(oidLanding);
        partner = DbPartner.fetchExc(deepSlope.getPartnerId());
    } catch(Exception e) {
        System.out.println(e.toString());
    }
}

Date landingDate = new Date();
if(sLandingDate.length() > 0) {
    landingDate = JSPFormater.formatDate(sLandingDate, "dd/MM/yyyy");
} else {
    landingDate = deepSlope.getLandingDate();
}

Vector listOfBoat = new Vector();
if(deepSlope.getLandingDate() != null) listOfBoat = com.project.insite.DbSizing.listOfBoat(deepSlope.getPartnerId(), JSPFormater.formatDate(landingDate, "yyyy-MM-dd"));

Vector listSizing = new Vector();
String where = com.project.insite.DbSizing.colNames[com.project.insite.DbSizing.COL_BOAT] + " ilike '%" + boatName + "%' and "
        + " date_trunc('day', " + com.project.insite.DbSizing.colNames[com.project.insite.DbSizing.COL_SIZING_DATE] + ") = '" + JSPFormater.formatDate(landingDate, "yyyy-MM-dd") + "'"
        + " and " + com.project.insite.DbSizing.colNames[com.project.insite.DbSizing.COL_PARTNER_ID] + " = " + deepSlope.getPartnerId()
        + " and " + com.project.insite.DbSizing.colNames[com.project.insite.DbSizing.COL_STATUS] + " = 0";
if(boatName.length() > 0 && (iJSPCommand == JSPCommand.LOAD || iJSPCommand == JSPCommand.SAVE)) {
    listSizing = com.project.insite.DbSizing.list(0, 0, where, "");
}

//Convert data from Insite into I-Fish Community data structure
if(iJSPCommand == JSPCommand.SAVE && listSizing != null && listSizing.size() > 0) {
    for(int i = 0; i < listSizing.size(); i++) {
        com.project.insite.Sizing sizingInsite = (com.project.insite.Sizing) listSizing.get(i);

        long fishId = 0;
        String[] latinName = sizingInsite.getLatinName().trim().split(" ");
        try {
            if (latinName.length == 1) {
                fishId = DbFish.getFishIdByFamily(latinName[0]); //family
            } else if (latinName.length == 2) {
                fishId = DbFish.getFishId(latinName[0], latinName[1]); //species
            }

            //if not found, set to other
            if(fishId == 0) fishId = 1427255974907l; //other
        } catch (Exception e) {
            System.out.println("ex latinName : " + e.toString());
        }

        //Only proceed data with correctly species name
        if (fishId != 0) {
            Fish fish = DbFish.fetchExc(fishId);
            Sizing sizing = new Sizing();
            sizing.setOID(sizingInsite.getOID());
            sizing.setLandingId(deepSlope.getOID());
            sizing.setFishId(fishId);
            sizing.setCm(sizingInsite.getCm());
            sizing.setOffloadingId(sizingInsite.getOffloadingId());
            if(sizing.getCm() > fish.getLmax()) {
                sizing.setDataQuality(IFishConfig.DATA_QUALITY_POOR);
            }

            try {
                long oid = DbSizing.insertExcWithOid(sizing);
                DbLogsAction.insertLogs(JSPCommand.ADD, DbSizing.DB_SIZING, oid, user.getOID());
                
                //Update Insite data status
                if(oid != 0) {
                    sizingInsite.setStatus(1);
                    com.project.insite.DbSizing.updateExc(sizingInsite);
                }
            } catch(Exception e) {
                System.out.println(e.toString());
            }
        }
    }

    if(boatName.length() > 0) {
        listSizing = com.project.insite.DbSizing.list(0, 0, where, "");
    }

    DbLogsAction.insertLogs(JSPCommand.UPDATE, DbDeepSlope.DB_DEEPSLOPE, oidLanding, user.getOID());
}
%>
<html><!-- #BeginTemplate "/Templates/index.dwt" -->
<head>
<!-- #BeginEditable "javascript" -->
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<link href="../../css/css.css" rel="stylesheet" type="text/css" />
<script language="javascript">
<%if (!privAdd) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
<%}%>

function cmdSearch() {
    document.frmsizingadd.command.value="<%=JSPCommand.LOAD%>";
    document.frmsizingadd.action="smsizingadd.jsp";
    document.frmsizingadd.submit();
}

<%if (privAdd || privEdit) {%>
function cmdSave() {
    document.frmsizingadd.command.value="<%=JSPCommand.SAVE%>";
    document.frmsizingadd.action="smsizingadd.jsp";
    document.frmsizingadd.submit();
}
<%}%>
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
    <%@ include file ="../../calendar/calendarframe.jsp"%>
    <form name="frmsizingadd" method="post" action="">
        <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
        <input type="hidden" name="command" value="<%=iJSPCommand%>">
        <input type="hidden" name="landing_oid" value="<%=oidLanding%>">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr align="left" valign="top">
                <td class="container">
                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                        <tr align="left" valign="top">
                            <td width="20%">&nbsp;</td>
                            <td width="80%">&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td>Partner (data owner)</td>
                            <td><%=partner.getName()%>&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td>Landing Date&nbsp;</td>
                            <td><input name="landing_date" value="<%=JSPFormater.formatDate((landingDate == null) ? deepSlope.getLandingDate() : landingDate, "dd/MM/yyyy")%>" size="11" style="text-align:center" readOnly>
                                <a href="javascript:void(0)" onClick="if(self.gfPop)gfPop.fPopCalendar(document.frmsizingadd.landing_date);return false;" ><img class="PopcalTrigger" align="absmiddle" src="<%=rootSystem%>/calendar/calbtn.gif" height="19" border="0" alt="Landing Date"></a>
                            </td>
                        </tr>
                        <tr align="left" valign="top">
                            <td>Boat/Supplier&nbsp;</td>
                            <td><%=JSPCombo.draw("boat_name", null, boatName, listOfBoat, listOfBoat, "") %></td>
                        </tr>
                        <tr align="left" valign="top">
                            <td>&nbsp;</td>
                            <td>
                                <a href="javascript:cmdSearch()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('search2','','../../images/search2.gif',1)"><img src="../../images/search.gif" name="search" border="0"></a>
                                <% if(listSizing.size() > 0) { %>
                                <img src="<%=rootSystem%>/images/spacer.gif" width="20">
                                <a href="javascript:cmdSave()"  onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('save2','','../../images/save2.gif',1)"><img src="../../images/save.gif" name="save" border="0"></a>
                                <% } %>
                            </td>
                        </tr>
                        <tr align="left" valign="top">
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr align="left" valign="top">
                            <td colspan="2"><b>List of sizing data from partner database</b></td>
                        </tr>
                        <% if(iJSPCommand == JSPCommand.LOAD) { %>
                        <tr align="left" valign="top">
                            <td colspan="2"><%=listSizing.size()>0?drawList(listSizing):"Data not found"%>&nbsp;</td>
                        </tr>
                        <% } %>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>