package com.project.main.log;

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
public class DbLogsAction extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_LOGS_ACTION = "logs_action";
    public static final int COL_OID = 0;
    public static final int COL_DATE_TIME = 1;
    public static final int COL_CMD_ACTION = 2;
    public static final int COL_TABLE_NAME = 3;
    public static final int COL_DOC_ID = 4;
    public static final int COL_USER_ID = 5;
    public static final String[] colNames = {
        "oid",
        "date_time",
        "cmd_action",
        "table_name",
        "doc_id",
        "user_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_DATE,
        TYPE_INT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbLogsAction() {
    }

    public DbLogsAction(int i) throws CONException {
        super(new DbLogsAction());
    }

    public DbLogsAction(String sOid) throws CONException {
        super(new DbLogsAction(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbLogsAction(long lOid) throws CONException {
        super(new DbLogsAction(0));
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
        return DB_LOGS_ACTION;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbLogsAction().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        LogsAction logsAction = fetchExc(ent.getOID());
        ent = (Entity) logsAction;
        return logsAction.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((LogsAction) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((LogsAction) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static LogsAction fetchExc(long oid) throws CONException {
        try {
            LogsAction logsAction = new LogsAction();
            DbLogsAction dbLogsAction = new DbLogsAction(oid);
            logsAction.setOID(oid);
            logsAction.setDateTime(dbLogsAction.getDate(COL_DATE_TIME));
            logsAction.setCmdAction(dbLogsAction.getInt(COL_CMD_ACTION));
            logsAction.setTableName(dbLogsAction.getString(COL_TABLE_NAME));
            logsAction.setDocId(dbLogsAction.getlong(COL_DOC_ID));
            logsAction.setUserId(dbLogsAction.getlong(COL_USER_ID));
            return logsAction;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogsAction(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(LogsAction logsAction) throws CONException {
        try {
            DbLogsAction dbLogsAction = new DbLogsAction(0);
            dbLogsAction.setDate(COL_DATE_TIME, logsAction.getDateTime());
            dbLogsAction.setInt(COL_CMD_ACTION, logsAction.getCmdAction());
            dbLogsAction.setString(COL_TABLE_NAME, logsAction.getTableName());
            dbLogsAction.setLong(COL_DOC_ID, logsAction.getDocId());
            dbLogsAction.setLong(COL_USER_ID, logsAction.getUserId());
            dbLogsAction.insert();
            logsAction.setOID(dbLogsAction.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogsAction(0), CONException.UNKNOWN);
        }
        return logsAction.getOID();
    }

    public static long updateExc(LogsAction logsAction) throws CONException {
        try {
            if (logsAction.getOID() != 0) {
                DbLogsAction dbLogsAction = new DbLogsAction(logsAction.getOID());
                dbLogsAction.setDate(COL_DATE_TIME, logsAction.getDateTime());
                dbLogsAction.setInt(COL_CMD_ACTION, logsAction.getCmdAction());
                dbLogsAction.setString(COL_TABLE_NAME, logsAction.getTableName());
                dbLogsAction.setLong(COL_DOC_ID, logsAction.getDocId());
                dbLogsAction.setLong(COL_USER_ID, logsAction.getUserId());
                dbLogsAction.update();
                return logsAction.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogsAction(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbLogsAction dbLogsAction = new DbLogsAction(oid);
            dbLogsAction.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbLogsAction(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_LOGS_ACTION;
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

    public static Vector listAll() {
        return list(0, 0, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_LOGS_ACTION;
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
                LogsAction logsAction = new LogsAction();
                resultToObject(rs, logsAction);
                lists.add(logsAction);
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

    private static void resultToObject(ResultSet rs, LogsAction logsAction) {
        try {
            logsAction.setOID(rs.getLong(colNames[COL_OID]));
            logsAction.setDateTime(rs.getTimestamp(colNames[COL_DATE_TIME]));
            logsAction.setCmdAction(rs.getInt(colNames[COL_CMD_ACTION]));
            logsAction.setTableName(rs.getString(colNames[COL_TABLE_NAME]));
            logsAction.setDocId(rs.getLong(colNames[COL_DOC_ID]));
            logsAction.setUserId(rs.getLong(colNames[COL_USER_ID]));
        } catch (Exception e) {
        }
    }

    public static void insertLogs(int cmdAction, String tableName, long docId, long userId) {
        try {
            LogsAction logsAction = new LogsAction();
            logsAction.setDateTime(new Date());
            logsAction.setCmdAction(cmdAction);
            logsAction.setTableName(tableName);
            logsAction.setDocId(docId);
            logsAction.setUserId(userId);
            long oid = insertExc(logsAction);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static Vector listLogs(int limitStart, int recordToGet, long docId) {
        return list(limitStart, recordToGet, colNames[COL_DOC_ID] + "=" + docId, colNames[COL_DATE_TIME]+" DESC");
    }
}
