package com.project.ifish.master;

import com.project.main.entity.Entity;

/**
 *
 * @author gwawan
 */
public class PartnerBoat extends Entity{
    private long partnerId = 0;
    private long boatId = 0;

    public long getPartnerId() {
        return partnerId;
    }

    public void setPartnerId(long partnerId) {
        this.partnerId = partnerId;
    }

    public long getBoatId() {
        return boatId;
    }

    public void setBoatId(long boatId) {
        this.boatId = boatId;
    }

}
