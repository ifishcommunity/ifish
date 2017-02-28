package com.project.general;

public class AppMenu {

    /** Creates a new instance of AppMenu */
    public AppMenu() {
    }

    public static final int PRIV_VIEW = 0;
    public static final int PRIV_ADD = 1;
    public static final int PRIV_EDIT = 2;
    public static final int PRIV_DELETE = 3;

    public static final int MENU_DASHBOARD_CONSTANT = 100;
    public static final int MENU_GENERAL_CONSTANT = 200;
    public static final int MENU_IFISH_CONSTANT = 300;

    /***************************** Begin Dashboard *****************************/

    public static final int M1_MENU_DASHBOARD = 0;
    public static final int M2_MENU_DASHBOARD_DOWNLOADABLE_RESOURCES = 0;
    public static final int M2_MENU_DASHBOARD_PUBLICATION = 1;
    public static final int M2_MENU_DASHBOARD_LANDING_UPDATE = 2;
    public static final int M2_MENU_DASHBOARD_SPOTTRACE_STATUS = 3;

    public static final String[] strMenuDashboard1 = {
        "Dashboard"
    };

    public static final String[][] strMenuDashboard2 = {
        {"Downloadable Resources", "Publication", "Landing Update", "SpotTrace Status"}
    };

    /****************************** End Dashboard ******************************/

    /****************************** Begin General ******************************/

    public static final int M1_GENERAL = 0;
    public static final int M2_GENERAL_OTHER = 0;
    public static final int M2_GENERAL_USER = 1;

    public static final String[] strMenuGeneral1 = {
        "General"
    };

    public static final String[][] strMenuGeneral2 = {
        {"Other", "User"}
    };

    /******************************* End General *******************************/

    /*************************** Begin I-Fish **************************/

    public static final int M1_IFISH_MASTER = 0;
    public static final int M2_IFISH_MASTER_SPOT_TRACE = 0;
    public static final int M2_IFISH_MASTER_FISH = 1;
    public static final int M2_IFISH_MASTER_PARTNER = 2;
    public static final int M2_IFISH_MASTER_BOAT = 3;

    public static final int M1_IFISH_DATA = 1;
    public static final int M2_IFISH_DATA_APPROVAL = 0;
    public static final int M2_IFISH_DATA_SWMS = 1;
    public static final int M2_IFISH_DATA_CODRS = 2;

    public static final int M1_IFISH_REPORT = 2;
    public static final int M2_IFISH_REPORT_SPOT_TRACE = 0;
    public static final int M2_IFISH_REPORT_USER_LOGS = 1;
    public static final int M2_IFISH_REPORT_SWMS = 2;
    public static final int M2_IFISH_REPORT_MDCU = 3;
    public static final int M2_IFISH_REPORT_CODRS = 4;

    public static final String[] strMenuIFish1 = {
        "Master", "Data", "Report"
    };

    public static final String[][] strMenuIFish2 = {
        {"Spot Trace", "Fish", "Partner", "Boat"},
        {"Approval", "SWMS", "CODRS"},
        {"Spot Trace", "User Logs", "SWMS", "MDCU", "CODRS"}
    };

    /**************************** End I-Fish ***************************/
}
