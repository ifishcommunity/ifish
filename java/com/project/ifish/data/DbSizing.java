package com.project.ifish.data;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
import java.util.Date;
import java.util.Vector;
import java.sql.ResultSet;

/**
 *
 * @author gwawan
 */
public class DbSizing extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SIZING = "ifish_sizing";
    public static final int COL_OID = 0;
    public static final int COL_LANDING_ID = 1;
    public static final int COL_OFFLOADING_ID = 2;
    public static final int COL_FISH_ID = 3;
    public static final int COL_CM = 4;
    public static final int COL_CODRS_PICTURE_DATE = 5;
    public static final int COL_CODRS_PICTURE_NAME = 6;
    public static final int COL_DATA_QUALITY = 7;

    public static final String[] colNames = {
        "oid",
        "landing_id",
        "offloading_id",
        "fish_id",
        "cm",
        "codrs_picture_date",
        "codrs_picture_name",
        "data_quality"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT
    };

    public DbSizing() {
    }

    public DbSizing(int i) throws CONException {
        super(new DbSizing());
    }

    public DbSizing(String sOid) throws CONException {
        super(new DbSizing(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSizing(long lOid) throws CONException {
        super(new DbSizing(0));
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
        return DB_SIZING;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSizing().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Sizing sizing = fetchExc(ent.getOID());
        ent = (Entity) sizing;
        return sizing.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Sizing) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Sizing) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Sizing fetchExc(long oid) throws CONException {
        try {
            Sizing sizing = new Sizing();
            DbSizing dbSizing = new DbSizing(oid);
            sizing.setOID(oid);
            sizing.setLandingId(dbSizing.getlong(COL_LANDING_ID));
            sizing.setOffloadingId(dbSizing.getlong(COL_OFFLOADING_ID));
            sizing.setFishId(dbSizing.getlong(COL_FISH_ID));
            sizing.setCm(dbSizing.getdouble(COL_CM));
            sizing.setCODRSPictureDate(dbSizing.getDate(COL_CODRS_PICTURE_DATE));
            sizing.setCODRSPictureName(dbSizing.getString(COL_CODRS_PICTURE_NAME));
            sizing.setDataQuality(dbSizing.getInt(COL_DATA_QUALITY));
            return sizing;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSizing(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Sizing sizing) throws CONException {
        try {
            DbSizing dbSizing = new DbSizing(0);
            dbSizing.setLong(COL_LANDING_ID, sizing.getLandingId());
            dbSizing.setLong(COL_OFFLOADING_ID, sizing.getOffloadingId());
            dbSizing.setLong(COL_FISH_ID, sizing.getFishId());
            dbSizing.setDouble(COL_CM, sizing.getCm());
            dbSizing.setDate(COL_CODRS_PICTURE_DATE, sizing.getCODRSPictureDate());
            dbSizing.setString(COL_CODRS_PICTURE_NAME, sizing.getCODRSPictureName());
            dbSizing.setInt(COL_DATA_QUALITY, sizing.getDataQuality());
            dbSizing.insert();
            sizing.setOID(dbSizing.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSizing(0), CONException.UNKNOWN);
        }
        return sizing.getOID();
    }

    public static long insertExcWithOid(Sizing sizing) throws CONException {
        try {
            String sql = "insert into "
                    + DB_SIZING + "(" + colNames[COL_OID] + ", " + colNames[COL_FISH_ID] + ", " + colNames[COL_CM]
                    + ", " + colNames[COL_LANDING_ID] + ", " + colNames[COL_OFFLOADING_ID]
                    + ", " + colNames[COL_CODRS_PICTURE_DATE] + ", " + colNames[COL_CODRS_PICTURE_NAME]
                    + ", " + colNames[COL_DATA_QUALITY]
                    + ") values ('"
                    + sizing.getOID() + "', '" + sizing.getFishId() + "', '" + sizing.getCm() + "'"
                    + ", '" + sizing.getLandingId() + "', '" + sizing.getOffloadingId() + "'"
                    + ", '" + JSPFormater.formatDate(sizing.getCODRSPictureDate(), "yyyy-MM-dd HH:mm:ss") + "'"
                    + ", '" + sizing.getCODRSPictureName() + "', " + sizing.getDataQuality() + ")";
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("[" + new Date() + "] " + sizing.getOID() + " - " + e.toString());
            sizing.setOID(0);
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
        }
        return sizing.getOID();
    }

    public static long deleteByLandingId(long oid) {
        DbSizing dbObj = new DbSizing();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + dbObj.getTableName()
                    + " WHERE " + colNames[COL_LANDING_ID]
                    + " = '" + oid + "'";
            return CONHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static long updateExc(Sizing sizing) throws CONException {
        try {
            if (sizing.getOID() != 0) {
                DbSizing dbSizing = new DbSizing(sizing.getOID());
                dbSizing.setLong(COL_LANDING_ID, sizing.getLandingId());
                dbSizing.setLong(COL_OFFLOADING_ID, sizing.getOffloadingId());
                dbSizing.setLong(COL_FISH_ID, sizing.getFishId());
                dbSizing.setDouble(COL_CM, sizing.getCm());
                dbSizing.setDate(COL_CODRS_PICTURE_DATE, sizing.getCODRSPictureDate());
                dbSizing.setString(COL_CODRS_PICTURE_NAME, sizing.getCODRSPictureName());
                dbSizing.setInt(COL_DATA_QUALITY, sizing.getDataQuality());
                dbSizing.update();
                return sizing.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSizing(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbSizing dbSizing = new DbSizing(oid);
            dbSizing.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSizing(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_SIZING;
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
                Sizing sizing = new Sizing();
                resultToObject(rs, sizing);
                lists.add(sizing);
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

    public static void resultToObject(ResultSet rs, Sizing sizing) {
        try {
            sizing.setOID(rs.getLong(colNames[COL_OID]));
            sizing.setLandingId(rs.getLong(colNames[COL_LANDING_ID]));
            sizing.setOffloadingId(rs.getLong(colNames[COL_OFFLOADING_ID]));
            sizing.setFishId(rs.getLong(colNames[COL_FISH_ID]));
            sizing.setCm(rs.getDouble(colNames[COL_CM]));
            sizing.setCODRSPictureDate(JSPFormater.formatDate(rs.getString(colNames[COL_CODRS_PICTURE_DATE]), "yyyy-MM-dd HH:mm:ss"));
            sizing.setCODRSPictureName(rs.getString(colNames[COL_CODRS_PICTURE_NAME]));
            sizing.setDataQuality(rs.getInt(colNames[COL_DATA_QUALITY]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long sizingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_SIZING + " WHERE "
                    + colNames[COL_OID] + " = " + sizingId;

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
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_SIZING;
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

    public static int getCount(long landingId) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_SIZING
                    + " WHERE " + colNames[COL_LANDING_ID] + " = " + landingId;

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
                    Sizing sizing = (Sizing) list.get(ls);
                    if (oid == sizing.getOID()) {
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
    
}
