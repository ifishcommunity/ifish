package com.project.general;

import com.project.main.entity.Entity;

/**
 *
 * @author gwawan
 */
public class UserBoat extends Entity {
    private long userId = 0;
    private long boatId = 0;

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

    public long getBoatId() {
        return boatId;
    }

    public void setBoatId(long boatId) {
        this.boatId = boatId;
    }

}
