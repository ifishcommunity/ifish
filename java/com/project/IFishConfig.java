package com.project;

/**
 *
 * @author gwawan
 */
public class IFishConfig {
    /**
     * ALL VALUE IN THIS FILE CANNOT EDITED!
     */
    public static final int UUID_KEY = 8;

    // Gear type
    public static final String GEAR_TYPE_DROPLINE = "Dropline";
    public static final String GEAR_TYPE_LONGLINE = "Longline";
    public static final String GEAR_TYPE_HL_PNL = "Handline_PoleAndLine";
    public static final String GEAR_TYPE_OTHERS = "Others";

    // Fishery type
    public static final String FISHERY_TYPE_SNAPPER = "Snapper";
    public static final String FISHERY_TYPE_TUNA = "Tuna";
    public static final String FISHERY_TYPE_SHARK = "Shark";
    public static final String FISHERY_TYPE_OTHERS = "Others";
    
    // Data quality
    public static final int DATA_QUALITY_POOR = 0;
    public static final int DATA_QUALITY_GOOD = 1;

    // Image type
    public static final String IMAGE_ORIGINAL = "original";
    public static final String IMAGE_CENSORED = "censored";
    public static final String IMAGE_LARGEST = "largest";

    // The approach used in data collection
    public static final int APPROACH_SWMS = 0;
    public static final int APPROACH_MDCU = 1;
    public static final int APPROACH_CODRS = 2;
    public static final String[] strApproachType = {"Smart Measuring", "mDCU", "CODRS"};

    // Application path
    public static final String API_PATH = "api";
    public static final String IMG_PATH = "users";
    public static final String IMG_EXTENSIONS = ".jpg";

    // Variable for mapping between I-Fish Community and mDUC
    public static final int NODE_USER = 0;
    public static final int NODE_LANDING_LOCATION = 1;
    public static final int NODE_BOAT = 2;
    public static final int NODE_FISH = 3;
    public static final String[] nodeNames = { "user", "landinglocation", "boat", "fish" };

    // Document status
    public static final String DOC_STATUS_DRAFT = "Draft";
    public static final String DOC_STATUS_POSTED = "Posted";
    public static final String DOC_STATUS_CANCEL = "Cancel";

    // Process status
    public static final int STATUS_DRAFT = 0;
    public static final int STATUS_POSTED = 1;

    // List of Spot Trace status
    public static final int STATUS_INACTIVE = 0;
    public static final int STATUS_ACTIVE = 1;
    public static final int STATUS_BROKEN = 2;
    public static final int STATUS_LOST = 3;
    public static String[] strStatus = {"Inactive", "Active", "Broken", "Lost"};

    // Partner type
    public static final String PARTNER_FISHERMAN = "Fisherman";
    public static final String PARTNER_FISH_TRADER = "Fish Trader";
    public static final String PARTNER_COMPANY = "Company";

    // User login status
    public static final int LOGIN_STATUS_NEW = 0;
    public static final int LOGIN_STATUS_SIGNOUT = 1;
    public static final int LOGIN_STATUS_SIGNIN = 2;
    public static final String[] strLoginStatus = {"New", "Sign Out", "Sign In"};

    // JSP name for API
    public static final String JSP_SERVER_IP = "JSP_SERVER_IP";
    public static final String JSP_TRANSACTION_DATE = "JSP_TRANSACTION_DATE";

    // Length basis used on LFD
    public static final String LENGTH_BASIS_TL = "TL";
    public static final String LENGTH_BASIS_FL = "FL";
    public static final String LENGTH_BASIS_SL = "SL";

    // Program Site as lable to categorize list of boats
    public static final String SITE_BALI = "Bali";
    public static final String SITE_KEMA = "Kema";
    public static final String SITE_KUPANG = "Kupang";
    public static final String SITE_LUWUK = "Luwuk";
    public static final String SITE_PROBOLINGGO = "Probolinggo";
    public static final String SITE_SORONG = "Sorong";
    public static final String SITE_TANJUNG_LUAR = "Tanjung Luar";
    public static final String SITE_TIMIKA = "Timika";
    public static final String SITE_DOBO = "Dobo";
    public static final String SITE_OTHERS = "Others";

    // Report Area
    public static final String AREA_A = "Area-A"; //WPP-573 + JPDA
    public static final String AREA_B = "Area-B"; //WPP-712 + WPP-713
    public static final String AREA_C = "Area-C"; //WPP-714 + WPP-715
    public static final String AREA_D = "Area-D"; //WPP-718
}
