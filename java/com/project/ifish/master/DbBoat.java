package com.project.ifish.master;

import com.project.IFishConfig;
import com.project.general.DbSystemProperty;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.io.File;
import java.util.Vector;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 *
 * @author gwawan
 */
public class DbBoat extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_BOAT = "ifish_boat";
    public static final int COL_OID = 0;
    public static final int COL_GEAR_TYPE = 1;
    public static final int COL_CODE = 2;
    public static final int COL_NAME = 3;
    public static final int COL_HOME_PORT = 4;
    public static final int COL_LENGTH = 5;
    public static final int COL_WIDTH = 6;
    public static final int COL_YEAR_BUILT = 7;
    public static final int COL_GROSS_TONNAGE = 8;
    public static final int COL_IS_ENGINE = 9;
    public static final int COL_ENGINE_HP = 10;
    public static final int COL_OWNER = 11;
    public static final int COL_OWNER_ORIGIN = 12;
    public static final int COL_CAPTAIN = 13;
    public static final int COL_CAPTAIN_ORIGIN = 14;
    public static final int COL_PARTNER_ID = 15;
    public static final int COL_TRACKER_ID = 16;
    public static final int COL_TRACKER_STATUS = 17;
    public static final int COL_TRACKER_START_DATE = 18;
    public static final int COL_TRACKER_END_DATE = 19;
    public static final int COL_PROGRAM_SITE = 20;
    public static final int COL_PICTURE_ORIGINAL = 21;
    public static final int COL_PICTURE_CENCORED = 22;
    public static final String[] colNames = {
        "oid",
        "gear_type",
        "code",
        "name",
        "home_port",
        "length",
        "width",
        "year_built",
        "gross_tonnage",
        "is_engine",
        "engine_hp",
        "owner",
        "owner_origin",
        "captain",
        "captain_origin",
        "partner_id",
        "tracker_id",
        "tracker_status",
        "tracker_start_date",
        "tracker_end_date",
        "program_site",
        "picture_original",
        "picture_censored"
    };
    public static final int[] fieldTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_LONG,
        TYPE_LONG
    };

    public DbBoat() {
    }

    public DbBoat(int i) throws CONException {
        super(new DbBoat());
    }

    public DbBoat(String sOid) throws CONException {
        super(new DbBoat(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbBoat(long lOid) throws CONException {
        super(new DbBoat(0));
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
        return DB_BOAT;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String getPersistentName() {
        return new DbBoat().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Boat boat = fetchExc(ent.getOID());
        ent = (Entity) boat;
        return boat.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Boat) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Boat) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Boat fetchExc(long oid) throws CONException {
        try {
            Boat boat = new Boat();
            DbBoat dbBoat = new DbBoat(oid);
            boat.setOID(oid);
            boat.setGearType(dbBoat.getString(COL_GEAR_TYPE));
            boat.setCode(dbBoat.getString(COL_CODE));
            boat.setName(dbBoat.getString(COL_NAME));
            boat.setHomePort(dbBoat.getString(COL_HOME_PORT));
            boat.setLength(dbBoat.getdouble(COL_LENGTH));
            boat.setWidth(dbBoat.getdouble(COL_WIDTH));
            boat.setYearBuilt(dbBoat.getInt(COL_YEAR_BUILT));
            boat.setGrossTonnage(dbBoat.getdouble(COL_GROSS_TONNAGE));
            boat.setIsEngine(dbBoat.getInt(COL_IS_ENGINE));
            boat.setEngineHP(dbBoat.getdouble(COL_ENGINE_HP));
            boat.setOwner(dbBoat.getString(COL_OWNER));
            boat.setOwnerOrigin(dbBoat.getString(COL_OWNER_ORIGIN));
            boat.setCaptain(dbBoat.getString(COL_CAPTAIN));
            boat.setCaptainOrigin(dbBoat.getString(COL_CAPTAIN_ORIGIN));
            boat.setPartnerId(dbBoat.getlong(COL_PARTNER_ID));
            boat.setTrackerId(dbBoat.getlong(COL_TRACKER_ID));
            boat.setTrackerStatus(dbBoat.getInt(COL_TRACKER_STATUS));
            boat.setTrackerStartDate(dbBoat.getDate(COL_TRACKER_START_DATE));
            boat.setTrackerEndDate(dbBoat.getDate(COL_TRACKER_END_DATE));
            boat.setProgramSite(dbBoat.getString(COL_PROGRAM_SITE));
            boat.setPictureOriginal(dbBoat.getlong(COL_PICTURE_ORIGINAL));
            boat.setPictureCensored(dbBoat.getlong(COL_PICTURE_CENCORED));
            return boat;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBoat(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Boat boat) throws CONException {
        try {
            DbBoat dbBoat = new DbBoat(0);
            dbBoat.setString(COL_GEAR_TYPE, boat.getGearType());
            dbBoat.setString(COL_CODE, boat.getCode());
            dbBoat.setString(COL_NAME, boat.getName());
            dbBoat.setString(COL_HOME_PORT, boat.getHomePort());
            dbBoat.setDouble(COL_LENGTH, boat.getLength());
            dbBoat.setDouble(COL_WIDTH, boat.getWidth());
            dbBoat.setInt(COL_YEAR_BUILT, boat.getYearBuilt());
            dbBoat.setDouble(COL_GROSS_TONNAGE, boat.getGrossTonnage());
            dbBoat.setInt(COL_IS_ENGINE, boat.isEngine());
            dbBoat.setDouble(COL_ENGINE_HP, boat.getEngineHP());
            dbBoat.setString(COL_OWNER, boat.getOwner());
            dbBoat.setString(COL_OWNER_ORIGIN, boat.getOwnerOrigin());
            dbBoat.setString(COL_CAPTAIN, boat.getCaptain());
            dbBoat.setString(COL_CAPTAIN_ORIGIN, boat.getCaptainOrigin());
            dbBoat.setLong(COL_PARTNER_ID, boat.getPartnerId());
            dbBoat.setLong(COL_TRACKER_ID, boat.getTrackerId());
            dbBoat.setInt(COL_TRACKER_STATUS, boat.getTrackerStatus());
            dbBoat.setDate(COL_TRACKER_START_DATE, boat.getTrackerStartDate());
            dbBoat.setDate(COL_TRACKER_END_DATE, boat.getTrackerEndDate());
            dbBoat.setString(COL_PROGRAM_SITE, boat.getProgramSite());
            dbBoat.setLong(COL_PICTURE_ORIGINAL, boat.getPictureOriginal());
            dbBoat.setLong(COL_PICTURE_CENCORED, boat.getPictureCensored());
            dbBoat.insert();
            boat.setOID(dbBoat.getlong(COL_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBoat(0), CONException.UNKNOWN);
        }
        return boat.getOID();
    }

    public static long updateExc(Boat boat) throws CONException {
        try {
            if (boat.getOID() != 0) {
                DbBoat dbBoat = new DbBoat(boat.getOID());
                dbBoat.setString(COL_GEAR_TYPE, boat.getGearType());
                dbBoat.setString(COL_CODE, boat.getCode());
                dbBoat.setString(COL_NAME, boat.getName());
                dbBoat.setString(COL_HOME_PORT, boat.getHomePort());
                dbBoat.setDouble(COL_LENGTH, boat.getLength());
                dbBoat.setDouble(COL_WIDTH, boat.getWidth());
                dbBoat.setInt(COL_YEAR_BUILT, boat.getYearBuilt());
                dbBoat.setDouble(COL_GROSS_TONNAGE, boat.getGrossTonnage());
                dbBoat.setInt(COL_IS_ENGINE, boat.isEngine());
                dbBoat.setDouble(COL_ENGINE_HP, boat.getEngineHP());
                dbBoat.setString(COL_OWNER, boat.getOwner());
                dbBoat.setString(COL_OWNER_ORIGIN, boat.getOwnerOrigin());
                dbBoat.setString(COL_CAPTAIN, boat.getCaptain());
                dbBoat.setString(COL_CAPTAIN_ORIGIN, boat.getCaptainOrigin());
                dbBoat.setLong(COL_PARTNER_ID, boat.getPartnerId());
                dbBoat.setLong(COL_TRACKER_ID, boat.getTrackerId());
                dbBoat.setInt(COL_TRACKER_STATUS, boat.getTrackerStatus());
                dbBoat.setDate(COL_TRACKER_START_DATE, boat.getTrackerStartDate());
                dbBoat.setDate(COL_TRACKER_END_DATE, boat.getTrackerEndDate());
                dbBoat.setString(COL_PROGRAM_SITE, boat.getProgramSite());
                dbBoat.setLong(COL_PICTURE_ORIGINAL, boat.getPictureOriginal());
                dbBoat.setLong(COL_PICTURE_CENCORED, boat.getPictureCensored());
                dbBoat.update();
                return boat.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBoat(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbBoat dbBoat = new DbBoat(oid);
            dbBoat.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbBoat(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_BOAT;
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
                Boat boat = new Boat();
                resultToObject(rs, boat);
                lists.add(boat);
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

    public static void resultToObject(ResultSet rs, Boat boat) {
        try {
            boat.setOID(rs.getLong(colNames[COL_OID]));
            boat.setGearType(rs.getString(colNames[COL_GEAR_TYPE]));
            boat.setCode(rs.getString(colNames[COL_CODE]));
            boat.setName(rs.getString(colNames[COL_NAME]));
            boat.setHomePort(rs.getString(colNames[COL_HOME_PORT]));
            boat.setLength(rs.getDouble(colNames[COL_LENGTH]));
            boat.setWidth(rs.getDouble(colNames[COL_WIDTH]));
            boat.setYearBuilt(rs.getInt(colNames[COL_YEAR_BUILT]));
            boat.setGrossTonnage(rs.getDouble(colNames[COL_GROSS_TONNAGE]));
            boat.setIsEngine(rs.getInt(colNames[COL_IS_ENGINE]));
            boat.setEngineHP(rs.getDouble(colNames[COL_ENGINE_HP]));
            boat.setOwner(rs.getString(colNames[COL_OWNER]));
            boat.setOwnerOrigin(rs.getString(colNames[COL_OWNER_ORIGIN]));
            boat.setCaptain(rs.getString(colNames[COL_CAPTAIN]));
            boat.setCaptainOrigin(rs.getString(colNames[COL_CAPTAIN_ORIGIN]));
            boat.setPartnerId(rs.getLong(colNames[COL_PARTNER_ID]));
            boat.setTrackerId(rs.getLong(colNames[COL_TRACKER_ID]));
            boat.setTrackerStatus(rs.getInt(colNames[COL_TRACKER_STATUS]));
            boat.setTrackerStartDate(rs.getDate(colNames[COL_TRACKER_START_DATE]));
            boat.setTrackerEndDate(rs.getDate(colNames[COL_TRACKER_END_DATE]));
            boat.setProgramSite(rs.getString(colNames[COL_PROGRAM_SITE]));
            boat.setPictureOriginal(rs.getLong(colNames[COL_PICTURE_ORIGINAL]));
            boat.setPictureCensored(rs.getLong(colNames[COL_PICTURE_CENCORED]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long boatId) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_BOAT + " WHERE "
                    + colNames[COL_OID] + " = " + boatId;

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
            String sql = "SELECT COUNT(" + colNames[COL_OID] + ") FROM " + DB_BOAT;
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
                    Boat boat = (Boat) list.get(ls);
                    if (oid == boat.getOID()) {
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

    public static long checkName(String name) {
        long oid = 0;
        try {
            String where = colNames[COL_NAME] + " like '" + name + "'";
            Vector list = list(0, 0, where, "");
            if(list != null && list.size() > 0) {
                Boat boat = (Boat) list.get(0);
                oid = boat.getOID();
            }
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    public static void generateXML() {
        try {
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

            // root elements
            Document doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("ifish");
            doc.appendChild(rootElement);

            Vector listBoat = DbBoat.list(0, 0, "", "");
            if (listBoat != null && listBoat.size() > 0) {
                for (int i = 0; i < listBoat.size(); i++) {
                    Boat boat = (Boat) listBoat.get(i);
                    Element eUser = doc.createElement("boat");
                    rootElement.appendChild(eUser);

                    Element eOid = doc.createElement("oid");
                    eOid.appendChild(doc.createTextNode(String.valueOf(boat.getOID())));
                    eUser.appendChild(eOid);

                    Element eLoginId = doc.createElement("code");
                    eLoginId.appendChild(doc.createTextNode(boat.getCode()));
                    eUser.appendChild(eLoginId);
                }
            }

            // write the content into xml file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            String APP_PATH = DbSystemProperty.getValueByName("APP_PATH");
            StreamResult result = new StreamResult(new File(APP_PATH + IFishConfig.API_PATH + System.getProperty("file.separator") + IFishConfig.nodeNames[IFishConfig.NODE_BOAT] + ".xml"));
            transformer.transform(source, result);
            System.out.println("File saved!");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
