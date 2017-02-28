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
import java.io.InputStream;
import java.io.StringWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Document;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.xml.sax.SAXException;

/**
 *
 * @author gwawan
 */
public class DbFile extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_FILE = "gen_file";
    public static final int COL_FILE_ID = 0;
    public static final int COL_NAME = 1;
    public static final int COL_NOTES = 2;
    public static final int COL_REF_ID = 3;
    public static final String[] colNames = {
        "file_id",
        "name",
        "notes",
        "ref_id"
    };
    public static final int[] colTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_LONG
    };
    public static String UPLOAD_DIRECTORY = "files";
    public static int MSG_UPLOAD_SUCCESS = 1;
    public static int MSG_UPLOAD_EXIST = 2;
    public static String[] msgUpload = {
        "",
        "Upload has been done successfully",
        "File already exist"
    };

    public DbFile() {
    }

    public DbFile(int i) throws CONException {
        super(new DbFile());
    }

    public DbFile(String sOid) throws CONException {
        super(new DbFile(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFile(long lOid) throws CONException {
        super(new DbFile(0));
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
        return DB_FILE;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return colTypes;
    }

    public String getPersistentName() {
        return new DbFile().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        File file = fetchExc(ent.getOID());
        ent = (Entity) file;
        return file.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((File) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((File) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static File fetchExc(long oid) throws CONException {
        try {
            File file = new File();
            DbFile dbFile = new DbFile(oid);
            file.setOID(oid);
            file.setName(dbFile.getString(COL_NAME));
            file.setNotes(dbFile.getString(COL_NOTES));
            file.setRefId(dbFile.getlong(COL_REF_ID));
            return file;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFile(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(File file) throws CONException {
        try {
            DbFile dbFile = new DbFile(0);
            dbFile.setString(COL_NAME, file.getName());
            dbFile.setString(COL_NOTES, file.getNotes());
            dbFile.setLong(COL_REF_ID, file.getRefId());
            dbFile.insert();
            file.setOID(dbFile.getlong(COL_FILE_ID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFile(0), CONException.UNKNOWN);
        }
        return file.getOID();
    }

    public static long updateExc(File file) throws CONException {
        try {
            if (file.getOID() != 0) {
                DbFile dbFile = new DbFile(file.getOID());
                dbFile.setString(COL_NAME, file.getName());
                dbFile.setString(COL_NOTES, file.getNotes());
                dbFile.setLong(COL_REF_ID, file.getRefId());
                dbFile.update();
                return file.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFile(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFile dbFile = new DbFile(oid);
            dbFile.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFile(0), CONException.UNKNOWN);
        }
        return oid;
    }

    public static boolean isHasData(long oid) {
        Vector list = new Vector();
        try {
            String where = colNames[COL_FILE_ID] + " = " + oid;
            list = list(0, 0, where, "");
        } catch(Exception e) {
            System.out.println(e.toString());
        }
        return (list!=null && list.size()>0 ? true : false);
    }

    public static Vector listAll() {
        return list(0, 500, "", "");
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;
        try {
            String sql = "SELECT * FROM " + DB_FILE;
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
                File file = new File();
                resultToObject(rs, file);
                lists.add(file);
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

    private static void resultToObject(ResultSet rs, File file) {
        try {
            file.setOID(rs.getLong(colNames[COL_FILE_ID]));
            file.setName(rs.getString(colNames[COL_NAME]));
            file.setNotes(rs.getString(colNames[COL_NOTES]));
            file.setRefId(rs.getLong(colNames[COL_REF_ID]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long oid) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FILE + " WHERE " + colNames[COL_FILE_ID] + " = " + oid;

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
            String sql = "SELECT COUNT(" + colNames[COL_FILE_ID] + ") FROM " + DB_FILE;

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
                    File file = (File) list.get(ls);
                    if (oid == file.getOID()) {
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

    public static long getFileByName(String nama) {
        CONResultSet dbrs = null;
        long oid = 0;
        File file = new File();

        try {
            String sql = "SELECT * FROM " + DB_FILE + " WHERE " + colNames[COL_NAME] + " LIKE '" + nama + "'";
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                resultToObject(rs, file);
            }

            oid = file.getOID();
            rs.close();
        } catch(Exception e) {
            System.out.println(e.toString());
        }

        return oid;
    }

    private static String getNode(String sTag, Element eElement) {
        try {
            NodeList nlList = eElement.getElementsByTagName(sTag).item(0).getChildNodes();
            Node nValue = (Node) nlList.item(0);
            return nValue.getNodeValue();
        } catch(Exception e) {
            return "";
        }
    }

    public static String XML2DB(InputStream is)
            throws IOException, ParserConfigurationException, SAXException,
            TransformerConfigurationException, TransformerException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();

        // Extract XML
        Document docReq = dBuilder.parse(is);
        docReq.getDocumentElement().normalize();
        NodeList nList = docReq.getElementsByTagName("file");

        // Generate XML response
        boolean isResponse = false;
        Document docRes = dBuilder.newDocument();
        Element rootElement = docRes.createElement("ifish");
        docRes.appendChild(rootElement);

        for (int temp = 0; temp < nList.getLength(); temp++) {
            Node nNode = nList.item(temp);
            if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                Element element = (Element) nNode;
                try {
                    File file = new File();
                    file.setOID(Long.parseLong(getNode("oid", element)));
                    file.setName(getNode("name", element));
                    file.setNotes(getNode("notes", element));
                    file.setRefId(Long.parseLong(getNode("refid", element)));

                    boolean isSaved = false;
                    if(isHasData(file.getOID())) { // Update
                        System.out.println(file.getOID() + " update");
                        updateExc(file);
                        isSaved = true;
                    } else { // Insert
                        String sql = "insert into "
                                + DB_FILE + "(" + colNames[COL_FILE_ID] + ", " + colNames[COL_NAME]
                                + ", " + colNames[COL_NOTES] + ", " + colNames[COL_REF_ID]
                                + ") values ("
                                + file.getOID() + ", '" + file.getName() + "', '" + file.getNotes() + "', " + file.getRefId() + ")";
                        try {
                            CONHandler.execUpdate(sql);
                            isSaved = true;
                        } catch(Exception e) {
                            System.out.println("[" + new Date() + "] " + e.toString());
                        }
                    }

                    // Generate XML response
                    Element eStatus = docRes.createElement("filestatus");
                    rootElement.appendChild(eStatus);

                    Element eStatus2 = docRes.createElement("oid");
                    eStatus2.appendChild(docRes.createTextNode(String.valueOf(file.getOID())));
                    eStatus.appendChild(eStatus2);

                    eStatus2 = docRes.createElement("status");
                    eStatus2.appendChild(docRes.createTextNode(isSaved?"1":"0"));
                    eStatus.appendChild(eStatus2);
                    isResponse = true;
                    // End
                } catch (Exception e) {
                    System.out.println(e.toString());
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
        return (isResponse?writer.toString():"No data to be proceed.");
    }
    
}
