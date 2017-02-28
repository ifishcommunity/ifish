package com.project.ifish.master;

import com.project.IFishConfig;
import com.project.main.db.CONException;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.main.db.I_CONInterface;
import com.project.main.db.I_CONType;
import com.project.main.entity.Entity;
import com.project.main.entity.I_PersintentExc;
import com.project.general.DbSystemProperty;
import com.project.util.lang.I_Language;
import java.sql.ResultSet;
import java.io.File;
import java.util.Hashtable;
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
public class DbFish extends CONHandler implements I_CONInterface, I_CONType, I_PersintentExc, I_Language {

    public static final String DB_FISH = "ifish_fish";
    public static final int COL_FISH_OID = 0;
    public static final int COL_FISH_PHYLUM = 1;
    public static final int COL_FISH_CLASS = 2;
    public static final int COL_FISH_ORDER = 3;
    public static final int COL_FISH_FAMILY = 4;
    public static final int COL_FISH_GENUS = 5;
    public static final int COL_FISH_SPECIES = 6;
    public static final int COL_DEFAULT_PICTURE_ID = 7;
    public static final int COL_ENGLISH_NAME = 8;
    public static final int COL_HAWAIIAN_NAME = 9;
    public static final int COL_MARKET_FISHES_OF_INDONESIA = 10;
    public static final int COL_OTHER_INDONESIAN_NAMES = 11;
    public static final int COL_FISH_CODE = 12;
    public static final int COL_COUNTER = 13;
    public static final int COL_LMAT = 14;
    public static final int COL_LOPT = 15;
    public static final int COL_LINF = 16;
    public static final int COL_LMAX = 17;
    public static final int COL_LMATM = 18;
    public static final int COL_PREFIX_CODE = 19;
    public static final int COL_IS_FAMILY_ID = 20;
    public static final int COL_INSITE_CODE = 21;
    public static final int COL_FISH_ID = 22;
    public static final int COL_REPORTED_TRADE_LIMIT_WEIGHT = 23;
    public static final int COL_VAR_A = 24;
    public static final int COL_VAR_B = 25;
    public static final int COL_LENGTH_BASIS = 26;
    public static final int COL_CONVERTED_TRADE_LIMIT_L = 27;
    public static final int COL_PLOTTED_TRADE_LIMIT_TL = 28;
    public static final int COL_CONVERSION_FACTOR_TL2FL = 29;
    public static final int COL_LARGEST_SPECIMEN_ID = 30;
    public static final int COL_LARGEST_SPECIMEN_CM = 31;
    public static final int COL_LARGEST_SPECIMEN_PICTURE = 32;
    public static final int COL_LARGEST_SPECIMEN_CATCH_AREA = 33;

    public static final String[] colNames = {
        "oid",
        "fish_phylum",
        "fish_class",
        "fish_order",
        "fish_family",
        "fish_genus",
        "fish_species",
        "default_picture_id",
        "english_name",
        "hawaiian_name",
        "market_fishes_of_indonesia",
        "other_indonesian_names",
        "fish_code",
        "counter",
        "lmat",
        "lopt",
        "linf",
        "lmax",
        "lmatm",
        "prefix_code",
        "is_family_id",
        "insite_code",
        "fish_id",
        "reported_trade_limit_weight",
        "var_a",
        "var_b",
        "length_basis",
        "converted_trade_limit_l",
        "plotted_trade_limit_tl",
        "conversion_factor_tl2fl",
        "largest_specimen_id",
        "largest_specimen_cm",
        "largest_specimen_picture",
        "largest_specimen_catch_area"
    };
    public static final int[] colTypes = {
        TYPE_LONG + TYPE_PK + TYPE_ID,
        TYPE_STRING,
        TYPE_STRING,
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
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_STRING,
        TYPE_INT,
        TYPE_FLOAT5,
        TYPE_FLOAT5,
        TYPE_FLOAT5,
        TYPE_STRING,
        TYPE_FLOAT5,
        TYPE_FLOAT5,
        TYPE_FLOAT5,
        TYPE_LONG,
        TYPE_FLOAT,
        TYPE_LONG,
        TYPE_STRING
    };
    public static String PREFIX_CODE_FAMILY = "FC";

    public DbFish() {
    }

    public DbFish(int i) throws CONException {
        super(new DbFish());
    }

