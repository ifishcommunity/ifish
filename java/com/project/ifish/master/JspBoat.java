package com.project.ifish.master;

import com.project.util.JSPFormater;
import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class JspBoat extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Boat boat;
    public static final String JSP_NAME_BOAT = "JSP_NAME_BOAT";
    public static final int JSP_GEAR_TYPE = 0;
    public static final int JSP_CODE = 1;
    public static final int JSP_NAME = 2;
    public static final int JSP_HOME_PORT = 3;
    public static final int JSP_LENGTH = 4;
    public static final int JSP_WIDTH = 5;
    public static final int JSP_YEAR_BUILT = 6;
    public static final int JSP_GROSS_TONNAGE = 7;
    public static final int JSP_IS_ENGINE = 8;
    public static final int JSP_ENGINE_HP = 9;
    public static final int JSP_OWNER = 10;
    public static final int JSP_OWNER_ORIGIN = 11;
    public static final int JSP_CAPTAIN = 12;
    public static final int JSP_CAPTAIN_ORIGIN = 13;
    public static final int JSP_PARTNER_ID = 14;
    public static final int JSP_TRACKER_ID = 15;
    public static final int JSP_TRACKER_STATUS = 16;
    public static final int JSP_TRACKER_START_DATE = 17;
    public static final int JSP_TRACKER_END_DATE = 18;
    public static final int JSP_PROGRAM_SITE = 19;
    public static String[] fieldNames = {
        "JSP_GEAR_TYPE",
        "JSP_CODE",
        "JSP_NAME",
        "JSP_HOME_PORT",
        "JSP_LENGTH",
        "JSP_WIDTH",
        "JSP_YEAR_BUILT",
        "JSP_GROSS_TONNAGE",
        "JSP_IS_ENGINE",
        "JSP_ENGINE_HP",
        "JSP_OWNER",
        "JSP_OWNER_ORIGIN",
        "JSP_CAPTAIN",
        "JSP_CAPTAIN_ORIGIN",
        "JSP_PARTNER_ID",
        "JSP_TRACKER_ID",
        "JSP_TRACKER_STATUS",
        "JSP_TRACKER_START_DATE",
        "JSP_TRACKER_END_DATE",
        "JSP_PROGRAM_SITE"
    };
    public static int[] fieldTypes = {
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_LONG,
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING + ENTRY_REQUIRED
    };

    public JspBoat() {
    }

    public JspBoat(Boat boat) {
        this.boat = boat;
    }

    public JspBoat(HttpServletRequest request, Boat boat) {
        super(new JspBoat(boat), request);
        this.boat = boat;
    }

    public String getFormName() {
        return JSP_NAME_BOAT;
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

    public Boat getEntityObject() {
        return boat;
    }

    public void requestEntityObject(Boat boat) {
        try {
            this.requestParam();
            boat.setGearType(getString(JSP_GEAR_TYPE));
            boat.setCode(getString(JSP_CODE));
            boat.setName(getString(JSP_NAME));
            boat.setHomePort(getString(JSP_HOME_PORT));
            boat.setLength(getDouble(JSP_LENGTH));
            boat.setWidth(getDouble(JSP_WIDTH));
            boat.setYearBuilt(getInt(JSP_YEAR_BUILT));
            boat.setGrossTonnage(getInt(JSP_GROSS_TONNAGE));
            boat.setIsEngine(getInt(JSP_IS_ENGINE));
            boat.setEngineHP(getInt(JSP_ENGINE_HP));
            boat.setOwner(getString(JSP_OWNER));
            boat.setOwnerOrigin(getString(JSP_OWNER_ORIGIN));
            boat.setCaptain(getString(JSP_CAPTAIN));
            boat.setCaptainOrigin(getString(JSP_CAPTAIN_ORIGIN));
            boat.setPartnerId(getLong(JSP_PARTNER_ID));
            boat.setTrackerId(getLong(JSP_TRACKER_ID));
            boat.setTrackerStatus(getInt(JSP_TRACKER_STATUS));
            boat.setTrackerStartDate(JSPFormater.formatDate(getString(JSP_TRACKER_START_DATE), "dd/MM/yyyy"));
            boat.setTrackerEndDate(JSPFormater.formatDate(getString(JSP_TRACKER_END_DATE), "dd/MM/yyyy"));
            boat.setProgramSite(getString(JSP_PROGRAM_SITE));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
