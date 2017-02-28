package com.project.insite;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class Sizing extends Entity {
    private long sizingId = 0;
    private Date sizingDate = new Date();
    private String genus = "";
    private String latinName = "";
    private String englishName = "";
    private double cm = 0;
    private String boat = "";
    private long tripId = 0;
    private long trackerId = 0;
    private int status = 0;
    private long userId = 0;
    private long offloadingId = 0;
    private String broughtBy = "";
    private long partnerId = 0;

    public long getSizingId() {
        return sizingId;
    }

    public void setSizingId(long sizingId) {
        this.sizingId = sizingId;
    }

    public Date getSizingDate() {
        return sizingDate;
    }

    public void setSizingDate(Date sizingDate) {
        this.sizingDate = sizingDate;
    }

    public String getGenus() {
        return genus;
    }

    public void setGenus(String genus) {
        this.genus = genus;
    }

    public String getLatinName() {
        return latinName;
    }

    public void setLatinName(String latinName) {
        this.latinName = latinName;
    }

    public String getEnglishName() {
        return englishName;
    }

    public void setEnglishName(String englishName) {
        this.englishName = englishName;
    }

    public double getCm() {
        return cm;
    }

    public void setCm(double cm) {
        this.cm = cm;
    }

    public String getBoat() {
        return boat;
    }

    public void setBoat(String boat) {
        this.boat = boat;
    }

    public long getTripId() {
        return tripId;
    }

    public void setTripId(long tripId) {
        this.tripId = tripId;
    }

    public long getTrackerId() {
        return trackerId;
    }

    public void setTrackerId(long trackerId) {
        this.trackerId = trackerId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getOffloadingId() {
        return offloadingId;
    }

    public void setOffloadingId(long offloadingId) {
        this.offloadingId = offloadingId;
    }
    
    public String getBroughtBy() {
        return broughtBy;
    }

    public void setBroughtBy(String broughtBy) {
        this.broughtBy = broughtBy;
    }

    public long getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(long partnerId) {
        this.partnerId = partnerId;
    }

}
