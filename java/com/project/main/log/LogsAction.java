package com.project.main.log;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class LogsAction extends Entity {
    private Date dateTime = new Date();
    private int cmdAction = 0;
    private String tableName = "";
    private long docId = 0;
    private long userId = 0;

    public Date getDateTime() {
        return dateTime;
    }

    public void setDateTime(Date dateTime) {
        this.dateTime = dateTime;
    }

    public int getCmdAction() {
        return cmdAction;
    }

    public void setCmdAction(int cmdAction) {
        this.cmdAction = cmdAction;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public long getDocId() {
        return docId;
    }

    public void setDocId(long docId) {
        this.docId = docId;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }

}
