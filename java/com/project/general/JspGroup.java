package com.project.general;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspGroup extends JSPHandler implements I_JSPInterface, I_JSPType {

    public static final String JSP_APP_GROUP = "JSP_APP_GROUP";
    public static final int JSP_GROUP_NAME = 0;
    public static final int JSP_REG_DATE = 1;
    public static final int JSP_DESCRIPTION = 2;
    public static final int JSP_GROUP_PRIV = 3;
    public static String[] colNames = {
        "JSP_GROUP_NAME",
        "JSP_REG_DATE",
        "JSP_DESCRIPTION",
        "JSP_GROUP_PRIV"
    };
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_COLLECTION
    };
    private Group appGroup = new Group();

    public JspGroup() {
    }

    public JspGroup(HttpServletRequest request) {
        super(new JspGroup(), request);
    }

    public String getFormName() {
        return JSP_APP_GROUP;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public Group getEntityObject() {
        return appGroup;
    }

    public void requestEntityObject(Group appGroup) {
        try {
            this.requestParam();
            appGroup.setGroupName(this.getString(JSP_GROUP_NAME));
            appGroup.setDescription(this.getString(JSP_DESCRIPTION));
            appGroup.setRegDate(this.getDate(JSP_REG_DATE));

            this.appGroup = appGroup;
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
            appGroup = new Group();
        }
    }
}
