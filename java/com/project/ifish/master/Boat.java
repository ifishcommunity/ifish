package com.project.ifish.master;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class Boat extends Entity {

    private String gearType = "";
    private String code = "";
    private String name = "";
    private String homePort = "";
    private double length = 0;
    private double width = 0;
    private int yearBuilt = 0;
    private double grossTonnage = 0;
    private int isEngine = 0;
    private double engineHP = 0;
    private String owner = "";
    private String ownerOrigin = "";
    private String captain = "";
    private String captainOrigin = "";
    private long partnerId = 0;
    private long trackerId = 0;
    private int trackerStatus = 0;
    private Date trackerStartDate = new Date();
    private Date trackerEndDate = new Date();
    private String programSite = "";
    private long pictureOriginal = 0;
    private long pictureCensored = 0;

    public String getGearType() {
        return gearType;
    }

    public void setGearType(String dataType) {
        this.gearType = dataType;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHomePort() {
        return homePort;
    }

    public void setHomePort(String homePort) {
        this.homePort = homePort;
    }

    public double getLength() {
        return length;
    }

    public void setLength(double length) {
        this.length = length;
    }

    public double getWidth() {
        return width;
    }

    public void setWidth(double width) {
        this.width = width;
    }

    public int getYearBuilt() {
        return yearBuilt;
    }

    public void setYearBuilt(int yearBuilt) {
        this.yearBuilt = yearBuilt;
    }

    public double getGrossTonnage() {
        return grossTonnage;
    }

    public void setGrossTonnage(double grossTonnage) {
        this.grossTonnage = grossTonnage;
    }

    public int isEngine() {
        return isEngine;
    }

    public void setIsEngine(int isEngine) {
        this.isEngine = isEngine;
    }

    public double getEngineHP() {
        return engineHP;
    }

    public void setEngineHP(double engineHP) {
        this.engineHP = engineHP;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getOwnerOrigin() {
        return ownerOrigin;
    }

    public void setOwnerOrigin(String ownerOrigin) {
        this.ownerOrigin = ownerOrigin;
    }

    public String getCaptain() {
        return captain;
    }

    public void setCaptain(String captain) {
        this.captain = captain;
    }

    public String getCaptainOrigin() {
        return captainOrigin;
    }

    public void setCaptainOrigin(String captainOrigin) {
        this.captainOrigin = captainOrigin;
    }

    public long getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(long partnerId) {
        this.partnerId = partnerId;
    }

    public long getTrackerId() {
        return trackerId;
    }

    public void setTrackerId(long trackerId) {
        this.trackerId = trackerId;
    }

    public int getTrackerStatus() {
        return trackerStatus;
    }

    public void setTrackerStatus(int trackerStatus) {
        this.trackerStatus = trackerStatus;
    }

    public Date getTrackerStartDate() {
        return trackerStartDate;
    }

    public void setTrackerStartDate(Date trackerStartDate) {
        this.trackerStartDate = trackerStartDate;
    }

    public Date getTrackerEndDate() {
        return trackerEndDate;
    }

    public void setTrackerEndDate(Date trackerEndDate) {
        this.trackerEndDate = trackerEndDate;
    }

    public String getProgramSite() {
        return programSite;
    }

    public void setProgramSite(String programSite) {
        this.programSite = programSite;
    }

    public long getPictureOriginal() {
        return pictureOriginal;
    }

    public void setPictureOriginal(long pictureOriginal) {
        this.pictureOriginal = pictureOriginal;
    }

    public long getPictureCensored() {
        return pictureCensored;
    }

    public void setPictureCensored(long pictureCensored) {
        this.pictureCensored = pictureCensored;
    }

}
