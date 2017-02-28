package com.project.ifish.master;

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
public class DbPartnerBoat extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_PARTNER_BOAT = "ifish_partner_boat";
    public static final int COL_PARTNER_ID = 0;
    public static final int COL_BOAT_ID = 1;
    public static final String[] colNames = {
        "partner_id", "boat_id"
    };
    public static int[] fieldTypes = {
        TYPE_LONG, TYPE_LONG
    };

    public DbPartnerBoat() {
    }

    public DbPartnerBoat(int i) throws CONException {
        super(new DbPartnerBoat());
    }

    public DbPartnerBoat(String sOid) throws CONException {
        super(new DbPartnerBoat(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPartnerBoat(long lOid) throws CONException {
        super(new DbPartnerBoat(0));
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
        return DB_PARTNER_BOAT;
    }

    public String getPersistentName() {
        return new DbPartnerBoat().getClass().getName();
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public long delete(Entity ent) {
        return delete((PartnerBoat) ent);
    }

    public long insert(Entity ent) {
        return DbPartnerBoat.insert((PartnerBoat) ent);
    }

    public long update(Entity ent) {
        return update((PartnerBoat) ent);
    }

    public long fetch(Entity ent) {
        PartnerBoat partnerBoat = DbPartnerBoat.fetch(ent.getOID());
        ent = (Entity) partnerBoat;
        return ent.getOID();
    }

    public static PartnerBoat fetch(long oid) {
        PartnerBoat partnerBoat = new PartnerBoat();
        try {
            DbPartnerBoat dbPartnerBoat = new DbPartnerBoat(oid);
            partnerBoat.setOID(oid);
            partnerBoat.setPartnerId(dbPartnerBoat.getlong(COL_PARTNER_ID));
            partnerBoat.setBoatId(dbPartnerBoat.getlong(COL_BOAT_ID));
        } catch (CONException e) {
            System.out.println("[Exception] " + e.toString());
        }
        return partnerBoat;
    }

    public static long insert(PartnerBoat partnerBoat) {
        try {
            DbPartnerBoat dbPartnerBoat = new DbPartnerBoat(0);
            dbPartnerBoat.setLong(COL_PARTNER_ID, partnerBoat.getPartnerId());
            dbPartnerBoat.setLong(COL_BOAT_ID, partnerBoat.getBoatId());

            dbPartnerBoat.insert();
            partnerBoat.setOID(dbPartnerBoat.getlong(COL_PARTNER_ID));
            return partnerBoat.getOID();
        } catch (CONException e) {
            System.out.println("[Exception] " + e.toString());
        }
        return 0;
    }

    public static long update(PartnerBoat partnerBoat) {
        if ((partnerBoat != null) && (partnerBoat.getOID() != 0)) {
            try {
                DbPartnerBoat dbPartnerBoat = new DbPartnerBoat(partnerBoat.getOID());
                dbPartnerBoat.setLong(COL_PARTNER_ID, partnerBoat.getPartnerId());
                dbPartnerBoat.setLong(COL_BOAT_ID, partnerBoat.getBoatId());

                dbPartnerBoat.update();
                return partnerBoat.getOID();
            } catch (Exception e) {
                System.out.println("[Exception] " + e.toString());
            }
        }
        return 0;
    }

    public static long delete(long oid) {
        try {
            DbPartnerBoat dbPartnerBoat = new DbPartnerBoat(oid);
            dbPartnerBoat.delete();
            return oid;
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
        return 0;
    }

    public static long deleteByPartner(long oid) {
        DbPartnerBoat dbPartnerBoat = new DbPartnerBoat();
        CONResultSet dbrs = null;
        try {
            String sql = "DELETE FROM " + dbPartnerBoat.getTableName()
                    + " WHERE " + DbPartnerBoat.colNames[DbPartnerBoat.COL_PARTNER_ID]
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
            String sql = " SELECT COUNT(" + colNames[COL_PARTNER_ID] + ") FROM " + DB_PARTNER_BOAT;

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
            String sql = "SELECT " + colNames[COL_PARTNER_ID] +
                    ", " + colNames[COL_BOAT_ID] +
                    " FROM " + DB_PARTNER_BOAT;

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
                PartnerBoat appPriv = new PartnerBoat();
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

    private static void resultToObject(ResultSet rs, PartnerBoat partnerBoat) {
        try {
            partnerBoat.setPartnerId(rs.getLong(colNames[COL_PARTNER_ID]));
            partnerBoat.setBoatId(rs.getLong(colNames[COL_BOAT_ID]));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }

    public static Vector listBoat(long partnerId) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT b.*"
                    + " FROM " + DbBoat.DB_BOAT + " b INNER JOIN " + DB_PARTNER_BOAT + " pb"
                    + " ON b." + DbBoat.colNames[DbBoat.COL_OID] + " = pb." + colNames[COL_BOAT_ID]
                    + " WHERE pb." + colNames[COL_PARTNER_ID] + " = " + partnerId
                    + " ORDER BY b." + DbBoat.colNames[DbBoat.COL_CODE];
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Boat boat = new Boat();
                DbBoat.resultToObject(rs, boat);
                lists.add(boat);
            }
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return lists;
    }
}
