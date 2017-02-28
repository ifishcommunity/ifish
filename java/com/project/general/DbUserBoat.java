package com.project.general;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_Persintent;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class DbUserBoat extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_USER_BOAT = "gen_user_boat";
    public static final int COL_USER_ID = 0;
    public static final int COL_BOAT_ID = 1;
    public static final String[] colNames = {
        "user_id", "boat_id"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG
    };

    public DbUserBoat() {
    }

    public DbUserBoat(int i) throws CONException {
        super(new DbUserBoat());
    }

    public DbUserBoat(String sOid) throws CONException {
        super(new DbUserBoat(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUserBoat(long lOid) throws CONException {
        super(new DbUserBoat(0));
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
        return DB_USER_BOAT;
    }

    public String getPersistentName() {
        return new DbUserBoat().getClass().getName();
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public long delete(Entity ent) {
        return delete((UserBoat) ent);
    }

    public long insert(Entity ent) {
        return DbUserBoat.insert((UserBoat) ent);
    }

    public long update(Entity ent) {
        return update((UserBoat) ent);
    }

    public long fetch(Entity ent) {
        UserBoat userBoat = DbUserBoat.fetch(ent.getOID());
        ent = (Entity) userBoat;
        return ent.getOID();
    }

    public static UserBoat fetch(long oid) {
        UserBoat userBoat = new UserBoat();
        try {
            DbUserBoat dbUserBoat = new DbUserBoat(oid);
            userBoat.setOID(oid);
            userBoat.setUserId(dbUserBoat.getlong(COL_USER_ID));
            userBoat.setBoatId(dbUserBoat.getlong(COL_BOAT_ID));
        } catch (CONException e) {
            System.out.println("[Exception] " + e.toString());
        }
        return userBoat;
    }

    public static long insert(UserBoat userBoat) {
        try {
            DbUserBoat dbUserBoat = new DbUserBoat(0);
            dbUserBoat.setLong(COL_USER_ID, userBoat.getUserId());
            dbUserBoat.setLong(COL_BOAT_ID, userBoat.getBoatId());

            dbUserBoat.insert();
            userBoat.setOID(dbUserBoat.getlong(COL_USER_ID));
            return userBoat.getOID();
        } catch (CONException e) {
            System.out.println("[Exception] " + e.toString());
        }
        return 0;
    }

    public static long update(UserBoat userBoat) {
        if ((userBoat != null) && (userBoat.getOID() != 0)) {
            try {
                DbUserBoat dbUserBoat = new DbUserBoat(userBoat.getOID());
                dbUserBoat.setLong(COL_USER_ID, userBoat.getUserId());
                dbUserBoat.setLong(COL_BOAT_ID, userBoat.getBoatId());

                dbUserBoat.update();
                return userBoat.getOID();
            } catch (Exception e) {
                System.out.println("[Exception] " + e.toString());
            }
        }
        return 0;
    }

    public static long delete(long oid) {
        try {
            DbUserBoat dbUserBoat = new DbUserBoat(oid);
            dbUserBoat.delete();
            return oid;
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
        return 0;
    }

    public static long deleteByUser(long oid) {
        DbUserBoat dbUserBoat = new DbUserBoat();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + dbUserBoat.getTableName()
                    + " WHERE " + DbUserBoat.colNames[DbUserBoat.COL_USER_ID]
                    + " = '" + oid + "'";

            int status = CONHandler.execUpdate(sql);
            return oid;
        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return 0;
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        int count = 0;
        try {
            String sql = " SELECT COUNT(" + colNames[COL_USER_ID] + ") FROM " + DB_USER_BOAT;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
        return count;
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT " + colNames[COL_USER_ID] +
                    ", " + colNames[COL_BOAT_ID] +
                    " FROM " + DB_USER_BOAT;

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
                UserBoat appPriv = new UserBoat();
                resultToObject(rs, appPriv);
                lists.add(appPriv);
            }
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return lists;
    }

    private static void resultToObject(ResultSet rs, UserBoat userBoat) {
        try {
            userBoat.setUserId(rs.getLong(colNames[COL_USER_ID]));
            userBoat.setBoatId(rs.getLong(colNames[COL_BOAT_ID]));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }
}
