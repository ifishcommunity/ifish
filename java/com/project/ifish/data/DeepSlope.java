package com.project.ifish.data;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class DeepSlope extends Entity {

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
    private String CODRSFileName = "";
    private String otherFishingGround = "";
    private String supplier = "";
    private String fisheryType = "";
    private Date entryDate = new Date();
    private Date postingDate = new Date();
    private long postingUser = 0;
    private String docStatus = "";
    private Date firstCODRSPictureDate = new Date();

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

    public String getCODRSFileName() {
        return CODRSFileName;
    }

    public void setCODRSFileName(String codrsFileName) {
        this.CODRSFileName = codrsFileName;
    }

    public String getOtherFishingGround() {
        return otherFishingGround;
    }

    public void setOtherFishingGround(String otherFishingGround) {
        this.otherFishingGround = otherFishingGround;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getFisheryType() {
        return fisheryType;
    }

    public void setFisheryType(String fisheryType) {
        this.fisheryType = fisheryType;
    }

    public Date getEntryDate() {
        return entryDate;
    }

    public void setEntryDate(Date entryDate) {
        this.entryDate = entryDate;
    }

    public Date getPostingDate() {
        return postingDate;
    }

    public void setPostingDate(Date postingDate) {
        this.postingDate = postingDate;
    }

    public long getPostingUser() {
        return postingUser;
    }

    public void setPostingUser(long postingUser) {
        this.postingUser = postingUser;
    }

    public String getDocStatus() {
        return docStatus;
    }

    public void setDocStatus(String docStatus) {
        this.docStatus = docStatus;
    }

    public Date getFirstCODRSPictureDate() {
        return firstCODRSPictureDate;
    }

    public void setFirstCODRSPictureDate(Date firstCODRSPictureDate) {
        this.firstCODRSPictureDate = firstCODRSPictureDate;
    }
    
}
