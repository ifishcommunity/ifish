package com.project.ifish.master;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class JspPartner extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Partner partner;
    public static final String JSP_NAME_PARTNER = "JSP_NAME_PARTNER";
    public static final int JSP_TYPE = 0;
    public static final int JSP_NAME = 1;
    public static final int JSP_ADDRESS = 2;
    public static final int JSP_CP = 3;
    public static final int JSP_PHONE = 4;
    public static final int JSP_EMAIL = 5;
    public static final int JSP_NOTES = 6;
    public static final int JSP_SERVER_STATUS = 7;
    public static final int JSP_SERVER_IP = 8;
    public static String[] fieldNames = {
        "JSP_TYPE",
        "JSP_NAME",
        "JSP_ADDRESS",
        "JSP_CP",
        "JSP_PHONE",
        "JSP_EMAIL",
        "JSP_NOTES",
        "JSP_SERVER_STATUS",
        "JSP_SERVER_IP"
    };
    public static int[] fieldTypes = {
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING
    };

    public JspPartner() {
    }

    public JspPartner(Partner partner) {
        this.partner = partner;
    }

    public JspPartner(HttpServletRequest request, Partner partner) {
        super(new JspPartner(partner), request);
        this.partner = partner;
    }

    public String getFormName() {
        return JSP_NAME_PARTNER;
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

    public Partner getEntityObject() {
        return partner;
    }

    public void requestEntityObject(Partner partner) {
        try {
            this.requestParam();
            partner.setType(getString(JSP_TYPE));
            partner.setName(getString(JSP_NAME));
            partner.setAddress(getString(JSP_ADDRESS));
            partner.setCp(getString(JSP_CP));
            partner.setPhone(getString(JSP_PHONE));
            partner.setEmail(getString(JSP_EMAIL));
            partner.setNotes(getString(JSP_NOTES));
            partner.setServerStatus(getInt(JSP_SERVER_STATUS));
            partner.setServerIP(getString(JSP_SERVER_IP));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
