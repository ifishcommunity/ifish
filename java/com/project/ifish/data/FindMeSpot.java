package com.project.ifish.data;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class FindMeSpot extends Entity {
    private long findmespotId = 0;
    private long trackerId = 0;
    private String trackerName = "";
    private long unixTime = 0;
    private String messageType = "";
    private double latitude = 0;
    private double longitude = 0;
    private String modelId = "";
    private String showCustomMessage = "";
    private Date dateTime = new Date();
    private String batteryState = "";
    private int hidden = 0;
    private String messageContent = "";
    private double dailyAvgLatitude = 0;
    private double dailyAvgLongitude = 0;

    public long getFindmespotId() {
        return findmespotId;
    }

    public void setFindmespotId(long findmespotId) {
        this.findmespotId = findmespotId;
    }

    public long getTrackerId() {
        return trackerId;
    }

    public void setTrackerId(long trackerId) {
        this.trackerId = trackerId;
    }

    public String getTrackerName() {
        return trackerName;
    }

    public void setTrackerName(String trackerName) {
        this.trackerName = trackerName;
    }

    public long getUnixTime() {
        return unixTime;
    }

    public void setUnixTime(long unixTime) {
        this.unixTime = unixTime;
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public String getModelId() {
        return modelId;
    }

    public void setModelId(String modelId) {
        this.modelId = modelId;
    }

    public String getShowCustomMessage() {
        return showCustomMessage;
    }

    public void setShowCustomMessage(String showCustomMessage) {
        this.showCustomMessage = showCustomMessage;
    }

    public Date getDateTime() {
        return dateTime;
    }

    public void setDateTime(Date dateTime) {
        this.dateTime = dateTime;
    }

    public String getBatteryState() {
        return batteryState;
    }

    public void setBatteryState(String batteryState) {
        this.batteryState = batteryState;
    }

    public int getHidden() {
        return hidden;
    }

    public void setHidden(int hidden) {
        this.hidden = hidden;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public double getDailyAvgLatitude() {
        return dailyAvgLatitude;
    }

    public void setDailyAvgLatitude(double dailyAvgLatitude) {
        this.dailyAvgLatitude = dailyAvgLatitude;
    }

    public double getDailyAvgLongitude() {
        return dailyAvgLongitude;
    }

    public void setDailyAvgLongitude(double dailyAvgLongitude) {
        this.dailyAvgLongitude = dailyAvgLongitude;
    }

}
