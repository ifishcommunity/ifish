package com.project.ifish.master;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class JspFish extends JSPHandler implements I_JSPInterface, I_JSPType {

    private Fish fish;
    public static final String JSP_NAME_FISH = "JSP_NAME_FISH";
    public static final int JSP_FISH_OID = 0;
    public static final int JSP_FISH_PHYLUM = 1;
    public static final int JSP_FISH_CLASS = 2;
    public static final int JSP_FISH_ORDER = 3;
    public static final int JSP_FISH_FAMILY = 4;
    public static final int JSP_FISH_GENUS = 5;
    public static final int JSP_FISH_SPECIES = 6;
    public static final int JSP_DEFAULT_PICTURE_ID = 7;
    public static final int JSP_ENGLISH_NAME = 8;
    public static final int JSP_HAWAIIAN_NAME = 9;
    public static final int JSP_MARKET_FISHES_OF_INDONESIA = 10;
    public static final int JSP_OTHER_INDONESIAN_NAMES = 11;
    public static final int JSP_FISH_CODE = 12;
    public static final int JSP_LMAT = 13;
    public static final int JSP_LOPT = 14;
    public static final int JSP_LINF = 15;
    public static final int JSP_LMAX = 16;
    public static final int JSP_LMATM = 17;
    public static final int JSP_IS_FAMILY_ID = 18;
    public static final int JSP_FISH_ID = 19;
    public static final int JSP_REPORTED_TRADE_LIMIT_WEIGHT = 20;
    public static final int JSP_VAR_A = 21;
    public static final int JSP_VAR_B = 22;
    public static final int JSP_LENGTH_BASIS = 23;
    public static final int JSP_CONVERTED_TRADE_LIMIT_L = 24;
    public static final int JSP_PLOTTED_TRADE_LIMIT_TL = 25;
    public static final int JSP_CONVERSION_FACTOR_TL2FL = 26;
    public static final int JSP_LARGEST_SPECIMEN_CATCH_AREA = 27;
    public static String[] fieldNames = {
        "JSP_FISH_OID",
        "JSP_FISH_PHYLUM",
        "JSP_FISH_CLASS",
        "JSP_FISH_ORDER",
        "JSP_FISH_FAMILY",
        "JSP_FISH_GENUS",
        "JSP_FISH_SPECIES",
        "JSP_DEFAULT_PICTURE_ID",
        "JSP_ENGLISH_NAME",
        "JSP_HAWAIIAN_NAME",
        "JSP_MARKET_FISHES_OF_INDONESIA",
        "JSP_OTHER_INDONESIAN_NAMES",
        "JSP_FISH_CODE",
        "JSP_LMAT",
        "JSP_OPT",
        "JSP_LINF",
        "JSP_LMAX",
        "JSP_LMATM",
        "JSP_IS_FAMILY_ID",
        "JSP_FISH_ID",
        "JSP_REPORTED_TRADE_LIMIT_WEIGHT",
        "JSP_VAR_A",
        "JSP_VAR_B",
        "JSP_LENGTH_BASIS",
        "JSP_CONVERTED_TRADE_LIMIT_L",
        "JSP_PLOTTED_TRADE_LIMIT_TL",
        "JSP_CONVERSION_FACTOR_TL2FL",
        "JSP_LARGEST_SPECIMEN_CATCH_AREA"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
        TYPE_STRING + ENTRY_REQUIRED,
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
        TYPE_INT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_FLOAT,
        TYPE_STRING
    };

    public JspFish() {
    }

    public JspFish(Fish fish) {
        this.fish = fish;
    }

    public JspFish(HttpServletRequest request, Fish fish) {
        super(new JspFish(fish), request);
        this.fish = fish;
    }

    public String getFormName() {
        return JSP_NAME_FISH;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return fieldNames;
    }

    public int getFieldSize() {
        return fieldNames.length;
    }

    public Fish getEntityObject() {
        return fish;
    }

    public void requestEntityObject(Fish fish) {
        try {
            this.requestParam();
            fish.setFishPhylum(getString(JSP_FISH_PHYLUM));
            fish.setFishClass(getString(JSP_FISH_CLASS));
            fish.setFishOrder(getString(JSP_FISH_ORDER));
            fish.setFishFamily(getString(JSP_FISH_FAMILY));
            fish.setFishGenus(getString(JSP_FISH_GENUS));
            fish.setFishSpecies(getString(JSP_FISH_SPECIES));
            fish.setDefaultPictureId(getLong(JSP_DEFAULT_PICTURE_ID));
            fish.setEnglishName(getString(JSP_ENGLISH_NAME));
            fish.setHawaiianName(getString(JSP_HAWAIIAN_NAME));
            fish.setMarketFishesOfIndonesia(getString(JSP_MARKET_FISHES_OF_INDONESIA));
            fish.setOtherIndonesianNames(getString(JSP_OTHER_INDONESIAN_NAMES));
            fish.setFishCode(getString(JSP_FISH_CODE));
            fish.setLmat(getInt(JSP_LMAT));
            fish.setLopt(getInt(JSP_LOPT));
            fish.setLinf(getInt(JSP_LINF));
            fish.setLmax(getInt(JSP_LMAX));
            fish.setLmatM(getInt(JSP_LMATM));
            fish.setFamilyID(getInt(JSP_IS_FAMILY_ID));
            fish.setFishID(getInt(JSP_FISH_ID));
            fish.setReportedTradeLimitWeight(getDouble(JSP_REPORTED_TRADE_LIMIT_WEIGHT));
            fish.setVarA(getDouble(JSP_VAR_A));
            fish.setVarB(getDouble(JSP_VAR_B));
            fish.setLengthBasis(getString(JSP_LENGTH_BASIS));
            fish.setPlottedTradeLimitTL(getDouble(JSP_CONVERTED_TRADE_LIMIT_L));
            fish.setPlottedTradeLimitTL(getDouble(JSP_PLOTTED_TRADE_LIMIT_TL));
            fish.setConversionFactorTL2FL(getDouble(JSP_CONVERSION_FACTOR_TL2FL));
            fish.setLargestSpecimenCatchArea(getString(JSP_LARGEST_SPECIMEN_CATCH_AREA));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }

}
