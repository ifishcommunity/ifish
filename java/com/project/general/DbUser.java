package com.project.general;

import com.project.IFishConfig;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_Persintent;
import com.project.util.JSPFormater;
import com.project.util.MD5;
import java.sql.ResultSet;
import java.util.Date;
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

public class DbUser extends CONHandler implements I_CONInterface, I_CONType, I_Persintent {

    public static final String DB_USER = "gen_user";
    public static final int COL_USER_ID = 0;
    public static final int COL_LOGIN_ID = 1;
    public static final int COL_PASSWORD = 2;
    public static final int COL_FULL_NAME = 3;
    public static final int COL_EMAIL = 4;
    public static final int COL_DESCRIPTION = 5;
    public static final int COL_REG_DATE = 6;
    public static final int COL_UPDATE_DATE = 7;
    public static final int COL_LOGIN_STATUS = 8;
    public static final int COL_LAST_LOGIN_DATE = 9;
    public static final int COL_LAST_LOGIN_IP = 10;
    public static final int COL_RESET_PASSWORD = 11;
    public static final int COL_PARTNER_ID = 12;
    public static final int COL_GROUP_ID = 13;
    public static final int COL_STATUS = 14;
    public static final int COL_UALD = 15;

    public static final String[] colNames = {
        "user_id",
        "login_id",
        "password",
        "full_name",
        "email",
        "description",
        "reg_date",
        "update_date",
        "login_status",
        "last_login_date",
        "last_login_ip",
        "reset_password",
        "partner_id",
        "group_id",
        "status",
        "uald"
    };
    public static  int   [] fieldTypes = {
        TYPE_PK + TYPE_LONG + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_STRING,
        TYPE_DATE,
        TYPE_DATE,
        TYPE_INT,
        TYPE_DATE,
        TYPE_STRING,
        TYPE_BOOL,
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT
    };

    /** Creates new DbUser */
    public DbUser() {
    }

    public DbUser(int i) throws CONException {
        super(new DbUser());
    }

