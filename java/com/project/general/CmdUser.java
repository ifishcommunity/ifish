package com.project.general;

import com.project.main.db.CONException;
import com.project.main.log.DbLogsAction;
import com.project.util.JSPCommand;
import com.project.util.MD5;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

public class CmdUser extends Control {

    private String msgString;
    private int start;
    private User user;
    private DbUser dbUser;
    private JspUser jspUser;

    /** Creates new CtrlUser */
    public CmdUser(HttpServletRequest request) {
        msgString = "";

        user = new User();
        try {
            dbUser = new DbUser(0);
        } catch (Exception e) {
        }
        jspUser = new JspUser(request);
    }

    public String getErrMessage(int errCode) {
        switch (errCode) {
            case JSPMessage.ERR_DELETED:
                return "Can't Delete User";
            case JSPMessage.ERR_SAVED:
                if (jspUser.getFieldSize() > 0) {
                    return "Can't save user, cause some required data are incomplete ";
                } else {
                    return "Can't save user, Duplicate login ID, please type another login ID";
                }
            default:
                return "Can't save user";
        }
    }

    public User getUser() {
        return user;
    }

    public JspUser getForm() {
        return jspUser;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long appUserOID, long oidUser) {
        long oid = 0;
        int excCode = 0;
        msgString = "";

        switch (cmd) {
            case JSPCommand.ADD:
                user.setLoginId("");
                user.setRegDate(new Date());
                break;

            case JSPCommand.SAVE:

                if (appUserOID != 0) {
                    try {
                        user = DbUser.fetch(appUserOID);
                    } catch (Exception e) {
                    }
                }

                jspUser.requestEntityObject(user);

                if (jspUser.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return JSPMessage.MSG_INCOMPLATE;
                }

                try {
                    this.user.setResetPassword(false);

                    if (user.getOID() == 0) {
                        //encrypt password using MD5 Hash, only for new user
                        String md5Password = MD5.getMD5Hash(this.user.getPassword());
                        this.user.setPassword(md5Password);
                        user.setRegDate(new Date());
                        oid = DbUser.insert(this.user);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.ADD, DbUser.DB_USER, oid, oidUser);
                    } else {
                        user.setUpdateDate(new Date());
                        oid = DbUser.update(this.user);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.UPDATE, DbUser.DB_USER, oid, oidUser);
                    }

                    if (oid == JSPMessage.NONE) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                        msgString = getErrMessage(excCode);
                        excCode = 0;
                    }

                } catch (CONException exc) {
                    excCode = exc.getErrorCode();
                    msgString = getErrMessage(excCode);
                }
                DbUser.generateXML();
                break;

            case JSPCommand.EDIT:

                if (appUserOID != 0) {
                    user = (User) dbUser.fetch(appUserOID);
                }
                break;

            case JSPCommand.ASK:

                if (appUserOID != 0) {
                    user = (User) dbUser.fetch(appUserOID);
                    msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                }
                break;

            case JSPCommand.DELETE:

                if (appUserOID != 0) {
                    oid = DbUser.delete(appUserOID);
                    DbUserBoat.deleteByUser(oid);
                    DbLogsAction.insertLogs(JSPCommand.DELETE, DbUser.DB_USER, oid, oidUser);

                    if (oid == JSPMessage.NONE) {
                        msgString = JSPMessage.getErr(JSPMessage.ERR_DELETED);
                    } else {
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_DELETED);
                    }
                }
                break;

            default:

        }//end switch
        return excCode;
    }
}
