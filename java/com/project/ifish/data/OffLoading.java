package com.project.ifish.data;

import com.project.main.entity.Entity;

/**
 *
 * @author gwawan
 */
public class OffLoading extends Entity {
    private long landingId = 0;
    private long fishId = 0;
    private double pcs = 0;
    private double nw = 0;
    private double temperature = 0;
    private String condition = "";
    private String grade = "";

    public long getLandingId() {
        return landingId;
    }

    public void setLandingId(long landingId) {
        this.landingId = landingId;
    }

    public long getFishId() {
        return fishId;
    }

    public void setFishId(long fishId) {
        this.fishId = fishId;
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
    
}
