package com.project.ifish.data;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class JspDeepSlope extends JSPHandler implements I_JSPInterface, I_JSPType {

    private DeepSlope deepslope;
    public static final String JSP_NAME_DEEPSLOPE = "JSP_NAME_DEEPSLOPE";
    public static final int JSP_OID = 0;
    public static final int JSP_APPROACH = 1;
    public static final int JSP_USER_ID = 2;
    public static final int JSP_PARTNER_ID = 3;
    public static final int JSP_LANDING_DATE = 4;
    public static final int JSP_LANDING_LOCATION = 5;
    public static final int JSP_WPP1 = 6;
    public static final int JSP_WPP2 = 7;
    public static final int JSP_WPP3 = 8;
    public static final int JSP_BOAT_ID = 9;
    public static final int JSP_FISHING_GEAR = 10;
    public static final int JSP_BROUGHT_BY = 11;
    public static final int JSP_OTHER_FISHING_GROUND = 12;
    public static final int JSP_SUPPLIER = 13;
    public static final int JSP_FISHERY_TYPE = 14;
    public static String[] fieldNames = {
        "JSP_OID",
        "JSP_APPROACH",
        "JSP_USER_ID",
        "JSP_PARTNER_ID",
        "JSP_LANDING_DATE",
        "JSP_LANDING_LOCATION",
        "JSP_WPP1",
        "JSP_WPP2",
        "JSP_WPP3",
        "JSP_BOAT_ID",
        "JSP_FISHING_GEAR",
        "JSP_BROUGHT_BY",
        "JSP_OTHER_FISHING_GROUND",
        "JSP_SUPPLIER",
        "JSP_FISHERY_TYPE"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public JspDeepSlope() {
    }

    public JspDeepSlope(DeepSlope deepSlope) {
        this.deepslope = deepSlope;
    }

    public JspDeepSlope(HttpServletRequest request, DeepSlope deepSlope) {
        super(new JspDeepSlope(deepSlope), request);
        this.deepslope = deepSlope;
    }

    public String getFormName() {
        return JSP_NAME_DEEPSLOPE;
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

    public DeepSlope getEntityObject() {
        return deepslope;
    }

    public void requestEntityObject(DeepSlope deepSlope) {
        try {
            this.requestParam();
            deepSlope.setApproach(getInt(JSP_APPROACH));
            deepSlope.setUserId(getLong(JSP_USER_ID));
            deepSlope.setPartnerId(getLong(JSP_PARTNER_ID));
            deepSlope.setLandingDate(JSPFormater.formatDate(getString(JSP_LANDING_DATE), "dd/MM/yyyy"));
            deepSlope.setLandingLocation(getString(JSP_LANDING_LOCATION));
            deepSlope.setWpp1(getString(JSP_WPP1));
            deepSlope.setWpp2(getString(JSP_WPP2));
            deepSlope.setWpp3(getString(JSP_WPP3));
            deepSlope.setBoatId(getLong(JSP_BOAT_ID));
            deepSlope.setFishingGear(getString(JSP_FISHING_GEAR));
            deepSlope.setBroughtBy(getString(JSP_BROUGHT_BY));
            deepSlope.setOtherFishingGround(getString(JSP_OTHER_FISHING_GROUND));
            deepSlope.setSupplier(getString(JSP_SUPPLIER));
            deepSlope.setFisheryType(getString(JSP_FISHERY_TYPE));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }
}
