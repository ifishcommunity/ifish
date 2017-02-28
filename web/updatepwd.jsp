 
<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import="com.project.general.User"%>
<%@ page import="com.project.general.DbUser"%>
<%@ page import = "java.util.Date" %>
<%@ include file="main/javainit.jsp"%>
<%
    int iJSPCommand = JSPRequestValue.requestCommand(request);
    String oldPwdError = "";
    String newPwdError = "";
    boolean isOK = true;
    long oid = 0;

    try {
        if (session.getValue("ADMIN_LOGIN") != null) {
            appSessUser = (QrUserSession) session.getValue("ADMIN_LOGIN");
        }
    } catch (Exception e) {
        appSessUser = null;
        response.sendRedirect(rootSystem + "/index.jsp");
    }
    
    if (iJSPCommand == JSPCommand.SAVE) {

        String loginId = JSPRequestValue.requestString(request, "login_id");
        String oldPwd = JSPRequestValue.requestString(request, "old_password");
        String newPwd = JSPRequestValue.requestString(request, "new_password");
        String cnfNewPwd = JSPRequestValue.requestString(request, "cnf_new_password");

        //check form
        if (oldPwd.length() == 0) {
            oldPwdError = "Entry Required";
            isOK = false;
        }

        if (newPwd.length() == 0) {
            newPwdError = "Entry Required";
            if (isOK) {
                isOK = false;
            }
        } else {
            if (newPwd.length() < 5) {
                newPwdError = "Minimum 5 digit character";
                if (isOK) {
                    isOK = false;
                }
            }

            if (!newPwd.equals(cnfNewPwd)) {
                newPwdError = "Confirm password incorrect";
                if (isOK) {
                    isOK = false;
                }
            }

            if (newPwd.equals(oldPwd)) {
                newPwdError = "Can't Use Previous Password";
                if (isOK) {
                    isOK = false;
                }
            }
        }

        User updateuser = new User();
        try {
            if (session.getValue("ADMIN_LOGIN") != null) {
                appSessUser = (QrUserSession) session.getValue("ADMIN_LOGIN");
                updateuser = DbUser.fetch(appSessUser.getUserOID());
                String md5OldPwd = MD5.getMD5Hash(oldPwd);
                
                if ((!updateuser.getPassword().equals(md5OldPwd)) && oldPwd.length() != 0) {
                    oldPwdError = "Invalid password";
                    if (isOK) {
                        isOK = false;
                    }
                }
            } else {
                appSessUser = null;
                response.sendRedirect(rootSystem + "/index.jsp");
            }
        } catch (Exception exc) {
            appSessUser = null;
            response.sendRedirect(rootSystem + "/index.jsp");
        }

        if (isOK) {
            try {
                String md5NewPwd = MD5.getMD5Hash(newPwd);
                updateuser.setPassword(md5NewPwd);
                updateuser.setResetPassword(false);
                oid = DbUser.update(updateuser);
            } catch (Exception e) {
            }
        }
    }

%>
<html >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>UPDATE PASSWORD</title>
<link href="css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
<!--
<%if(isOK && oid!=0 && iJSPCommand==JSPCommand.SAVE){%>
	alert('Your password has been updated, please re-login with your new password !');
	window.location="<%=rootSystem%>/index.jsp"
<%}%>

function cmdBack(){
    window.history.back();
}

function cmdSave(){
    document.form1.command.value="<%=JSPCommand.SAVE%>";
    document.form1.action="updatepwd.jsp";
    document.form1.submit();
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
//-->
</script>
</head>
<body onLoad="MM_preloadImages('<%=rootSystem%>/images/home2.gif','<%=rootSystem%>/images/logout2.gif','images/save2.gif')">
<table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
  <tr> 
    <td align="center" valign="middle">
      <table cellpadding="0" cellspacing="0" border="0">
        <tr> 
          <td>
            <form id="form1" name="form1" method="post" action="">
              <input type="hidden" name="command">
              <table width="100%" align="center" border="0" cellspacing="1" cellpadding="1">
                  <tr valign="top">
                    <td colspan="2" height="28"><b>UPDATE PASSWORD</b></td>
                  </tr>
                  <% if(appSessUser.isResetPassword()) { %>
                  <tr valign="top">
                    <td colspan="2"><u>As a best practice, we recommend changing your password periodically to enhance security.</u></td>
                  </tr>
                  <tr>
                    <td width="30%">&nbsp;</td>
                    <td width="70%">&nbsp;</td>
                  </tr>
                  <% } %>
                  <tr>
                    <td width="30%">Login ID</td>
                    <td width="70%"><input type="text" name="login_id" size="30" readOnly class="readonly" value="<%=appSessUser.getLoginId()%>"></td>
                  </tr>
                  <tr>
                    <td width="30%">Old Password</td>
                    <td width="70%"><input type="password" name="old_password" size="30">*</td>
                  </tr>
                  <tr>
                    <td width="30%">&nbsp;</td>
                    <td width="70%"><span class="errfont"><%=oldPwdError%></span></td>
                  </tr>
                  <tr>
                    <td width="30%">New Password</td>
                    <td width="70%"><input type="password" name="new_password" size="30">*</td>
                  </tr>
                  <tr>
                    <td width="30%" nowrap>Confirm New Password</td>
                    <td width="70%"><input type="password" name="cnf_new_password" size="30">*</td>
                  </tr>
                  <tr>
                    <td width="30%">&nbsp;</td>
                    <td width="70%"><span class="errfont"><%=newPwdError%></span></td>
                  </tr>
                  <tr>
                    <td colspan="2"><% if(!appSessUser.isResetPassword()) { %><a href="javascript:cmdBack()"><b><font color="#0000FF">Back</font></b></a>
                    | <% } %><a href="javascript:cmdSave()"><b><font color="#0000FF">Save</font></b></a></td>
                  </tr>
              </table>
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html>
