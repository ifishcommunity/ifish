<%
int menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
%>
<script language="JavaScript">
    function cmdChangeMenu(idx){
	var x = idx;

	switch(parseInt(idx)){
            case 0 :
                <%if(privGeneralOther || privGeneralUser) {%>
                document.all.general1.style.display="";
                document.all.general2.style.display="none";
                document.all.general.style.display="none";
                <%}%>

                <%if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) {%>
                document.all.master1.style.display="";
                document.all.master2.style.display="none";
                document.all.master.style.display="none";
                <%}%>

                <%if(privDataSWMS || privDataCODRS) {%>
                document.all.data1.style.display="";
                document.all.data2.style.display="none";
                document.all.data.style.display="none";
                <%}%>

                <%if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) {%>
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                <%}%>

                <%if(privUALD) {%>
                document.all.uald1.style.display="";
                document.all.uald2.style.display="none";
                document.all.uald.style.display="none";
                <%}%>
                break;
            case 1 :
                <%if(privGeneralOther || privGeneralUser) {%>
                document.all.general1.style.display="none";
                document.all.general2.style.display="";
                document.all.general.style.display="";
                <%}%>

                <%if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) {%>
                document.all.master1.style.display="";
                document.all.master2.style.display="none";
                document.all.master.style.display="none";
                <%}%>

                <%if(privDataSWMS || privDataCODRS) {%>
                document.all.data1.style.display="";
                document.all.data2.style.display="none";
                document.all.data.style.display="none";
                <%}%>

                <%if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) {%>
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                <%}%>

                <%if(privUALD) {%>
                document.all.uald1.style.display="";
                document.all.uald2.style.display="none";
                document.all.uald.style.display="none";
                <%}%>
                break;
            case 2 :
                <%if(privGeneralOther || privGeneralUser) {%>
                document.all.general1.style.display="";
                document.all.general2.style.display="none";
                document.all.general.style.display="none";
                <%}%>

                <%if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) {%>
                document.all.master1.style.display="none";
                document.all.master2.style.display="";
                document.all.master.style.display="";
                <%}%>

                <%if(privDataSWMS || privDataCODRS) {%>
                document.all.data1.style.display="";
                document.all.data2.style.display="none";
                document.all.data.style.display="none";
                <%}%>

                <%if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) {%>
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                <%}%>

                <%if(privUALD) {%>
                document.all.uald1.style.display="";
                document.all.uald2.style.display="none";
                document.all.uald.style.display="none";
                <%}%>
                break;
            case 3 :
                <%if(privGeneralOther || privGeneralUser) {%>
                document.all.general1.style.display="";
                document.all.general2.style.display="none";
                document.all.general.style.display="none";
                <%}%>

                <%if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) {%>
                document.all.master1.style.display="";
                document.all.master2.style.display="none";
                document.all.master.style.display="none";
                <%}%>

                <%if(privDataSWMS || privDataCODRS) {%>
                document.all.data1.style.display="none";
                document.all.data2.style.display="";
                document.all.data.style.display="";
                <%}%>

                <%if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) {%>
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                <%}%>

                <%if(privUALD) {%>
                document.all.uald1.style.display="";
                document.all.uald2.style.display="none";
                document.all.uald.style.display="none";
                <%}%>
                break;
            case 4 :
                <%if(privGeneralOther || privGeneralUser) {%>
                document.all.general1.style.display="";
                document.all.general2.style.display="none";
                document.all.general.style.display="none";
                <%}%>

                <%if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) {%>
                document.all.master1.style.display="";
                document.all.master2.style.display="none";
                document.all.master.style.display="none";
                <%}%>

                <%if(privDataSWMS || privDataCODRS) {%>
                document.all.data1.style.display="";
                document.all.data2.style.display="none";
                document.all.data.style.display="none";
                <%}%>

                <%if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) {%>
                document.all.report1.style.display="none";
                document.all.report2.style.display="";
                document.all.report.style.display="";
                <%}%>

                <%if(privUALD) {%>
                document.all.uald1.style.display="";
                document.all.uald2.style.display="none";
                document.all.uald.style.display="none";
                <%}%>
                break;
            case 5 :
                <%if(privGeneralOther || privGeneralUser) {%>
                document.all.general1.style.display="";
                document.all.general2.style.display="none";
                document.all.general.style.display="none";
                <%}%>

                <%if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) {%>
                document.all.master1.style.display="";
                document.all.master2.style.display="none";
                document.all.master.style.display="none";
                <%}%>

                <%if(privDataSWMS || privDataCODRS) {%>
                document.all.data1.style.display="";
                document.all.data2.style.display="none";
                document.all.data.style.display="none";
                <%}%>

                <%if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) {%>
                document.all.report1.style.display="";
                document.all.report2.style.display="none";
                document.all.report.style.display="none";
                <%}%>

                <%if(privUALD) {%>
                document.all.uald1.style.display="none";
                document.all.uald2.style.display="";
                document.all.uald.style.display="";
                <%}%>
                break;
	}
    }
