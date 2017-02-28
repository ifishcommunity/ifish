package com.project.ifish.session;

import com.project.IFishConfig;
import com.project.general.DbFile;
import com.project.general.File;
import com.project.ifish.data.DbDeepSlope;
import com.project.ifish.data.DbSizing;
import com.project.ifish.data.Sizing;
import com.project.ifish.master.DbBoat;
import com.project.ifish.master.DbFish;
import com.project.ifish.master.Fish;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class SessDeepSlope {

    public static List<CODRSSummary> codrsSummary(int period, String programSite) {
        List list = new ArrayList<CODRSSummary>();
        CONResultSet dbrs = null;
        try {
            String where = "d.approach = " + IFishConfig.APPROACH_CODRS
                    + " and date_trunc('year', " + DbDeepSlope.colNames[DbDeepSlope.COL_LANDING_DATE] + ") = '" + period + "-01-01'";
            if (programSite.length() > 0) {
                where += " and " + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + " ilike '" + programSite + "'";
            }
            String sql = "select b.oid, b.name, b.home_port, t.tracker_name, b.tracker_status, date_trunc('month', landing_date) as mth, count(s.*)"
                    + " from ifish_deepslope d inner join ifish_sizing s on d.oid = s.landing_id"
                    + " inner join ifish_boat b on d.boat_id = b.oid"
                    + " inner join ifish_tracker t on b.tracker_id = t.tracker_id"
                    + " where " + where
                    + " group by 1,2,3,4,5,6"
                    + " order by b.oid, mth";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            long prevBoatId = 0;
            int n = -1;
            CODRSSummary codrss;
            while (rs.next()) {
                long boatId = rs.getLong(1);
                String sMth = rs.getString(6);
                sMth = sMth.substring(5, 7);
                int mth = Integer.parseInt(sMth);
                int vol = rs.getInt(7);

                if (boatId != prevBoatId) {
                    codrss = new CODRSSummary();
                    codrss.setBoatName(rs.getString(2));
                    codrss.setBoatHomePort(rs.getString(3));
                    codrss.setTrackerName(rs.getString(4));
                    codrss.setTrackerStatus(rs.getInt(5) == 1 ? "Active" : "Inactive");
                    setVol(codrss, mth, vol);
                    list.add(codrss);
                    n++;
                } else {
                    codrss = (CODRSSummary) list.get(n);
                    setVol(codrss, mth, vol);
                    list.set(n, codrss);
                }
                prevBoatId = boatId;
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

    private static void setVol(CODRSSummary codrss, int mth, int vol) {
        switch (mth) {
            case 1:
                codrss.setJan(vol);
                break;
            case 2:
                codrss.setFeb(vol);
                break;
            case 3:
                codrss.setMar(vol);
                break;
            case 4:
                codrss.setApr(vol);
                break;
            case 5:
                codrss.setMay(vol);
                break;
            case 6:
                codrss.setJun(vol);
                break;
            case 7:
                codrss.setJul(vol);
                break;
            case 8:
                codrss.setAug(vol);
                break;
            case 9:
                codrss.setSep(vol);
                break;
            case 10:
                codrss.setOct(vol);
                break;
            case 11:
                codrss.setNov(vol);
                break;
            case 12:
                codrss.setDec(vol);
                break;
        }
    }

    /**
     * W = a*L^b, L = FL (Fork Length)
     * @param landingId
     * @return
     */
    public static double getEstimatedWeight(long landingId) {
        double estimatedWeight = 0;
        CONResultSet dbrs = null;
        try {
            String sql = "select s.landing_id, sum(f.var_a*((s.cm*conversion_factor_tl2fl)^f.var_b))"
                    + " from ifish_fish f inner join ifish_sizing s on f.oid = s.fish_id"
                    + " where s.landing_id = " + landingId + " and f.fish_id > 0 and f.var_a > 0"
                    + "group by 1";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                estimatedWeight = rs.getDouble(2);
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return estimatedWeight;
    }

    public static List<List> summarySizing(long landingId) {
        List list = new ArrayList<List>();
        CONResultSet dbrs = null;
        try {
            if (landingId > 0) {
                String sql = "select f." + DbFish.colNames[DbFish.COL_FISH_ID] //1
                        + ", f." + DbFish.colNames[DbFish.COL_IS_FAMILY_ID] //2
                        + ", f." + DbFish.colNames[DbFish.COL_FISH_OID] //3
                        + ", count(*)" //4
                        + " from " + DbSizing.DB_SIZING + " s inner join " + DbFish.DB_FISH + " f"
                        + " on s." + DbSizing.colNames[DbSizing.COL_FISH_ID] + "=f." + DbFish.colNames[DbFish.COL_FISH_OID]
                        + " where " + DbSizing.colNames[DbSizing.COL_LANDING_ID] + " = " + landingId
                        + " group by 1,2,3"
                        + " order by f." + DbFish.colNames[DbFish.COL_IS_FAMILY_ID] + ", f." + DbFish.colNames[DbFish.COL_FISH_ID];

                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                while (rs.next()) {
                    long fishId = rs.getLong(3);
                    int n = rs.getInt(4);
                    List listx = new ArrayList();
                    listx.add(fishId);
                    listx.add(n);
                    list.add(listx);
                }

                rs.close();
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

    public static int getCountSizing(long landingId) {
        CONResultSet dbrs = null;
        try {
            if(landingId != 0) {
                String sql = "SELECT COUNT(" + DbSizing.colNames[DbSizing.COL_OID] + ") FROM " + DbSizing.DB_SIZING
                        + " WHERE " + DbSizing.colNames[DbSizing.COL_LANDING_ID] + "=" + landingId;

                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();

                int count = 0;
                while (rs.next()) {
                    count = rs.getInt(1);
                }

                rs.close();
                return count;
            } else {
                return 0;
            }
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static Vector listSizing(int limitStart, int recordToGet, long landingId) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            if(landingId != 0) {
                String sql = "SELECT s.* FROM " + DbSizing.DB_SIZING + " s INNER JOIN " + DbFish.DB_FISH + " f"
                        + " ON s." + DbSizing.colNames[DbSizing.COL_FISH_ID] + "=f." + DbFish.colNames[DbFish.COL_FISH_OID]
                        + " WHERE s." + DbSizing.colNames[DbSizing.COL_LANDING_ID] + "=" + landingId
                        + " ORDER BY f." + DbFish.colNames[DbFish.COL_IS_FAMILY_ID] + ", f." + DbFish.colNames[DbFish.COL_FISH_ID];

                if (limitStart == 0 && recordToGet == 0) {
                    sql = sql + "";
                } else {
                    switch (CONHandler.CONSVR_TYPE) {
                        case CONHandler.CONSVR_ORACLE:
                            break;
                        case CONHandler.CONSVR_MYSQL:
                            sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                            break;
                        case CONHandler.CONSVR_POSTGRESQL:
                            sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                            break;
                        case CONHandler.CONSVR_MSSQL:
                            break;
                        case CONHandler.CONSVR_SYBASE:
                            break;
                        default:
                            break;
                    }
                }
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {
                    Sizing sizing = new Sizing();
                    DbSizing.resultToObject(rs, sizing);
                    list.add(sizing);
                }
                rs.close();
            }
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

    public synchronized static void setLargestSpecimen(long landingId) {
        try {
            Hashtable hTop100Species = DbFish.getTop100Species();

            Vector listSizing = DbSizing.list(0, 0, DbSizing.colNames[DbSizing.COL_LANDING_ID]+"="+landingId, "");
            if(listSizing != null && listSizing.size() > 0) {
                for(int i=0; i<listSizing.size(); i++) {
                    Sizing sizing = (Sizing) listSizing.get(i);

                    Fish fish = (Fish) hTop100Species.get(sizing.getFishId());
                    if (fish == null) fish = new Fish();

                    if (sizing.getOID() != 0 && fish.getFishID() != 0 && sizing.getCm() > fish.getLargestSpecimenCm()) { // update database of Fish if it is the largest specimen
                        fish.setLargestSpecimenId(sizing.getOID());
                        fish.setLargestSpecimenCm(sizing.getCm());
                        DbFish.updateExc(fish);
                    }
                }
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    }

    public synchronized static void rollbackLargestSpecimen(HttpServletRequest request, long landingId) {
        CONResultSet dbrs = null;
        try {
            if (landingId != 0) {
                String sOID = "";
                Vector listSizing = DbSizing.list(0, 0, DbSizing.colNames[DbSizing.COL_LANDING_ID] + "=" + landingId, "");
                if (listSizing != null && listSizing.size() > 0) {
                    for (int i = 0; i < listSizing.size(); i++) {
                        Sizing sizing = (Sizing) listSizing.get(i);
                        if (sOID.length() == 0) {
                            sOID = String.valueOf(sizing.getOID());
                        } else {
                            sOID += ", " + String.valueOf(sizing.getOID());
                        }
                    }

                    // Get list of Species that recorded as largest specimen
                    Vector listFish = DbFish.list(0, 0, DbFish.colNames[DbFish.COL_LARGEST_SPECIMEN_ID] + " in (" + sOID + ")", "");
                    if (listFish != null && listFish.size() > 0) {
                        for (int i = 0; i < listFish.size(); i++) {
                            Fish fish = (Fish) listFish.get(i);

                            //SQL get previous largest specimen
                            String sql = "select s.* from " + DbDeepSlope.DB_DEEPSLOPE + " d inner join " + DbSizing.DB_SIZING + " s"
                                    + " on d." + DbDeepSlope.colNames[DbDeepSlope.COL_OID] + "=s." + DbSizing.colNames[DbSizing.COL_LANDING_ID]
                                    + " where " + DbSizing.colNames[DbSizing.COL_FISH_ID] + "=" + fish.getOID()
                                    + " and " + DbSizing.colNames[DbSizing.COL_DATA_QUALITY] + "=" + IFishConfig.DATA_QUALITY_GOOD
                                    + " and " + DbDeepSlope.colNames[DbDeepSlope.COL_APPROACH] + "=" + IFishConfig.APPROACH_CODRS
                                    + " and " + DbDeepSlope.colNames[DbDeepSlope.COL_DOC_STATUS] + "=any(values('" + IFishConfig.DOC_STATUS_POSTED + "'))"
                                    + " order by " + DbSizing.colNames[DbSizing.COL_CM] + " desc limit 1 offset 0";
                            dbrs = CONHandler.execQueryResult(sql);
                            ResultSet rs = dbrs.getResultSet();

                            while (rs.next()) {
                                Sizing sizing = new Sizing();
                                DbSizing.resultToObject(rs, sizing);

                                //Remove previous largest specimen photo
                                if (fish.getLargestSpecimenPicture() != 0) {
                                    File file = new File();
                                    try {
                                        file = DbFile.fetchExc(fish.getLargestSpecimenPicture());
                                    } catch (Exception e) {
                                        System.out.println(e.toString());
                                    }
                                    if (file.getOID() != 0) {
                                        String uploadPath = request.getSession().getServletContext().getRealPath("") + java.io.File.separator + DbFile.UPLOAD_DIRECTORY;
                                        String filePath = uploadPath + java.io.File.separator + file.getName();
                                        java.io.File storeFile = new java.io.File(filePath);
                                        if (storeFile != null) {
                                            try {
                                                storeFile.delete(); // <<<< remove file from storage
                                                DbFile.deleteExc(file.getOID()); // <<<< remove file from database
                                            } catch (Exception e) {
                                                System.out.println(e.toString());
                                            }
                                        }
                                    }
                                }

                                if (sizing.getOID() != 0) { //Update database by previous largest specimen
                                    fish.setLargestSpecimenId(sizing.getOID());
                                    fish.setLargestSpecimenCm(sizing.getCm());
                                    fish.setLargestSpecimenPicture(0);
                                    DbFish.updateExc(fish);
                                } else { //If no more specimen
                                    fish.setLargestSpecimenId(0);
                                    fish.setLargestSpecimenCm(0);
                                    fish.setLargestSpecimenPicture(0);
                                    DbFish.updateExc(fish);
                                }
                            }
                        }
                    }
                }
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    }
    
}
