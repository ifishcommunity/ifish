package com.project.general;

import com.project.main.entity.Entity;

/**
 *
 * @author gwawan
 */
public class File extends Entity{

    private String name = "";
    private String notes = "";
    private long refId = 0;

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getRefId() {
        return refId;
    }

    public void setRefId(long refId) {
        this.refId = refId;
    }

}
