package com.project.ifish.data;

import com.project.IFishConfig;
import com.project.general.DbUser;
import com.project.general.User;
import com.project.ifish.master.Boat;
import com.project.ifish.master.DbFish;
import com.project.ifish.master.DbPartnerBoat;
import com.project.ifish.master.Fish;
import com.project.ifish.session.SessDeepSlope;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.JSPFormater;
import com.project.util.lang.I_Language;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 *
 * @author gwawan
 */
public class DbDeepSlope extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_DEEPSLOPE = "ifish_deepslope";
    public static final int COL_OID = 0;
    public static final int COL_APPROACH = 1;
    public static final int COL_USER_ID = 2;
    public static final int COL_PARTNER_ID = 3;
    public static final int COL_LANDING_DATE = 4;
    public static final int COL_LANDING_LOCATION = 5;
    public static final int COL_WPP1 = 6;
    public static final int COL_WPP2 = 7;
    public static final int COL_WPP3 = 8;
    public static final int COL_BOAT_ID = 9;
    public static final int COL_FISHING_GEAR = 10;
    public static final int COL_BROUGHT_BY = 11;
    public static final int COL_CODRS_FILE_NAME = 12;
    public static final int COL_OTHER_FISHING_GROUND = 13;
    public static final int COL_SUPPLIER = 14;
    public static final int COL_FISHERY_TYPE = 15;
    public static final int COL_ENTRY_DATE = 16;
    public static final int COL_POSTING_DATE = 17;
    public static final int COL_POSTING_USER = 18;
    public static final int COL_FIRST_CODRS_PICTURE_DATE = 19;
    public static final int COL_DOC_STATUS = 20;
    public static final String[] colNames = {
        "oid",
        "approach",
        "user_id",
        "partner_id",
        "landing_date",
        "landing_location",
        "wpp1",
        "wpp2",
        "wpp3",
        "boat_id",
        "fishing_gear",
        "brought_by",
        "codrs_file_name",
        "other_fishing_ground",
        "supplier",
        "fishery_type",
        "entry_date",
        "posting_date",
        "posting_user",
        "first_codrs_picture_date",
        "doc_status"
    };
    public static final int[] colTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_INT,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_LONG,
        TYPE_DATE,
        TYPE_STRING
    };

    public DbDeepSlope() {
    }

    public DbDeepSlope(int i) throws CONException {
        super(new DbDeepSlope());
    }

    public DbDeepSlope(String sOid) throws CONException {
        super(new DbDeepSlope(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbDeepSlope(long lOid) throws CONException {
        super(new DbDeepSlope(0));
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
        return DB_DEEPSLOPE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return colTypes;
    }

    public String getPersistentName() {
        return new DbDeepSlope().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long updateExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long deleteExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public long insertExc(Entity ent) throws Exception {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public static DeepSlope fetchExc(long oid) throws CONException {
        try {
            DeepSlope deepSlope = new DeepSlope();
            DbDeepSlope dbDeepSlope = new DbDeepSlope(oid);
            deepSlope.setOID(oid);
            deepSlope.setApproach(dbDeepSlope.getInt(COL_APPROACH));
            deepSlope.setUserId(dbDeepSlope.getlong(COL_USER_ID));
            deepSlope.setPartnerId(dbDeepSlope.getlong(COL_PARTNER_ID));
            deepSlope.setLandingDate(dbDeepSlope.getDate(COL_LANDING_DATE));
            deepSlope.setLandingLocation(dbDeepSlope.getString(COL_LANDING_LOCATION));
            deepSlope.setWpp1(dbDeepSlope.getString(COL_WPP1));
            deepSlope.setWpp2(dbDeepSlope.getString(COL_WPP2));
            deepSlope.setWpp3(dbDeepSlope.getString(COL_WPP3));
            deepSlope.setBoatId(dbDeepSlope.getlong(COL_BOAT_ID));
            deepSlope.setFishingGear(dbDeepSlope.getString(COL_FISHING_GEAR));
            deepSlope.setBroughtBy(dbDeepSlope.getString(COL_BROUGHT_BY));
            deepSlope.setCODRSFileName(dbDeepSlope.getString(COL_CODRS_FILE_NAME));
            deepSlope.setOtherFishingGround(dbDeepSlope.getString(COL_OTHER_FISHING_GROUND));
            deepSlope.setSupplier(dbDeepSlope.getString(COL_SUPPLIER));
            deepSlope.setFisheryType(dbDeepSlope.getString(COL_FISHERY_TYPE));
            deepSlope.setEntryDate(dbDeepSlope.getDate(COL_ENTRY_DATE));
            deepSlope.setPostingDate(dbDeepSlope.getDate(COL_POSTING_DATE));
            deepSlope.setPostingUser(dbDeepSlope.getlong(COL_POSTING_USER));
            deepSlope.setFirstCODRSPictureDate(dbDeepSlope.getDate(COL_FIRST_CODRS_PICTURE_DATE));
            deepSlope.setDocStatus(dbDeepSlope.getString(COL_DOC_STATUS));
            return deepSlope;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDeepSlope(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(DeepSlope deepSlope) throws CONException {
        try {
            DbDeepSlope dbDeepSlope = new DbDeepSlope(0);
            dbDeepSlope.setInt(COL_APPROACH, deepSlope.getApproach());
            dbDeepSlope.setLong(COL_USER_ID, deepSlope.getUserId());
            dbDeepSlope.setLong(COL_PARTNER_ID, deepSlope.getPartnerId());
            dbDeepSlope.setDate(COL_LANDING_DATE, deepSlope.getLandingDate());
            dbDeepSlope.setString(COL_LANDING_LOCATION, deepSlope.getLandingLocation());
            dbDeepSlope.setString(COL_WPP1, deepSlope.getWpp1());
            dbDeepSlope.setString(COL_WPP2, deepSlope.getWpp2());
            dbDeepSlope.setString(COL_WPP3, deepSlope.getWpp3());
            dbDeepSlope.setLong(COL_BOAT_ID, deepSlope.getBoatId());
            dbDeepSlope.setString(COL_FISHING_GEAR, deepSlope.getFishingGear());
            dbDeepSlope.setString(COL_BROUGHT_BY, deepSlope.getBroughtBy());
            dbDeepSlope.setString(COL_CODRS_FILE_NAME, deepSlope.getCODRSFileName());
            dbDeepSlope.setString(COL_OTHER_FISHING_GROUND, deepSlope.getOtherFishingGround());
            dbDeepSlope.setString(COL_SUPPLIER, deepSlope.getSupplier());
            dbDeepSlope.setString(COL_FISHERY_TYPE, deepSlope.getFisheryType());
            dbDeepSlope.setDate(COL_ENTRY_DATE, deepSlope.getEntryDate());
            dbDeepSlope.setDate(COL_POSTING_DATE, deepSlope.getPostingDate());
            dbDeepSlope.setLong(COL_POSTING_USER, deepSlope.getPostingUser());
            dbDeepSlope.setDate(COL_FIRST_CODRS_PICTURE_DATE, deepSlope.getFirstCODRSPictureDate());
            dbDeepSlope.setString(COL_DOC_STATUS, deepSlope.getDocStatus());
            dbDeepSlope.insert();
            deepSlope.setOID(dbDeepSlope.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDeepSlope(0), CONException.UNKNOWN);
        }
        return deepSlope.getOID();
    }

    public static boolean insertExcWithOID(DeepSlope deepSlope) throws CONException {
        boolean isSaved = false;
        String sql = "insert into " + DB_DEEPSLOPE
                + "(" + colNames[COL_OID]
                + "," + colNames[COL_APPROACH]
                + "," + colNames[COL_USER_ID]
                + "," + colNames[COL_PARTNER_ID]
                + "," + colNames[COL_LANDING_DATE]
                + "," + colNames[COL_LANDING_LOCATION]
                + "," + colNames[COL_WPP1]
                + "," + colNames[COL_WPP2]
                + "," + colNames[COL_WPP3]
                + "," + colNames[COL_BOAT_ID]
                + "," + colNames[COL_FISHING_GEAR]
                + "," + colNames[COL_BROUGHT_BY]
                + "," + colNames[COL_CODRS_FILE_NAME]
                + "," + colNames[COL_OTHER_FISHING_GROUND]
                + "," + colNames[COL_SUPPLIER]
                + "," + colNames[COL_FISHERY_TYPE]
                + "," + colNames[COL_ENTRY_DATE]
                + "," + colNames[COL_POSTING_DATE]
                + "," + colNames[COL_POSTING_USER]
                + "," + colNames[COL_FIRST_CODRS_PICTURE_DATE]
                + "," + colNames[COL_DOC_STATUS]
                + ") values ("
                + deepSlope.getOID()
                + "," + deepSlope.getApproach()
                + "," + deepSlope.getUserId()
                + "," + deepSlope.getPartnerId()
                + ",'" + JSPFormater.formatDate(deepSlope.getLandingDate(), "yyyy-MM-dd HH:mm:ss") + "'"
                + ",'" + deepSlope.getLandingLocation() + "'"
                + ",'" + deepSlope.getWpp1() + "'"
                + ",'" + deepSlope.getWpp2() + "'"
                + ",'" + deepSlope.getWpp3() + "'"
                + "," + deepSlope.getBoatId()
                + ",'" + deepSlope.getFishingGear() + "'"
                + ",'" + deepSlope.getBroughtBy() + "'"
                + ",'" + deepSlope.getCODRSFileName() + "'"
                + ",'" + deepSlope.getOtherFishingGround() + "'"
                + ",'" + deepSlope.getSupplier() + "'"
                + ",'" + deepSlope.getFisheryType() + "'"
                + ",'" + JSPFormater.formatDate(deepSlope.getEntryDate(), "yyyy-MM-dd HH:mm:ss") + "'"
                + ",'" + JSPFormater.formatDate(deepSlope.getPostingDate(), "yyyy-MM-dd HH:mm:ss") + "'"
                + "," + deepSlope.getPostingUser()
                + ",'" + JSPFormater.formatDate(deepSlope.getFirstCODRSPictureDate(), "yyyy-MM-dd HH:mm:ss") + "'"
                + ",'" + deepSlope.getDocStatus() + "'"
                + ")";

        try {
            CONHandler.execUpdate(sql);
            isSaved = true;
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return isSaved;
    }

    public static long updateExc(DeepSlope deepSlope) throws CONException {
        try {
            if (deepSlope.getOID() != 0) {
                DbDeepSlope dbDeepSlope = new DbDeepSlope(deepSlope.getOID());
                dbDeepSlope.setInt(COL_APPROACH, deepSlope.getApproach());
                dbDeepSlope.setLong(COL_USER_ID, deepSlope.getUserId());
                dbDeepSlope.setLong(COL_PARTNER_ID, deepSlope.getPartnerId());
                dbDeepSlope.setDate(COL_LANDING_DATE, deepSlope.getLandingDate());
                dbDeepSlope.setString(COL_LANDING_LOCATION, deepSlope.getLandingLocation());
                dbDeepSlope.setString(COL_WPP1, deepSlope.getWpp1());
                dbDeepSlope.setString(COL_WPP2, deepSlope.getWpp2());
                dbDeepSlope.setString(COL_WPP3, deepSlope.getWpp3());
                dbDeepSlope.setLong(COL_BOAT_ID, deepSlope.getBoatId());
                dbDeepSlope.setString(COL_FISHING_GEAR, deepSlope.getFishingGear());
                dbDeepSlope.setString(COL_BROUGHT_BY, deepSlope.getBroughtBy());
                dbDeepSlope.setString(COL_CODRS_FILE_NAME, deepSlope.getCODRSFileName());
                dbDeepSlope.setString(COL_OTHER_FISHING_GROUND, deepSlope.getOtherFishingGround());
                dbDeepSlope.setString(COL_SUPPLIER, deepSlope.getSupplier());
                dbDeepSlope.setString(COL_FISHERY_TYPE, deepSlope.getFisheryType());
                dbDeepSlope.setDate(COL_ENTRY_DATE, deepSlope.getEntryDate());
                dbDeepSlope.setDate(COL_POSTING_DATE, deepSlope.getPostingDate());
                dbDeepSlope.setLong(COL_POSTING_USER, deepSlope.getPostingUser());
                dbDeepSlope.setDate(COL_FIRST_CODRS_PICTURE_DATE, deepSlope.getFirstCODRSPictureDate());
                dbDeepSlope.setString(COL_DOC_STATUS, deepSlope.getDocStatus());
                dbDeepSlope.update();
                return deepSlope.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDeepSlope(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbDeepSlope dbDeepSlope = new DbDeepSlope(oid);
            dbDeepSlope.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbDeepSlope(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_DEEPSLOPE;
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
                DeepSlope deepSlope = new DeepSlope();
                resultToObject(rs, deepSlope);
                lists.add(deepSlope);
            }
            rs.close();
            return lists;

        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    private static void resultToObject(ResultSet rs, DeepSlope deepSlope) {
        try {
            deepSlope.setOID(rs.getLong(colNames[COL_OID]));
            deepSlope.setApproach(rs.getInt(colNames[COL_APPROACH]));
            deepSlope.setUserId(rs.getLong(colNames[COL_USER_ID]));
            deepSlope.setPartnerId(rs.getLong(colNames[COL_PARTNER_ID]));
            deepSlope.setLandingDate(rs.getDate(colNames[COL_LANDING_DATE]));
            deepSlope.setLandingLocation(rs.getString(colNames[COL_LANDING_LOCATION]));
            deepSlope.setWpp1(rs.getString(colNames[COL_WPP1]));
            deepSlope.setWpp2(rs.getString(colNames[COL_WPP2]));
            deepSlope.setWpp3(rs.getString(colNames[COL_WPP3]));
            deepSlope.setBoatId(rs.getLong(colNames[COL_BOAT_ID]));
            deepSlope.setFishingGear(rs.getString(colNames[COL_FISHING_GEAR]));
            deepSlope.setBroughtBy(rs.getString(colNames[COL_BROUGHT_BY]));
            deepSlope.setCODRSFileName(rs.getString(colNames[COL_CODRS_FILE_NAME]));
            deepSlope.setOtherFishingGround(rs.getString(colNames[COL_OTHER_FISHING_GROUND]));
            deepSlope.setSupplier(rs.getString(colNames[COL_SUPPLIER]));
            deepSlope.setFisheryType(rs.getString(colNames[COL_FISHERY_TYPE]));
            deepSlope.setEntryDate(rs.getDate(colNames[COL_ENTRY_DATE]));
            deepSlope.setPostingDate(rs.getDate(colNames[COL_POSTING_DATE]));
            deepSlope.setPostingUser(rs.getLong(colNames[COL_POSTING_USER]));
            deepSlope.setFirstCODRSPictureDate(rs.getDate(colNames[COL_FIRST_CODRS_PICTURE_DATE]));
            deepSlope.setDocStatus(rs.getString(colNames[COL_DOC_STATUS]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long deepSlopeId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_DEEPSLOPE + " WHERE "
                    + colNames[COL_OID] + " = " + deepSlopeId;

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                result = true;
            }
            rs.close();
        } catch (Exception e) {
            System.out.println(e.toString());
        } finally {
            CONResultSet.close(dbrs);
            return result;
        }
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_DEEPSLOPE;
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
                    DeepSlope deepSlope = (DeepSlope) list.get(ls);
                    if (oid == deepSlope.getOID()) {
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

    private static String getNode(String sTag, Element eElement) {
        try {
            NodeList nlList = eElement.getElementsByTagName(sTag).item(0).getChildNodes();
            Node nValue = (Node) nlList.item(0);
            return nValue.getNodeValue();
        } catch (Exception e) {
            System.out.println("Exc getNode() " + sTag + e.toString());
            return "";
        }
    }

    /**
     * Extract XML that contains Deep Slope data from mobile device (Android)
     * @param is
     * @return
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws SAXException
     * @throws TransformerConfigurationException
     * @throws TransformerException
     */
    public static String mDCUDeepSlope(InputStream is)
            throws IOException, ParserConfigurationException, SAXException,
            TransformerConfigurationException, TransformerException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

        // Extract XML
        Document docReq = dBuilder.parse(is);
        docReq.getDocumentElement().normalize();
        NodeList nList = docReq.getElementsByTagName("deepslope");

        // Generate XML response
        boolean isResponse = false;
        Document docRes = dBuilder.newDocument();
        Element rootElement = docRes.createElement("ifish");
        docRes.appendChild(rootElement);

        long oid = 0;
        long prevOID = 0;
        for (int temp = 0; temp < nList.getLength(); temp++) {
            Node nNode = nList.item(temp);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element element = (Element) nNode;

                long userId = 0;
                long partnerId = 0;
                try {
                    userId = Long.parseLong(getNode("userid", element));
                    if (userId != 0) {
                        User u = DbUser.fetch(userId);
                        partnerId = u.getPartnerId();
                    }
                } catch (Exception e) {
                    System.out.println(e.toString());
                }

                try {
                    DeepSlope deepSlope = new DeepSlope();
                    deepSlope.setOID(Long.parseLong(getNode("landingid", element)));
                    deepSlope.setApproach(IFishConfig.APPROACH_MDCU);
                    deepSlope.setUserId(userId);
                    deepSlope.setPartnerId(partnerId);
                    deepSlope.setLandingDate(sdf.parse(getNode("landingdate", element)));
                    deepSlope.setLandingLocation(getNode("landinglocation", element));
                    deepSlope.setWpp1(getNode("wpp1", element));
                    deepSlope.setWpp2(getNode("wpp2", element));
                    deepSlope.setWpp3(getNode("wpp3", element));
                    deepSlope.setBoatId(Long.parseLong(getNode("boatid", element)));
                    deepSlope.setFishingGear(getNode("fishinggear", element));
                    deepSlope.setSupplier(getNode("supplier", element));

                    Sizing sizing = new Sizing();
                    sizing.setOID(Long.parseLong(getNode("oid", element)));
                    sizing.setLandingId(Long.parseLong(getNode("landingid", element)));
                    sizing.setFishId(Long.parseLong(getNode("fishid", element)));
                    sizing.setCm(Double.parseDouble(getNode("cm", element)));
                    sizing.setOffloadingId(0); //only the data from the smart measuring system comes with offloading_id

                    boolean isSaved = false;
                    oid = deepSlope.getOID();
                    if (deepSlope.getOID() != 0 && deepSlope.getWpp1().length() > 0 && (deepSlope.getBoatId() != 0 || deepSlope.getSupplier().length() > 0)
                            && sizing.getFishId() != 0 && sizing.getCm() > 0) { // only complete data can be proceed

                        // insert landing
                        if (prevOID != oid) { // only insert once a landing data for each group of landing
                            // check if landing is already on database
                            if (checkOID(deepSlope.getOID())) {
                                updateExc(deepSlope);
                                isSaved = true;
                            } else {
                                isSaved = insertExcWithOID(deepSlope);
                            }
                        }

                        // insert sizing
                        long oidx = 0;
                        if (DbSizing.checkOID(sizing.getOID())) {
                            oidx = DbSizing.updateExc(sizing);
                        } else {
                            oidx = DbSizing.insertExcWithOid(sizing);
                        }
                        if (oidx != 0) {
                            isSaved = true;
                        }

                        prevOID = oid;
                    }

                    // Generate XML response
                    Element eStatus = docRes.createElement("deepslopestatus");
                    rootElement.appendChild(eStatus);

                    Element eStatus2 = docRes.createElement("oid");
                    eStatus2.appendChild(docRes.createTextNode(String.valueOf(sizing.getOID())));
                    eStatus.appendChild(eStatus2);

                    eStatus2 = docRes.createElement("status");
                    eStatus2.appendChild(docRes.createTextNode(isSaved ? "1" : "0"));
                    eStatus.appendChild(eStatus2);
                    isResponse = true;
                    // End
                } catch (Exception e) {
                    System.out.println("Exc mDCUDeepSlope() " + e.toString());
                }
            }
        }

        // Write XML into string
        TransformerFactory transformerFactory = TransformerFactory.newInstance();
        Transformer transformer = transformerFactory.newTransformer();
        transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
        DOMSource source = new DOMSource(docRes);
        StringWriter writer = new StringWriter();
        StreamResult result = new StreamResult(writer);
        transformer.transform(source, result);
        return (isResponse ? writer.toString() : "No data to be proceed.");
    }

    public static List<CODRS> CODRSDeepSlopeReview(InputStream is, long userId, long partnerId, String codrsFileName) {
        List<CODRS> list = new ArrayList<CODRS>();
        //boolean status = false;
        try {
            System.out.println("in CODRSDeepSlopeReview.....");
            //Get the workbook instance for XLS file
            HSSFWorkbook workbook = new HSSFWorkbook(is);

            //Get first sheet from the workbook
            HSSFSheet sheet = workbook.getSheetAt(0);

            //Iterate through each rows from first sheet
            Iterator<Row> rowIterator = sheet.rowIterator();

            Cell cell;
            int n = 0;

            Vector vFish = DbFish.listAll();
            Hashtable hFish = new Hashtable();
            if (vFish != null && vFish.size() > 0) {
                for (int i = 0; i < vFish.size(); i++) {
                    Fish f = (Fish) vFish.get(i);
                    hFish.put(f.getOID(), f);
                }
            }

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                System.out.println("n=" + n);
                if (n > 0) { // 1st row is header
                    String fishingGear = "";
                    cell = row.getCell(1, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        fishingGear = cell.getStringCellValue().trim();
                    }

                    Date pictureDate = null;
                    cell = row.getCell(2, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            pictureDate = ((Cell) row.getCell(2)).getDateCellValue();
                        } catch (Exception e) {
                            System.out.println("pictureDate >> " + e.toString());
                        }
                    }

                    Date landingDate = null;
                    cell = row.getCell(3, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            landingDate = ((Cell) row.getCell(3)).getDateCellValue();
                        } catch (Exception e) {
                            System.out.println("landingDate >> " + e.toString());
                        }
                    }

                    String pictureName = "";
                    cell = row.getCell(4, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        pictureName = cell.getStringCellValue().trim();
                    }

                    String family = "";
                    cell = row.getCell(5, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        family = cell.getStringCellValue().trim();
                    }

                    String genus = "";
                    cell = row.getCell(6, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        genus = cell.getStringCellValue().trim();
                    }

                    String species = "";
                    cell = row.getCell(7, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        species = cell.getStringCellValue().trim();
                    }

                    long fishId = 0;
                    if (genus.length() > 0 && species.length() > 0) {
                        fishId = DbFish.getFishId(genus, species);
                    } else {
                        fishId = DbFish.getFishIdByFamily(family);
                    }

                    double cm = 0;
                    cell = row.getCell(8, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            cm = cell.getNumericCellValue();
                        } catch (Exception e) {
                            cm = 0;
                            System.out.println("cm >> " + e.toString());
                        }
                    }

                    String wpp1 = "";
                    cell = row.getCell(9, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            wpp1 = JSPFormater.formatNumber(cell.getNumericCellValue(), "#");
                        } catch (Exception e) {
                            System.out.println("wpp1 >> " + e.toString());
                        }
                    }

                    String wpp2 = "";
                    cell = row.getCell(10, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            wpp2 = JSPFormater.formatNumber(cell.getNumericCellValue(), "#");
                        } catch (Exception e) {
                            System.out.println("wpp2 >> " + e.toString());
                        }
                    }

                    String wpp3 = "";
                    cell = row.getCell(11, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            wpp3 = JSPFormater.formatNumber(cell.getNumericCellValue(), "#");
                        } catch (Exception e) {
                            System.out.println("wpp3 >> " + e.toString());
                        }
                    }

                    String otherFishingGround = "";
                    cell = row.getCell(12, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            otherFishingGround = cell.getStringCellValue();
                        } catch (Exception e) {
                            System.out.println("otherFishingGround >> " + e.toString());
                        }
                    }

                    long boatId = 0;
                    Vector listBoat = DbPartnerBoat.listBoat(partnerId);
                    if (listBoat != null && listBoat.size() > 0) {
                        Boat b = (Boat) listBoat.get(0); // only return one boat because Partner type is Fishermen (CODRS)
                        boatId = b.getOID();
                    }

                    Fish fish = (Fish) hFish.get(fishId);
                    if (fish == null) {
                        fish = new Fish();
                    }

                    CODRS codrs = new CODRS();
                    codrs.setApproach(IFishConfig.APPROACH_CODRS);
                    codrs.setUserId(userId);
                    codrs.setPartnerId(partnerId);
                    codrs.setLandingDate(landingDate);
                    codrs.setWpp1(wpp1);
                    codrs.setWpp2(wpp2);
                    codrs.setWpp3(wpp3);
                    codrs.setBoatId(boatId);
                    codrs.setFishingGear(fishingGear);
                    codrs.setFishId(fish.getOID());
                    codrs.setCm(cm);
                    codrs.setFileName(codrsFileName);
                    codrs.setOtherFishingGround(otherFishingGround);
                    codrs.setPictureDate(pictureDate);
                    codrs.setPictureName(pictureName);

                    if(fish.getOID() == 0) {
                        codrs.setDataQuality(0); //error
                    } else {
                        if(codrs.getCm() == 0) {
                            codrs.setDataQuality(0); //error if TL is 0
                        } else if(codrs.getCm() > fish.getLmax()) {
                            codrs.setDataQuality(-1); //warning if length more than lmax
                        } else if(codrs.getCm() > fish.getLargestSpecimenCm()) {
                            codrs.setDataQuality(-1); //warning if length more than recorded largest specimen
                        } else if(landingDate.equals(codrs.getPictureDate())) {
                            codrs.setDataQuality(-1); //warning if picture date same as landing date
                        } else {
                            codrs.setDataQuality(1); //ok
                        }
                    }

                    list.add(codrs);
                }
                n++;
            }
        } catch (Exception e) {
            System.out.println("CODRSDeepSlopeRevew >> " + e.toString());
        }
        return list;
    }

    public static String CODRSDeepSlopeUpload(List<CODRS> list) {
        long oid = 0;
        try {
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    CODRS codrs = (CODRS) list.get(i);

                    if (i == 0) { //only save 1st row into ifish_deepslope as main data
                        DeepSlope deepSlope = new DeepSlope();
                        deepSlope.setApproach(codrs.getApproach());
                        deepSlope.setUserId(codrs.getUserId());
                        deepSlope.setPartnerId(codrs.getPartnerId());
                        deepSlope.setLandingDate(codrs.getLandingDate());
                        deepSlope.setWpp1(codrs.getWpp1());
                        deepSlope.setWpp2(codrs.getWpp2());
                        deepSlope.setWpp3(codrs.getWpp3());
                        deepSlope.setBoatId(codrs.getBoatId());
                        deepSlope.setFishingGear(codrs.getFishingGear());
                        deepSlope.setCODRSFileName(codrs.getFileName());
                        deepSlope.setOtherFishingGround(codrs.getOtherFishingGround());

                        if (DbDeepSlope.codrsFileIsExist(deepSlope.getCODRSFileName())) {
                            return "File already exist!";
                        } else {
                            try {
                                oid = DbDeepSlope.insertExc(deepSlope);
                            } catch (Exception e) {
                                System.out.println(e.toString());
                            }
                        }
                    }

                    if (oid != 0) { //process the measuring data
                        Sizing sizing = new Sizing();
                        sizing.setLandingId(oid);
                        sizing.setFishId(codrs.getFishId());
                        sizing.setCm(codrs.getCm());
                        sizing.setCODRSPictureDate(codrs.getPictureDate());
                        sizing.setCODRSPictureName(codrs.getPictureName());
                        try {
                            long oids = DbSizing.insertExc(sizing);
                            if (oids != 0) {
                                codrs.setUploadStatus(IFishConfig.STATUS_POSTED); // set the upload status as a success
                            }
                        } catch (Exception e) {
                            System.out.println(e.toString());
                        }
                    }
                }
            }
            return "Upload data done.";
        } catch (Exception e) {
            try {
                DbDeepSlope.deleteExc(oid); // delete deepslope data
                DbSizing.deleteByLandingId(oid); // delete measurement data
            } catch (Exception ex) {
            }
            System.out.println(e.toString());
            return "Upload data fail! Please re-upload the data.";
        }
    }

    public static boolean codrsFileIsExist(String fileName) {
        boolean status = false;
        try {
            Vector list = list(0, 0, colNames[COL_CODRS_FILE_NAME] + " like '" + fileName + "'", "");
            if (list != null && list.size() > 0) {
                status = true;
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return status;
    }

    public static List<CODRS> CODRSDeepSlopeReviewV2(InputStream is, long userId, long partnerId, String codrsFileName, String fisheryType) {
        List<CODRS> list = new ArrayList<CODRS>();
        //boolean status = false;
        try {
            System.out.println("in CODRSDeepSlopeReviewV2.....");
            //Get the workbook instance for XLS file
            HSSFWorkbook workbook = new HSSFWorkbook(is);

            //Get first sheet from the workbook
            HSSFSheet sheet = workbook.getSheetAt(0);

            //Iterate through each rows from first sheet
            Iterator<Row> rowIterator = sheet.rowIterator();

            Cell cell;
            int n = 0;
            Date landingDate = null;

            Vector vFish = DbFish.listAll();
            Hashtable hFish = new Hashtable();
            if (vFish != null && vFish.size() > 0) {
                for (int i = 0; i < vFish.size(); i++) {
                    Fish f = (Fish) vFish.get(i);
                    hFish.put(f.getOID(), f);
                }
            }

            while (rowIterator.hasNext()) {
                System.out.println("n=" + n);

                Row row = rowIterator.next();
                CODRS codrs = new CODRS();

                if (n == 1) { //landing information
                    cell = row.getCell(1, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            landingDate = ((Cell) row.getCell(1)).getDateCellValue();
                        } catch (Exception e) {
                            System.out.println("landingDate >> " + e.toString());
                        }
                    }

                    String wpp1 = "";
                    cell = row.getCell(2, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                                wpp1 = JSPFormater.formatNumber(cell.getNumericCellValue(), "#");
                            } else {
                                wpp1 = cell.getStringCellValue().trim();
                            }
                        } catch (Exception e) {
                            System.out.println("wpp1 >> " + e.toString());
                        }
                    }

                    String wpp2 = "";
                    cell = row.getCell(3, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                                wpp2 = JSPFormater.formatNumber(cell.getNumericCellValue(), "#");
                            } else {
                                wpp2 = cell.getStringCellValue().trim();
                            }
                        } catch (Exception e) {
                            System.out.println("wpp2 >> " + e.toString());
                        }
                    }

                    String wpp3 = "";
                    cell = row.getCell(4, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            if(cell.getCellType() == Cell.CELL_TYPE_NUMERIC) {
                                wpp3 = JSPFormater.formatNumber(cell.getNumericCellValue(), "#");
                            } else {
                                wpp3 = cell.getStringCellValue().trim();
                            }
                        } catch (Exception e) {
                            System.out.println("wpp3 >> " + e.toString());
                        }
                    }

                    String otherFishingGround = "";
                    cell = row.getCell(5, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            otherFishingGround = cell.getStringCellValue();
                        } catch (Exception e) {
                            System.out.println("otherFishingGround >> " + e.toString());
                        }
                    }

                    Vector listBoat = DbPartnerBoat.listBoat(partnerId);
                    if (listBoat != null && listBoat.size() > 0) {
                        Boat b = (Boat) listBoat.get(0); // only return one boat because Partner type is Fishermen (CODRS)
                        codrs.setBoatId(b.getOID());
                        codrs.setFishingGear(b.getGearType());
                    }

                    codrs.setApproach(IFishConfig.APPROACH_CODRS);
                    codrs.setUserId(userId);
                    codrs.setPartnerId(partnerId);
                    codrs.setLandingDate(landingDate);
                    codrs.setWpp1(wpp1);
                    codrs.setWpp2(wpp2);
                    codrs.setWpp3(wpp3);
                    codrs.setOtherFishingGround(otherFishingGround);
                    codrs.setDataQuality(1);
                    codrs.setFisheryType(fisheryType);

                    list.add(codrs);
                }

                if (n > 3) { //list of specimen
                    Date pictureDate = null;
                    cell = row.getCell(0, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            pictureDate = ((Cell) row.getCell(0)).getDateCellValue();
                        } catch (Exception e) {
                            System.out.println("pictureDate >> " + e.toString());
                        }
                    }

                    String pictureName = "";
                    cell = row.getCell(1, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        pictureName = cell.getStringCellValue().trim();
                    }

                    String family = "";
                    cell = row.getCell(2, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        family = cell.getStringCellValue().trim();
                    }

                    String genus = "";
                    cell = row.getCell(3, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        genus = cell.getStringCellValue().trim();
                    }

                    String species = "";
                    cell = row.getCell(4, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        species = cell.getStringCellValue().trim();
                    }

                    long fishId = 0;
                    if (genus.length() > 0 && species.length() > 0) {
                        fishId = DbFish.getFishId(genus, species);
                    } else {
                        fishId = DbFish.getFishIdByFamily(family);
                    }

                    double cm = 0;
                    cell = row.getCell(5, Row.RETURN_BLANK_AS_NULL);
                    if (cell != null) {
                        try {
                            cm = cell.getNumericCellValue();
                        } catch (Exception e) {
                            cm = 0;
                            System.out.println("cm >> " + e.toString());
                        }
                    }

                    Fish fish = (Fish) hFish.get(fishId);
                    if (fish == null) {
                        fish = new Fish();
                    }

                    codrs.setPictureDate(pictureDate);
                    codrs.setPictureName(pictureName);
                    codrs.setFishId(fish.getOID());
                    codrs.setCm(cm);

                    if(fish.getOID() == 0) {
                        codrs.setDataQuality(0); //error
                    } else {
                        if(codrs.getCm() == 0) {
                            codrs.setDataQuality(0); //error if TL is 0
                        } else if(codrs.getCm() > fish.getLmax()) {
                            codrs.setDataQuality(-1); //warning if length more than lmax
                        } else if(codrs.getCm() > fish.getLargestSpecimenCm()) {
                            codrs.setDataQuality(-1); //warning if length more than recorded largest specimen
                        } else if(landingDate.equals(codrs.getPictureDate())) {
                            codrs.setDataQuality(-1); //warning if picture date same as landing date
                        } else {
                            codrs.setDataQuality(1); //ok
                        }
                    }

                    list.add(codrs);
                }

                n++;
            }
        } catch (Exception e) {
            System.out.println("CODRSDeepSlopeReviewV2 >> " + e.toString());
        }
        return list;
    }

    public static String CODRSDeepSlopeUploadV2(List<CODRS> list) {
        long oid = 0;
        DeepSlope deepSlope = new DeepSlope();
        try {
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    CODRS codrs = (CODRS) list.get(i);

                    if (i == 0) { //only save 1st row into ifish_deepslope as main data
                        deepSlope.setApproach(codrs.getApproach());
                        deepSlope.setUserId(codrs.getUserId());
                        deepSlope.setPartnerId(codrs.getPartnerId());
                        deepSlope.setBoatId(codrs.getBoatId());
                        deepSlope.setFishingGear(codrs.getFishingGear());
                        deepSlope.setLandingDate(codrs.getLandingDate());
                        deepSlope.setWpp1(codrs.getWpp1());
                        deepSlope.setWpp2(codrs.getWpp2());
                        deepSlope.setWpp3(codrs.getWpp3());
                        deepSlope.setOtherFishingGround(codrs.getOtherFishingGround());
                        deepSlope.setFisheryType(codrs.getFisheryType());
                        deepSlope.setEntryDate(new Date());
                        deepSlope.setFirstCODRSPictureDate(codrs.getPictureDate());
                        deepSlope.setDocStatus(IFishConfig.DOC_STATUS_DRAFT);

                        DeepSlope prevLanding = getLandingId(IFishConfig.APPROACH_CODRS, codrs.getBoatId(), codrs.getLandingDate());
                        if (prevLanding.getOID() != 0) {
                            if(prevLanding.getDocStatus().equals(IFishConfig.DOC_STATUS_POSTED)) {
                                return "Data already exist!";
                            } else {
                                deepSlope.setOID(prevLanding.getOID());
                                oid = DbDeepSlope.updateExc(deepSlope);
                                DbSizing.deleteByLandingId(oid); // reset measurement data
                            }
                        } else {
                            try {
                                oid = DbDeepSlope.insertExc(deepSlope);
                            } catch (Exception e) {
                                System.out.println(e.toString());
                            }
                        }
                    }

                    if (oid != 0 && i > 0) { //process the specimen data
                        Sizing sizing = new Sizing();
                        sizing.setLandingId(oid);
                        sizing.setFishId(codrs.getFishId());
                        sizing.setCm(codrs.getCm());
                        sizing.setCODRSPictureDate(codrs.getPictureDate());
                        sizing.setCODRSPictureName(codrs.getPictureName());
                        DbSizing.insertExc(sizing);
                    }
                }

                // Set 1st CODRS picture date
                if(deepSlope.getOID() != 0) {
                    Vector vSizing = DbSizing.list(0, 1, DbSizing.colNames[DbSizing.COL_LANDING_ID]+"="+deepSlope.getOID(), DbSizing.colNames[DbSizing.COL_CODRS_PICTURE_DATE]);
                    if(vSizing != null && vSizing.size() > 0) {
                        Sizing s = (Sizing) vSizing.get(0);
                        deepSlope.setFirstCODRSPictureDate(s.getCODRSPictureDate());
                        DbDeepSlope.updateExc(deepSlope);
                    }
                }
            }
            return "Upload data done.";
        } catch (Exception e) {
            try {
                DbDeepSlope.deleteExc(oid); // delete deepslope data
                DbSizing.deleteByLandingId(oid); // delete measurement data
            } catch (Exception ex) {
            }
            System.out.println(e.toString());
            return "Upload data fail! Please re-upload the data.";
        }
    }

    public static DeepSlope getLandingId(int approach, long boatId, Date landingDate) {
        DeepSlope ds = new DeepSlope();
        try {
            String where = colNames[COL_APPROACH] + " = " + approach + " and " + colNames[COL_BOAT_ID] + " = " + boatId
                    + " and date_trunc('day', " + colNames[COL_LANDING_DATE] + ") = '" + JSPFormater.formatDate(landingDate, "yyyy-MM-dd") + "'";
            Vector list = list(0, 0, where, "");
            if (list != null && list.size() > 0) {
                ds = (DeepSlope) list.get(0);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return ds;
    }

    public static void deleteRecursiveCODRS(HttpServletRequest request, long landingId) {
        try {
            if (landingId != 0) {
                // Reset largest specimen
                SessDeepSlope.rollbackLargestSpecimen(request, landingId);

                // Delete sizing document
                String sql = "DELETE FROM " + DbSizing.DB_SIZING + " WHERE " + DbSizing.colNames[DbSizing.COL_LANDING_ID] + " = " + landingId;
                CONHandler.execUpdate(sql);

                // Delete main document
                deleteExc(landingId);
            }
        } catch (Exception e) {
            System.out.print(e.toString());
        }
    }
}
