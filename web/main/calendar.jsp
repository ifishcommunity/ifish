<%

int cldD = JSPRequestValue.requestInt(request, "cld_d");
int cldM = JSPRequestValue.requestInt(request, "cld_m");
int cldY = JSPRequestValue.requestInt(request, "cld_y");

//out.println("cldD : "+cldD+",  cldM : "+cldM+", cldY : "+cldY);

if(cldM<0){
	cldM = 11;
	cldY = cldY - 1;
}
if(cldM>11){
	cldM = 0;
	cldY = cldY + 1;
}

//out.println("<br>cldD : "+cldD+",  cldM : "+cldM+", cldY : "+cldY);

Date currdt = new Date();
if(cldD!=0 && cldY!=0){

	//out.println("<br>in here !");
	currdt.setDate(cldD);
	currdt.setMonth(cldM);
	currdt.setYear(cldY);
}

cldD = currdt.getDate();
cldM = currdt.getMonth();
cldY = currdt.getYear();

//out.println("<br>cldD : "+cldD+",  cldM : "+cldM+", cldY : "+cldY);

//out.println("<br>currdt : "+currdt);

Date startDate = (Date)currdt.clone();
startDate.setDate(1);
Date endDate = (Date)currdt.clone();
endDate.setMonth(endDate.getMonth()+1);
endDate.setDate(1);
endDate.setMonth(endDate.getMonth()-1);

//mulai
int day = startDate.getDay();
//out.println("day : "+day);
//out.println("startDate : "+startDate);

Date cldstart = (Date)startDate.clone();

Vector tempCldDays = new Vector();
switch(day){
	case 1 : 
		
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		}
		break;
	case 2 :
		
		cldstart.setDate(cldstart.getDate()-1);
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		}
		break;
	case 3 : 
		
		cldstart.setDate(cldstart.getDate()-2);
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		}
		break;
	case 4 :
		
		cldstart.setDate(cldstart.getDate()-3);
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		} 
		break;
	case 5 :
		
		cldstart.setDate(cldstart.getDate()-4);
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		}  
		break;
	case 6 :
		
		cldstart.setDate(cldstart.getDate()-5);
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		}  
	break;
	case 0 : 
		
		cldstart.setDate(cldstart.getDate()-6);
		for(int i=0; i<35; i++){											
			tempCldDays.add(cldstart);	
			cldstart = (Date)cldstart.clone();
			cldstart.setDate(cldstart.getDate()+1);
		}
	break;									
}

// out.println(tempCldDays);

%>
<script language="JavaScript">

function cmdCurMonth(){
	document.frm.cld_d.value="0";
	document.frm.cld_m.value="0";
	document.frm.cld_y.value="0";
	document.frm.action="dashboard.jsp";
	document.frm.submit();
}

function cmdPrevMonth(){
	document.frm.cld_m.value="<%=(cldM-1)%>";	
	document.frm.action="dashboard.jsp";
	document.frm.submit();
}

function cmdNextMonth(){	
	document.frm.cld_m.value="<%=(cldM+1)%>";	
	document.frm.action="dashboard.jsp";
	document.frm.submit();
}

</script>

