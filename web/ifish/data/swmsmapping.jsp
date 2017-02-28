<%-- 
    Document   : swmsmapping
    Created on : Nov 1, 2016, 4:12:00 PM
    Author     : gwawan
--%>

<% ((HttpServletResponse)response).addCookie(new Cookie("JSESSIONID",session.getId())) ; %>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.general.*" %>
<%@ page import="com.project.IFishConfig"%>
<%@ page import="com.project.main.db.OIDGenerator"%>
<%@ page import="com.project.ifish.master.DbFish"%>
<%@ page import="com.project.ifish.master.Fish"%>
<%@ page import="com.project.ifish.data.DbDeepSlope"%>
<%@ page import="com.project.ifish.data.DeepSlope"%>
<%@ page import="com.project.ifish.master.Partner" %>
<%@ page import="com.project.ifish.master.DbPartner" %>
<%@ page import="com.project.ifish.master.Boat" %>
<%@ page import="com.project.ifish.master.DbBoat" %>
<%@ page import="com.project.ifish.master.Tracker" %>
<%@ page import="com.project.ifish.master.DbTracker" %>
<%@ page import="com.project.ifish.data.FindMeSpot" %>
<%@ page import="com.project.ifish.data.DbFindMeSpot" %>
<%@ page import="com.project.ifish.session.SessSpotTrace" %>
<%@ page import="com.project.insite.DbOffLoading"%>
<%@ page import="com.project.insite.OffLoading"%>
<%@ page import="com.project.insite.DbSizing"%>
<%@ page import="com.project.insite.Sizing"%>
<%@ include file="../../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>
<!-- Jsp Block -->

<%
Vector listPartner = DbPartner.listAll();
Hashtable hPartner = new Hashtable();
if(listPartner != null && listPartner.size() > 0) {
    for(int i=0; i<listPartner.size(); i++) {
        Partner partner = (Partner) listPartner.get(i);
        hPartner.put(partner.getOID(), partner);
    }
}

//Get list of Insite OffLoading
Vector listOffLoading = DbOffLoading.listLatestOffLoading(0, 0);

