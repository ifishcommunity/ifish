package com.project.insite.ws;

import com.project.IFishConfig;
import com.project.ifish.data.DbDeepSlope;
import java.net.URL;
import java.util.List;
import javax.xml.ws.ServiceMode;
import javax.xml.ws.WebServiceProvider;
import com.project.insite.DbOffLoading;
import com.project.insite.DbSizing;
import com.project.insite.OffLoading;
import com.project.insite.Sizing;
import com.project.util.JSPFormater;

/**
 *
 * @author gwawan
 */
@ServiceMode(value = javax.xml.ws.Service.Mode.PAYLOAD)
@WebServiceProvider(serviceName = "NPService", portName = "BasicHttpBinding_INPService", targetNamespace = "http://tempuri.org/", wsdlLocation = "WEB-INF/wsdl/InsiteWSDL/103.255.123.88/TNCService/NPService.svc.wsdl")
public class InsiteWS implements javax.xml.ws.Provider<javax.xml.transform.Source> {

    public javax.xml.transform.Source invoke(javax.xml.transform.Source source) {
        //TODO implement this method
        throw new UnsupportedOperationException("Not implemented yet.");
    }

    /*
     * Get offloading data from Insite Server by selected date
     * @param serverIP "123.11.22.33"
     * @param date "03/23/2015" "MM/dd/yyyy"
     */
    public static void getTNCOffloadSummary(String serverIP, String date, long partnerId) {
        try {
            URL wsdlLocation = new URL("http://" + serverIP + "/TNCService/NPService.svc");
            org.tempuri.NPService service = new org.tempuri.NPService(wsdlLocation);
            org.tempuri.INPService port = service.getBasicHttpBindingINPService();
            org.datacontract.schemas._2004._07.npservice.ArrayOfOffloadSummary arrayOffloadSummary = port.getTNCOffloadSummary(date);
            List<org.datacontract.schemas._2004._07.npservice.OffloadSummary> list = arrayOffloadSummary.getOffloadSummary();
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    org.datacontract.schemas._2004._07.npservice.OffloadSummary offloadSummary = (org.datacontract.schemas._2004._07.npservice.OffloadSummary) list.get(i);

                    long offloadingId = 0;
                    try {
                        offloadingId = Long.parseLong(offloadSummary.getSN().getValue().toString());
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }

                    double pcs = 0;
                    try {
                        pcs = Double.parseDouble(offloadSummary.getPcs().getValue().toString());
                    } catch(Exception e) {
                        System.out.println(e.toString());
                    }

                    double nw = 0;
                    try {
                        nw = Double.parseDouble(offloadSummary.getNW().getValue().toString());
                    } catch(Exception e) {
                        System.out.println(e.toString());
                    }

                    double temperature = 0;
                    try {
                        temperature = Double.parseDouble(offloadSummary.getTemperature().getValue().toString());
                    } catch(Exception e) {
                        System.out.println(e.toString());
                    }

                    long tripId = 0;
                    try {
                        tripId = Long.parseLong(offloadSummary.getTripID().getValue().toString());
                    } catch (Exception e) {
                        System.out.println();
                    }

                    long trackerId = 0;
                    try {
                        trackerId = Long.parseLong(offloadSummary.getTrackerID().getValue().toString());
                    } catch (Exception e) {
                        System.out.println();
                    }

                    OffLoading offLoading = new OffLoading();
                    offLoading.setOffloadingId(offloadingId);
                    offLoading.setReceivedDate(JSPFormater.formatDate(offloadSummary.getRcvDate().getValue().toString(), "M/d/yyyy h:mm:ss a")); //value format : 4/6/2015 9:54:54 PM
                    offLoading.setLatinName(offloadSummary.getLatinName().getValue().toString());
                    offLoading.setSpecies(offloadSummary.getSpecies().getValue().toString());
                    offLoading.setPcs(pcs);
                    offLoading.setNw(nw);
                    offLoading.setTemperature(temperature);
                    offLoading.setCondition(offloadSummary.getCondition().getValue().toString());
                    offLoading.setGrade(offloadSummary.getGrade().getValue().toString());
                    offLoading.setTripId(tripId);
                    offLoading.setTrackerId(trackerId);
                    offLoading.setUserId(0);
                    offLoading.setPartnerId(partnerId);
                    offLoading.setBoat(offloadSummary.getBoat().getValue().toString());
                    offLoading.setBroughtBy(offloadSummary.getBroughtBy().getValue().toString());

                    try {
                        OffLoading olx = DbOffLoading.getByOffLoadingId(offLoading.getPartnerId(), offLoading.getOffloadingId());
                        if(olx.getOID() == 0) {
                            long oid = DbOffLoading.insertExc(offLoading);
                            System.out.println("Insert SN " + offLoading.getOffloadingId());
                        } else {
                            if(olx.getStatus() == IFishConfig.STATUS_DRAFT) {
                                offLoading.setOID(olx.getOID());
                                long oid = DbOffLoading.updateExc(offLoading);
                                System.out.println("Update SN " + offLoading.getOffloadingId());
                            }
                        }
                    } catch (Exception e) {
                        System.out.println("failed to insert " + offLoading.getOffloadingId());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    /*
     * Get sizing data from Insite Server by selected date
     * @param serverIP "123.11.22.33"
     * @param date "03/23/2015" "MM/dd/yyyy"
     */
    public static void getTNCSizing(String serverIP, String date, long partnerId) {
        try {
            URL wsdlLocation = new URL("http://" + serverIP + "/TNCService/NPService.svc");
            org.tempuri.NPService service = new org.tempuri.NPService(wsdlLocation);
            org.tempuri.INPService port = service.getBasicHttpBindingINPService();
            org.datacontract.schemas._2004._07.npservice.ArrayOfTNCSizing arrayTNCSizing = port.getTNCSizing(date);
            List<org.datacontract.schemas._2004._07.npservice.TNCSizing> list = arrayTNCSizing.getTNCSizing();
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    org.datacontract.schemas._2004._07.npservice.TNCSizing tncSizing = (org.datacontract.schemas._2004._07.npservice.TNCSizing) list.get(i);

                    long sizingId = 0;
                    try {
                        sizingId = Long.parseLong(tncSizing.getSizingID().getValue().toString());
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }

                    double cm = 0;
                    try {
                        cm = Double.parseDouble(tncSizing.getCM().getValue().toString());
                    } catch(Exception e) {
                        System.out.println(e.toString());
                    }

                    long tripId = 0;
                    try {
                        tripId = Long.parseLong(tncSizing.getTripID().getValue().toString());
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }

                    long trackerId = 0;
                    try {
                        trackerId = Long.parseLong(tncSizing.getTrackerID().getValue().toString());
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }

                    long offloadingId = 0;
                    try {
                        offloadingId = Long.parseLong(tncSizing.getSN().getValue().toString());
                    } catch (Exception e) {
                        System.out.println(e.toString());
                    }

                    Sizing sizing = new Sizing();
                    sizing.setSizingId(sizingId);
                    sizing.setSizingDate(JSPFormater.formatDate(tncSizing.getSizingDate().getValue().toString(), "M/d/yyyy h:mm:ss a")); //value format : 4/6/2015 9:54:54 PM
                    sizing.setGenus(tncSizing.getGenus().getValue().toString());
                    sizing.setLatinName(tncSizing.getLatinName().getValue().toString());
                    sizing.setEnglishName(tncSizing.getEnglishName().getValue().toString());
                    sizing.setCm(cm);
                    sizing.setBoat(tncSizing.getBoat().getValue().toString());
                    sizing.setTripId(tripId);
                    sizing.setTrackerId(trackerId);
                    sizing.setUserId(0);
                    sizing.setOffloadingId(offloadingId);
                    sizing.setBroughtBy(tncSizing.getBroughtBy().getValue().toString());
                    sizing.setPartnerId(partnerId);

                    try {
                        Sizing sx = DbSizing.getBySizingId(sizing.getPartnerId(), sizing.getSizingId());
                        if(sx.getOID() == 0) {
                            long oid = DbSizing.insertExc(sizing);
                            System.out.println("Insert SizingID " + sizing.getSizingId());
                        } else {
                            if(sx.getStatus() == IFishConfig.STATUS_DRAFT) {
                                sizing.setOID(sx.getOID());
                                long oid = DbSizing.updateExc(sizing);
                                System.out.println("Update SizingID " + sizing.getSizingId());
                            }
                        }
                    } catch(Exception e) {
                        System.out.println("failed to insert " + sizing.getSizingId());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
