package com.project.general;

import com.project.main.entity.Entity;

/**
 *
 * @author gwawan
 */
public class GroupDetail extends Entity {

    private long groupId = 0;
    private int mn1 = 0;
    private int mn2 = 0;
    private int cmdAdd = 0;
    private int cmdEdit = 0;
    private int cmdView = 0;
    private int cmdDelete = 0;

    public long getGroupId() {
        return groupId;
    }

    public void setGroupId(long groupId) {
        this.groupId = groupId;
    }

    public int getMn1() {
        return mn1;
    }

    public void setMn1(int mn1) {
        this.mn1 = mn1;
    }

    public int getMn2() {
        return mn2;
    }

    public void setMn2(int mn2) {
        this.mn2 = mn2;
    }

    public int getCmdAdd() {
        return cmdAdd;
    }

    public void setCmdAdd(int cmdAdd) {
        this.cmdAdd = cmdAdd;
    }

    public int getCmdEdit() {
        return cmdEdit;
    }

    public void setCmdEdit(int cmdEdit) {
        this.cmdEdit = cmdEdit;
    }

    public int getCmdView() {
        return cmdView;
    }

    public void setCmdView(int cmdView) {
        this.cmdView = cmdView;
    }

    public int getCmdDelete() {
        return cmdDelete;
    }

    public void setCmdDelete(int cmdDelete) {
        this.cmdDelete = cmdDelete;
    }
}
