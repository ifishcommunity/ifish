package com.project.general;

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
public class DbGroupDetail extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_GROUP_DETAIL = "gen_group_detail";
    
    public static final int COL_GROUP_DETAIL_ID = 0;
    public static final int COL_GROUP_ID = 1;
    public static final int COL_MN_1 = 2;
    public static final int COL_MN_2 = 3;
    public static final int COL_CMD_ADD = 4;
    public static final int COL_CMD_EDIT = 5;
    public static final int COL_CMD_VIEW = 6;
    public static final int COL_CMD_DELETE = 7;
    
    public static final String[] colNames = {
        "group_detail_id",
        "group_id",
        "mn_1",
        "mn_2",
        "cmd_add",
        "cmd_edit",
        "cmd_view",
        "cmd_delete"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public DbGroupDetail() {
    }

    public DbGroupDetail(int i) throws CONException {
        super(new DbGroupDetail());
    }

    public DbGroupDetail(String sOid) throws CONException {
        super(new DbGroupDetail(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbGroupDetail(long lOid) throws CONException {
        super(new DbGroupDetail(0));
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
        return DB_GROUP_DETAIL;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbGroupDetail().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        GroupDetail GroupDetail = fetchExc(ent.getOID());
        ent = (Entity) GroupDetail;
        return GroupDetail.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((GroupDetail) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((GroupDetail) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static GroupDetail fetchExc(long oid) throws CONException {
        try {
            GroupDetail groupDetail = new GroupDetail();
            DbGroupDetail dbGroupDetail = new DbGroupDetail(oid);
            groupDetail.setOID(oid);

            groupDetail.setGroupId(dbGroupDetail.getlong(COL_GROUP_ID));
            groupDetail.setMn1(dbGroupDetail.getInt(COL_MN_1));
            groupDetail.setMn2(dbGroupDetail.getInt(COL_MN_2));
            groupDetail.setCmdAdd(dbGroupDetail.getInt(COL_CMD_ADD));
            groupDetail.setCmdEdit(dbGroupDetail.getInt(COL_CMD_EDIT));
            groupDetail.setCmdView(dbGroupDetail.getInt(COL_CMD_VIEW));
            groupDetail.setCmdDelete(dbGroupDetail.getInt(COL_CMD_DELETE));

            return groupDetail;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGroupDetail(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(GroupDetail GroupDetail) throws CONException {
        try {
            DbGroupDetail dbGroupDetail = new DbGroupDetail(0);

            dbGroupDetail.setLong(COL_GROUP_ID, GroupDetail.getGroupId());
            dbGroupDetail.setInt(COL_MN_1, GroupDetail.getMn1());
            dbGroupDetail.setInt(COL_MN_2, GroupDetail.getMn2());
            dbGroupDetail.setInt(COL_CMD_ADD, GroupDetail.getCmdAdd());
            dbGroupDetail.setInt(COL_CMD_EDIT, GroupDetail.getCmdEdit());
            dbGroupDetail.setInt(COL_CMD_VIEW, GroupDetail.getCmdView());
            dbGroupDetail.setInt(COL_CMD_DELETE, GroupDetail.getCmdDelete());

            dbGroupDetail.insert();
            GroupDetail.setOID(dbGroupDetail.getlong(COL_GROUP_DETAIL_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGroupDetail(0), CONException.UNKNOWN);
        }
        return GroupDetail.getOID();
    }

    public static long updateExc(GroupDetail GroupDetail) throws CONException {
        try {
            if (GroupDetail.getOID() != 0) {
                DbGroupDetail dbGroupDetail = new DbGroupDetail(GroupDetail.getOID());

                dbGroupDetail.setLong(COL_GROUP_ID, GroupDetail.getGroupId());
                dbGroupDetail.setInt(COL_MN_1, GroupDetail.getMn1());
                dbGroupDetail.setInt(COL_MN_2, GroupDetail.getMn2());
                dbGroupDetail.setInt(COL_CMD_ADD, GroupDetail.getCmdAdd());
                dbGroupDetail.setInt(COL_CMD_EDIT, GroupDetail.getCmdEdit());
                dbGroupDetail.setInt(COL_CMD_VIEW, GroupDetail.getCmdView());
                dbGroupDetail.setInt(COL_CMD_DELETE, GroupDetail.getCmdDelete());

                dbGroupDetail.update();
                return GroupDetail.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGroupDetail(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbGroupDetail dbGroupDetail = new DbGroupDetail(oid);
            dbGroupDetail.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbGroupDetail(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_GROUP_DETAIL;
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
                GroupDetail GroupDetail = new GroupDetail();
                resultToObject(rs, GroupDetail);
                lists.add(GroupDetail);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static void resultToObject(ResultSet rs, GroupDetail GroupDetail) {
        try {
            GroupDetail.setOID(rs.getLong(DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_DETAIL_ID]));
            GroupDetail.setGroupId(rs.getLong(DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_ID]));
            GroupDetail.setMn1(rs.getInt(DbGroupDetail.colNames[DbGroupDetail.COL_MN_1]));
            GroupDetail.setMn2(rs.getInt(DbGroupDetail.colNames[DbGroupDetail.COL_MN_2]));
            GroupDetail.setCmdAdd(rs.getInt(DbGroupDetail.colNames[DbGroupDetail.COL_CMD_ADD]));
            GroupDetail.setCmdEdit(rs.getInt(DbGroupDetail.colNames[DbGroupDetail.COL_CMD_EDIT]));
            GroupDetail.setCmdView(rs.getInt(DbGroupDetail.colNames[DbGroupDetail.COL_CMD_VIEW]));
            GroupDetail.setCmdDelete(rs.getInt(DbGroupDetail.colNames[DbGroupDetail.COL_CMD_DELETE]));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }

    public static boolean checkOID(long groupDetailId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_GROUP_DETAIL + " WHERE " +
                    DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_DETAIL_ID] + " = " + groupDetailId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_DETAIL_ID] + ") FROM " + DB_GROUP_DETAIL;
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
                    GroupDetail GroupDetail = (GroupDetail) list.get(ls);
                    if (oid == GroupDetail.getOID()) {
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
    
    public static long deleteByGroup(long groupId) {
        CONResultSet dbrs = null;
        try {
            String sql = "delete from " + DB_GROUP_DETAIL + " where " + colNames[COL_GROUP_ID] + "=" + groupId;
            CONHandler.execUpdate(sql);
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        
        return 0;
    }
}
