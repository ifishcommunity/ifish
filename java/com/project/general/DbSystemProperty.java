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

public class DbSystemProperty extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_SYSPROP = "gen_sysprop";
    public static final int COL_SYSPROP_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_VALUE = 2;
    public static final int COL_VALTYPE = 3;
    public static final int COL_NOTE = 4;
    public static String[] fieldNames = {
        "sysprop_id",
        "name",
        "valueprop",
        "valtype",
        "note"
    };
    public static int[] fieldTypes = {
        TYPE_PK + TYPE_LONG + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING
    };
    //Other constanta goes here (if any)
    public static String[] valueTypes = {"STRING", "TEXT", "NUMBER"};
    public static String NOT_INITIALIZED = "Not Initialized!";

    public DbSystemProperty() {
    }

    public DbSystemProperty(int i) throws CONException {
        super(new DbSystemProperty());
    }

    public DbSystemProperty(String sOid) throws CONException {
        super(new DbSystemProperty(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbSystemProperty(long lOid) throws CONException {
        super(new DbSystemProperty(0));
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

    /**
     *	Implemanting I_Entity interface methods
     */
    public int getFieldSize() {
        return fieldNames.length;
    }

    public String getTableName() {
        return DB_SYSPROP;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbSystemProperty().getClass().getName();
    }

    /**
     *	Implemanting I_CONInterface interface methods
     */
    public long fetch(Entity ent) {
        SystemProperty sysProp = DbSystemProperty.fetch(ent.getOID());
        ent = (Entity) sysProp;
        return sysProp.getOID();
    }

    public long insert(Entity ent) {
        return DbSystemProperty.insert((SystemProperty) ent);
    }

    public long update(Entity ent) {
        return update((SystemProperty) ent);
    }

    public long delete(Entity ent) {
        return delete((SystemProperty) ent);
    }

    public static SystemProperty fetch(long oid) {
        SystemProperty sysProp = new SystemProperty();
        try {
            DbSystemProperty dbSystemProperty = new DbSystemProperty(oid);
            sysProp.setOID(oid);
            sysProp.setName(dbSystemProperty.getString(COL_NAME));
            sysProp.setValue(dbSystemProperty.getString(COL_VALUE));
            sysProp.setValueType(dbSystemProperty.getString(COL_VALTYPE));
            sysProp.setNote(dbSystemProperty.getString(COL_NOTE));
        } catch (CONException e) {
            System.out.println("[Exception] " + e.toString());
        }
        return sysProp;
    }

    public static long insert(SystemProperty sysProp) {
        try {
            DbSystemProperty dbSystemProperty = new DbSystemProperty(0);
            dbSystemProperty.setString(COL_NAME, sysProp.getName());
            dbSystemProperty.setString(COL_VALUE, sysProp.getValue());
            dbSystemProperty.setString(COL_VALTYPE, sysProp.getValueType());
            dbSystemProperty.setString(COL_NOTE, sysProp.getNote());
            dbSystemProperty.insert();
            sysProp.setOID(dbSystemProperty.getlong(COL_SYSPROP_ID));
            return sysProp.getOID();
        } catch (CONException e) {
            System.out.println("[Exception] " + e.toString());
        }
        return 0;
    }

    public static long update(SystemProperty sysProp) {
        if (sysProp.getOID() != 0) {
            try {
                DbSystemProperty dbSystemProperty = new DbSystemProperty(sysProp.getOID());
                dbSystemProperty.setString(COL_NAME, sysProp.getName());
                dbSystemProperty.setString(COL_VALUE, sysProp.getValue());
                dbSystemProperty.setString(COL_VALTYPE, sysProp.getValueType());
                dbSystemProperty.setString(COL_NOTE, sysProp.getNote());
                dbSystemProperty.update();
                return sysProp.getOID();
            } catch (Exception e) {
                System.out.println("[Exception] " + e.toString());
            }
        }
        return 0;
    }

    public static long delete(long oid) {
        try {
            DbSystemProperty dbSystemProperty = new DbSystemProperty(oid);
            dbSystemProperty.delete();
            return oid;
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
        return 0;
    }

    public static Vector listAll() {
        return list(0, 0, null, null);
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        CONResultSet CONrs = null;
        Vector lists = new Vector();
        try {
            String sql = "SELECT * FROM " + DB_SYSPROP + " ";
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
            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs = CONrs.getResultSet();

            while (rs.next()) {
                SystemProperty sysProp = new SystemProperty();
                resultToObject(rs, sysProp);
                lists.add(sysProp);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(CONrs);
        }
        return new Vector();
    }

    public static String getValueByName(String name) {
        CONResultSet CONrs = null;
        String val = NOT_INITIALIZED;
        try {
            String sql = "SELECT " + fieldNames[COL_VALUE] + " FROM " + DB_SYSPROP + " WHERE " + fieldNames[COL_NAME] + "='" + name + "'";
            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs = CONrs.getResultSet();

            if(rs.next()) {
                val = rs.getString(1);
            } else {
                val = name + " " + val;
                System.out.println(val);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(CONrs);
        }
        return val;
    }

    public static int getCount() {
        int count = 0;
        CONResultSet CONrs = null;
        try {
            String sql = "SELECT COUNT(" + fieldNames[COL_SYSPROP_ID] + ") FROM " + DB_SYSPROP;
            CONrs = CONHandler.execQueryResult(sql);
            ResultSet rs = CONrs.getResultSet();

            while (rs.next()) {
                count = rs.getInt(1);
                break;
            }
            rs.close();
            return count;

        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(CONrs);
        }
        return 0;
    }

    private static void resultToObject(ResultSet rs, SystemProperty sysProp) {
        try {
            sysProp.setOID(rs.getLong(COL_SYSPROP_ID + 1));
            sysProp.setName(rs.getString(COL_NAME + 1));
            sysProp.setValue(rs.getString(COL_VALUE + 1));
            sysProp.setValueType(rs.getString(COL_VALTYPE + 1));
            sysProp.setNote(rs.getString(COL_NOTE + 1));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }
}