</script>
<table width="100%"  height="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td valign="top" style="<%="background:url("+rootSystem+"/images/leftmenu-bg.gif) repeat-y"%>">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" width="216">
        <tr> 
          <td valign="top"><img src="<%=rootSystem%>/images/spacer.gif" width="216" height="13" /></td>
        </tr>
        <tr> 
          <td style="padding-left:10px" valign="top" height="1" > 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="1" /></td>
              </tr>
              <tr> 
                <td class="menu0"><a href="<%=subSystem%>/dashboard.jsp">Dashboard</a></td>
              </tr>
              <tr>
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% if(privUALD) { %>
              <tr id="uald1">
                <td class="menu0" onClick="javascript:cmdChangeMenu('5')"><a href="javascript:cmdChangeMenu('5')">UALD</a></td>
              </tr>
              <tr id="uald2">
                <td class="menu0"><a href="javascript:cmdChangeMenu('0')"><span class="selected">UALD</span></a></td>
              </tr>
              <tr id="uald">
                <td class="submenutd">
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/uald/spottrace.jsp?menu_idx=5">SpotTrace Data</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/uald/spottracemaps.jsp?menu_idx=5">SpotTrace Maps</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/uald/boatpicture.jsp?menu_idx=5">Boat Picture by Site</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/uald/srcboatpicture.jsp?menu_idx=5">Search Boat Picture</a></td>
                    </tr>
                  </table>
                </td>
              </tr>
              <tr>
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% } %>
              <% if(privReportSpotTrace || privReportUserLogs || privReportSWMS || privReportMDCU || privReportCODRS) { %>
              <tr id="report1">
                <td class="menu0" onClick="javascript:cmdChangeMenu('4')"><a href="javascript:cmdChangeMenu('4')">Report</a></td>
              </tr>
              <tr id="report2">
                <td class="menu0"><a href="javascript:cmdChangeMenu('0')"><span class="selected">Report</span></a></td>
              </tr>
              <tr id="report">
                <td class="submenutd">
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <% if(privReportSpotTrace) { %>
                    <tr>
                      <td class="menu1">Spot Trace</td>
                    </tr>
                    <tr>
                      <td class="menu2"><a href="<%=subSystem%>/report/spottracestatus.jsp?menu_idx=4">Status</a></td>
                    </tr>
                    <tr>
                      <td class="menu2"><a href="<%=subSystem%>/report/spottracedata.jsp?menu_idx=4">Tabular Data</a></td>
                    </tr>
                    <tr>
                      <td class="menu2"><a href="<%=subSystem%>/report/spottracemapwpp.jsp?menu_idx=4">Maps</a></td>
                    </tr>
                    <% } %>
                    <% if(privReportSWMS) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/report/rptswms.jsp?menu_idx=4">SWMS</a></td>
                    </tr>
                    <% } %>
                    <% if(privReportMDCU) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/report/rptmdcu.jsp?menu_idx=4">MDCU</a></td>
                    </tr>
                    <% } %>
                    <% if(privReportCODRS) { %>
                    <tr>
                      <td class="menu1">CODRS</td>
                    </tr>
                    <tr>
                      <td class="menu2"><a href="<%=subSystem%>/report/rptcodrs.jsp?menu_idx=4">By Period</a></td>
                    </tr>
                    <tr>
                      <td class="menu2"><a href="<%=subSystem%>/report/rptcodrsdetail.jsp?menu_idx=4">By Landing</a></td>
                    </tr>
                    <% } %>
                    <% if(privReportUserLogs) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/report/userlogs.jsp?menu_idx=4">User Logs</a></td>
                    </tr>
                    <% } %>
                  </table>
                </td>
              </tr>
              <tr>
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% } %>
              <% if(privDataSWMS || privDataCODRS) { %>
              <tr id="data1">
                <td class="menu0" onClick="javascript:cmdChangeMenu('3')"><a href="javascript:cmdChangeMenu('3')">Data Entry</a></td>
              </tr>
              <tr id="data2">
                <td class="menu0"><a href="javascript:cmdChangeMenu('0')"><span class="selected">Data Entry</span></a></td>
              </tr>
              <tr id="data">
                <td class="submenutd"> 
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <% if(privDataSWMS) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/data/smlist.jsp?menu_idx=3">SWMS</a></td>
                    </tr>
                    <% } %>
                    <% if(privDataCODRS) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/data/codrs.jsp?menu_idx=3">CODRS</a></td>
                    </tr>
                    <% } %>
                    <% if(privDataApproval) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/data/approval.jsp?menu_idx=3">Approval</a></td>
                    </tr>
                    <% } %>
                  </table>
                </td>
              </tr>
              <tr> 
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% } %>
              <% if(privMasterSpotTrace || privMasterFish || privMasterPartner || privMasterBoat) { %>
              <tr id="master1">
                <td class="menu0" onClick="javascript:cmdChangeMenu('2')"><a href="javascript:cmdChangeMenu('2')">Master</a></td>
              </tr>
              <tr id="master2">
                <td class="menu0"><a href="javascript:cmdChangeMenu('0')"><span class="selected">Master</span></a></td>
              </tr>
              <tr id="master">
                <td class="submenutd">
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <% if(privMasterPartner) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/master/partner.jsp?menu_idx=2">Partner</a></td>
                    </tr>
                    <% } %>
                    <% if(privMasterBoat) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/master/boat.jsp?menu_idx=2">Boat</a></td>
                    </tr>
                    <% } %>
                    <% if(privMasterSpotTrace) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/master/spottrace.jsp?menu_idx=2">Spot Trace</a></td>
                    </tr>
                    <% } %>
                    <% if(privMasterFish) { %>
                    <tr>
                      <td class="menu1"><a href="<%=subSystem%>/master/fish.jsp?menu_idx=2">Fish Library</a></td>
                    </tr>
                    <% } %>
                  </table>
                </td>
              </tr>
              <tr>
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% } %>
              <% if(privGeneralOther || privGeneralUser) { %>
              <tr id="general1">
                <td class="menu0" onClick="javascript:cmdChangeMenu('1')"><a href="javascript:cmdChangeMenu('1')">General</a></td>
              </tr>
              <tr id="general2">
                <td class="menu0"><a href="javascript:cmdChangeMenu('0')"><span class="selected">General</span></a></td>
              </tr>
              <tr id="general">
                <td class="submenutd">
                  <table width="99%" border="0" cellspacing="0" cellpadding="0" class="submenu">
                    <% if(privGeneralUser) { %>
                    <tr>
                      <td class="menu1"><a href="<%=rootSystem%>/admin/grouplist.jsp?menu_idx=1">User Group</a></td>
                    </tr>
                    <tr>
                      <td class="menu1"><a href="<%=rootSystem%>/admin/userlist.jsp?menu_idx=1">User</a></td>
                    </tr>
                    <% } %>
                    <% if(privGeneralOther) { %>
                    <tr>
                      <td class="menu1"><a href="<%=rootSystem%>/upload/file.jsp?menu_idx=1">File</a></td>
                    </tr>
                    <% } %>
                  </table>
                </td>
              </tr>
              <tr>
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% } %>
              <% if(1==2) { %>
              <tr>
                <td class="menu0"><a href="<%=rootSystem%>/manual.htm" target="blank">Manual</a></td>
              </tr>
              <tr>
                <td><img src="<%=rootSystem%>/images/spacer.gif" width="1" height="2"></td>
              </tr>
              <% } %>
              <tr>
                <td class="menu0"><a href="<%=rootSystem%>/logout.jsp">Logout</a></td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script language="JavaScript">
	cmdChangeMenu('<%=menuIdx%>');
</script>
