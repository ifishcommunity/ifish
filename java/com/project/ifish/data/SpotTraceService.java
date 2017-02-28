package com.project.ifish.data;

import com.project.ifish.master.DbTracker;
import com.project.ifish.master.Tracker;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class SpotTraceService implements Runnable {

    /**
     * This class based on SpotTrace Knowledge base
     * http://faq.findmespot.com/index.php?action=showEntry&data=69
     */
    public synchronized void run() {
        DbFindMeSpot dbFindMeSpot = new DbFindMeSpot();
        int count1 = 0;
        int count2 = 0;
        int count3 = 0;
        boolean status = false;
        String url = "";
        while (dbFindMeSpot.running) {
            try {
                Vector list = DbTracker.list(0, 0, DbTracker.colNames[DbTracker.COL_STATUS] + "=" + 1, "");
                System.out.println("Tracker active: " + list.size());

                /**
                 * Grab data every 10 minute
                 */
                if (count1 == 1 && false) {
                    if (list != null && list.size() > 0) {
                        for (int i = 0; i < list.size(); i++) {
                            Tracker tracker = (Tracker) list.get(i);
                            status = false;
                            url = "https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/public/feed/" + tracker.getFeedId() + "/latest.xml";
                            try {
                                status = DbFindMeSpot.XML2DBv2(url);
                                DbFindMeSpot.setAvgPosition();
                            } catch (Exception e) {
                                System.out.println("(" + new Date() + "): " + e.toString());
                            }
                            System.out.println("(" + new Date() + ") [10M] Tracker: " + tracker.getTrackerName() + " " + (status == true ? "Done" : "Fail"));
                            count1 = 0;
                        }
                    }
                }

                /**
                 * Grab data every 6 hour
                 */
                if (count2 == (6 * 6)) { //60 minute * 6 = 6 hour
                    if (list != null && list.size() > 0) {
                        Thread.sleep(1000 * 60 * 1); //1 minute
                        for (int i = 0; i < list.size(); i++) {
                            Tracker tracker = (Tracker) list.get(i);
                            status = false;
                            url = "https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/public/feed/" + tracker.getFeedId() + "/message.xml?startDate=" + formatDate(new Date(), "yyyy-MM-dd 00:00:00") + "&endDate=" + formatDate(new Date(), "yyyy-MM-dd 23:59:59");
                            try {
                                status = DbFindMeSpot.XML2DBv2(url);
                                DbFindMeSpot.setAvgPosition();
                            } catch (Exception e) {
                                System.out.println("(" + new Date() + "): " + e.toString());
                            }
                            System.out.println("(" + new Date() + ") [6H] Tracker: " + tracker.getTrackerName() + " " + (status == true ? "Done" : "Fail"));
                            count2 = 0;
                        }
                    }
                }

                /**
                 * Grab data every 24 hour
                 */
                if (count3 == (6 * 24) || count3 == 0) { //60 minute * 24 = 24 hour
                    if (list != null && list.size() > 0) {
                        Thread.sleep(1000 * 60 * 1); //1 minute
                        for (int i = 0; i < list.size(); i++) {
                            Tracker tracker = (Tracker) list.get(i);
                            status = false;
                            url = "https://api.findmespot.com/spot-main-web/consumer/rest-api/2.0/public/feed/" + tracker.getFeedId() + "/message.xml";
                            try {
                                status = DbFindMeSpot.XML2DBv2(url);
                                DbFindMeSpot.setAvgPositionAllDays();
                            } catch (Exception e) {
                                System.out.println("(" + new Date() + "): " + e.toString());
                            }
                            System.out.println("(" + new Date() + ") [24H] Tracker: " + tracker.getTrackerName() + " " + (status == true ? "Done" : "Fail"));
                            count3 = 0;
                        }
                    }
                }
                count1 += 1;
                count2 += 1;
                count3 += 1;
                Thread.sleep(1000 * 60 * 10); //10 minute
            } catch (Exception e) {
                System.out.println("(" + new Date() + "): " + e.toString());
            }
        }
    }

    String formatDate(Date date, String format) {
        String sdate = JSPFormater.formatDate(date, format);
        sdate += "-0000";
        sdate = sdate.substring(0, 10) + "T" + sdate.substring(11, sdate.length());
        return sdate;
    }
}
