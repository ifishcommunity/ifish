package com.project.ifish.data;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class Sizing extends Entity{
    private long landingId = 0;
    private long offloadingId = 0;
    private long fishId = 0;
    private double cm = 0;
    private Date codrsPictureDate = new Date();
    private String codrsPictureName = "";
    private int dataQuality = 1; //Default is 1 for Good. And 0 for Poor

    public long getLandingId() {
        return landingId;
    }

    public void setLandingId(long landingId) {
        this.landingId = landingId;
    }

    public long getOffloadingId() {
        return offloadingId;
    }

    public void setOffloadingId(long offloadingId) {
        this.offloadingId = offloadingId;
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

    public Date getCODRSPictureDate() {
        return codrsPictureDate;
    }

    public void setCODRSPictureDate(Date codrsPictureDate) {
        this.codrsPictureDate = codrsPictureDate;
    }

    public String getCODRSPictureName() {
        return codrsPictureName;
    }

    public void setCODRSPictureName(String codrsPictureName) {
        this.codrsPictureName = codrsPictureName;
    }

    public int getDataQuality() {
        return dataQuality;
    }

    public void setDataQuality(int dataQuality) {
        this.dataQuality = dataQuality;
    }

}
