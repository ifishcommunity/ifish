<%-- 
    Document   : uploadpicture
    Created on : Mar 15, 2015, 3:05:19 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@page language="java" %>
<%@page import="java.util.*" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="com.project.general.DbFile"%>
<%
System.out.println("...in uploadpicture");
String msgStatus = "";
// upload settings
int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB

// checks if the request actually contains upload file
if (!ServletFileUpload.isMultipartContent(request)) {
// if not, we stop here
    PrintWriter writer = response.getWriter();
    writer.println("Error: Form must has enctype=multipart/form-data.");
    writer.flush();
    return;
}

// configures upload settings
DiskFileItemFactory factory = new DiskFileItemFactory();
// sets memory threshold - beyond which file are stored in disk
factory.setSizeThreshold(MEMORY_THRESHOLD);
// sets temporary location to store file
factory.setRepository(new java.io.File(System.getProperty("java.io.tmpdir")));

ServletFileUpload upload = new ServletFileUpload(factory);

// sets maximum size of upload file
upload.setFileSizeMax(MAX_FILE_SIZE);

// sets maximum size of request (include file + form data)
upload.setSizeMax(MAX_REQUEST_SIZE);

// constructs the directory path to store upload file
// this path is relative to application's directory
String uploadPath = getServletContext().getRealPath("") + java.io.File.separator + DbFile.UPLOAD_DIRECTORY;

// creates the directory if it does not exist
java.io.File uploadDir = new java.io.File(uploadPath);
if (!uploadDir.exists()) {
    uploadDir.mkdir();
}

try {
    @SuppressWarnings("unchecked")
    List<FileItem> formItems = upload.parseRequest(request);
    if (formItems != null && formItems.size() > 0) {
        int i = 0;
        for (FileItem item : formItems) {
            System.out.println("loop " + i++);
            // processes only fields that are not form fields
            if (!item.isFormField()) {
                String fileName = new java.io.File(item.getName()).getName();
                String filePath = uploadPath + java.io.File.separator + fileName;
                java.io.File storeFile = new java.io.File(filePath);
                try {
                    item.write(storeFile);
                    msgStatus = "1";
                    System.out.println("done");
                } catch(Exception e) {
                    System.out.println("failed");
                }
            }
        }
    }
} catch (Exception ex) {
    out.println(ex.getMessage());
}

out.println(msgStatus);
%>