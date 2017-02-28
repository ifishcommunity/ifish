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
import java.io.InputStream;
import java.net.HttpURLConnection;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.net.URL;
import java.net.URLConnection;
import java.security.cert.X509Certificate;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

/**
 *
 * @author gwawan
 */
public class DbFindMeSpot extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_FINDMESPOT = "ifish_findmespot";
    public static final int COL_OID = 0;
    public static final int COL_FINDMESPOT_ID = 1;
    public static final int COL_TRACKER_ID = 2;
    public static final int COL_TRACKER_NAME = 3;
    public static final int COL_UNIX_TIME = 4;
    public static final int COL_MESSAGE_TYPE = 5;
    public static final int COL_LATITUDE = 6;
    public static final int COL_LONGITUDE = 7;
    public static final int COL_MODEL_ID = 8;
    public static final int COL_SHOW_CUSTOM_MSG = 9;
    public static final int COL_DATE_TIME = 10;
    public static final int COL_BATTERY_STATE = 11;
    public static final int COL_HIDDEN = 12;
    public static final int COL_MESSAGE_CONTENT = 13;
    public static final int COL_DAILY_AVG_LATITUDE = 14;
    public static final int COL_DAILY_AVG_LONGITUDE = 15;
    public static final String[] colNames = {
        "oid",
        "findmespot_id",
        "tracker_id",
        "tracker_name",
        "unix_time",
        "message_type",
        "latitude",
        "longitude",
        "model_id",
        "show_custom_msg",
        "date_time",
        "battery_state",
        "hidden",
        "message_content",
        "daily_avg_latitude",
        "daily_avg_longitude"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_FLOAT5,
        TYPE_FLOAT5,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_FLOAT5,
        TYPE_FLOAT5
    };
    public static boolean running = false; // status service

    public DbFindMeSpot() {
    }

    public DbFindMeSpot(int i) throws CONException {
        super(new DbFindMeSpot());
    }

    public DbFindMeSpot(String sOid) throws CONException {
        super(new DbFindMeSpot(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFindMeSpot(long lOid) throws CONException {
        super(new DbFindMeSpot(0));
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
        return DB_FINDMESPOT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbFindMeSpot().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        FindMeSpot findMeSpot = fetchExc(ent.getOID());
        ent = (Entity) findMeSpot;
        return findMeSpot.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((FindMeSpot) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((FindMeSpot) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static FindMeSpot fetchExc(long oid) throws CONException {
        try {
            FindMeSpot findMeSpot = new FindMeSpot();
            DbFindMeSpot dbFindMeSpot = new DbFindMeSpot(oid);
            findMeSpot.setOID(oid);
            findMeSpot.setFindmespotId(dbFindMeSpot.getlong(COL_FINDMESPOT_ID));
            findMeSpot.setTrackerId(dbFindMeSpot.getlong(COL_TRACKER_ID));
            findMeSpot.setTrackerName(dbFindMeSpot.getString(COL_TRACKER_NAME));
            findMeSpot.setUnixTime(dbFindMeSpot.getlong(COL_UNIX_TIME));
            findMeSpot.setMessageType(dbFindMeSpot.getString(COL_MESSAGE_TYPE));
            findMeSpot.setLatitude(dbFindMeSpot.getdouble(COL_LATITUDE));
            findMeSpot.setLongitude(dbFindMeSpot.getdouble(COL_LONGITUDE));
            findMeSpot.setModelId(dbFindMeSpot.getString(COL_MODEL_ID));
            findMeSpot.setShowCustomMessage(dbFindMeSpot.getString(COL_SHOW_CUSTOM_MSG));
            findMeSpot.setDateTime(dbFindMeSpot.getDate(COL_DATE_TIME));
            findMeSpot.setBatteryState(dbFindMeSpot.getString(COL_BATTERY_STATE));
            findMeSpot.setHidden(dbFindMeSpot.getInt(COL_HIDDEN));
            findMeSpot.setMessageContent(dbFindMeSpot.getString(COL_MESSAGE_CONTENT));
            findMeSpot.setDailyAvgLatitude(dbFindMeSpot.getdouble(COL_DAILY_AVG_LATITUDE));
            findMeSpot.setDailyAvgLongitude(dbFindMeSpot.getdouble(COL_DAILY_AVG_LONGITUDE));
            return findMeSpot;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFindMeSpot(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(FindMeSpot findMeSpot) throws CONException {
        try {
            DbFindMeSpot dbFindMeSpot = new DbFindMeSpot(0);
            dbFindMeSpot.setLong(COL_FINDMESPOT_ID, findMeSpot.getFindmespotId());
            dbFindMeSpot.setLong(COL_TRACKER_ID, findMeSpot.getTrackerId());
            dbFindMeSpot.setString(COL_TRACKER_NAME, findMeSpot.getTrackerName());
            dbFindMeSpot.setLong(COL_UNIX_TIME, findMeSpot.getUnixTime());
            dbFindMeSpot.setString(COL_MESSAGE_TYPE, findMeSpot.getMessageType());
            dbFindMeSpot.setDouble(COL_LATITUDE, findMeSpot.getLatitude());
            dbFindMeSpot.setDouble(COL_LONGITUDE, findMeSpot.getLongitude());
            dbFindMeSpot.setString(COL_MODEL_ID, findMeSpot.getModelId());
            dbFindMeSpot.setString(COL_SHOW_CUSTOM_MSG, findMeSpot.getShowCustomMessage());
            dbFindMeSpot.setDate(COL_DATE_TIME, findMeSpot.getDateTime());
            dbFindMeSpot.setString(COL_BATTERY_STATE, findMeSpot.getBatteryState());
            dbFindMeSpot.setInt(COL_HIDDEN, findMeSpot.getHidden());
            dbFindMeSpot.setString(COL_MESSAGE_CONTENT, findMeSpot.getMessageContent());
            dbFindMeSpot.setDouble(COL_DAILY_AVG_LATITUDE, findMeSpot.getDailyAvgLatitude());
            dbFindMeSpot.setDouble(COL_DAILY_AVG_LONGITUDE, findMeSpot.getDailyAvgLongitude());
            dbFindMeSpot.insert();
            findMeSpot.setOID(dbFindMeSpot.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFindMeSpot(0), CONException.UNKNOWN);
        }
        return findMeSpot.getOID();
    }

    public static long updateExc(FindMeSpot findMeSpot) throws CONException {
        try {
            if (findMeSpot.getOID() != 0) {
                DbFindMeSpot dbFindMeSpot = new DbFindMeSpot(findMeSpot.getOID());
                dbFindMeSpot.setLong(COL_FINDMESPOT_ID, findMeSpot.getFindmespotId());
                dbFindMeSpot.setLong(COL_TRACKER_ID, findMeSpot.getTrackerId());
                dbFindMeSpot.setString(COL_TRACKER_NAME, findMeSpot.getTrackerName());
                dbFindMeSpot.setLong(COL_UNIX_TIME, findMeSpot.getUnixTime());
                dbFindMeSpot.setString(COL_MESSAGE_TYPE, findMeSpot.getMessageType());
                dbFindMeSpot.setDouble(COL_LATITUDE, findMeSpot.getLatitude());
                dbFindMeSpot.setDouble(COL_LONGITUDE, findMeSpot.getLongitude());
                dbFindMeSpot.setString(COL_MODEL_ID, findMeSpot.getModelId());
                dbFindMeSpot.setString(COL_SHOW_CUSTOM_MSG, findMeSpot.getShowCustomMessage());
                dbFindMeSpot.setDate(COL_DATE_TIME, findMeSpot.getDateTime());
                dbFindMeSpot.setString(COL_BATTERY_STATE, findMeSpot.getBatteryState());
                dbFindMeSpot.setInt(COL_HIDDEN, findMeSpot.getHidden());
                dbFindMeSpot.setString(COL_MESSAGE_CONTENT, findMeSpot.getMessageContent());
                dbFindMeSpot.setDouble(COL_DAILY_AVG_LATITUDE, findMeSpot.getDailyAvgLatitude());
                dbFindMeSpot.setDouble(COL_DAILY_AVG_LONGITUDE, findMeSpot.getDailyAvgLongitude());
                dbFindMeSpot.update();
                return findMeSpot.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFindMeSpot(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFindMeSpot dbFindMeSpot = new DbFindMeSpot(oid);
            dbFindMeSpot.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFindMeSpot(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FINDMESPOT;
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
                FindMeSpot findMeSpot = new FindMeSpot();
                resultToObject(rs, findMeSpot);
                lists.add(findMeSpot);
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

    public static void resultToObject(ResultSet rs, FindMeSpot findMeSpot) {
        try {
            findMeSpot.setOID(rs.getLong(colNames[COL_OID]));
            findMeSpot.setFindmespotId(rs.getLong(colNames[COL_FINDMESPOT_ID]));
            findMeSpot.setTrackerId(rs.getLong(colNames[COL_TRACKER_ID]));
            findMeSpot.setTrackerName(rs.getString(colNames[COL_TRACKER_NAME]));
            findMeSpot.setUnixTime(rs.getLong(colNames[COL_UNIX_TIME]));
            findMeSpot.setMessageType(rs.getString(colNames[COL_MESSAGE_TYPE]));
            findMeSpot.setLatitude(rs.getDouble(colNames[COL_LATITUDE]));
            findMeSpot.setLongitude(rs.getDouble(colNames[COL_LONGITUDE]));
            findMeSpot.setModelId(rs.getString(colNames[COL_MODEL_ID]));
            findMeSpot.setShowCustomMessage(rs.getString(colNames[COL_SHOW_CUSTOM_MSG]));
            findMeSpot.setDateTime(rs.getTimestamp(colNames[COL_DATE_TIME]));
            findMeSpot.setBatteryState(rs.getString(colNames[COL_BATTERY_STATE]));
            findMeSpot.setHidden(rs.getInt(colNames[COL_HIDDEN]));
            findMeSpot.setMessageContent(rs.getString(colNames[COL_MESSAGE_CONTENT]));
            findMeSpot.setDailyAvgLatitude(rs.getDouble(colNames[COL_DAILY_AVG_LATITUDE]));
            findMeSpot.setDailyAvgLongitude(rs.getDouble(colNames[COL_DAILY_AVG_LONGITUDE]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long findMeSpotId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FINDMESPOT + " WHERE "
                    + colNames[COL_OID] + " = " + findMeSpotId;

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
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_FINDMESPOT;
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

    public static int getCount(long trackerId, Date startDate, Date endDate) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_FINDMESPOT
                    + " WHERE " + colNames[COL_TRACKER_ID] + " = " + trackerId
                    + " AND date_trunc('day', " + colNames[COL_DATE_TIME]+ ") >= '" + JSPFormater.formatDate(startDate, "yyyy-MM-dd") + "'"
                    + " AND date_trunc('day', " + colNames[COL_DATE_TIME]+ ") <= '" + JSPFormater.formatDate(endDate, "yyyy-MM-dd") + "'";

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
                    FindMeSpot findMeSpot = (FindMeSpot) list.get(ls);
                    if (oid == findMeSpot.getOID()) {
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

    /**
     * Data example
     * <message clientUnixTime="0">
     *  <id>329456444</id>
     *  <messengerId>0-2526747</messengerId>
     *  <messengerName>tnc0001</messengerName>
     *  <unixTime>1412559143</unixTime>
     *  <messageType>STATUS</messageType>
     *  <latitude>-10.20009</latitude>
     *  <longitude>123.52834</longitude>
     *  <modelId>SPOTTRACE</modelId>
     *  <showCustomMsg>Y</showCustomMsg>
     *  <dateTime>2014-10-06T01:32:23+0000</dateTime>
     *  <batteryState>GOOD</batteryState>
     *  <hidden>0</hidden>
     *  <messageContent>  SPOT Trace is functioning properly.</messageContent>
     * </message>
     * @param sUrl
     * @return
     */
    public static boolean XML2DBv1(String sUrl) {
        boolean status = false;
        try {
            // Create a trust manager that does not validate certificate chains
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {

                    public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                        return new X509Certificate[0];
                    }

                    public void checkClientTrusted(
                            java.security.cert.X509Certificate[] certs, String authType) {
                    }

                    public void checkServerTrusted(
                            java.security.cert.X509Certificate[] certs, String authType) {
                    }
                }
            };

            // Install the all-trusting trust manager
            final SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());
            // Create an ssl socket factory with our all-trusting manager
            HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());

            // Create all-trusting host name verifier
            HostnameVerifier allHostsValid = new HostnameVerifier() {

                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };

            // Install the all-trusting host verifier
            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);

            URL url = new URL(sUrl);
            URLConnection connection = url.openConnection();
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(connection.getInputStream());
            doc.getDocumentElement().normalize();
            NodeList nList = doc.getElementsByTagName("message");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;
                    FindMeSpot findMeSpot = new FindMeSpot();
                    findMeSpot.setFindmespotId(Long.parseLong((String) eElement.getElementsByTagName("id").item(0).getTextContent()));

                    String str1 = (String) eElement.getElementsByTagName("messengerId").item(0).getTextContent(); //original value : 0-2526747
                    findMeSpot.setTrackerId(Long.parseLong(str1.substring(2)));

                    findMeSpot.setTrackerName(eElement.getElementsByTagName("messengerName").item(0).getTextContent());
                    findMeSpot.setUnixTime(Long.parseLong((String) eElement.getElementsByTagName("unixTime").item(0).getTextContent()));
                    findMeSpot.setMessageType(eElement.getElementsByTagName("messageType").item(0).getTextContent());
                    findMeSpot.setLatitude(Double.parseDouble((String) eElement.getElementsByTagName("latitude").item(0).getTextContent()));
                    findMeSpot.setLongitude(Double.parseDouble((String) eElement.getElementsByTagName("longitude").item(0).getTextContent()));
                    findMeSpot.setModelId(eElement.getElementsByTagName("modelId").item(0).getTextContent());
                    findMeSpot.setShowCustomMessage(eElement.getElementsByTagName("showCustomMsg").item(0).getTextContent());

                    String strDateTime = (eElement.getElementsByTagName("dateTime").item(0).getTextContent()); //original value : 2014-10-06T01:32:23+0000
                    strDateTime = strDateTime.substring(0, 19);
                    strDateTime = strDateTime.replace("T", " ");
                    findMeSpot.setDateTime(JSPFormater.formatDate(strDateTime, "yyyy-MM-dd HH:mm:ss"));

                    findMeSpot.setBatteryState(eElement.getElementsByTagName("batteryState").item(0).getTextContent());
                    findMeSpot.setHidden(Integer.parseInt((String) eElement.getElementsByTagName("hidden").item(0).getTextContent()));

                    try {
                        findMeSpot.setMessageContent(eElement.getElementsByTagName("messageContent").item(0).getTextContent());
                    } catch (Exception e) {
                        System.out.println("(" + new Date() + ") " + findMeSpot.getTrackerName() + " messageContent: " + e.toString());
                    }

                    try {
                        if(!isFindmespotIdExist(findMeSpot.getFindmespotId())) {
                            long oid = insertExc(findMeSpot);
                        }
                        status = true;
                    } catch (Exception e) {
                        System.out.println("(" + new Date() + ") failed to insert: " + findMeSpot.getFindmespotId());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("(" + new Date() + ") xml2db: " + e.toString());
        }
        return status;
    }

    public static boolean XML2DBv2(String url) {
        boolean status = true;
        try {
            URL page = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) page.openConnection();
            conn.connect();
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(conn.getInputStream());
            doc.getDocumentElement().normalize();
            NodeList nList = doc.getElementsByTagName("message");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;
                    FindMeSpot findMeSpot = new FindMeSpot();
                    findMeSpot.setFindmespotId(Long.parseLong((String) eElement.getElementsByTagName("id").item(0).getTextContent()));

                    String str1 = (String) eElement.getElementsByTagName("messengerId").item(0).getTextContent(); //original value : 0-2526747
                    findMeSpot.setTrackerId(Long.parseLong(str1.substring(2)));

                    findMeSpot.setTrackerName(eElement.getElementsByTagName("messengerName").item(0).getTextContent());
                    findMeSpot.setUnixTime(Long.parseLong((String) eElement.getElementsByTagName("unixTime").item(0).getTextContent()));
                    findMeSpot.setMessageType(eElement.getElementsByTagName("messageType").item(0).getTextContent());
                    findMeSpot.setLatitude(Double.parseDouble((String) eElement.getElementsByTagName("latitude").item(0).getTextContent()));
                    findMeSpot.setLongitude(Double.parseDouble((String) eElement.getElementsByTagName("longitude").item(0).getTextContent()));
                    findMeSpot.setModelId(eElement.getElementsByTagName("modelId").item(0).getTextContent());
                    findMeSpot.setShowCustomMessage(eElement.getElementsByTagName("showCustomMsg").item(0).getTextContent());

                    String strDateTime = (eElement.getElementsByTagName("dateTime").item(0).getTextContent()); //original value : 2014-10-06T01:32:23+0000
                    strDateTime = strDateTime.substring(0, 19);
                    strDateTime = strDateTime.replace("T", " ");
                    findMeSpot.setDateTime(JSPFormater.formatDate(strDateTime, "yyyy-MM-dd HH:mm:ss"));

                    findMeSpot.setBatteryState(eElement.getElementsByTagName("batteryState").item(0).getTextContent());
                    findMeSpot.setHidden(Integer.parseInt((String) eElement.getElementsByTagName("hidden").item(0).getTextContent()));

                    try {
                        findMeSpot.setMessageContent(eElement.getElementsByTagName("messageContent").item(0).getTextContent());
                    } catch (Exception e) {
                        System.out.println("(" + new Date() + ") " + findMeSpot.getTrackerName() + " messageContent: " + e.toString());
                    }

                    try {
                        if(!isFindmespotIdExist(findMeSpot.getFindmespotId())) {
                            long oid = insertExc(findMeSpot);
                        }
                        status = true;
                    } catch (Exception e) {
                        System.out.println("(" + new Date() + ") failed to insert: " + findMeSpot.getFindmespotId());
                    }
                }
            }
            status = true;
        } catch (Exception e) {
            System.out.println("(" + new Date() + ") xml2db: " + e.toString());
            status = false;
        }
        return status;
    }

    public static Vector XML2DB(InputStream is) {
        Vector list = new Vector();
        try {
            DocumentBuilder dBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            Document doc = dBuilder.parse(is);
            doc.getDocumentElement().normalize();
            NodeList nList = doc.getElementsByTagName("message");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                    Element eElement = (Element) nNode;
                    FindMeSpot findMeSpot = new FindMeSpot();
                    findMeSpot.setFindmespotId(Long.parseLong((String) eElement.getElementsByTagName("id").item(0).getTextContent()));

                    String str1 = (String) eElement.getElementsByTagName("messengerId").item(0).getTextContent(); //original value : 0-2526747
                    findMeSpot.setTrackerId(Long.parseLong(str1.substring(2)));

                    findMeSpot.setTrackerName(eElement.getElementsByTagName("messengerName").item(0).getTextContent());
                    findMeSpot.setUnixTime(Long.parseLong((String) eElement.getElementsByTagName("unixTime").item(0).getTextContent()));
                    findMeSpot.setMessageType(eElement.getElementsByTagName("messageType").item(0).getTextContent());
                    findMeSpot.setLatitude(Double.parseDouble((String) eElement.getElementsByTagName("latitude").item(0).getTextContent()));
                    findMeSpot.setLongitude(Double.parseDouble((String) eElement.getElementsByTagName("longitude").item(0).getTextContent()));
                    findMeSpot.setModelId(eElement.getElementsByTagName("modelId").item(0).getTextContent());
                    findMeSpot.setShowCustomMessage(eElement.getElementsByTagName("showCustomMsg").item(0).getTextContent());

                    String strDateTime = (eElement.getElementsByTagName("dateTime").item(0).getTextContent()); //original value : 2014-10-06T01:32:23+0000
                    strDateTime = strDateTime.substring(0, 19);
                    strDateTime = strDateTime.replace("T", " ");
                    findMeSpot.setDateTime(JSPFormater.formatDate(strDateTime, "yyyy-MM-dd HH:mm:ss"));

                    findMeSpot.setBatteryState(eElement.getElementsByTagName("batteryState").item(0).getTextContent());
                    findMeSpot.setHidden(Integer.parseInt((String) eElement.getElementsByTagName("hidden").item(0).getTextContent()));

                    try {
                        findMeSpot.setMessageContent(eElement.getElementsByTagName("messageContent").item(0).getTextContent());
                    } catch (Exception e) {
                        System.out.println("(" + new Date() + ") " + findMeSpot.getTrackerName() + " messageContent: " + e.toString());
                    }

                    try {
                        if(!isFindmespotIdExist(findMeSpot.getFindmespotId())) {
                            long oid = insertExc(findMeSpot);
                        }
                        list.add(findMeSpot);
                    } catch (Exception e) {
                        System.out.println("(" + new Date() + ") failed to insert: " + findMeSpot.getFindmespotId());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("(" + new Date() + ") xml2db: " + e.toString());
        }
        return list;
    }

    public static boolean isFindmespotIdExist(long findmespotId) {
        boolean status = false;
        CONResultSet dbrs = null;
        try {
            String sql = "select * from " + DB_FINDMESPOT + " where " + colNames[COL_FINDMESPOT_ID] + "=" + findmespotId;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                status = true;
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return status;
    }

    public synchronized void startService() {
        if (!running) {
            System.out.println(".:: SpotTraceService service started ... !!!");
            try {
                Thread thr = new Thread(new SpotTraceService());
                thr.setDaemon(false);
                thr.start();
                running = true;
            } catch (Exception e) {
                System.out.println("(" + new Date() + ") Exc when SpotTraceService start ... !!!: " + e.toString());
            }
        }
    }

    public synchronized void stopService() {
        running = false;
        System.out.println(".:: SpotTraceService service stoped ... !!!");
    }

    public static FindMeSpot getLatestStatus(long trackerId) {
        FindMeSpot findMeSpot = new FindMeSpot();
        try {
            String where = colNames[COL_TRACKER_ID] + " = " + trackerId;
            String order = colNames[COL_DATE_TIME] + " desc";
            Vector list = list(0, 1, where, order);
            if(list != null && list.size() > 0) {
                findMeSpot = (FindMeSpot) list.get(0);
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return findMeSpot;
    }

    public static void setAvgPosition() {
        setAvgPosition(new Date());
    }

    public static void setAvgPositionAllDays() {
        CONResultSet dbrs = null;
        try {
            String sql = "select distinct date_trunc('day', date_time) from ifish_findmespot where daily_avg_latitude=0 and message_type not like 'POWER-OFF' order by 1;";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                Date selectedDate = rs.getDate(1);
                System.out.println("Process avg position on " + JSPFormater.formatDate(selectedDate, "yyyy-MM-dd"));
                DbFindMeSpot.setAvgPosition(selectedDate);
            }

            rs.close();
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
            System.out.println("done!");
        }
        setAvgPosition(new Date());
    }

    public static void setAvgPosition(Date selectedDate) {
        try {
            String sql = "with avg as ("
                    + " select "+colNames[COL_TRACKER_ID]+","
                    + " (sum("+colNames[COL_LATITUDE]+")/count("+colNames[COL_LATITUDE]+")) as lat,"
                    + " (sum("+colNames[COL_LONGITUDE]+")/count("+colNames[COL_LONGITUDE]+")) as long"
                    + " from " + DB_FINDMESPOT
                    + " where "+colNames[COL_MESSAGE_TYPE]+" not like 'POWER-OFF'"
                    + " and date_trunc('day', "+colNames[COL_DATE_TIME]+") = '"+JSPFormater.formatDate(selectedDate, "yyyy-MM-dd")+"'"
                    + " group by "+colNames[COL_TRACKER_ID]+" "
                    + ") update "+DB_FINDMESPOT+" st"
                    + " set "+colNames[COL_DAILY_AVG_LATITUDE]+" = avg.lat, "+colNames[COL_DAILY_AVG_LONGITUDE]+" = avg.long"
                    + " from avg where avg."+colNames[COL_TRACKER_ID]+" = st."+colNames[COL_TRACKER_ID]
                    + " and date_trunc('day', st."+colNames[COL_DATE_TIME]+") = '"+JSPFormater.formatDate(selectedDate, "yyyy-MM-dd")+"';";
            int n = CONHandler.execUpdate(sql);
        } catch(Exception e) {
            System.out.println(e.toString());
        }
    }

}
