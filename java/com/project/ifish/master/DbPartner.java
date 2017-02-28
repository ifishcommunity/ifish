package com.project.ifish.master;

import com.project.IFishConfig;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class DbPartner extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_PARTNER = "ifish_partner";
    public static final int COL_OID = 0;
    public static final int COL_TYPE = 1;
    public static final int COL_NAME = 2;
    public static final int COL_ADDRESS = 3;
    public static final int COL_CP = 4;
    public static final int COL_PHONE = 5;
    public static final int COL_EMAIL = 6;
    public static final int COL_NOTES = 7;
    public static final int COL_SERVER_STATUS = 8;
    public static final int COL_SERVER_IP = 9;
    public static final int COL_TOKEN = 10;
    public static final String[] colNames = {
        "oid",
        "type",
        "name",
        "address",
        "cp",
        "phone",
        "email",
        "notes",
        "server_status",
        "server_ip",
        "token"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_STRING
    };

    public DbPartner() {
    }

    public DbPartner(int i) throws CONException {
        super(new DbPartner());
    }

    public DbPartner(String sOid) throws CONException {
        super(new DbPartner(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbPartner(long lOid) throws CONException {
        super(new DbPartner(0));
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
        return DB_PARTNER;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbPartner().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Partner partner = fetchExc(ent.getOID());
        ent = (Entity) partner;
        return partner.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Partner) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Partner) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Partner fetchExc(long oid) throws CONException {
        try {
            Partner partner = new Partner();
            DbPartner dbPartner = new DbPartner(oid);
            partner.setOID(oid);
            partner.setType(dbPartner.getString(COL_TYPE));
            partner.setName(dbPartner.getString(COL_NAME));
            partner.setAddress(dbPartner.getString(COL_ADDRESS));
            partner.setCp(dbPartner.getString(COL_CP));
            partner.setPhone(dbPartner.getString(COL_PHONE));
            partner.setEmail(dbPartner.getString(COL_EMAIL));
            partner.setNotes(dbPartner.getString(COL_NOTES));
            partner.setServerStatus(dbPartner.getInt(COL_SERVER_STATUS));
            partner.setServerIP(dbPartner.getString(COL_SERVER_IP));
            partner.setToken(dbPartner.getString(COL_TOKEN));
            return partner;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPartner(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Partner partner) throws CONException {
        try {
            DbPartner dbPartner = new DbPartner(0);
            dbPartner.setString(COL_TYPE, partner.getType());
            dbPartner.setString(COL_NAME, partner.getName());
            dbPartner.setString(COL_ADDRESS, partner.getAddress());
            dbPartner.setString(COL_CP, partner.getCp());
            dbPartner.setString(COL_PHONE, partner.getPhone());
            dbPartner.setString(COL_EMAIL, partner.getEmail());
            dbPartner.setString(COL_NOTES, partner.getNotes());
            dbPartner.setInt(COL_SERVER_STATUS, partner.getServerStatus());
            dbPartner.setString(COL_SERVER_IP, partner.getServerIP());
            dbPartner.setString(COL_TOKEN, partner.getToken());
            dbPartner.insert();
            partner.setOID(dbPartner.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPartner(0), CONException.UNKNOWN);
        }
        return partner.getOID();
    }

    public static long updateExc(Partner partner) throws CONException {
        try {
            if (partner.getOID() != 0) {
                DbPartner dbPartner = new DbPartner(partner.getOID());
                dbPartner.setString(COL_TYPE, partner.getType());
                dbPartner.setString(COL_NAME, partner.getName());
                dbPartner.setString(COL_ADDRESS, partner.getAddress());
                dbPartner.setString(COL_CP, partner.getCp());
                dbPartner.setString(COL_PHONE, partner.getPhone());
                dbPartner.setString(COL_EMAIL, partner.getEmail());
                dbPartner.setString(COL_NOTES, partner.getNotes());
                dbPartner.setInt(COL_SERVER_STATUS, partner.getServerStatus());
                dbPartner.setString(COL_SERVER_IP, partner.getServerIP());
                dbPartner.setString(COL_TOKEN, partner.getToken());
                dbPartner.update();
                return partner.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPartner(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbPartner dbPartner = new DbPartner(oid);
            dbPartner.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbPartner(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_PARTNER;
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
                Partner partner = new Partner();
                resultToObject(rs, partner);
                lists.add(partner);
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

    private static void resultToObject(ResultSet rs, Partner partner) {
        try {
            partner.setOID(rs.getLong(colNames[COL_OID]));
            partner.setType(rs.getString(colNames[COL_TYPE]));
            partner.setName(rs.getString(colNames[COL_NAME]));
            partner.setAddress(rs.getString(colNames[COL_ADDRESS]));
            partner.setCp(rs.getString(colNames[COL_CP]));
            partner.setPhone(rs.getString(colNames[COL_PHONE]));
            partner.setEmail(rs.getString(colNames[COL_EMAIL]));
            partner.setNotes(rs.getString(colNames[COL_NOTES]));
            partner.setServerStatus(rs.getInt(colNames[COL_SERVER_STATUS]));
            partner.setServerIP(rs.getString(colNames[COL_SERVER_IP]));
            partner.setToken(rs.getString(colNames[COL_TOKEN]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long partnerId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_PARTNER + " WHERE "
                    + colNames[COL_OID] + " = " + partnerId;

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
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_PARTNER;
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
                    Partner partner = (Partner) list.get(ls);
                    if (oid == partner.getOID()) {
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

    public static List<Partner> listFishermen() {
        List<Partner> list = new ArrayList<Partner>();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT p.*, b.* FROM " + DB_PARTNER + " p INNER JOIN " + DbPartnerBoat.DB_PARTNER_BOAT + " pb"
                    + " ON p." + colNames[COL_OID] + " = pb." + DbPartnerBoat.colNames[DbPartnerBoat.COL_PARTNER_ID]
                    + " INNER JOIN " + DbBoat.DB_BOAT + " b"
                    + " ON pb." + DbPartnerBoat.colNames[DbPartnerBoat.COL_BOAT_ID] + " = b." + DbBoat.colNames[DbBoat.COL_OID]
                    + " WHERE p." + colNames[COL_TYPE] + " like '" + IFishConfig.PARTNER_FISHERMAN + "'"
                    + " ORDER BY b." + DbBoat.colNames[DbBoat.COL_PROGRAM_SITE] + ", p." + DbPartner.colNames[DbPartner.COL_NAME];

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                Partner p = new Partner();
                resultToObject(rs, p);
                Boat b = new Boat();
                DbBoat.resultToObject(rs, b);
                p.setName(b.getProgramSite() + " - " + p.getName());
                list.add(p);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return list;
    }
}
