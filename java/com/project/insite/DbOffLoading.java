package com.project.insite;

import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
import java.io.InputStream;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class DbOffLoading extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_OFFLOADING = "insite_offloading";
    public static final int COL_OID = 0;
    public static final int COL_OFFLOADING_ID = 1;
    public static final int COL_RECEIVED_DATE = 2;
    public static final int COL_LATIN_NAME = 3;
    public static final int COL_SPECIES = 4;
    public static final int COL_PCS = 5;
    public static final int COL_NW = 6;
    public static final int COL_TEMPERATURE = 7;
    public static final int COL_CONDITION = 8;
    public static final int COL_GRADE = 9;
    public static final int COL_TRIP_ID = 10;
    public static final int COL_TRACKER_ID = 11;
    public static final int COL_STATUS = 12;
    public static final int COL_USER_ID = 13;
    public static final int COL_BOAT = 14;
    public static final int COL_BROUGHT_BY = 15;
    public static final int COL_PARTNER_ID = 16;
    public static final String[] colNames = {
        "oid",
        "offloading_id",
        "received_date",
        "latin_name",
        "species",
        "pcs",
        "nw",
        "temperature",
        "condition_",
        "grade",
        "trip_id",
        "tracker_id",
        "status",
        "user_id",
        "boat",
        "brought_by",
        "partner_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
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
            offloading.setOffloadingId(dbOffLoading.getlong(COL_OFFLOADING_ID));
            offloading.setReceivedDate(dbOffLoading.getDate(COL_RECEIVED_DATE));
            offloading.setLatinName(dbOffLoading.getString(COL_LATIN_NAME));
            offloading.setSpecies(dbOffLoading.getString(COL_SPECIES));
            offloading.setPcs(dbOffLoading.getdouble(COL_PCS));
            offloading.setNw(dbOffLoading.getdouble(COL_NW));
            offloading.setTemperature(dbOffLoading.getdouble(COL_TEMPERATURE));
            offloading.setCondition(dbOffLoading.getString(COL_CONDITION));
            offloading.setGrade(dbOffLoading.getString(COL_GRADE));
            offloading.setTripId(dbOffLoading.getlong(COL_TRIP_ID));
            offloading.setTripId(dbOffLoading.getlong(COL_TRACKER_ID));
            offloading.setStatus(dbOffLoading.getInt(COL_STATUS));
            offloading.setUserId(dbOffLoading.getlong(COL_USER_ID));
            offloading.setPartnerId(dbOffLoading.getlong(COL_PARTNER_ID));
            offloading.setBoat(dbOffLoading.getString(COL_BOAT));
            offloading.setBroughtBy(dbOffLoading.getString(COL_BROUGHT_BY));
            return offloading;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(OffLoading offloading) throws CONException {
        try {
            DbOffLoading dbOffLoading = new DbOffLoading(0);
            dbOffLoading.setLong(COL_OFFLOADING_ID, offloading.getOffloadingId());
            dbOffLoading.setDate(COL_RECEIVED_DATE, offloading.getReceivedDate());
            dbOffLoading.setString(COL_LATIN_NAME, offloading.getLatinName());
            dbOffLoading.setString(COL_SPECIES, offloading.getSpecies());
            dbOffLoading.setDouble(COL_PCS, offloading.getPcs());
            dbOffLoading.setDouble(COL_NW, offloading.getNw());
            dbOffLoading.setDouble(COL_TEMPERATURE, offloading.getTemperature());
            dbOffLoading.setString(COL_CONDITION, offloading.getCondition());
            dbOffLoading.setString(COL_GRADE, offloading.getGrade());
            dbOffLoading.setLong(COL_TRIP_ID, offloading.getTripId());
            dbOffLoading.setLong(COL_TRACKER_ID, offloading.getTrackerId());
            dbOffLoading.setInt(COL_STATUS, offloading.getStatus());
            dbOffLoading.setLong(COL_USER_ID, offloading.getUserId());
            dbOffLoading.setLong(COL_PARTNER_ID, offloading.getPartnerId());
            dbOffLoading.setString(COL_BOAT, offloading.getBoat());
            dbOffLoading.setString(COL_BROUGHT_BY, offloading.getBroughtBy());
            dbOffLoading.insert();
            offloading.setOID(dbOffLoading.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbOffLoading(0), CONException.UNKNOWN);
        }
        return offloading.getOID();
    }

    public static long updateExc(OffLoading offloading) throws CONException {
        try {
            if (offloading.getOID() != 0) {
                DbOffLoading dbOffLoading = new DbOffLoading(offloading.getOID());
                dbOffLoading.setLong(COL_OFFLOADING_ID, offloading.getOffloadingId());
                dbOffLoading.setDate(COL_RECEIVED_DATE, offloading.getReceivedDate());
                dbOffLoading.setString(COL_LATIN_NAME, offloading.getLatinName());
                dbOffLoading.setString(COL_SPECIES, offloading.getSpecies());
                dbOffLoading.setDouble(COL_PCS, offloading.getPcs());
                dbOffLoading.setDouble(COL_NW, offloading.getNw());
                dbOffLoading.setDouble(COL_TEMPERATURE, offloading.getTemperature());
                dbOffLoading.setString(COL_CONDITION, offloading.getCondition());
                dbOffLoading.setString(COL_GRADE, offloading.getGrade());
                dbOffLoading.setLong(COL_TRIP_ID, offloading.getTripId());
                dbOffLoading.setLong(COL_TRACKER_ID, offloading.getTrackerId());
                dbOffLoading.setInt(COL_STATUS, offloading.getStatus());
                dbOffLoading.setLong(COL_USER_ID, offloading.getUserId());
                dbOffLoading.setLong(COL_PARTNER_ID, offloading.getPartnerId());
                dbOffLoading.setString(COL_BOAT, offloading.getBoat());
                dbOffLoading.setString(COL_BROUGHT_BY, offloading.getBroughtBy());
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
            offloading.setOffloadingId(rs.getLong(colNames[COL_OFFLOADING_ID]));
            offloading.setReceivedDate(JSPFormater.formatDate(rs.getString(colNames[COL_RECEIVED_DATE]), "yyyy-MM-dd HH:mm:ss"));
            offloading.setLatinName(rs.getString(colNames[COL_LATIN_NAME]));
            offloading.setSpecies(rs.getString(colNames[COL_SPECIES]));
            offloading.setPcs(rs.getDouble(colNames[COL_PCS]));
            offloading.setNw(rs.getDouble(colNames[COL_NW]));
            offloading.setTemperature(rs.getDouble(colNames[COL_TEMPERATURE]));
            offloading.setCondition(rs.getString(colNames[COL_CONDITION]));
            offloading.setGrade(rs.getString(colNames[COL_GRADE]));
            offloading.setTripId(rs.getLong(colNames[COL_TRIP_ID]));
            offloading.setTrackerId(rs.getLong(colNames[COL_TRACKER_ID]));
            offloading.setStatus(rs.getInt(colNames[COL_STATUS]));
            offloading.setUserId(rs.getLong(colNames[COL_USER_ID]));
            offloading.setPartnerId(rs.getLong(colNames[COL_PARTNER_ID]));
            offloading.setBoat(rs.getString(colNames[COL_BOAT]));
            offloading.setBroughtBy(rs.getString(colNames[COL_BROUGHT_BY]));
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

    public static long getByOffLoadingId(long offloadingId) {
        long oid = 0;
        try {
            Vector list = list(0, 0, colNames[COL_OFFLOADING_ID] + " = " + offloadingId , "");
            if(list != null && list.size() > 0) {
                OffLoading offLoading = (OffLoading) list.get(0);
                oid = offLoading.getOID();
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    /**
     * Data example
     * <Table1>
     * <No>1</No>
     * <SN>50088532</SN>
     * <LatinName>Etelis carbunculus</LatinName>
     * <Species>Bagong</Species>
     * <Pcs>31.00</Pcs>
     * <NW>37</NW>
     * <Temperature>1</Temperature>
     * <Condition>Pass</Condition>
     * <Grade>Export</Grade>
     * <TripID>10</TripID>
     * <TrackerID>1</TrackerID>
     * <RcvDate>2014-10-08T10:37:48+08:00</RcvDate>
     * </Table1>
     * @param sFile
     * @return
     */
    public static Vector XML2DB(InputStream is, long partnerId, long userId) {
        Vector list = new Vector();
        try {
            DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            Document doc = dBuilder.parse(is);
            doc.getDocumentElement().normalize();
            NodeList nList = doc.getElementsByTagName("Table1");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;

                    String strDateTime = getElementValString(eElement, "RcvDate"); //original value : 2014-10-08T10:37:48+08:00
                    strDateTime = strDateTime.substring(0, 19);
                    strDateTime = strDateTime.replace("T", " ");

                    OffLoading offloading = new OffLoading();
                    offloading.setPartnerId(partnerId);
                    offloading.setUserId(userId);
                    offloading.setOffloadingId(getElementValLong(eElement, "SN"));
                    offloading.setReceivedDate(JSPFormater.formatDate(strDateTime, "yyyy-MM-dd HH:mm:ss"));
                    offloading.setLatinName(getElementValString(eElement, "LatinName"));
                    offloading.setSpecies(getElementValString(eElement, "Species"));
                    offloading.setPcs(getElementValDouble(eElement, "Pcs"));
                    offloading.setNw(getElementValDouble(eElement, "NW"));
                    offloading.setTemperature(getElementValDouble(eElement, "Temperature"));
                    offloading.setCondition(getElementValString(eElement, "Condition"));
                    offloading.setGrade(getElementValString(eElement, "Grade"));
                    offloading.setTripId(getElementValLong(eElement, "TripID"));
                    offloading.setTrackerId(getElementValLong(eElement, "TrackerID"));

                    try {
                        long oid = getByOffLoadingId(offloading.getOffloadingId());
                        if(oid == 0) {
                            oid = insertExc(offloading);
                            System.out.println("Insert SN " + offloading.getOffloadingId());
                        } else {
                            offloading.setOID(oid);
                            oid = updateExc(offloading);
                            System.out.println("Update SN " + offloading.getOffloadingId());
                        }
                        list.add(offloading);
                    } catch(Exception e) {
                        System.out.println("failed to insert " + offloading.getOffloadingId());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("xml2db>>" + e.toString());
        }
        return list;
    }

    private static String getElementValString(Element eElement, String tagName) {
        try {
            return (String)eElement.getElementsByTagName(tagName).item(0).getTextContent();
        } catch(Exception e) {
            return "";
        }
    }

    private static long getElementValLong(Element eElement, String tagName) {
        try {
            return Long.parseLong((String)eElement.getElementsByTagName(tagName).item(0).getTextContent());
        } catch(Exception e) {
            return 0;
        }
    }

    private static double getElementValDouble(Element eElement, String tagName) {
        try {
            return Double.parseDouble((String)eElement.getElementsByTagName(tagName).item(0).getTextContent());
        } catch(Exception e) {
            return 0;
        }
    }

    public static Vector listOfBoat(long partnerId, String landingDate) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select distinct(" + colNames[COL_BOAT] + ") from " + DB_OFFLOADING
                    + " where date_trunc('day', " + colNames[COL_RECEIVED_DATE] + ") = '" + landingDate + "'"
                    + " and " + colNames[COL_PARTNER_ID] + " = " + partnerId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                list.add(rs.getString(1));
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return list;
    }

    public static int countLatestOffloading() {
        int count = 0;
        CONResultSet dbrs = null;
        try {
            String sql = "select count(*) from ("
                    + "select date_trunc('day', " + colNames[COL_RECEIVED_DATE] + ") as day, "
                    + colNames[COL_BOAT] + ", " + colNames[COL_BROUGHT_BY]
                    + ", " + colNames[COL_PARTNER_ID] + ", " + colNames[COL_STATUS]
                    + " from " + DB_OFFLOADING + " where " + colNames[COL_BOAT] + " not like ''"
                    + " group by 1,2,3,4,5"
                    + ") as x;";

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                count = rs.getInt(1);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println("err : " + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return count;
    }

    public static Vector listLatestOffLoading(int start, int recordToGet) {
        Vector list = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "select date_trunc('day', " + colNames[COL_RECEIVED_DATE] + ") as day"
                    + ", " + colNames[COL_PARTNER_ID] + ", " + colNames[COL_BOAT]
                    + ", " + colNames[COL_BROUGHT_BY]  + ", " + colNames[COL_STATUS]
                    + " from " + DB_OFFLOADING + " where " + colNames[COL_BOAT] + " not like ''"
                    + " group by 1, 2, 3, 4, 5 order by 1 desc, 2,3 asc";

            if (start == 0 && recordToGet == 0) {
                sql = sql + "";
            } else {
                switch (CONHandler.CONSVR_TYPE) {
                    case CONSVR_ORACLE:
                        break;
                    case CONSVR_MYSQL:
                        sql = sql + " limit " + start + "," + recordToGet;
                        break;
                    case CONSVR_POSTGRESQL:
                        sql = sql + " limit " + recordToGet + " offset " + start;
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
                OffLoading offLoading = new OffLoading();
                offLoading.setReceivedDate(JSPFormater.formatDate(rs.getString(1), "yyyy-MM-dd hh:mm:ss"));
                offLoading.setPartnerId(rs.getLong(2));
                offLoading.setBoat(rs.getString(3));
                offLoading.setBroughtBy(rs.getString(4));
                offLoading.setStatus(rs.getInt(5));
                list.add(offLoading);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return list;
    }
}