for (int n = 0; n < listOffLoading.size(); n++) {
    OffLoading insiteOffLoading = (OffLoading) listOffLoading.get(n);

    Partner partner = (Partner) hPartner.get(insiteOffLoading.getPartnerId());
    if(partner == null) partner = new Partner();

    if(insiteOffLoading.getStatus() == IFishConfig.STATUS_DRAFT && partner.getOID() != 0) { //OPEN
        System.out.println(partner.getName()+" - "+ insiteOffLoading.getBoat()+" ("+JSPFormater.formatDate(insiteOffLoading.getReceivedDate(), "yyyy-MM-dd")+")<br />");

        DeepSlope deepSlope = new DeepSlope();
        deepSlope.setOID(OIDGenerator.generateOID());
        deepSlope.setPartnerId(partner.getOID());
        deepSlope.setLandingDate(insiteOffLoading.getReceivedDate());
        deepSlope.setSupplier(insiteOffLoading.getBoat()); //Boat name from SWMS not yet standardized like in I-Fish
        deepSlope.setBroughtBy(insiteOffLoading.getBroughtBy());
        deepSlope.setApproach(IFishConfig.APPROACH_SWMS);

        boolean offLoadingOK = false;
        boolean sizingOK = false;
        
        if(deepSlope.getOID() != 0) {
            //Process offLoading
            String whereOffLoading = DbOffLoading.colNames[DbOffLoading.COL_BOAT] + " ilike '%" + deepSlope.getSupplier() + "%' and "
                    + " date_trunc('day', " + DbOffLoading.colNames[DbOffLoading.COL_RECEIVED_DATE] + ") = '" + JSPFormater.formatDate(deepSlope.getLandingDate(), "yyyy-MM-dd") + "'"
                    + " and " + DbOffLoading.colNames[DbOffLoading.COL_PARTNER_ID] + " = " + deepSlope.getPartnerId()
                    + " and " + DbOffLoading.colNames[DbOffLoading.COL_STATUS] + " = " + IFishConfig.STATUS_DRAFT;
            Vector listOffloading = DbOffLoading.list(0, 0, whereOffLoading, "");
            if(listOffloading != null && listOffloading.size() > 0) {
                for(int i = 0; i < listOffloading.size(); i++) {
                    OffLoading offLoadingInsite = (OffLoading) listOffloading.get(i);

                    //Process species name
                    long fishId = 0;
                    String[] latinName = offLoadingInsite.getLatinName().trim().split(" ");
                    try {
                        if (latinName.length == 1) {
                            fishId = DbFish.getFishIdByFamily(latinName[0]); //family
                        } else if (latinName.length == 2) {
                            fishId = DbFish.getFishId(latinName[0], latinName[1]); //species
                        }

                        //if not found, set to ID others
                        if(fishId == 0) fishId = 1427255974907l; //oid for others
                    } catch (Exception e) {
                        System.out.println("ex latinName : " + e.toString());
                    }

                    //Only proceed data with correctly species name
                    if(fishId != 0) {
                        com.project.ifish.data.OffLoading offLoading = new com.project.ifish.data.OffLoading();
                        offLoading.setOID(offLoadingInsite.getOID());
                        offLoading.setLandingId(deepSlope.getOID());
                        offLoading.setFishId(fishId);
                        offLoading.setPcs(offLoadingInsite.getPcs());
                        offLoading.setNw(offLoadingInsite.getNw());
                        offLoading.setTemperature(offLoadingInsite.getTemperature());
                        offLoading.setCondition(offLoadingInsite.getCondition());
                        offLoading.setGrade(offLoadingInsite.getGrade());

                        try {
                            long oid = com.project.ifish.data.DbOffLoading.insertExcWithOid(offLoading);

                            //Update Insite data status
                            if (oid != 0) {
                                offLoadingInsite.setStatus(1);
                                DbOffLoading.updateExc(offLoadingInsite);
                            }
                        } catch (Exception e) {
                            System.out.println(e.toString());
                        }
                    }
                }

                offLoadingOK = true;
            }

            //Process sizing
            String whereSizing = DbSizing.colNames[DbSizing.COL_BOAT] + " ilike '%" + deepSlope.getSupplier() + "%' and "
                    + " date_trunc('day', " + DbSizing.colNames[DbSizing.COL_SIZING_DATE] + ") = '" + JSPFormater.formatDate(deepSlope.getLandingDate(), "yyyy-MM-dd") + "'"
                    + " and " + DbSizing.colNames[DbSizing.COL_PARTNER_ID] + " = " + deepSlope.getPartnerId()
                    + " and " + DbSizing.colNames[DbSizing.COL_STATUS] + " = " + IFishConfig.STATUS_DRAFT;
            Vector listSizing = DbSizing.list(0, 0, whereSizing, "");
            if(listSizing != null && listSizing.size() > 0) {
                for(int i = 0; i < listSizing.size(); i++) {
                    Sizing sizingInsite = (Sizing) listSizing.get(i);

                    //Process species name
                    long fishId = 0;
                    String[] latinName = sizingInsite.getLatinName().trim().split(" ");
                    try {
                        if (latinName.length == 1) {
                            fishId = DbFish.getFishIdByFamily(latinName[0]); //family
                        } else if (latinName.length == 2) {
                            fishId = DbFish.getFishId(latinName[0], latinName[1]); //species
                        }

                        //if not found, set to ID others
                        if(fishId == 0) fishId = 1427255974907l; //oid for others
                    } catch (Exception e) {
                        System.out.println("ex latinName : " + e.toString());
                    }

                    //Only proceed data with correctly species name
                    if (fishId != 0) {
                        Fish fish = DbFish.fetchExc(fishId);
                        com.project.ifish.data.Sizing sizing = new com.project.ifish.data.Sizing();
                        sizing.setOID(sizingInsite.getOID());
                        sizing.setLandingId(deepSlope.getOID());
                        sizing.setFishId(fishId);
                        sizing.setCm(sizingInsite.getCm());
                        sizing.setOffloadingId(sizingInsite.getOffloadingId());
                        if(sizing.getCm() > fish.getLmax()) {
                            sizing.setDataQuality(IFishConfig.DATA_QUALITY_POOR);
                        }

                        try {
                            long oid = com.project.ifish.data.DbSizing.insertExcWithOid(sizing);

                            //Update Insite data status
                            if(oid != 0) {
                                sizingInsite.setStatus(1);
                                DbSizing.updateExc(sizingInsite);
                            }
                        } catch(Exception e) {
                            System.out.println("OID Sizing" + sizing.getOID());
                            System.out.println(e.toString());
                        }
                    }
                }

                sizingOK = true;
            }

            if(offLoadingOK || sizingOK) {
                boolean isDeepSlope = DbDeepSlope.insertExcWithOID(deepSlope);
            }
        }
    }
}
out.println("...done");
%>