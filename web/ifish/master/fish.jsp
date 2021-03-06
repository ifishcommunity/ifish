<%--
    Document   : fish
    Created on : Jan 27, 2015, 3:14:33 PM
    Author     : gwawan
--%>
<%@ page language="java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.ifish.master.Fish"%>
<%@ page import = "com.project.ifish.master.DbFish"%>
<%@ page import = "com.project.ifish.master.CmdFish"%>
<%@ include file = "../../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp"%>
<%
boolean privAdd = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH, AppMenu.PRIV_ADD);
boolean privEdit = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH, AppMenu.PRIV_EDIT);
boolean privDelete = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH, AppMenu.PRIV_DELETE);
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

    jspList.addHeader("Fish ID", "5%");
    jspList.addHeader("Family", "10%");
    jspList.addHeader("Latin Name", "15%");
    jspList.addHeader("L-Max (cm)", "10%");
    jspList.addHeader("English Name", "30%");
    jspList.addHeader("Other Indonesian Names", "30%");

    jspList.setLinkRow(0);
    jspList.setLinkSufix("");
    Vector lstData = jspList.getData();
    Vector lstLinkData = jspList.getLinkData();
    jspList.setLinkPrefix("javascript:cmdEdit('");
    jspList.setLinkSufix("')");
    jspList.reset();
    int index = -1;

    for (int i = 0; i < objectClass.size(); i++) {
        Fish fish = (Fish) objectClass.get(i);
        Vector rowx = new Vector();

        rowx.add("<div align=\"center\">"+JSPFormater.formatNumber(fish.getFishID(), "#")+"</div>");
        rowx.add(fish.getFishFamily());
        rowx.add(fish.getFishGenus()+" "+fish.getFishSpecies());
        rowx.add("<div align=\"center\">"+JSPFormater.formatNumber(fish.getLmax(), "#")+"</div>");
        rowx.add(fish.getEnglishName());
        rowx.add(fish.getOtherIndonesianNames());

        lstData.add(rowx);
        lstLinkData.add(String.valueOf(fish.getOID()));
    }

    return jspList.draw(index);
}
%>
<%
/* VARIABLE DECLARATION */
int recordToGet = 15;
String where = "";
String order = DbFish.colNames[DbFish.COL_IS_FAMILY_ID]+", "+DbFish.colNames[DbFish.COL_FISH_FAMILY]+", "+DbFish.colNames[DbFish.COL_FISH_ID];
Vector listFish = new Vector(1, 1);
JSPLine jspLine = new JSPLine();

/* GET REQUEST FROM HIDDEN TEXT */
int listJSPCommand = JSPRequestValue.requestInt(request, "list_command");
int start = JSPRequestValue.requestInt(request, "start");
String srcLatinName = JSPRequestValue.requestString(request, "src_latin_name");
int srcIsFishID = JSPRequestValue.requestInt(request, "src_is_fish_id");

if (listJSPCommand == JSPCommand.NONE) {
    listJSPCommand = JSPCommand.LIST;
}

if(srcLatinName.length() > 0) {
    String xwhere = "";
    for(String xstring: srcLatinName.split(" ")) {
        if(xwhere.length() == 0) {
            xwhere = DbFish.colNames[DbFish.COL_FISH_FAMILY] + " ilike '%" + xstring +"%'"
                + " or " + DbFish.colNames[DbFish.COL_FISH_GENUS] + " ilike '%" + xstring +"%'"
                + " or " + DbFish.colNames[DbFish.COL_FISH_SPECIES] + " ilike '%" + xstring +"%'";
        } else {
            xwhere += " or " + DbFish.colNames[DbFish.COL_FISH_FAMILY] + " ilike '%" + xstring +"%'"
                + " or " + DbFish.colNames[DbFish.COL_FISH_GENUS] + " ilike '%" + xstring +"%'"
                + " or " + DbFish.colNames[DbFish.COL_FISH_SPECIES] + " ilike '%" + xstring +"%'";
        }
    }
    where = "(" + xwhere + ")";
}

