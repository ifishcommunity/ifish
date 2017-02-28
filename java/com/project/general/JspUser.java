package com.project.general;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

public class JspUser extends JSPHandler implements I_JSPInterface, I_JSPType {

    public static final String JSP_APP_USER = "JSP_APP_USER";
    public static final int JSP_LOGIN_ID = 0;
    public static final int JSP_PASSWORD = 1;
    public static final int JSP_CONFIRM_PASSWORD = 2;
    public static final int JSP_FULL_NAME = 3;
    public static final int JSP_EMAIL = 4;
    public static final int JSP_DESCRIPTION = 5;
    public static final int JSP_UPDATE_DATE = 6;
    public static final int JSP_LOGIN_STATUS = 7;
    public static final int JSP_BOAT_ID = 8;
    public static final int JSP_PARTNER_ID = 9;
    public static final int JSP_GROUP_ID = 10;
    public static final int JSP_STATUS = 11;
    public static final int JSP_UALD = 12;
    
    public static final String[] colNames = {
        "JSP_LOGIN_ID",
        "JSP_PASSWORD",
        "JSP_CONFIRM_PASSWORD",
        "JSP_FULL_NAME",
        "JSP_EMAIL",
        "JSP_DESCRIPTION",
        "JSP_UPDATE_DATE",
        "JSP_LOGIN_STATUS",
        "JSP_BOAT_ID",
        "JSP_PARTNER_ID",
        "JSP_GROUP_ID",
        "JSP_STATUS",
        "JSP_UALD"
    };
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + FORMAT_EMAIL,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT
    };
    private User appUser = new User();

    /** Creates new JspUser */
    public JspUser() {
    }

    public JspUser(HttpServletRequest request) {
        super(new JspUser(), request);
    }

    public String getFormName() {
        return JSP_APP_USER;
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

    public User getEntityObject() {
        return appUser;
    }

    public void requestEntityObject(User entObj) {
        try {
            this.requestParam();
            entObj.setLoginId(this.getString(JSP_LOGIN_ID));
            entObj.setPassword(this.getString(JSP_PASSWORD));
            entObj.setFullName(this.getString(JSP_FULL_NAME));
            entObj.setEmail(this.getString(JSP_EMAIL));
            entObj.setDescription(this.getString(JSP_DESCRIPTION));            
            entObj.setLoginStatus(this.getInt(JSP_LOGIN_STATUS));
            entObj.setUpdateDate(JSPFormater.formatDate(this.getString(JSP_UPDATE_DATE), "yyyy-MM-dd hh:mm:ss"));
            entObj.setPartnerId(this.getLong(JSP_PARTNER_ID));
            entObj.setGroupId(this.getLong(JSP_GROUP_ID));
            entObj.setStatus(this.getInt(JSP_STATUS));
            entObj.setUald(this.getInt(JSP_UALD));
            this.appUser = entObj;
        } catch (Exception e) {
            System.out.println("exception : " + e);
            entObj = new User();
        }
    }
}

