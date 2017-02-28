package com.project.ifish.session;

import java.util.Date;

/**
 *
 * @author gwawan
 */
public class DeepSlopeSummary {
    private long landingId = 0;
    private String approach = "";
    private Date landingDate = new Date();
    private String boatName = "";
    private String boatHomePort = "";
    private String codrsFileName = "";
    private String fishingGear = "";
    private String majorFishingArea = "";
    private int totalOfSpecies = 0;
    private double estimatedWeight = 0;
    private long userId = 0;
    private String userName = "";

    public long getLandingId() {
        return landingId;
    }

    public void setLandingId(long landingId) {
        this.landingId = landingId;
    }

    public String getApproach() {
        return approach;
    }

    public void setApproach(String approach) {
        this.approach = approach;
    }

    public Date getLandingDate() {
        return landingDate;
    }

    public void setLandingDate(Date landingDate) {
        this.landingDate = landingDate;
    }

    public String getBoatName() {
        return boatName;
    }

    public void setBoatName(String boatName) {
        this.boatName = boatName;
    }

    public String getBoatHomePort() {
        return boatHomePort;
    }

    public void setBoatHomePort(String boatHomePort) {
        this.boatHomePort = boatHomePort;
    }

    public String getCODRSFileName() {
        return codrsFileName;
    }

    public void setCODRSFileName(String codrsFileName) {
        this.codrsFileName = codrsFileName;
    }

    public String getFishingGear() {
        return fishingGear;
    }

    public void setFishingGear(String fishingGear) {
        this.fishingGear = fishingGear;
    }

    public String getMajorFishingArea() {
        return majorFishingArea;
    }

    public void setMajorFishingArea(String majorFishingArea) {
        this.majorFishingArea = majorFishingArea;
    }

    public int getTotalOfSpecies() {
        return totalOfSpecies;
    }

    public void setTotalOfSpecies(int totalOfSpecies) {
        this.totalOfSpecies = totalOfSpecies;
    }

    public double getEstimatedWeight() {
        return estimatedWeight;
    }

    public void setEstimatedWeight(double estimatedWeight) {
        this.estimatedWeight = estimatedWeight;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

}
