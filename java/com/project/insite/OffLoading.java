package com.project.insite;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class OffLoading extends Entity {
    private long offloadingId = 0;
    private Date receivedDate = new Date();
    private String latinName = "";
    private String species = "";
    private double pcs = 0;
    private double nw = 0;
    private double temperature = 0;
    private String condition = "";
    private String grade = "";
    private long tripId = 0;
    private long trackerId = 0;
    private int status = 0;
    private long userId = 0;
    private String boat = "";
    private String broughtBy = "";
    private long partnerId = 0;

    public long getOffloadingId() {
        return offloadingId;
    }

    public void setOffloadingId(long offloadingId) {
        this.offloadingId = offloadingId;
    }

    public Date getReceivedDate() {
        return receivedDate;
    }

    public void setReceivedDate(Date receivedDate) {
        this.receivedDate = receivedDate;
    }

    public String getLatinName() {
        return latinName;
    }

    public void setLatinName(String latinName) {
        this.latinName = latinName;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public double getPcs() {
        return pcs;
    }

    public void setPcs(double pcs) {
        this.pcs = pcs;
    }

    public double getNw() {
        return nw;
    }

    public void setNw(double nw) {
        this.nw = nw;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
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

    public String getBoat() {
        return boat;
    }

    public void setBoat(String boat) {
        this.boat = boat;
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
