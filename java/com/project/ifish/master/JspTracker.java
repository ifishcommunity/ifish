package com.project.ifish.master;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class JspTracker extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Tracker tracker;
    public static final String JSP_NAME_TRACKER = "JSP_NAME_TRACKER";
    public static final int JSP_TRACKER_ID = 0;
    public static final int JSP_TRACKER_NAME = 1;
    public static final int JSP_FEED_ID = 2;
    public static final int JSP_STATUS = 3;
    public static final int JSP_AUTH_CODE = 4;
    public static final int JSP_NOTES = 5;
    public static String[] fieldNames = {
        "JSP_TRACKER_ID",
        "JSP_TRACKER_NAME",
        "JSP_FEED_ID",
        "JSP_STATUS",
        "JSP_AUTH_CODE",
        "JSP_NOTES"
    };
    public static int[] fieldTypes = {
        TYPE_LONG + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_INT,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING
    };

    public JspTracker() {
    }

    public JspTracker(Tracker tracker) {
        this.tracker = tracker;
    }

    public JspTracker(HttpServletRequest request, Tracker tracker) {
        super(new JspTracker(tracker), request);
        this.tracker = tracker;
    }

    public String getFormName() {
        return JSP_NAME_TRACKER;
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

    public Tracker getEntityObject() {
        return tracker;
    }

    public void requestEntityObject(Tracker tracker) {
        try {
            this.requestParam();
            tracker.setTrackerId(getLong(JSP_TRACKER_ID));
            tracker.setTrackerName(getString(JSP_TRACKER_NAME));
            tracker.setFeedId(getString(JSP_FEED_ID));
            tracker.setStatus(getInt(JSP_STATUS));
            tracker.setAuthCode(getString(JSP_AUTH_CODE));
            tracker.setNotes(getString(JSP_NOTES));
        } catch (Exception e) {
            System.out.println("Error on requestEntityObject : " + e.toString());
        }
    }
}
