package com.project.general;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class JspFile extends JSPHandler implements I_JSPInterface, I_JSPType {

    private File file;
    public static final String JSP_NAME_FILE = "JSP_NAME_FILE";
    public static final int JSP_FILE_ID = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_NOTES = 2;
    public static final int JSP_REF_ID = 3;
    public static String[] fieldNames = {
        "JSP_FILE_ID",
        "JSP_NAME",
        "JSP_NOTES",
        "JSP_REF_ID"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_LONG
    };

    public JspFile() {
    }

    public JspFile(File file) {
        this.file = file;
    }

    public JspFile(HttpServletRequest request, File file) {
        super(new JspFile(file), request);
        this.file = file;
    }

    public String getFormName() {
        return JSP_NAME_FILE;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public File getEntityObject() {
        return file;
    }

    public void requestEntityObject(File file) {
        try {
            this.requestParam();
            file.setName(getString(JSP_NAME));
            file.setNotes(getString(JSP_NOTES));
            file.setRefId(getLong(JSP_REF_ID));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }
}
