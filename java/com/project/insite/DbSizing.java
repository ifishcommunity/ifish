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
public class DbSizing extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_SIZING = "insite_sizing";
    public static final int COL_OID = 0;
    public static final int COL_SIZING_ID = 1;
    public static final int COL_SIZING_DATE = 2;
    public static final int COL_GENUS = 3;
    public static final int COL_LATIN_NAME = 4;
    public static final int COL_ENGLISH_NAME = 5;
    public static final int COL_CM = 6;
    public static final int COL_BOAT = 7;
    public static final int COL_TRIP_ID = 8;
    public static final int COL_TRACKER_ID = 9;
    public static final int COL_STATUS = 10;
    public static final int COL_USER_ID = 11;
    public static final int COL_OFFLOADING_ID = 12;
    public static final int COL_BROUGHT_BY = 13;
    public static final int COL_PARTNER_ID = 14;
    public static final String[] colNames = {
        "oid",
        "sizing_id",
        "sizing_date",
        "genus",
        "latin_name",
        "english_name",
        "cm",
        "boat",
        "trip_id",
        "tracker_id",
        "status",
        "user_id",
        "offloading_id",
        "brought_by",
        "partner_id"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG
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
            sizing.setSizingId(dbSizing.getlong(COL_SIZING_ID));
            sizing.setSizingDate(dbSizing.getDate(COL_SIZING_DATE));
            sizing.setGenus(dbSizing.getString(COL_GENUS));
            sizing.setLatinName(dbSizing.getString(COL_LATIN_NAME));
            sizing.setEnglishName(dbSizing.getString(COL_ENGLISH_NAME));
            sizing.setCm(dbSizing.getdouble(COL_CM));
            sizing.setBoat(dbSizing.getString(COL_BOAT));
            sizing.setTripId(dbSizing.getlong(COL_TRIP_ID));
            sizing.setTripId(dbSizing.getlong(COL_TRACKER_ID));
            sizing.setStatus(dbSizing.getInt(COL_STATUS));
            sizing.setUserId(dbSizing.getlong(COL_USER_ID));
            sizing.setOffloadingId(dbSizing.getlong(COL_OFFLOADING_ID));
            sizing.setBroughtBy(dbSizing.getString(COL_BROUGHT_BY));
            sizing.setPartnerId(dbSizing.getlong(COL_PARTNER_ID));
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
            dbSizing.setLong(COL_SIZING_ID, sizing.getSizingId());
            dbSizing.setDate(COL_SIZING_DATE, sizing.getSizingDate());
            dbSizing.setString(COL_GENUS, sizing.getGenus());
            dbSizing.setString(COL_LATIN_NAME, sizing.getLatinName());
            dbSizing.setString(COL_ENGLISH_NAME, sizing.getEnglishName());
            dbSizing.setDouble(COL_CM, sizing.getCm());
            dbSizing.setString(COL_BOAT, sizing.getBoat());
            dbSizing.setLong(COL_TRIP_ID, sizing.getTripId());
            dbSizing.setLong(COL_TRACKER_ID, sizing.getTrackerId());
            dbSizing.setInt(COL_STATUS, sizing.getStatus());
            dbSizing.setLong(COL_USER_ID, sizing.getUserId());
            dbSizing.setLong(COL_OFFLOADING_ID, sizing.getOffloadingId());
            dbSizing.setString(COL_BROUGHT_BY, sizing.getBroughtBy());
            dbSizing.setLong(COL_PARTNER_ID, sizing.getPartnerId());
            dbSizing.insert();
            sizing.setOID(dbSizing.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbSizing(0), CONException.UNKNOWN);
        }
        return sizing.getOID();
    }

    public static long updateExc(Sizing sizing) throws CONException {
        try {
            if (sizing.getOID() != 0) {
                DbSizing dbSizing = new DbSizing(sizing.getOID());
                dbSizing.setLong(COL_SIZING_ID, sizing.getSizingId());
                dbSizing.setDate(COL_SIZING_DATE, sizing.getSizingDate());
                dbSizing.setString(COL_GENUS, sizing.getGenus());
                dbSizing.setString(COL_LATIN_NAME, sizing.getLatinName());
                dbSizing.setString(COL_ENGLISH_NAME, sizing.getEnglishName());
                dbSizing.setDouble(COL_CM, sizing.getCm());
                dbSizing.setString(COL_BOAT, sizing.getBoat());
                dbSizing.setLong(COL_TRIP_ID, sizing.getTripId());
                dbSizing.setLong(COL_TRACKER_ID, sizing.getTrackerId());
                dbSizing.setInt(COL_STATUS, sizing.getStatus());
                dbSizing.setLong(COL_USER_ID, sizing.getUserId());
                dbSizing.setLong(COL_OFFLOADING_ID, sizing.getOffloadingId());
                dbSizing.setString(COL_BROUGHT_BY, sizing.getBroughtBy());
                dbSizing.setLong(COL_PARTNER_ID, sizing.getPartnerId());
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

    private static void resultToObject(ResultSet rs, Sizing sizing) {
        try {
            sizing.setOID(rs.getLong(colNames[COL_OID]));
            sizing.setSizingId(rs.getLong(colNames[COL_SIZING_ID]));
            sizing.setSizingDate(JSPFormater.formatDate(rs.getString(colNames[COL_SIZING_DATE]), "yyyy-MM-dd HH:mm:ss"));
            sizing.setGenus(rs.getString(colNames[COL_GENUS]));
            sizing.setLatinName(rs.getString(colNames[COL_LATIN_NAME]));
            sizing.setEnglishName(rs.getString(colNames[COL_ENGLISH_NAME]));
            sizing.setCm(rs.getDouble(colNames[COL_CM]));
            sizing.setBoat(rs.getString(colNames[COL_BOAT]));
            sizing.setTripId(rs.getLong(colNames[COL_TRIP_ID]));
            sizing.setTrackerId(rs.getLong(colNames[COL_TRACKER_ID]));
            sizing.setStatus(rs.getInt(colNames[COL_STATUS]));
            sizing.setUserId(rs.getLong(colNames[COL_USER_ID]));
            sizing.setOffloadingId(rs.getLong(colNames[COL_OFFLOADING_ID]));
            sizing.setBroughtBy(rs.getString(colNames[COL_BROUGHT_BY]));
            sizing.setPartnerId(rs.getLong(colNames[COL_PARTNER_ID]));
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

    public static long getBySizingId(long sizingId) {
        long oid = 0;
        try {
            Vector list = list(0, 0, colNames[COL_SIZING_ID] + " = " + sizingId , "");
            if(list != null && list.size() > 0) {
                Sizing sizing = (Sizing) list.get(0);
                oid = sizing.getOID();
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
     * <Genus>Bigeyes</Genus>
     * <LatinName>Cookeolus japonicus</LatinName>
     * <EnglishName>Bullseye, long-finned bullseye, deepwater bullseye, big-fin bigeye, Japanese bigeye</EnglishName>
     * <CM>49</CM>
     * <Boat>Ulam Jaya</Boat>
     * <TripID>10</TripID>
     * <TrackerID>1</TrackerID>
     * <SizingID>3050</SizingID>
     * <SizingDate>2014-10-06T20:17:59+08:00</SizingDate>
     * <OffloadID>120359</OffloadID>
     * <BroughtBy>GSL 01</BroughtBy>
     * </Table1>
     * @param sFile
     * @return
     */
    public static Vector XML2DB(InputStream inputStream, long partnerId, long userId) {
        Vector list = new Vector();
        try {
            DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            Document doc = dBuilder.parse(inputStream);
            doc.getDocumentElement().normalize();
            NodeList nList = doc.getElementsByTagName("Table1");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;
                    
                    String strDateTime = getElementValString(eElement, "SizingDate");//original value : 2014-10-06T20:17:59+08:00
                    strDateTime = strDateTime.substring(0, 19);
                    strDateTime = strDateTime.replace("T", " ");
                    
                    Sizing sizing = new Sizing();
                    sizing.setPartnerId(partnerId);
                    sizing.setUserId(userId);
                    sizing.setSizingId(getElementValLong(eElement, "SizingID"));
                    sizing.setSizingDate(JSPFormater.formatDate(strDateTime, "yyyy-MM-dd HH:mm:ss"));
                    sizing.setGenus(getElementValString(eElement, "Genus"));
                    sizing.setLatinName(getElementValString(eElement, "LatinName"));
                    sizing.setEnglishName(getElementValString(eElement, "EnglishName"));
                    sizing.setCm(getElementValDouble(eElement, "CM"));
                    sizing.setBoat(getElementValString(eElement, "Boat"));
                    sizing.setTrackerId(getElementValLong(eElement, "TrackerID"));
                    sizing.setTripId(getElementValLong(eElement, "TripID"));
                    sizing.setOffloadingId(getElementValLong(eElement, "SN"));
                    sizing.setBroughtBy(getElementValString(eElement, "BroughtBy"));
                    
                    try {
                        long oid = getBySizingId(sizing.getSizingId());
                        if(oid == 0) {
                            oid = insertExc(sizing);
                            System.out.println("Insert SizingID " + sizing.getSizingId());
                        } else {
                            sizing.setOID(oid);
                            oid = updateExc(sizing);
                            System.out.println("Update SizingID " + sizing.getSizingId());
                        }

                        sizing.setOID(oid);
                        list.add(sizing);
                    } catch(Exception e) {
                        System.out.println("failed to insert " + sizing.getSizingId());
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
            String sql = "select distinct(" + colNames[COL_BOAT]  + ") from " + DB_SIZING
                    + " where date_trunc('day', " + colNames[COL_SIZING_DATE] + ") = '" + landingDate + "'"
                    + " and " + colNames[COL_PARTNER_ID] + " = " + partnerId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                list.add(rs.getString(1));
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return list;
    }
}
