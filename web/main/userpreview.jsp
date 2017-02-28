 
 <table width="100%%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap>
      <div align="right"><font face="Arial, Helvetica, sans-serif"><b><%=user.getFullName().toUpperCase()%> , Last Login : <%=JSPFormater.formatDate(user.getLastLoginDate(), "dd/MM/yyyy HH:mm:ss")%></b>&nbsp;[ <a href="<%=rootSystem%>/updatepwd.jsp">Change Password</a> ]&nbsp;</font></div>
    </td>
  </tr>
</table>

                        