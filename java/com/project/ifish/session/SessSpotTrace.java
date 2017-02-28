package com.project.ifish.session;

import com.project.IFishConfig;
import com.project.util.JSPFormater;
import com.project.general.DbUserBoat;
import com.project.ifish.data.DbFindMeSpot;
import com.project.ifish.data.FindMeSpot;
import com.project.ifish.master.Boat;
import com.project.ifish.master.DbBoat;
import com.project.ifish.master.DbTracker;
import com.project.ifish.master.Tracker;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class SessSpotTrace {
    public static int getCountUserBoat(long userId, String trackerName) {
        int count = 0;
        CONResultSet dbrs = null;
        try {
            String sql = "select count(distinct t.*)"
                    + " from " + DbUserBoat.DB_USER_BOAT + " ub inner join " + DbBoat.DB_BOAT + " b"
                    + " on ub." + DbUserBoat.colNames[DbUserBoat.COL_BOAT_ID]
                    + " = b." + DbBoat.colNames[DbBoat.COL_OID]
                    + " inner join " + DbTracker.DB_TRACKER + " t"
                    + " on b." + DbBoat.colNames[DbBoat.COL_TRACKER_ID]
                    + " = t." + DbTracker.colNames[DbTracker.COL_TRACKER_ID];

            sql = sql + " where ub." + DbUserBoat.colNames[DbUserBoat.COL_USER_ID] + " = " + userId
                    + " and b." + DbBoat.colNames[DbBoat.COL_TRACKER_STATUS] + " = " + IFishConfig.STATUS_ACTIVE;
            if(trackerName != null && trackerName.length() > 0) {
                sql += " and t." + DbTracker.colNames[DbTracker.COL_TRACKER_NAME] + " ilike '%" + trackerName + "%'";
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return count;
    }

    public static Vector listUserBoat(int start, int recordToGet, long userId, String trackerName) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select distinct t.*"
                    + ", b." + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE]
                    + ", b." + DbBoat.colNames[DbBoat.COL_HOME_PORT]
                    + " from " + DbUserBoat.DB_USER_BOAT + " ub inner join " + DbBoat.DB_BOAT + " b"
                    + " on ub." + DbUserBoat.colNames[DbUserBoat.COL_BOAT_ID]
                    + " = b." + DbBoat.colNames[DbBoat.COL_OID]
                    + " inner join " + DbTracker.DB_TRACKER + " t"
                    + " on b." + DbBoat.colNames[DbBoat.COL_TRACKER_ID]
                    + " = t." + DbTracker.colNames[DbTracker.COL_TRACKER_ID];

            sql = sql + " where ub." + DbUserBoat.colNames[DbUserBoat.COL_USER_ID] + " = " + userId
                    + " and b." + DbBoat.colNames[DbBoat.COL_TRACKER_STATUS] + " = " + IFishConfig.STATUS_ACTIVE;
            if(trackerName != null && trackerName.length() > 0) {
                sql += " and t." + DbTracker.colNames[DbTracker.COL_TRACKER_NAME] + " ilike '%" + trackerName + "%'";
            }
            sql += " order by b." + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE]
                    + ", b." + DbBoat.colNames[DbBoat.COL_HOME_PORT]
                    + ", t." + DbTracker.colNames[DbTracker.COL_TRACKER_NAME];
            if (start == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                switch (CONHandler.CONSVR_TYPE) {
                    case CONHandler.CONSVR_ORACLE:
                        break;
                    case CONHandler.CONSVR_MYSQL:
                        sql = sql + " limit " + start + "," + recordToGet;
                        break;
                    case CONHandler.CONSVR_POSTGRESQL:
                        sql = sql + " limit " + recordToGet + " offset " + start;
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
                Tracker tracker = new Tracker();
                DbTracker.resultToObject(rs, tracker);
                list.add(tracker);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

    /**
     * List SpotTrace data that related with start date and end date for each boat
     * @param start
     * @param recordToGet
     * @param whereClause
     * @param orderClause
     * @return
     */
    public static Vector getMap(int start, int recordToGet, String whereClause) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select * from ("
                    + " select st.* from "+DbBoat.DB_BOAT+" b inner join "+DbFindMeSpot.DB_FINDMESPOT+" st"
                    + " on b."+DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" = st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + " where date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") >= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE]+")"
                    + " and date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") <= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_END_DATE]+")"
                    + " and b."+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+" = 0"
                    + " and " + whereClause
                    + " union "
                    + " select st.* from "+DbBoat.DB_BOAT+" b inner join "+DbFindMeSpot.DB_FINDMESPOT+" st"
                    + " on b."+DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" = st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + " where date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") >= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE]+")"
                    + " and b."+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+" = 1"
                    + " and " + whereClause
                    + ") as t1 order by "+DbBoat.colNames[DbBoat.COL_OID]+", "+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+"";
            
            if (start == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                switch (CONHandler.CONSVR_TYPE) {
                    case CONHandler.CONSVR_ORACLE:
                        break;
                    case CONHandler.CONSVR_MYSQL:
                        sql = sql + " limit " + start + "," + recordToGet;
                        break;
                    case CONHandler.CONSVR_POSTGRESQL:
                        sql = sql + " limit " + recordToGet + " offset " + start;
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
                FindMeSpot findMeSpot = new FindMeSpot();
                DbFindMeSpot.resultToObject(rs, findMeSpot);
                list.add(findMeSpot);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

    /**
     * Count list of SpotTrace data that related with start date and end date for each boat
     * @param start
     * @param recordToGet
     * @param whereClause
     * @param orderClause
     * @return
     */
    public static int  getCountMap(String whereClause) {
        int count = 0;
        CONResultSet dbrs = null;
        try {
            String sql = "select count(*) from ("
                    + " select st.* from "+DbBoat.DB_BOAT+" b inner join "+DbFindMeSpot.DB_FINDMESPOT+" st"
                    + " on b."+DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" = st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + " where date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") >= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE]+")"
                    + " and date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") <= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_END_DATE]+")"
                    + " and b."+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+" = 0"
                    + " and " + whereClause
                    + " union "
                    + " select st.* from "+DbBoat.DB_BOAT+" b inner join "+DbFindMeSpot.DB_FINDMESPOT+" st"
                    + " on b."+DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" = st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + " where date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") >= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE]+")"
                    + " and b."+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+" = 1"
                    + " and " + whereClause
                    + ") as t1";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return count;
    }

    public static Vector getMapDailyAvgPosition(int start, int recordToGet, String whereClause) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select * from ("
                    + " select distinct b."+DbBoat.colNames[DbBoat.COL_OID]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_NAME]
                    + ", date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") as "+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DAILY_AVG_LATITUDE]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DAILY_AVG_LONGITUDE]
                    + " from "+DbBoat.DB_BOAT+" b inner join "+DbFindMeSpot.DB_FINDMESPOT+" st"
                    + " on b."+DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" = st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + " where date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") >= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE]+")"
                    + " and date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") <= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_END_DATE]+")"
                    + " and b."+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+" = 0"
                    + " and " + whereClause
                    + " union "
                    + " select distinct b."+DbBoat.colNames[DbBoat.COL_OID]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_NAME]
                    + ", date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") as "+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DAILY_AVG_LATITUDE]
                    + ", st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DAILY_AVG_LONGITUDE]
                    + " from "+DbBoat.DB_BOAT+" b inner join "+DbFindMeSpot.DB_FINDMESPOT+" st"
                    + " on b."+DbBoat.colNames[DbBoat.COL_TRACKER_ID]+" = st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]
                    + " where date_trunc('day', st."+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]+") >= date_trunc('day', b."+DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE]+")"
                    + " and b."+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+" = 1"
                    + " and " + whereClause
                    + ") as t1 order by "+DbBoat.colNames[DbBoat.COL_OID]+", "+DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME];

            if (start == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                switch (CONHandler.CONSVR_TYPE) {
                    case CONHandler.CONSVR_ORACLE:
                        break;
                    case CONHandler.CONSVR_MYSQL:
                        sql = sql + " limit " + start + "," + recordToGet;
                        break;
                    case CONHandler.CONSVR_POSTGRESQL:
                        sql = sql + " limit " + recordToGet + " offset " + start;
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
                FindMeSpot findMeSpot = new FindMeSpot();
                findMeSpot.setTrackerId(rs.getLong(DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_ID]));
                findMeSpot.setTrackerName(rs.getString(DbFindMeSpot.colNames[DbFindMeSpot.COL_TRACKER_NAME]));
                findMeSpot.setDateTime(rs.getDate(DbFindMeSpot.colNames[DbFindMeSpot.COL_DATE_TIME]));
                findMeSpot.setDailyAvgLatitude(rs.getDouble(DbFindMeSpot.colNames[DbFindMeSpot.COL_DAILY_AVG_LATITUDE]));
                findMeSpot.setDailyAvgLongitude(rs.getDouble(DbFindMeSpot.colNames[DbFindMeSpot.COL_DAILY_AVG_LONGITUDE]));
                list.add(findMeSpot);
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

    public static Vector getCODRSCoordinates(Date startDate, Date endDate, String area, Vector selectedBoat) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            String whereArea = "";
            if(area.equals(IFishConfig.AREA_A)) {
                whereArea = "d.wpp1 ilike '573' or d.wpp2 ilike '573' or d.wpp3 ilike '573'"
                        + " or d.wpp1 ilike 'JPDA' or d.wpp2 ilike 'JPDA' or d.wpp3 ilike 'JPDA'";
            } else if(area.equals(IFishConfig.AREA_B)) {
                whereArea = "d.wpp1 ilike '712' or d.wpp2 ilike '712' or d.wpp3 ilike '712'"
                        + " or d.wpp1 ilike '713' or d.wpp2 ilike '713' or d.wpp3 ilike '713'";
            } else if(area.equals(IFishConfig.AREA_C)) {
                whereArea = "d.wpp1 ilike '714' or d.wpp2 ilike '714' or d.wpp3 ilike '714'"
                        + " or d.wpp1 ilike '715' or d.wpp2 ilike '715' or d.wpp3 ilike '715'";
            } else if(area.equals(IFishConfig.AREA_D)) {
                whereArea = "d.wpp1 ilike '718' or d.wpp2 ilike '718' or d.wpp3 ilike '718'";
            }

            String whereTracker = "";
            if (selectedBoat != null && selectedBoat.size() > 0) {
                for (int i = 0; i < selectedBoat.size(); i++) {
                    Boat boat = (Boat) selectedBoat.get(i);
                    if(whereTracker.length() > 0) {
                        whereTracker += " or ";
                    }
                    whereTracker += "b." + DbBoat.colNames[DbBoat.COL_OID] + " = " + boat.getOID();
                }
            }

            String sql = "select distinct st.*"
                    + " from ifish_deepslope d inner join ifish_sizing s on d.oid = s.landing_id"
                    + " inner join ifish_fish f on f.oid = s.fish_id"
                    + " inner join ifish_boat b on b.oid = d.boat_id"
                    + " inner join ifish_findmespot st on st.tracker_id = b.tracker_id"
                    + " where date_trunc('day', s.codrs_picture_date) = date_trunc('day', st.date_time)"
                    + " and d.approach = 2 and s.data_quality = 1"
                    + " and (st.message_type ilike 'STOP' or st.message_type ilike 'STATUS')"
                    + " and date_trunc('day', d.landing_date) >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'"
                    + " and date_trunc('day', d.landing_date) <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

            if(whereArea.length() > 0) {
                sql += " and (" + whereArea + ")";
            }

            if(whereTracker.length() > 0) {
                sql += " and (" + whereTracker + ")";
            }
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                FindMeSpot findMeSpot = new FindMeSpot();
                DbFindMeSpot.resultToObject(rs, findMeSpot);
                list.add(findMeSpot);
            }
            rs.close();
        } catch(Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }

}
