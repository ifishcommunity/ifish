
<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.general.*" %>
<%@ include file="main/javainit.jsp"%> 
<%!
 final static int CMD_NONE =0;
 final static int CMD_LOGIN=1;
 final static int MAX_SESSION_IDLE=2500000;
%>
<%
int iCommand = JSPRequestValue.requestCommand(request);
int dologin = 0;
boolean isResetPassword = false;

try {
    if (session.getValue("ADMIN_LOGIN") != null) {
        session.removeValue("ADMIN_LOGIN");
    }
} catch (Exception e) {
    System.out.println(" ==> Exception during remove all menu session");
    e.printStackTrace();
}

dologin = QrUserSession.DO_LOGIN_OK;
if (iCommand == CMD_LOGIN) {
    String loginID = JSPRequestValue.requestString(request, "login_id");
    String passwd = JSPRequestValue.requestString(request, "pass_wd");
    String remoteIP = request.getRemoteAddr();
    QrUserSession userQr = new QrUserSession(remoteIP);

    session.putValue("APP_LANG", String.valueOf(JSPRequestValue.requestInt(request, "lang")));
    dologin = userQr.doLogin(loginID, passwd);

    if (dologin == QrUserSession.DO_LOGIN_OK) {
        session.setMaxInactiveInterval(MAX_SESSION_IDLE);
        session.putValue("ADMIN_LOGIN", userQr);
        userQr = (QrUserSession) session.getValue("ADMIN_LOGIN");
        isResetPassword = userQr.isResetPassword();
    }
}

String msg = "";

if (iCommand == CMD_LOGIN) {
    if (dologin == QrUserSession.DO_LOGIN_OK) {
        if (isResetPassword) {
            response.sendRedirect("updatepwd.jsp");
        } else {
            response.sendRedirect(subSystem + "/dashboard.jsp");
        }
    } else {
        msg = "Login ID or password invalid";
        response.sendRedirect(rootSystem + "/index.jsp");
    }
}
%>
<html>
<head>
<title><%=titleSystem%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="css/css.css" type="text/css">
<link rel="stylesheet" href="css/css1.css" type="text/css">
<link rel="shortcut icon" href="images/ifish-community-icon.ico" />
</head>
<body>
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
  <%if(!isSystemActive){%>
  <tr>
    <td align="center" valign="middle">
        Your Licence System Expired<br>
        please contact your system administrator<br>
        Gede Wawan<br>
        081328392576<br>
        gede.wawan@gmail.com
    </td>
  </tr>
  <%}else{%>
  <tr> 
    <td align="center" valign="middle"> 
      <table cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td width="220">
            <form  name="frmLogin" method="post" onSubmit="javascript:cmdLogin()">
              <input type="hidden" name="sel_top_mn" value="4">
              <input type="hidden" name="command" value="<%=CMD_LOGIN%>">
              <table width="100%" border="0" align="center" cellpadding="2" cellspacing="2">
                <tr> 
                  <td align="right" width="37%"> 
                    <div align="left"><font face="arial" size="3" color="#609836"><b><%=titleSystem%></b></font></div>
                  </td>
                </tr>
                <tr> 
                  <td align="right" width="37%"> 
                    <div align="left"><strong><i><font color="#609836">Username</font></i></strong></div>
                  </td>
                </tr>
                <tr> 
                  <td width="37%" align="right"> 
                    <div align="left"> 
                      <input type="text" name="login_id" class="input_text" value="" size="30" onClick="this.select()">
                    </div>
                  </td>
                </tr>
                <tr> 
                  <td align="right" width="37%"> 
                    <div align="left"><strong><i><font color="#609836">Password</font></i></strong></div>
                  </td>
                </tr>
                <tr> 
                  <td align="right" width="37%"> 
                    <div align="left"> 
                      <input type="password" name="pass_wd" class="input_text" value="" size="30" onClick="this.select()">
                    </div>
                  </td>
                </tr>
                <tr class="text" align="center"> 
                  <td height="10" colspan="5" valign="top"></td>
                </tr>
                <tr class="text" align="center"> 
                  <td height="22" colspan="5" valign="top"> 
                    <div align="left"> 
                      <input type="submit" name="Submit" value="  Login " onClick="javascript:cmdLogin()" style="background-color:#609836; width:58; height:23; border:0px; vertical-align:middle; color:#FFFFFF; font-family:Geneva, Arial, Helvetica, sans-serif; font-size:11px; font-weight:bold;">
                    </div>
                  </td>
                </tr>
                <tr> 
                  <td align="right"  height="27" width="37%"> 
                    <div align="left">&nbsp;</div>
                  </td>
                </tr>
                <tr class="text"> 
                  <td height="10" colspan="5" valign="bottom" align="left"> 
                    <div align="center"></div>
                  </td>
                </tr>
                <%if(msg.length()>0){%>
                <tr class="text"> 
                  <td height="10" colspan="5" valign="bottom" align="left"> 
                    <div align="center"><font color="#FF0000"><%=msg%></font></div>
                  </td>
                </tr>
                <%}%>
                <tr> 
                  <td height="10" colspan="5" valign="bottom" align="left"> 
                    <div align="center"></div>
                  </td>
              </table>
                <script language="JavaScript">
                    document.frmLogin.login_id.focus();
                </script>
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <%}%>
</table>
</body>
</html>
