package com.project.ifish.data;

import java.util.Date;

/**
 *
 * @author gwawan
 */
public class CODRS {

    private int approach = 0;
    private long userId = 0;
    private long partnerId = 0;
    private Date landingDate = new Date();
    private String landingLocation = "";
    private String wpp1 = "";
    private String wpp2 = "";
    private String wpp3 = "";
    private long boatId = 0;
    private String fishingGear = "";
    private String broughtBy = "";
    private long fishId = 0;
    private double cm = 0;
    private int dataQuality = 0;
    private int uploadStatus = 0;
    private String fileName = "";
    private String otherFishingGround = "";
    private Date pictureDate = new Date();
    private String pictureName = "";
    private String fisheryType = "";

    public int getApproach() {
        return approach;
    }

    public void setApproach(int approach) {
        this.approach = approach;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(long partnerId) {
        this.partnerId = partnerId;
    }

    public Date getLandingDate() {
        return landingDate;
    }

    public void setLandingDate(Date landingDate) {
        this.landingDate = landingDate;
    }

    public String getLandingLocation() {
        return landingLocation;
    }

    public void setLandingLocation(String landingLocation) {
        this.landingLocation = landingLocation;
    }

    public String getWpp1() {
        return wpp1;
    }

    public void setWpp1(String wpp1) {
        this.wpp1 = wpp1;
    }

    public String getWpp2() {
        return wpp2;
    }

    public void setWpp2(String wpp2) {
        this.wpp2 = wpp2;
    }

    public String getWpp3() {
        return wpp3;
    }

    public void setWpp3(String wpp3) {
        this.wpp3 = wpp3;
    }

    public long getBoatId() {
        return boatId;
    }

    public void setBoatId(long boatId) {
        this.boatId = boatId;
    }

    public String getFishingGear() {
        return fishingGear;
    }

    public void setFishingGear(String fishingGear) {
        this.fishingGear = fishingGear;
    }

    public String getBroughtBy() {
        return broughtBy;
    }

    public void setBroughtBy(String broughtBy) {
        this.broughtBy = broughtBy;
    }

    public long getFishId() {
        return fishId;
    }

    public void setFishId(long fishId) {
        this.fishId = fishId;
    }

    public double getCm() {
        return cm;
    }

    public void setCm(double cm) {
        this.cm = cm;
    }

    public int getDataQuality() {
        return dataQuality;
    }

    public void setDataQuality(int dataQuality) {
        this.dataQuality = dataQuality;
    }

    public int getUploadStatus() {
        return uploadStatus;
    }

    public void setUploadStatus(int uploadStatus) {
        this.uploadStatus = uploadStatus;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOtherFishingGround() {
        return otherFishingGround;
    }

    public void setOtherFishingGround(String otherFishingGround) {
        this.otherFishingGround = otherFishingGround;
    }

    public Date getPictureDate() {
        return pictureDate;
    }

    public void setPictureDate(Date pictureDate) {
        this.pictureDate = pictureDate;
    }

    public String getPictureName() {
        return pictureName;
    }

    public void setPictureName(String pictureName) {
        this.pictureName = pictureName;
    }

    public String getFisheryType() {
        return fisheryType;
    }

    public void setFisheryType(String fisheryType) {
        this.fisheryType = fisheryType;
    }

}