<input type="hidden" name="cld_d" value="<%=cldD%>">
<input type="hidden" name="cld_m" value="<%=cldM%>">
<input type="hidden" name="cld_y" value="<%=cldY%>">
<table width="180" border="0" cellspacing="0" cellpadding="0" class="list">
  <tr> 
                                <td class="tablehdr" height="17" width="15">&nbsp;</td>
                                <td class="tablehdr" colspan="5" height="17"> 
                                  <div align="center"><%=JSPFormater.formatDate(currdt, "MMMM yyyy")%></div>
                                </td>
                                <td class="tablehdr" height="17" width="15">&nbsp;</td>
                              </tr>
                              <tr> 
                                <td height="17" width="15"> 
                                  <div align="center">M</div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center">T</div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center">W</div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center">T</div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center">F</div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center">S</div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center"><font color="#FF0000">S</font></div>
                                </td>
                              </tr>
                              <tr> 
                                <td colspan="7" height="3" background="images/line1.gif"></td>
                              </tr>							  
							  <%
							  for(int i=0; i<5 ; i++){
							  		
									int idx = i * 7;
									
									Date date1 = (Date)tempCldDays.get(idx);
									Date date2 = (Date)tempCldDays.get(idx+1);
									Date date3 = (Date)tempCldDays.get(idx+2);
									Date date4 = (Date)tempCldDays.get(idx+3);
									Date date5 = (Date)tempCldDays.get(idx+4);
									Date date6 = (Date)tempCldDays.get(idx+5);
									Date date7 = (Date)tempCldDays.get(idx+6);
									
									
							  %>
                              <tr> 
                                <td height="17" width="15"> 
								  <%
								  String s = ""+date1.getDate();
								  if(currdt.getMonth()!=date1.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }
								  else{
								  		if(currdt.getDate()==date1.getDate()){
											s = "<font color=\"#0000FF\"><b>"+s+"</b></font>";
										}
								  }%>	
                                  <div align="center"><%=s%></div>
                                </td>
                                <td height="17" width="15">
								  <%
								  s = ""+date2.getDate();
								  if(currdt.getMonth()!=date2.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }else{
								  		if(currdt.getDate()==date2.getDate()){
											s = "<font color=\"#0000FF\"><b>"+s+"</b></font>";
										}
								  }%> 
                                  <div align="center"><%=s%></div>
                                </td>
                                <td height="17" width="15"> 
                                  <%
								  s = ""+date3.getDate();
								  if(currdt.getMonth()!=date3.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }else{
								  		if(currdt.getDate()==date3.getDate()){
											s = "<font color=\"#0000FF\"><b>"+s+"</b></font>";
										}
								  }%> 
                                  <div align="center"><%=s%></div>
                                </td>
                                <td height="17" width="15"> 
                                  <%
								  s = ""+date4.getDate();
								  if(currdt.getMonth()!=date4.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }else{
								  		if(currdt.getDate()==date4.getDate()){
											s = "<font color=\"#0000FF\"><b>"+s+"</b></font>";
										}
								  }%> 
                                  <div align="center"><%=s%></div>
                                </td>
                                <td height="17" width="15"> 
                                  <%
								  s = ""+date5.getDate();
								  if(currdt.getMonth()!=date5.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }else{
								  		if(currdt.getDate()==date5.getDate()){
											s = "<font color=\"#0000FF\"><b>"+s+"</b></font>";
										}
								  }%> 
                                  <div align="center"><%=s%></div>
                                </td>
                                <td height="17" width="15">
								  <%
								  s = ""+date6.getDate();
								  if(currdt.getMonth()!=date6.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }
								  else{								  					
										if(currdt.getDate()==date6.getDate()){
											s = "<font color=\"red\"><b>"+s+"</b></font>";
										}
										else{
											s= "<font color=\"#FF0000\">"+s+"</font>";							
										}											
								  }
								  %> 
                                  <div align="center"><%=s%></div>                                   
                                </td>
                                <td height="17" width="15"> 
								  <%
								  s = ""+date7.getDate();
								  if(currdt.getMonth()!=date7.getMonth()){
								  		s= "<font color=\"#666666\">"+s+"</font>";	
								  }
								  else{
								  //		s= "<font color=\"#FF0000\">"+s+"</font>";
										if(currdt.getDate()==date7.getDate()){
											s = "<font color=\"red\"><b>"+s+"</b></font>";
										}
										else{
											s= "<font color=\"#FF0000\">"+s+"</font>";							
										}	
								  }
								  %> 
                                  <div align="center"><%=s%></div>   	
                                  
                                </td>
                              </tr>
							  <%}%>
                              
                              <tr> 
                                <td colspan="7" height="3" background="images/line1.gif"></td>
                              </tr>
                              <tr> 
                                
      <td height="17" width="15"><font color="#0000FF"></font></td>
                                <td height="17" width="15"> 
                                  <div align="center"><a href="javascript:cmdPrevMonth()"><img src="<%=rootSystem%>/images/dtprev.gif" width="9" height="14" border="0"></a></div>
                                </td>
                                <td height="17" colspan="3"> 
                                  <div align="center">[ <a href="javascript:cmdCurMonth()" title="<%=JSPFormater.formatDate(new Date(), "dd MMMM yyyy")%>">today</a> 
                                    ] </div>
                                </td>
                                <td height="17" width="15"> 
                                  <div align="center"><a href="javascript:cmdNextMonth()"><img src="<%=rootSystem%>/images/dtnext.gif" width="9" height="14" border="0"></a></div>
                                </td>
                                <td height="17" width="15">&nbsp;</td>
                              </tr>
                            </table>
							

							
							