if(srcIsFishID == 1) {
    if(where.length() > 0) {
        where += " and " + DbFish.colNames[DbFish.COL_FISH_ID] + " > 0";
    } else {
        where = DbFish.colNames[DbFish.COL_FISH_ID] + " > 0";
    }

    //also order by Fish ID
    order = DbFish.colNames[DbFish.COL_FISH_ID];
}

/* control list */
CmdFish cmdFish = new CmdFish(request);
int vectSize = DbFish.getCount(where);
start = cmdFish.actionList(listJSPCommand, start, vectSize, recordToGet);
listFish = DbFish.list(start, recordToGet, where, order);
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
    <%if (!privMasterFish) {%>
    window.location="<%=rootSystem%>/nopriv.jsp";
    <%}%>

    function addNew(){
        document.frmfish.fish_oid.value="0";
        document.frmfish.command.value="<%=JSPCommand.ADD%>";
        document.frmfish.action="fishedit.jsp";
        document.frmfish.submit();
    }

    function cmdEdit(oid){
        document.frmfish.fish_oid.value=oid;
        document.frmfish.command.value="<%=JSPCommand.EDIT%>";
        document.frmfish.action="fishedit.jsp";
        document.frmfish.submit();
    }

    function cmdList(){
        document.frmfish.start.value="0";
        document.frmfish.list_command.value="<%=JSPCommand.LIST%>";
        document.frmfish.action="fish.jsp";
        document.frmfish.submit();
    }

    function cmdListFirst(){
        document.frmfish.list_command.value="<%=JSPCommand.FIRST%>";
        document.frmfish.action="fish.jsp";
        document.frmfish.submit();
    }

    function cmdListPrev(){
        document.frmfish.list_command.value="<%=JSPCommand.PREV%>";
        document.frmfish.action="fish.jsp";
        document.frmfish.submit();
    }

    function cmdListNext(){
        document.frmfish.list_command.value="<%=JSPCommand.NEXT%>";
        document.frmfish.action="fish.jsp";
        document.frmfish.submit();
    }

    function cmdListLast(){
        document.frmfish.list_command.value="<%=JSPCommand.LAST%>";
        document.frmfish.action="fish.jsp";
        document.frmfish.submit();
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
                          <form name="frmfish" method="post" action="">
                          <input type="hidden" name="menu_idx" value="<%=menuIdx%>">
                          <input type="hidden" name="command" value="0">
                          <input type="hidden" name="list_command" value="<%=listJSPCommand%>">
                          <input type="hidden" name="start" value="<%=start%>">
                          <input type="hidden" name="vectSize" value="<%=vectSize%>">
                          <input type="hidden" name="fish_oid" value="">
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
                                    <table width="100%" border="0" cellspacing="2" cellpadding="0">
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Latin Name&nbsp;</td>
                                            <td width="30%"><input type="text" name="src_latin_name" value="<%=srcLatinName%>" size="30">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">Has a Fish ID?&nbsp;</td>
                                            <td width="30%"><input type="checkbox" name="src_is_fish_id" value="1" <%=srcIsFishID==1?"checked":""%>>&nbsp;Yes</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <tr align="left" valign="top">
                                            <td width="10%">&nbsp;</td>
                                            <td width="30%"><input type="submit" name="search" value="Search" onClick="javascript:cmdList(this)">&nbsp;</td>
                                            <td width="60%">&nbsp;</td>
                                        </tr>
                                        <% if ((listFish != null) && (listFish.size() > 0)) {%>
                                        <tr align="left" valign="top">
                                            <td height="5" colspan="3">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="3"><%=drawList(listFish)%></td>
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
                                            <td><a href="javascript:addNew()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('new','','../../images/new2.gif',1)"><img src="../../images/new.gif" name="new" height="22" border="0"></a></td>
                                            <td colspan="2%" valign="top">&nbsp;</td>
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