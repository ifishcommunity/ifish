
<html>
<head>
    <%@ include file = "main/javainit.jsp" %>
    <title><%=titleSystem%> - Not Authorized</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <link rel="stylesheet" href="style/main.css" type="text/css" />
</head>
<script language="javascript">
function cmdBack(){
    window.location = "<%=subSystem%>/dashboard.jsp"
}
</script>
<body bgcolor="#FFFFFF" text="#000000">
<h1><font color="#FF0000">Not Authorized</font></h1>
You do not have permission to access this module.<br>
Please contact your system administrator for more detail about access privilege!
<br>
<hr size="1">
<a href="javascript:cmdBack()" class="command"> Homepage</a> 
</body>
</html>
