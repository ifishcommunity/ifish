<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.blob.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.general.*" %>
<%@ include file = "../main/javainit.jsp" %>
<%
int menuIdx = JSPRequestValue.requestInt(request, "menu_idx");
long userOid = JSPRequestValue.requestLong(request, "user_oid");
User appUser = new User();
QrPictureSave qrPictureSave = new QrPictureSave();
ImageLoader uploader = new ImageLoader();

try {
    appUser = DbUser.fetch(userOid);
    uploader.uploadImage(config, request, response);
    Object obj = uploader.getImage(QrPictureSave.JSP_USER_PICTURE);
    if (obj != null) {
        qrPictureSave.updateImage(obj, appUser.getLoginId());
    }
} catch (Exception e) {
    System.out.println(e.toString());
}

Thread.sleep(5000);
%>
<%
response.sendRedirect(rootSystem + "/admin/userimage.jsp?user_oid=" + userOid + "&menu_idx=" + menuIdx);
%>
