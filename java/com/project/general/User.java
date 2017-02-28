package com.project.general;

import com.project.main.entity.Entity;
import java.util.Date;

public class User extends Entity {

    private String loginId = "";
    private String password = "";
    private String fullName = "";
    private String email = "";
    private String description = "";
    private Date regDate = new Date();
    private Date updateDate = new Date();
    private int loginStatus = 0;
    private Date lastLoginDate = new Date();
    private String lastLoginIp = "";
    private boolean resetPassword = false;
    private long partnerId = 0;
    private long groupId = 0;
    private int status = 0;
    private int uald = 0; //User of Anonymous Location Data

    public User() {
    }

    public String getLoginId() {
        return loginId;
    }

    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public java.util.Date getRegDate() {
        return regDate;
    }

    public void setRegDate(java.util.Date regDate) {
        this.regDate = regDate;
    }

    public java.util.Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(java.util.Date updateDate) {
        this.updateDate = updateDate;
    }

    public int getLoginStatus() {
        return loginStatus;
    }

    public void setLoginStatus(int loginStatus) {
        this.loginStatus = loginStatus;
    }

    public java.util.Date getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(java.util.Date lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    public String getLastLoginIp() {
        return lastLoginIp;
    }

    public void setLastLoginIp(String lastLoginIp) {
        this.lastLoginIp = lastLoginIp;
    }

    public boolean isResetPassword() {
        return resetPassword;
    }

    public void setResetPassword(boolean resetPassword) {
        this.resetPassword = resetPassword;
    }

    public long getPartnerId() {
        return this.partnerId;
    }

    public void setPartnerId(long partnerId) {
        this.partnerId = partnerId;
    }

    public long getGroupId() {
        return groupId;
    }

    public void setGroupId(long groupId) {
        this.groupId = groupId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getUald() {
        return uald;
    }

    public void setUald(int uald) {
        this.uald = uald;
    }
    
}
