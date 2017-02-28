package com.project.ifish.master;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class DbTracker extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_TRACKER = "ifish_tracker";
    public static final int COL_OID = 0;
    public static final int COL_TRACKER_ID = 1;
    public static final int COL_TRACKER_NAME = 2;
    public static final int COL_FEED_ID = 3;
    public static final int COL_STATUS = 4;
    public static final int COL_AUTH_CODE = 5;
    public static final int COL_NOTES = 6;
    public static final String[] colNames = {
        "oid",
        "tracker_id",
        "tracker_name",
        "feed_id",
        "status",
        "auth_code",
        "notes"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };

    public DbTracker() {
    }

    public DbTracker(int i) throws CONException {
        super(new DbTracker());
    }

    public DbTracker(String sOid) throws CONException {
        super(new DbTracker(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbTracker(long lOid) throws CONException {
        super(new DbTracker(0));
        String sOid = "0";
        try {
            sOid = String.valueOf(lOid);
        } catch (Exception e) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public String getTableName() {
        return DB_TRACKER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbTracker().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Tracker tracker = fetchExc(ent.getOID());
        ent = (Entity) tracker;
        return tracker.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Tracker) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Tracker) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Tracker fetchExc(long oid) throws CONException {
        try {
            Tracker tracker = new Tracker();
            DbTracker dbTracker = new DbTracker(oid);
            tracker.setOID(oid);
            tracker.setTrackerId(dbTracker.getlong(COL_TRACKER_ID));
            tracker.setTrackerName(dbTracker.getString(COL_TRACKER_NAME));
            tracker.setFeedId(dbTracker.getString(COL_FEED_ID));
            tracker.setStatus(dbTracker.getInt(COL_STATUS));
            tracker.setAuthCode(dbTracker.getString(COL_AUTH_CODE));
            tracker.setNotes(dbTracker.getString(COL_NOTES));
            return tracker;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTracker(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Tracker tracker) throws CONException {
        try {
            DbTracker dbTracker = new DbTracker(0);
            dbTracker.setLong(COL_TRACKER_ID, tracker.getTrackerId());
            dbTracker.setString(COL_TRACKER_NAME, tracker.getTrackerName());
            dbTracker.setString(COL_FEED_ID, tracker.getFeedId());
            dbTracker.setInt(COL_STATUS, tracker.getStatus());
            dbTracker.setString(COL_AUTH_CODE, tracker.getAuthCode());
            dbTracker.setString(COL_NOTES, tracker.getNotes());
            dbTracker.insert();
            tracker.setOID(dbTracker.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTracker(0), CONException.UNKNOWN);
        }
        return tracker.getOID();
    }

    public static long updateExc(Tracker tracker) throws CONException {
        try {
            if (tracker.getOID() != 0) {
                DbTracker dbTracker = new DbTracker(tracker.getOID());
                dbTracker.setLong(COL_TRACKER_ID, tracker.getTrackerId());
                dbTracker.setString(COL_TRACKER_NAME, tracker.getTrackerName());
                dbTracker.setString(COL_FEED_ID, tracker.getFeedId());
                dbTracker.setInt(COL_STATUS, tracker.getStatus());
                dbTracker.setString(COL_AUTH_CODE, tracker.getAuthCode());
                dbTracker.setString(COL_NOTES, tracker.getNotes());
                dbTracker.update();
                return tracker.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTracker(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbTracker dbTracker = new DbTracker(oid);
            dbTracker.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbTracker(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 0, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_TRACKER;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            if (order != null && order.length() > 0) {
                sql = sql + " ORDER BY " + order;
            }
            if (limitStart == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                switch (CONHandler.CONSVR_TYPE) {
                    case CONSVR_ORACLE:
                        break;
                    case CONSVR_MYSQL:
                        sql = sql + " LIMIT " + limitStart + "," + recordToGet;
                        break;
                    case CONSVR_POSTGRESQL:
                        sql = sql + " LIMIT " + recordToGet + " OFFSET " + limitStart;
                        break;
                    case CONSVR_MSSQL:
                        break;
                    case CONSVR_SYBASE:
                        break;
                    default:
                        break;
                }
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Tracker tracker = new Tracker();
                resultToObject(rs, tracker);
                lists.add(tracker);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, Tracker tracker) {
        try {
            tracker.setOID(rs.getLong(colNames[COL_OID]));
            tracker.setTrackerId(rs.getLong(colNames[COL_TRACKER_ID]));
            tracker.setTrackerName(rs.getString(colNames[COL_TRACKER_NAME]));
            tracker.setFeedId(rs.getString(colNames[COL_FEED_ID]));
            tracker.setStatus(rs.getInt(colNames[COL_STATUS]));
            tracker.setAuthCode(rs.getString(colNames[COL_AUTH_CODE]));
            tracker.setNotes(rs.getString(colNames[COL_NOTES]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long trackerId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_TRACKER + " WHERE "
                    + colNames[COL_OID] + " = " + trackerId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_TRACKER;
            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            int count = 0;
            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
            return count;
        } catch (Exception e) {
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static int findLimitStart(long oid, int recordToGet, String whereClause) {
        String order = "";
        int size = getCount(whereClause);
        int start = 0;
        boolean found = false;
        for (int i = 0; (i < size) && !found; i = i + recordToGet) {
            Vector list = list(i, recordToGet, whereClause, order);
            start = i;
            if (list.size() > 0) {
                for (int ls = 0; ls < list.size(); ls++) {
                    Tracker tracker = (Tracker) list.get(ls);
                    if (oid == tracker.getOID()) {
                        found = true;
                    }
                }
            }
        }
        if ((start >= size) && (size > 0)) {
            start = start - recordToGet;
        }

        return start;
    }

    public static long getTrackerIdByName(String trackerName) {
        Vector v = list(0, 0, colNames[COL_TRACKER_NAME]+" = '"+trackerName+"'", "");
        if(v != null && v.size() > 0) {
            Tracker t = (Tracker) v.get(0);
            return t.getTrackerId();
        } else {
            return 0;
        }
    }

    public static Tracker getByTrackerId(long trackerId) {
        Vector v = list(0, 0, colNames[COL_TRACKER_ID]+" = '"+trackerId+"'", "");
        if(v != null && v.size() > 0) {
            Tracker t = (Tracker) v.get(0);
            return t;
        } else {
            return new Tracker();
        }
    }

}
