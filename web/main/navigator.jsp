<table width="100%" border="0" cellspacing="1" cellpadding="1" height="17">
    <tr valign="bottom">
        <td width="60%" height="23"><%=navigator%></td>
        <td width="40%" height="23">
            <table width="100%%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td nowrap>
                        <div align="right"><font face="Arial, Helvetica, sans-serif"><b><%=user.getFullName().toUpperCase()%> , Login : <%=JSPFormater.formatDate(user.getLastLoginDate(), "dd/MM/yyyy HH:mm:ss")%>&nbsp; </b>[ <a href="<%=rootSystem%>/logout.jsp">Logout</a> , <a href="<%=rootSystem%>/updatepwd.jsp">Change Password</a> ]<b>&nbsp;&nbsp;&nbsp;</b></font></div></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr >
        <td colspan="2" height="3" background="<%=rootSystem%>/images/line1.gif" ></td>
    </tr>
</table>