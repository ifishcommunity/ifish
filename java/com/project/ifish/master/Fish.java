package com.project.ifish.master;

import com.project.main.entity.Entity;

/**
 *
 * @author gwawan
 */
public class Fish extends Entity {
    private String fishPhylum = "";
    private String fishClass = "";
    private String fishOrder = "";
    private String fishFamily = "";
    private String fishGenus = "";
    private String fishSpecies = "";
    private long defaultPictureId = 0;
    private String englishName = "";
    private String hawaiianName = "";
    private String marketFishesOfIndonesia = "";
    private String otherIndonesianNames = "";
    private String fishCode = "";
    private int counter = 0;
    private int lmat = 0;
    private int lmatM = 0;
    private int lopt = 0;
    private int linf = 0;
    private int lmax = 0;
    private String prefixCode = "";
    private int isFamilyID = 0;
    private String insiteCode = "";
    private int fishID = 0;
    private double reportedTradeLimitWeight = 0;
    private double varA = 0;
    private double varB = 0;
    private String lengthBasis = "";
    private double convertedTradeLimitL = 0;
    private double plottedTradeLimitTL = 0; // Total Length (TL) in cm
    private double conversionFactorTL2FL = 0; //Total Length to Fork Length
    private long largestSpecimenId = 0; // OID ifish_sizing
    private double largestSpecimenCm = 0; // CM
    private long largestSpecimenPicture = 0; // OID gen_file
    private String largestSpecimenCatchArea = "";

    public String getFishPhylum() {
        return fishPhylum;
    }

    public void setFishPhylum(String fishPhylum) {
        this.fishPhylum = fishPhylum;
    }

    public String getFishClass() {
        return fishClass;
    }

    public void setFishClass(String fishClass) {
        this.fishClass = fishClass;
    }

    public String getFishOrder() {
        return fishOrder;
    }

    public void setFishOrder(String fishOrder) {
        this.fishOrder = fishOrder;
    }

    public String getFishFamily() {
        return fishFamily;
    }

    public void setFishFamily(String fishFamily) {
        this.fishFamily = fishFamily;
    }

    public String getFishGenus() {
        return fishGenus;
    }

    public void setFishGenus(String fishGenus) {
        this.fishGenus = fishGenus;
    }

    public String getFishSpecies() {
        return fishSpecies;
    }

    public void setFishSpecies(String fishSpecies) {
        this.fishSpecies = fishSpecies;
    }

    public long getDefaultPictureId() {
        return defaultPictureId;
    }

    public void setDefaultPictureId(long defaultPictureId) {
        this.defaultPictureId = defaultPictureId;
    }

    public String getEnglishName() {
        return englishName;
    }

    public void setEnglishName(String englishName) {
        this.englishName = englishName;
    }

    public String getHawaiianName() {
        return hawaiianName;
    }

    public void setHawaiianName(String hawaiianName) {
        this.hawaiianName = hawaiianName;
    }

    public String getMarketFishesOfIndonesia() {
        return marketFishesOfIndonesia;
    }

    public void setMarketFishesOfIndonesia(String marketFishesOfIndonesia) {
        this.marketFishesOfIndonesia = marketFishesOfIndonesia;
    }

    public String getOtherIndonesianNames() {
        return otherIndonesianNames;
    }

    public void setOtherIndonesianNames(String otherIndonesianNames) {
        this.otherIndonesianNames = otherIndonesianNames;
    }

    public String getFishCode() {
        return fishCode;
    }

    public void setFishCode(String fishCode) {
        this.fishCode = fishCode;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public int getLmat() {
        return lmat;
    }

    public void setLmat(int lmat) {
        this.lmat = lmat;
    }

    public int getLmatM() {
        return lmatM;
    }

    public void setLmatM(int lmatM) {
        this.lmatM = lmatM;
    }

    public int getLopt() {
        return lopt;
    }

    public void setLopt(int lopt) {
        this.lopt = lopt;
    }

    public int getLinf() {
        return linf;
    }

    public void setLinf(int linf) {
        this.linf = linf;
    }

    public int getLmax() {
        return lmax;
    }

    public void setLmax(int lmax) {
        this.lmax = lmax;
    }

    public String getPrefixCode() {
        return prefixCode;
    }

    public void setPrefixCode(String prefixCode) {
        this.prefixCode = prefixCode;
    }

    public int isFamilyID() {
        return isFamilyID;
    }

    public void setFamilyID(int isFamilyID) {
        this.isFamilyID = isFamilyID;
    }

    public String getInsiteCode() {
        if(insiteCode.equals("") || insiteCode == null) {
            return "";
        } else {
            return insiteCode;
        }
    }

    public void setInsiteCode(String insiteCode) {
        this.insiteCode = insiteCode;
    }

    public int getFishID() {
        return fishID;
    }

    public void setFishID(int fishID) {
        this.fishID = fishID;
    }

    public double getReportedTradeLimitWeight() {
        return reportedTradeLimitWeight;
    }

    public void setReportedTradeLimitWeight(double tradeLimitWeight) {
        this.reportedTradeLimitWeight = tradeLimitWeight;
    }

    public double getVarA() {
        return varA;
    }

    public void setVarA(double varA) {
        this.varA = varA;
    }

    public double getVarB() {
        return varB;
    }

    public void setVarB(double varB) {
        this.varB = varB;
    }

    public String getLengthBasis() {
        if(lengthBasis == null) lengthBasis = "";
        return lengthBasis;
    }

    public void setLengthBasis(String lengthBasis) {
        this.lengthBasis = lengthBasis;
    }

    public double getConvertedTradeLimitL() {
        return convertedTradeLimitL;
    }

    public void setConvertedTradeLimitL(double convertedTradeLimitL) {
        this.convertedTradeLimitL = convertedTradeLimitL;
    }

    public double getPlottedTradeLimitTL() {
        return plottedTradeLimitTL;
    }

    public void setPlottedTradeLimitTL(double tradeLimitTL) {
        this.plottedTradeLimitTL = tradeLimitTL;
    }

    public double getConversionFactorTL2FL() {
        return conversionFactorTL2FL;
    }

    public void setConversionFactorTL2FL(double conversionFactorTL2FL) {
        this.conversionFactorTL2FL = conversionFactorTL2FL;
    }

    public long getLargestSpecimenId() {
        return largestSpecimenId;
    }

    public void setLargestSpecimenId(long largestSpecimenId) {
        this.largestSpecimenId = largestSpecimenId;
    }

    public double getLargestSpecimenCm() {
        return largestSpecimenCm;
    }

    public void setLargestSpecimenCm(double largestSpecimenCm) {
        this.largestSpecimenCm = largestSpecimenCm;
    }

    public long getLargestSpecimenPicture() {
        return largestSpecimenPicture;
    }

    public void setLargestSpecimenPicture(long largestSpecimenPicture) {
        this.largestSpecimenPicture = largestSpecimenPicture;
    }

    public String getLargestSpecimenCatchArea() {
        return largestSpecimenCatchArea;
    }

    public void setLargestSpecimenCatchArea(String largestSpecimenCatchArea) {
        this.largestSpecimenCatchArea = largestSpecimenCatchArea;
    }

}