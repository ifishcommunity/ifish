<%@ page import="com.project.general.*"%>
<%
session.setMaxInactiveInterval(2500000);
try {
    if (session.getValue("ADMIN_LOGIN") != null) {
        appSessUser = (QrUserSession) session.getValue("ADMIN_LOGIN");
        user = appSessUser.getUser();
        try {
            user = DbUser.fetch(user.getOID());
        } catch (Exception e) {
        }
    } else {
        appSessUser = null;
        response.sendRedirect(rootSystem + "/index.jsp");
    }
} catch (Exception exc) {
    appSessUser = null;
    response.sendRedirect(rootSystem + "/index.jsp");
}

if(appSessUser==null){ appSessUser = new QrUserSession(); }

boolean privHome = true;

boolean privDashboardDownloadableResources = appSessUser.isPriviledged((AppMenu.MENU_DASHBOARD_CONSTANT + AppMenu.M1_MENU_DASHBOARD), AppMenu.M2_MENU_DASHBOARD_DOWNLOADABLE_RESOURCES);
boolean privDashboardPublication = appSessUser.isPriviledged((AppMenu.MENU_DASHBOARD_CONSTANT + AppMenu.M1_MENU_DASHBOARD), AppMenu.M2_MENU_DASHBOARD_PUBLICATION);
boolean privDashboardLandingUpdate = appSessUser.isPriviledged((AppMenu.MENU_DASHBOARD_CONSTANT + AppMenu.M1_MENU_DASHBOARD), AppMenu.M2_MENU_DASHBOARD_LANDING_UPDATE);
boolean privDashboardSpotTraceStatus = appSessUser.isPriviledged((AppMenu.MENU_DASHBOARD_CONSTANT + AppMenu.M1_MENU_DASHBOARD), AppMenu.M2_MENU_DASHBOARD_SPOTTRACE_STATUS);

boolean privGeneralOther = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_OTHER);
boolean privGeneralUser = appSessUser.isPriviledged((AppMenu.MENU_GENERAL_CONSTANT + AppMenu.M1_GENERAL), AppMenu.M2_GENERAL_USER);

boolean privMasterSpotTrace = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_SPOT_TRACE);
boolean privMasterFish = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_FISH);
boolean privMasterPartner = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_PARTNER);
boolean privMasterBoat = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_MASTER), AppMenu.M2_IFISH_MASTER_BOAT);

boolean privDataApproval = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_APPROVAL);
boolean privDataSWMS = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_SWMS);
boolean privDataCODRS = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_CODRS);

boolean privReportSpotTrace = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_SPOT_TRACE);
boolean privReportUserLogs = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_USER_LOGS);
boolean privReportSWMS = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_SWMS);
boolean privReportMDCU = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_MDCU);
boolean privReportCODRS = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_REPORT), AppMenu.M2_IFISH_REPORT_CODRS);

boolean privUALD = user.getUald()==1?true:false;

//Privilege for edit or delete CODRS data
boolean privEditCODRS = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_CODRS, AppMenu.PRIV_EDIT);
boolean privDeleteCODRS = appSessUser.isPriviledged((AppMenu.MENU_IFISH_CONSTANT + AppMenu.M1_IFISH_DATA), AppMenu.M2_IFISH_DATA_CODRS, AppMenu.PRIV_DELETE);
%>
