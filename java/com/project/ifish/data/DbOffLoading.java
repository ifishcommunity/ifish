package com.project.ifish.data;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class DbOffLoading extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_OFFLOADING = "ifish_offloading";
    public static final int COL_OID = 0;
    public static final int COL_LANDING_ID = 1;
    public static final int COL_FISH_ID = 2;
    public static final int COL_PCS = 3;
    public static final int COL_NW = 4;
    public static final int COL_TEMPERATURE = 5;
    public static final int COL_CONDITION = 6;
    public static final int COL_GRADE = 7;
    public static final String[] colNames = {
        "oid",
        "landing_id",
        "fish_id",
        "pcs",
        "nw",
        "temperature",
        "condition_",
        "grade"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };

    public DbOffLoading() {
    }

    public DbOffLoading(int i) throws CONException {
        super(new DbOffLoading());
    }

    public DbOffLoading(String sOid) throws CONException {
        super(new DbOffLoading(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbOffLoading(long lOid) throws CONException {
        super(new DbOffLoading(0));
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
        return DB_OFFLOADING;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbOffLoading().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        OffLoading offloading = fetchExc(ent.getOID());
        ent = (Entity) offloading;
        return offloading.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((OffLoading) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((OffLoading) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static OffLoading fetchExc(long oid) throws CONException {
        try {
            OffLoading offloading = new OffLoading();
            DbOffLoading dbOffLoading = new DbOffLoading(oid);
            offloading.setOID(oid);
            offloading.setLandingId(dbOffLoading.getlong(COL_LANDING_ID));
            offloading.setFishId(dbOffLoading.getlong(COL_FISH_ID));
            offloading.setPcs(dbOffLoading.getdouble(COL_PCS));
            offloading.setNw(dbOffLoading.getdouble(COL_NW));
            offloading.setTemperature(dbOffLoading.getdouble(COL_TEMPERATURE));
            offloading.setCondition(dbOffLoading.getString(COL_CONDITION));
            offloading.setGrade(dbOffLoading.getString(COL_GRADE));
            return offloading;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
        }
    }

    public static long insertExcWithOid(OffLoading offloading) throws CONException {
        try {
            String sql = "insert into "
                    + DB_OFFLOADING + "(" + colNames[COL_OID] + ", " + colNames[COL_LANDING_ID]
                    + ", " + colNames[COL_FISH_ID] + ", " + colNames[COL_PCS] + ", " + colNames[COL_NW]
                    + ", " + colNames[COL_TEMPERATURE] + ", " + colNames[COL_CONDITION] + ", " + colNames[COL_GRADE]
                    + ") values ('" + offloading.getOID() + "', '" + offloading.getLandingId() + "'"
                    + ", '" + offloading.getFishId() + "', '" + offloading.getPcs() + "', '" + offloading.getNw() + "'"
                    + ", '" + offloading.getTemperature() + "', '" + offloading.getCondition() + "', '" + offloading.getGrade() + "')";
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            offloading.setOID(0);
            System.out.println("[" + new Date() + "] " + e.toString());
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
        }
        return offloading.getOID();
    }

    public static long updateExc(OffLoading offloading) throws CONException {
        try {
            if (offloading.getOID() != 0) {
                DbOffLoading dbOffLoading = new DbOffLoading(offloading.getOID());
                dbOffLoading.setLong(COL_LANDING_ID, offloading.getLandingId());
                dbOffLoading.setLong(COL_FISH_ID, offloading.getFishId());
                dbOffLoading.setDouble(COL_PCS, offloading.getPcs());
                dbOffLoading.setDouble(COL_NW, offloading.getNw());
                dbOffLoading.setDouble(COL_TEMPERATURE, offloading.getTemperature());
                dbOffLoading.setString(COL_CONDITION, offloading.getCondition());
                dbOffLoading.setString(COL_GRADE, offloading.getGrade());
                dbOffLoading.update();
                return offloading.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbOffLoading dbOffLoading = new DbOffLoading(oid);
            dbOffLoading.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_OFFLOADING;
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
                OffLoading offloading = new OffLoading();
                resultToObject(rs, offloading);
                lists.add(offloading);
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

    private static void resultToObject(ResultSet rs, OffLoading offloading) {
        try {
            offloading.setOID(rs.getLong(colNames[COL_OID]));
            offloading.setLandingId(rs.getLong(colNames[COL_LANDING_ID]));
            offloading.setFishId(rs.getLong(colNames[COL_FISH_ID]));
            offloading.setPcs(rs.getDouble(colNames[COL_PCS]));
            offloading.setNw(rs.getDouble(colNames[COL_NW]));
            offloading.setTemperature(rs.getDouble(colNames[COL_TEMPERATURE]));
            offloading.setCondition(rs.getString(colNames[COL_CONDITION]));
            offloading.setGrade(rs.getString(colNames[COL_GRADE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long offloadingId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_OFFLOADING + " WHERE "
                    + colNames[COL_OID] + " = " + offloadingId;

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
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_OFFLOADING;
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

    public static double getCount(long landingId) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT SUM(" + colNames[COL_PCS] + ") FROM " + DB_OFFLOADING
                    + " WHERE " + colNames[COL_LANDING_ID] + " = " + landingId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            double count = 0;
            while (rs.next()) {
                count = rs.getDouble(1);
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
                    OffLoading offloading = (OffLoading) list.get(ls);
                    if (oid == offloading.getOID()) {
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