    public DbUser(String sOid) throws CONException {
        super(new DbUser(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbUser(long lOid) throws CONException {
        super(new DbUser(0));
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
        return DB_USER;
    }

    public String getPersistentName() {
        return new DbUser().getClass().getName();
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public long delete(Entity ent) {
        return delete((User) ent);
    }

    public long insert(Entity ent) {
        try {
            return DbUser.insert((User) ent);
        } catch (Exception e) {
            System.out.println(" exception " + e);
            return 0;
        }
    }

    public long update(Entity ent) {
        return update((User) ent);
    }

    public long fetch(Entity ent) {
        User user = DbUser.fetch(ent.getOID());
        ent = (Entity) user;
        return ent.getOID();
    }

    public static User fetch(long oid) {
        User user = new User();
        try {
            DbUser dbUser = new DbUser(oid);
            user.setOID(oid);
            user.setLoginId(dbUser.getString(COL_LOGIN_ID));
            user.setPassword(dbUser.getString(COL_PASSWORD));
            user.setFullName(dbUser.getString(COL_FULL_NAME));
            user.setEmail(dbUser.getString(COL_EMAIL));
            user.setDescription(dbUser.getString(COL_DESCRIPTION));
            user.setRegDate(dbUser.getDate(COL_REG_DATE));
            user.setUpdateDate(dbUser.getDate(COL_UPDATE_DATE));
            user.setLoginStatus(dbUser.getInt(COL_LOGIN_STATUS));
            user.setLastLoginDate(dbUser.getDate(COL_LAST_LOGIN_DATE));
            user.setLastLoginIp(dbUser.getString(COL_LAST_LOGIN_IP));
            user.setResetPassword(dbUser.getboolean(COL_RESET_PASSWORD));
            user.setPartnerId(dbUser.getlong(COL_PARTNER_ID));
            user.setGroupId(dbUser.getlong(COL_GROUP_ID));
            user.setStatus(dbUser.getInt(COL_STATUS));
            user.setUald(dbUser.getInt(COL_UALD));
        } catch (CONException e) {
            System.out.println(e);
        }
        return user;
    }

    public static long insert(User user) throws CONException {
        DbUser dbUser = new DbUser(0);
        dbUser.setString(COL_LOGIN_ID, user.getLoginId());
        dbUser.setString(COL_PASSWORD, user.getPassword());
        dbUser.setString(COL_FULL_NAME, user.getFullName());
        dbUser.setString(COL_EMAIL, user.getEmail());
        dbUser.setString(COL_DESCRIPTION, user.getDescription());
        dbUser.setDate(COL_REG_DATE, new Date());
        dbUser.setDate(COL_UPDATE_DATE, new Date());
        dbUser.setInt(COL_LOGIN_STATUS, user.getLoginStatus());
        dbUser.setDate(COL_LAST_LOGIN_DATE, user.getLastLoginDate());
        dbUser.setString(COL_LAST_LOGIN_IP, user.getLastLoginIp());
        dbUser.setboolean(COL_RESET_PASSWORD, user.isResetPassword());
        dbUser.setLong(COL_PARTNER_ID, user.getPartnerId());
        dbUser.setLong(COL_GROUP_ID, user.getGroupId());
        dbUser.setInt(COL_STATUS, user.getStatus());
        dbUser.setInt(COL_UALD, user.getUald());

        dbUser.insert();
        user.setOID(dbUser.getlong(COL_USER_ID));
        return user.getOID();
    }

    public static long update(User user) {
        if ((user != null) && (user.getOID() != 0)) {
            try {
                DbUser dbUser = new DbUser(user.getOID());

                dbUser.setString(COL_LOGIN_ID, user.getLoginId());
                dbUser.setString(COL_PASSWORD, user.getPassword());
                dbUser.setString(COL_FULL_NAME, user.getFullName());
                dbUser.setString(COL_EMAIL, user.getEmail());
                dbUser.setString(COL_DESCRIPTION, user.getDescription());
                dbUser.setDate(COL_UPDATE_DATE, new Date());
                dbUser.setInt(COL_LOGIN_STATUS, user.getLoginStatus());
                dbUser.setDate(COL_LAST_LOGIN_DATE, user.getLastLoginDate());
                dbUser.setString(COL_LAST_LOGIN_IP, user.getLastLoginIp());
                dbUser.setboolean(COL_RESET_PASSWORD, user.isResetPassword());
                dbUser.setLong(COL_PARTNER_ID, user.getPartnerId());
                dbUser.setLong(COL_GROUP_ID, user.getGroupId());
                dbUser.setInt(COL_STATUS, user.getStatus());
                dbUser.setInt(COL_UALD, user.getUald());

                if ((user.getLoginId() != null && user.getLoginId().length() > 0 && !(user.getLoginId().equalsIgnoreCase("NULL"))) &&
                        (user.getPassword() != null && user.getPassword().length() > 0 && !(user.getPassword().equalsIgnoreCase("NULL")))) {
                    dbUser.update();
                }

                return user.getOID();
            } catch (Exception e) {
                System.out.println(e);
            }
        }
        return 0;
    }

    public static long delete(long oid) {
        try {
            DbUser dbUser = new DbUser(oid);
            dbUser.delete();
            return oid;
        } catch (Exception e) {
            System.out.println(e);
        }
        return 0;
    }

    public static int getCount(String whereClause) {
        CONResultSet dbrs = null;
        try {
            int count = 0;
            String sql = " SELECT COUNT(" + colNames[COL_USER_ID] + ") AS NRCOUNT" +
                    " FROM " + DB_USER;

            if (whereClause != null && whereClause.length() > 0) {
                sql = sql + " WHERE " + whereClause;
            }

            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            while (rs.next()) {
                count = rs.getInt(1);
            }
            return count;
        } catch (Exception exc) {
            System.out.println("getCount " + exc);
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }

    }

    public static void resultToObject(ResultSet rs, User user) {
        try {
            user.setOID(rs.getLong(colNames[COL_USER_ID]));
            user.setLoginId(rs.getString(colNames[COL_LOGIN_ID]));
            user.setPassword(rs.getString(colNames[COL_PASSWORD]));
            user.setFullName(rs.getString(colNames[COL_FULL_NAME]));
            user.setEmail(rs.getString(colNames[COL_EMAIL]));
            user.setDescription(rs.getString(colNames[COL_DESCRIPTION]));
            user.setRegDate(JSPFormater.formatDate(rs.getString(colNames[COL_REG_DATE]), "yyyy-MM-dd HH:mm:ss"));
            user.setUpdateDate(JSPFormater.formatDate(rs.getString(colNames[COL_UPDATE_DATE]), "yyyy-MM-dd HH:mm:ss"));
            user.setLoginStatus(rs.getInt(colNames[COL_LOGIN_STATUS]));
            user.setLastLoginDate(JSPFormater.formatDate(rs.getString(colNames[COL_LAST_LOGIN_DATE]), "yyyy-MM-dd HH:mm:ss"));
            user.setLastLoginIp(rs.getString(colNames[COL_LAST_LOGIN_IP]));
            user.setResetPassword(rs.getBoolean(colNames[COL_RESET_PASSWORD]));
            user.setPartnerId(rs.getLong(colNames[COL_PARTNER_ID]));
            user.setGroupId(rs.getLong(colNames[COL_GROUP_ID]));
            user.setStatus(rs.getInt(colNames[COL_STATUS]));
            user.setUald(rs.getInt(colNames[COL_UALD]));
        } catch (Exception e) {
            System.out.println("[Exception] DbUser.resultToObject() >>" + e.toString());
        }
    }

    public static Vector list(int limitStart, int recordToGet, String whereClause, String order) {
        Vector lists = new Vector();
        CONResultSet dbrs = null;

        try {
            String sql = "select * from " + DB_USER;
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
                User appUser = new User();
                DbUser.resultToObject(rs, appUser);
                lists.add(appUser);
            }
            return lists;

        } catch (Exception e) {
            System.out.println(e);
        } finally {
            CONResultSet.close(dbrs);
        }
        return new Vector();
    }

    public static Vector listAll() {
        return list(0, 0, "", "");
    }

    public static long updateUserStatus(long userOID, int status) {
        if (userOID == 0) {
            return 0;
        }

        CONResultSet dbrs = null;
        try {
            if (userOID != 0) {
                User auser = DbUser.fetch(userOID);
                auser.setLoginStatus(status);

                if ((auser.getLoginId() != null && auser.getLoginId().length() > 0 && !(auser.getLoginId().equalsIgnoreCase("NULL"))) &&
                        (auser.getPassword() != null && auser.getPassword().length() > 0 && !(auser.getPassword().equalsIgnoreCase("NULL")))) {
                    DbUser.update(auser);
                }
            }
            return userOID;

        } catch (Exception e) {
            System.out.println("updateUserStatus " + e);
            return 0;
        } finally {
            CONResultSet.close(dbrs);
        }
    }

    public static User getByLoginIDAndPassword(String loginID, String password) {
        CONResultSet dbrs = null;
        User appUser = new User();

        if ((loginID == null) || (loginID.length() < 1) || (password == null) || (password.length() < 1)) {
            return null;
        }

        try {
            String md5Password = MD5.getMD5Hash(password);
            String sql = "SELECT * FROM " + DB_USER 
                    + " WHERE " + colNames[COL_LOGIN_ID] + " = '" + loginID + "'"
                    + " AND " + colNames[COL_PASSWORD] + " = '" + md5Password + "'"
                    + " AND " + colNames[COL_STATUS] + " = " + IFishConfig.STATUS_ACTIVE;
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();

            while (rs.next()) {
                DbUser.resultToObject(rs, appUser);
            }
        } catch (Exception e) {
            System.out.println("getByLoginIDAndPassword " + e);
        } finally {
            CONResultSet.close(dbrs);
        }

        return appUser;
    }

    public static void generateXML() {
        try {
            DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

            // root elements
            Document doc = docBuilder.newDocument();
            Element rootElement = doc.createElement("ifish");
            doc.appendChild(rootElement);

            Vector listUser = DbUser.list(0, 0, "", "");
            if (listUser != null && listUser.size() > 0) {
                for (int i = 0; i < listUser.size(); i++) {
                    User user = (User) listUser.get(i);
                    Element eUser = doc.createElement("user");
                    rootElement.appendChild(eUser);

                    Element eOid = doc.createElement("oid");
                    eOid.appendChild(doc.createTextNode(String.valueOf(user.getOID())));
                    eUser.appendChild(eOid);

                    Element eLoginId = doc.createElement("loginid");
                    eLoginId.appendChild(doc.createTextNode(user.getLoginId()));
                    eUser.appendChild(eLoginId);

                    Element ePassword = doc.createElement("password");
                    ePassword.appendChild(doc.createTextNode(user.getPassword()));
                    eUser.appendChild(ePassword);

                    Element eFullName = doc.createElement("fullname");
                    eFullName.appendChild(doc.createTextNode(user.getFullName()));
                    eUser.appendChild(eFullName);
                }
            }

            // write the content into xml file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            String APP_PATH = DbSystemProperty.getValueByName("APP_PATH");
            StreamResult result = new StreamResult(new File(APP_PATH + IFishConfig.API_PATH + System.getProperty("file.separator") + IFishConfig.nodeNames[IFishConfig.NODE_USER] + ".xml"));
            transformer.transform(source, result);
            System.out.println("File saved!");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }
}
