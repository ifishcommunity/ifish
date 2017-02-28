package com.project.general;

import com.project.IFishConfig;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.ifish.data.DbDeepSlope;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Vector;

public class QrUserSession {

    public final static String HTTP_SESSION_NAME = "USER_SESSION";
    public final static int DO_LOGIN_OK = 0;
    public final static int DO_LOGIN_ALREADY_LOGIN = 1;
    public final static int DO_LOGIN_NOT_VALID = 2;
    public final static int DO_LOGIN_SYSTEM_FAIL = 3;
    public final static int DO_LOGIN_GET_PRIV_ERROR = 4;
    public final static int DO_LOGIN_NO_PRIV_ASIGNED = 5;
    public final static String[] soLoginTxt = {"Login succeed", "User is already logged in",
        "Login ID or Password are invalid", "System cannot login you", "Can't get privilege",
        "No access asigned, please contact your system administrator"
    };
    private Vector privObj = new Vector();
    private User appUser = new User();
    public final String[] injectString = {"=", "<", ">", "?", "&", "|", "!", "/", "%", " ", "#", "@", "*", "(", ")", "+"};

    public User getUser() {
        return appUser;
    }

    public QrUserSession() {
        appUser.setLoginStatus(IFishConfig.LOGIN_STATUS_SIGNOUT);
    }

    public QrUserSession(String hostIP) {
        appUser.setLoginStatus(IFishConfig.LOGIN_STATUS_SIGNOUT);
        appUser.setLastLoginIp(hostIP);
    }

    public String getUserName() {
        return appUser.getFullName();
    }

    public long getUserOID() {
        return appUser.getOID();
    }

    public String getLoginId() {
        return appUser.getLoginId();
    }

    public boolean isResetPassword() {
        return appUser.isResetPassword();
    }

    public boolean isLoggedIn() {
        if ((this.appUser.getLoginStatus() == IFishConfig.LOGIN_STATUS_SIGNIN)) {
            return true;
        } else {
            return false;
        }
    }

    public boolean checkPrivilege(int objCode) {
        if (!isLoggedIn()) {
            return false;
        }
        return QrPrivilegeObj.existCode(this.privObj, objCode);
    }

    public String removeInjection(String str) {

        boolean injection = false;
        String s = "";
        String result = "";
        for (int i = 0; i < str.length(); i++) {

            injection = false;
            s = "" + str.charAt(i);

            for (int x = 0; x < injectString.length; x++) {
                if (injectString[x].equals(s)) {
                    injection = true;
                    break;
                }
            }

            if (!injection) {
                result = result + s;
            }
        }

        return result;
    }

    public int doLogin(String loginID, String password) {
        loginID = removeInjection(loginID);
        password = removeInjection(password);
        User user = DbUser.getByLoginIDAndPassword(loginID, password);
        appUser = user;

        if (user == null) {
            return DO_LOGIN_SYSTEM_FAIL;
        }

        if (user.getOID() == 0) {
            return DO_LOGIN_NOT_VALID;
        }

        if (user.getOID() != 0) {
            try {
                user = DbUser.fetch(user.getOID());
                appUser = user;
            } catch (Exception e) {
            }
        }

        user.setLastLoginIp(this.appUser.getLastLoginIp());
        user.setLoginStatus(IFishConfig.LOGIN_STATUS_SIGNIN);
        user.setLastLoginDate(new Date());

        /* remove comment bellow to enable checking of user host IP */
        //if ((user.getLoginStatus() == User.STATUS_LOGIN) && !(this.appUser.getLastLoginIp().equals(user.getLastLoginIp()))) {
        //return DO_LOGIN_ALREADY_LOGIN;
        //}

        if (DbUser.update(user) == 0) {
            return DO_LOGIN_SYSTEM_FAIL;
        }

        this.appUser = user;
        privObj = getAllPrivileges(user.getOID());

        if (privObj == null) {
            privObj = new Vector(1, 1);
            return DO_LOGIN_GET_PRIV_ERROR;
        }

        return DO_LOGIN_OK;
    }

    public void doLogout() {
        if ((appUser == null) || (appUser.getLoginStatus() != IFishConfig.LOGIN_STATUS_SIGNIN)) {
            return;
        }

        DbUser.updateUserStatus(appUser.getOID(), IFishConfig.LOGIN_STATUS_SIGNOUT);
    }

    private Vector getAllPrivileges(long oidUser) {
        CONResultSet crs = null;
        Vector result = new Vector(1, 1);
        try {
            String sql = " select distinct gd.*"
                    + " from " + DbUser.DB_USER + " u "
                    + " inner join " + DbGroupDetail.DB_GROUP_DETAIL + " gd"
                    + " on gd." + DbGroupDetail.colNames[DbGroupDetail.COL_GROUP_ID] + " = u." + DbUser.colNames[DbUser.COL_GROUP_ID]
                    + " where u." + DbUser.colNames[DbUser.COL_USER_ID] + "=" + oidUser
                    + " order by gd." + DbGroupDetail.colNames[DbGroupDetail.COL_MN_1] + " , gd." + DbGroupDetail.colNames[DbGroupDetail.COL_MN_2];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                GroupDetail groupDetail = new GroupDetail();
                DbGroupDetail.resultToObject(rs, groupDetail);
                result.add(groupDetail);
            }
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;

    }

    public boolean isPriviledged(int menu1, int menu2) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                GroupDetail groupDetail = (GroupDetail) temp.get(i);
                if (groupDetail.getMn1() == menu1 && groupDetail.getMn2() == menu2) {
                    return true;
                }
            }
        }
        return false;
    }

    public boolean isPriviledged(int menu1, int menu2, int type) {
        Vector temp = this.privObj;

        if (temp != null && temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                GroupDetail groupDetail = (GroupDetail) temp.get(i);

                if (groupDetail.getMn1() == menu1 && groupDetail.getMn2() == menu2) {
                    boolean found = false;
                    switch (type) {
                        case AppMenu.PRIV_VIEW:
                            if (groupDetail.getCmdView() == 1) {
                                found = true;
                            }
                            break;
                        case AppMenu.PRIV_ADD:
                            if (groupDetail.getCmdAdd() == 1) {
                                found = true;
                            }
                            break;
                        case AppMenu.PRIV_EDIT:
                            if (groupDetail.getCmdEdit() == 1) {
                                found = true;
                            }
                            break;
                        case AppMenu.PRIV_DELETE:
                            if (groupDetail.getCmdDelete() == 1) {
                                found = true;
                            }
                            break;
                    }

                    if (found) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static List<User> getCODRSUsers() {
        List<User> result = new ArrayList<User>();
        CONResultSet crs = null;
        try {
            String sql = " select distinct u.*"
                    + " from " + DbUser.DB_USER + " u "
                    + " inner join " + DbDeepSlope.DB_DEEPSLOPE + " d"
                    + " on d." + DbDeepSlope.colNames[DbDeepSlope.COL_USER_ID] + " = u." + DbUser.colNames[DbUser.COL_USER_ID]
                    + " where " + DbDeepSlope.colNames[DbDeepSlope.COL_APPROACH] + " = " + IFishConfig.APPROACH_CODRS
                    + " order by u." + DbUser.colNames[DbUser.COL_FULL_NAME];

            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();

            while (rs.next()) {
                User user = new User();
                DbUser.resultToObject(rs, user);
                result.add(user);
            }
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        } finally {
            CONResultSet.close(crs);
        }

        return result;
    }
}