    public DbFish(String sOid) throws CONException {
        super(new DbFish(0));
        if (!locate(sOid)) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        } else {
            return;
        }
    }

    public DbFish(long lOid) throws CONException {
        super(new DbFish(0));
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
        return DB_FISH;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int[] getFieldTypes() {
        return colTypes;
    }

    public String getPersistentName() {
        return new DbFish().getClass().getName();
    }

    public long fetchExc(Entity ent) throws Exception {
        Fish fish = fetchExc(ent.getOID());
        ent = (Entity) fish;
        return fish.getOID();
    }

    public long insertExc(Entity ent) throws Exception {
        return insertExc((Fish) ent);
    }

    public long updateExc(Entity ent) throws Exception {
        return updateExc((Fish) ent);
    }

    public long deleteExc(Entity ent) throws Exception {
        if (ent == null) {
            throw new CONException(this, CONException.RECORD_NOT_FOUND);
        }
        return deleteExc(ent.getOID());
    }

    public static Fish fetchExc(long oid) throws CONException {
        try {
            Fish fish = new Fish();
            DbFish dbFish = new DbFish(oid);
            fish.setOID(oid);
            fish.setFishPhylum(dbFish.getString(COL_FISH_PHYLUM));
            fish.setFishClass(dbFish.getString(COL_FISH_CLASS));
            fish.setFishOrder(dbFish.getString(COL_FISH_ORDER));
            fish.setFishFamily(dbFish.getString(COL_FISH_FAMILY));
            fish.setFishGenus(dbFish.getString(COL_FISH_GENUS));
            fish.setFishSpecies(dbFish.getString(COL_FISH_SPECIES));
            fish.setDefaultPictureId(dbFish.getlong(COL_DEFAULT_PICTURE_ID));
            fish.setEnglishName(dbFish.getString(COL_ENGLISH_NAME));
            fish.setHawaiianName(dbFish.getString(COL_HAWAIIAN_NAME));
            fish.setMarketFishesOfIndonesia(dbFish.getString(COL_MARKET_FISHES_OF_INDONESIA));
            fish.setOtherIndonesianNames(dbFish.getString(COL_OTHER_INDONESIAN_NAMES));
            fish.setFishCode(dbFish.getString(COL_FISH_CODE));
            fish.setCounter(dbFish.getInt(COL_COUNTER));
            fish.setLmat(dbFish.getInt(COL_LMAT));
            fish.setLopt(dbFish.getInt(COL_LOPT));
            fish.setLinf(dbFish.getInt(COL_LINF));
            fish.setLmax(dbFish.getInt(COL_LMAX));
            fish.setLmatM(dbFish.getInt(COL_LMATM));
            fish.setPrefixCode(dbFish.getString(COL_PREFIX_CODE));
            fish.setFamilyID(dbFish.getInt(COL_IS_FAMILY_ID));
            fish.setInsiteCode(dbFish.getString(COL_INSITE_CODE));
            fish.setFishID(dbFish.getInt(COL_FISH_ID));
            fish.setReportedTradeLimitWeight(dbFish.getdouble(COL_REPORTED_TRADE_LIMIT_WEIGHT));
            fish.setVarA(dbFish.getdouble(COL_VAR_A));
            fish.setVarB(dbFish.getdouble(COL_VAR_B));
            fish.setLengthBasis(dbFish.getString(COL_LENGTH_BASIS));
            fish.setConvertedTradeLimitL(dbFish.getdouble(COL_CONVERTED_TRADE_LIMIT_L));
            fish.setPlottedTradeLimitTL(dbFish.getdouble(COL_PLOTTED_TRADE_LIMIT_TL));
            fish.setConversionFactorTL2FL(dbFish.getdouble(COL_CONVERSION_FACTOR_TL2FL));
            fish.setLargestSpecimenId(dbFish.getlong(COL_LARGEST_SPECIMEN_ID));
            fish.setLargestSpecimenCm(dbFish.getdouble(COL_LARGEST_SPECIMEN_CM));
            fish.setLargestSpecimenPicture(dbFish.getlong(COL_LARGEST_SPECIMEN_PICTURE));
            fish.setLargestSpecimenCatchArea(dbFish.getString(COL_LARGEST_SPECIMEN_CATCH_AREA));
            return fish;
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFish(0), CONException.UNKNOWN);
        }
    }

    public static long insertExc(Fish fish) throws CONException {
        try {
            DbFish dbFish = new DbFish(0);
            dbFish.setString(COL_FISH_PHYLUM, fish.getFishPhylum());
            dbFish.setString(COL_FISH_CLASS, fish.getFishClass());
            dbFish.setString(COL_FISH_ORDER, fish.getFishOrder());
            dbFish.setString(COL_FISH_FAMILY, fish.getFishFamily());
            dbFish.setString(COL_FISH_GENUS, fish.getFishGenus());
            dbFish.setString(COL_FISH_SPECIES, fish.getFishSpecies());
            dbFish.setLong(COL_DEFAULT_PICTURE_ID, fish.getDefaultPictureId());
            dbFish.setString(COL_ENGLISH_NAME, fish.getEnglishName());
            dbFish.setString(COL_HAWAIIAN_NAME, fish.getHawaiianName());
            dbFish.setString(COL_MARKET_FISHES_OF_INDONESIA, fish.getMarketFishesOfIndonesia());
            dbFish.setString(COL_OTHER_INDONESIAN_NAMES, fish.getOtherIndonesianNames());
            dbFish.setString(COL_FISH_CODE, fish.getFishCode());
            dbFish.setInt(COL_COUNTER, fish.getCounter());
            dbFish.setInt(COL_LMAT, fish.getLmat());
            dbFish.setInt(COL_LOPT, fish.getLopt());
            dbFish.setInt(COL_LINF, fish.getLinf());
            dbFish.setInt(COL_LMAX, fish.getLmax());
            dbFish.setInt(COL_LMATM, fish.getLmatM());
            dbFish.setString(COL_PREFIX_CODE, fish.getPrefixCode());
            dbFish.setInt(COL_IS_FAMILY_ID, fish.isFamilyID());
            dbFish.setString(COL_INSITE_CODE, fish.getInsiteCode());
            dbFish.setInt(COL_FISH_ID, fish.getFishID());
            dbFish.setDouble(COL_REPORTED_TRADE_LIMIT_WEIGHT, fish.getReportedTradeLimitWeight());
            dbFish.setDouble(COL_VAR_A, fish.getVarA());
            dbFish.setDouble(COL_VAR_B, fish.getVarB());
            dbFish.setString(COL_LENGTH_BASIS, fish.getLengthBasis());
            dbFish.setDouble(COL_CONVERTED_TRADE_LIMIT_L, fish.getConvertedTradeLimitL());
            dbFish.setDouble(COL_PLOTTED_TRADE_LIMIT_TL, fish.getPlottedTradeLimitTL());
            dbFish.setDouble(COL_CONVERSION_FACTOR_TL2FL, fish.getConversionFactorTL2FL());
            dbFish.setLong(COL_LARGEST_SPECIMEN_ID, fish.getLargestSpecimenId());
            dbFish.setDouble(COL_LARGEST_SPECIMEN_CM, fish.getLargestSpecimenCm());
            dbFish.setLong(COL_LARGEST_SPECIMEN_PICTURE, fish.getLargestSpecimenPicture());
            dbFish.setString(COL_LARGEST_SPECIMEN_CATCH_AREA, fish.getLargestSpecimenCatchArea());
            dbFish.insert();
            fish.setOID(dbFish.getlong(COL_FISH_OID));
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFish(0), CONException.UNKNOWN);
        }
        return fish.getOID();
    }

    public static long updateExc(Fish fish) throws CONException {
        try {
            if (fish.getOID() != 0) {
                DbFish dbFish = new DbFish(fish.getOID());
                dbFish.setString(COL_FISH_PHYLUM, fish.getFishPhylum());
                dbFish.setString(COL_FISH_CLASS, fish.getFishClass());
                dbFish.setString(COL_FISH_ORDER, fish.getFishOrder());
                dbFish.setString(COL_FISH_FAMILY, fish.getFishFamily());
                dbFish.setString(COL_FISH_GENUS, fish.getFishGenus());
                dbFish.setString(COL_FISH_SPECIES, fish.getFishSpecies());
                dbFish.setLong(COL_DEFAULT_PICTURE_ID, fish.getDefaultPictureId());
                dbFish.setString(COL_ENGLISH_NAME, fish.getEnglishName());
                dbFish.setString(COL_HAWAIIAN_NAME, fish.getHawaiianName());
                dbFish.setString(COL_MARKET_FISHES_OF_INDONESIA, fish.getMarketFishesOfIndonesia());
                dbFish.setString(COL_OTHER_INDONESIAN_NAMES, fish.getOtherIndonesianNames());
                dbFish.setString(COL_FISH_CODE, fish.getFishCode());
                dbFish.setInt(COL_COUNTER, fish.getCounter());
                dbFish.setInt(COL_LMAT, fish.getLmat());
                dbFish.setInt(COL_LOPT, fish.getLopt());
                dbFish.setInt(COL_LINF, fish.getLinf());
                dbFish.setInt(COL_LMAX, fish.getLmax());
                dbFish.setInt(COL_LMATM, fish.getLmatM());
                dbFish.setString(COL_PREFIX_CODE, fish.getPrefixCode());
                dbFish.setInt(COL_IS_FAMILY_ID, fish.isFamilyID());
                dbFish.setString(COL_INSITE_CODE, fish.getInsiteCode());
                dbFish.setInt(COL_FISH_ID, fish.getFishID());
                dbFish.setDouble(COL_REPORTED_TRADE_LIMIT_WEIGHT, fish.getReportedTradeLimitWeight());
                dbFish.setDouble(COL_VAR_A, fish.getVarA());
                dbFish.setDouble(COL_VAR_B, fish.getVarB());
                dbFish.setString(COL_LENGTH_BASIS, fish.getLengthBasis());
                dbFish.setDouble(COL_CONVERTED_TRADE_LIMIT_L, fish.getConvertedTradeLimitL());
                dbFish.setDouble(COL_PLOTTED_TRADE_LIMIT_TL, fish.getPlottedTradeLimitTL());
                dbFish.setDouble(COL_CONVERSION_FACTOR_TL2FL, fish.getConversionFactorTL2FL());
                dbFish.setLong(COL_LARGEST_SPECIMEN_ID, fish.getLargestSpecimenId());
                dbFish.setDouble(COL_LARGEST_SPECIMEN_CM, fish.getLargestSpecimenCm());
                dbFish.setLong(COL_LARGEST_SPECIMEN_PICTURE, fish.getLargestSpecimenPicture());
                dbFish.setString(COL_LARGEST_SPECIMEN_CATCH_AREA, fish.getLargestSpecimenCatchArea());
                dbFish.update();
                return fish.getOID();
            }
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFish(0), CONException.UNKNOWN);
        }
        return 0;
    }

    public static long deleteExc(long oid) throws CONException {
        try {
            DbFish dbFish = new DbFish(oid);
            dbFish.delete();
        } catch (CONException dbe) {
            throw dbe;
        } catch (Exception e) {
            throw new CONException(new DbFish(0), CONException.UNKNOWN);
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
            String sql = "SELECT * FROM " + DB_FISH;
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
                Fish fish = new Fish();
                resultToObject(rs, fish);
                lists.add(fish);
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

    private static void resultToObject(ResultSet rs, Fish fish) {
        try {
            fish.setOID(rs.getLong(colNames[COL_FISH_OID]));
            fish.setFishPhylum(rs.getString(colNames[COL_FISH_PHYLUM]));
            fish.setFishClass(rs.getString(colNames[COL_FISH_CLASS]));
            fish.setFishOrder(rs.getString(colNames[COL_FISH_ORDER]));
            fish.setFishFamily(rs.getString(colNames[COL_FISH_FAMILY]));
            fish.setFishGenus(rs.getString(colNames[COL_FISH_GENUS]));
            fish.setFishSpecies(rs.getString(colNames[COL_FISH_SPECIES]));
            fish.setDefaultPictureId(rs.getLong(colNames[COL_DEFAULT_PICTURE_ID]));
            fish.setEnglishName(rs.getString(colNames[COL_ENGLISH_NAME]));
            fish.setHawaiianName(rs.getString(colNames[COL_HAWAIIAN_NAME]));
            fish.setMarketFishesOfIndonesia(rs.getString(colNames[COL_MARKET_FISHES_OF_INDONESIA]));
            fish.setOtherIndonesianNames(rs.getString(colNames[COL_OTHER_INDONESIAN_NAMES]));
            fish.setFishCode(rs.getString(colNames[COL_FISH_CODE]));
            fish.setCounter(rs.getInt(colNames[COL_COUNTER]));
            fish.setLmat(rs.getInt(colNames[COL_LMAT]));
            fish.setLopt(rs.getInt(colNames[COL_LOPT]));
            fish.setLinf(rs.getInt(colNames[COL_LINF]));
            fish.setLmax(rs.getInt(colNames[COL_LMAX]));
            fish.setLmatM(rs.getInt(colNames[COL_LMATM]));
            fish.setPrefixCode(rs.getString(colNames[COL_PREFIX_CODE]));
            fish.setFamilyID(rs.getInt(colNames[COL_IS_FAMILY_ID]));
            fish.setInsiteCode(rs.getString(colNames[COL_INSITE_CODE]));
            fish.setFishID(rs.getInt(colNames[COL_FISH_ID]));
            fish.setReportedTradeLimitWeight(rs.getDouble(colNames[COL_REPORTED_TRADE_LIMIT_WEIGHT]));
            fish.setVarA(rs.getDouble(colNames[COL_VAR_A]));
            fish.setVarB(rs.getDouble(colNames[COL_VAR_B]));
            fish.setLengthBasis(rs.getString(colNames[COL_LENGTH_BASIS]));
            fish.setConvertedTradeLimitL(rs.getDouble(colNames[COL_CONVERTED_TRADE_LIMIT_L]));
            fish.setPlottedTradeLimitTL(rs.getDouble(colNames[COL_PLOTTED_TRADE_LIMIT_TL]));
            fish.setConversionFactorTL2FL(rs.getDouble(colNames[COL_CONVERSION_FACTOR_TL2FL]));
            fish.setLargestSpecimenId(rs.getLong(colNames[COL_LARGEST_SPECIMEN_ID]));
            fish.setLargestSpecimenCm(rs.getDouble(colNames[COL_LARGEST_SPECIMEN_CM]));
            fish.setLargestSpecimenPicture(rs.getLong(colNames[COL_LARGEST_SPECIMEN_PICTURE]));
            fish.setLargestSpecimenCatchArea(rs.getString(colNames[COL_LARGEST_SPECIMEN_CATCH_AREA]));
        } catch (Exception e) {
        }
    }

    public static boolean checkOID(long oid) {
        CONResultSet dbrs = null;
        boolean result = false;
        try {
            String sql = "SELECT * FROM " + DB_FISH + " WHERE " + colNames[COL_FISH_OID] + " = " + oid;

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
            String sql = "SELECT COUNT(" + colNames[COL_FISH_OID] + ") FROM " + DB_FISH;

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
                    Fish fish = (Fish) list.get(ls);
                    if (oid == fish.getOID()) {
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

    public static int getMax(String whereClause) {
        CONResultSet dbrs = null;

        try {
            String sql = "SELECT MAX(" + colNames[COL_COUNTER] + ") FROM " + DB_FISH;

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

    public static void fishCodeGenerator(Fish fish) {
        String fishCode = "";
        try {
            String prefixCode = "";
            if (fish.isFamilyID() == 1) { // get fish code for family id
                prefixCode = PREFIX_CODE_FAMILY;
            } else {
                String strFamily = fish.getFishFamily().substring(0, 1);
                String strGenus = fish.getFishGenus().substring(0, 1);
                prefixCode = strFamily.toUpperCase() + strGenus.toUpperCase();
            }
            
            String where = colNames[COL_PREFIX_CODE] + " like '" + prefixCode + "'";
            int counter = getMax(where) + 1;
            if (counter < 10) {
                fishCode = prefixCode + "00" + String.valueOf(counter);
            } else if (counter >= 10 && counter < 100) {
                fishCode = prefixCode + "0" + String.valueOf(counter);
            } else {
                fishCode = prefixCode + String.valueOf(counter);
            }
            fish.setFishCode(fishCode);
            fish.setPrefixCode(prefixCode);
            fish.setCounter(counter);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static long getFishIdByFamily(String family) {
        long oid = 0;
        try {
            if (family.length() > 0) {
                String where = colNames[COL_IS_FAMILY_ID] + " = 1 and " + colNames[COL_FISH_FAMILY] + " ilike '" + family + "'";
                Vector list = list(0, 0, where, "");
                
                if (list != null && list.size() > 0) {
                    for (int i = 0; i < list.size(); i++) {
                        Fish fish = (Fish) list.get(i);
                        oid = fish.getOID();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    public static long getFishId(String genus, String species) {
        long oid = 0;
        try {
            String where = "";
            if (genus.length() > 0) {
                where = colNames[COL_FISH_GENUS] + " ilike '" + genus + "'";
            }

            if (species.length() > 0) {
                if (where.length() > 0) {
                    where += " and " + colNames[COL_FISH_SPECIES] + " ilike '" + species + "'";
                } else {
                    where = colNames[COL_FISH_SPECIES] + " ilike '" + species + "'";
                }
            }

            Vector list = list(0, 0, where, "");
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Fish fish = (Fish) list.get(i);
                    oid = fish.getOID();
                }
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return oid;
    }

    public static long getFishId(String code) {
        long oid = 0;
        try {
            String where = colNames[COL_FISH_CODE] + " ilike '" + code + "'";
            Vector list = list(0, 0, where, "");
            if (list != null && list.size() > 0) {
                for (int i = 0; i < list.size(); i++) {
                    Fish fish = (Fish) list.get(i);
                    oid = fish.getOID();
                }
            }
        } catch (Exception e) {
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

            Vector listFish = DbFish.list(0, 0, "", "");
            if (listFish != null && listFish.size() > 0) {
                for (int i = 0; i < listFish.size(); i++) {
                    Fish fish = (Fish) listFish.get(i);
                    Element eFish = doc.createElement("fish");
                    rootElement.appendChild(eFish);

                    Element eData = doc.createElement("oid");
                    eData.appendChild(doc.createTextNode(String.valueOf(fish.getOID())));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishphylum");
                    eData.appendChild(doc.createTextNode(fish.getFishPhylum()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishclass");
                    eData.appendChild(doc.createTextNode(fish.getFishClass()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishorder");
                    eData.appendChild(doc.createTextNode(fish.getFishOrder()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishfamily");
                    eData.appendChild(doc.createTextNode(fish.getFishFamily()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishgenus");
                    eData.appendChild(doc.createTextNode(fish.getFishGenus()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishspecies");
                    eData.appendChild(doc.createTextNode(fish.getFishSpecies()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("englishname");
                    eData.appendChild(doc.createTextNode(fish.getEnglishName()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("hawaiianname");
                    eData.appendChild(doc.createTextNode(fish.getHawaiianName()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("marketfishesofindonesia");
                    eData.appendChild(doc.createTextNode(fish.getMarketFishesOfIndonesia()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("otherindonesiannames");
                    eData.appendChild(doc.createTextNode(fish.getOtherIndonesianNames()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("isfamilyid");
                    eData.appendChild(doc.createTextNode(String.valueOf(fish.isFamilyID())));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishid");
                    eData.appendChild(doc.createTextNode(String.valueOf(fish.getFishID())));
                    eFish.appendChild(eData);

                    eData = doc.createElement("fishcode");
                    eData.appendChild(doc.createTextNode(fish.getFishCode()));
                    eFish.appendChild(eData);

                    eData = doc.createElement("insitecode");
                    eData.appendChild(doc.createTextNode(fish.getInsiteCode()));
                    eFish.appendChild(eData);
                }
            }

            // write the content into xml file
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            DOMSource source = new DOMSource(doc);
            String APP_PATH = DbSystemProperty.getValueByName("APP_PATH");
            StreamResult result = new StreamResult(new File(APP_PATH + IFishConfig.API_PATH + System.getProperty("file.separator") + IFishConfig.nodeNames[IFishConfig.NODE_FISH] + ".xml"));
            transformer.transform(source, result);
            System.out.println("File saved!");
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static Hashtable getTop100Species() {
        Hashtable hTop100Species = new Hashtable();
        Vector list = list(0, 0, colNames[COL_FISH_ID]+">0", colNames[COL_FISH_ID]);
        if(list != null && list.size() > 0) {
            for(int i = 0; i < list.size(); i++) {
                Fish fish = (Fish) list.get(i);
                hTop100Species.put(fish.getOID(), fish);
            }
        }
        return hTop100Species;
    }
}
