package com.project.general;

import com.project.main.log.DbLogsAction;
import com.project.util.JSPCommand;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;
import com.project.util.lang.I_Language;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;

public class CmdGroup extends Control implements I_Language {

    private String msgString;
    private int start;
    private Group appGroup;
    private JspGroup frmGroup;

    public CmdGroup(HttpServletRequest request) {
        msgString = "";
        appGroup = new Group();
        frmGroup = new JspGroup(request);
    }

    public Group getGroup() {
        return appGroup;
    }

    public JspGroup getForm() {
        return frmGroup;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long appGroupOID, long oidUser) {
        msgString = "";
        int excCode = 0;
        switch (cmd) {
            case JSPCommand.ADD:
                appGroup.setGroupName("");
                appGroup.setRegDate(new Date());
                break;

            case JSPCommand.SAVE:

                if (appGroupOID != 0) {
                    try {
                        appGroup = DbGroup.fetch(appGroupOID);
                    } catch (Exception e) {
                    }
                }

                frmGroup.requestEntityObject(appGroup);
                appGroup.setOID(appGroupOID);

                if (DbGroup.isGroupExist(appGroup.getGroupName(), appGroupOID)) {
                    msgString = "Can't save data, group name already exist";
                    return excCode;
                }

                if (frmGroup.errorSize() > 0) {
                    excCode = JSPMessage.MSG_INCOMPLATE;
                    msgString = JSPMessage.getMsg(excCode);
                    return excCode;
                }

                long oid = 0;
                if (appGroup.getOID() == 0) {
                    oid = DbGroup.insert(this.appGroup);
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                    DbLogsAction.insertLogs(JSPCommand.ADD, DbGroup.DB_GROUP, oid, oidUser);
                } else {
                    oid = DbGroup.update(this.appGroup);
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                    DbLogsAction.insertLogs(JSPCommand.UPDATE, DbGroup.DB_GROUP, oid, oidUser);
                }

                if (oid == JSPMessage.NONE) {
                    excCode = JSPMessage.ERR_SAVED;
                    msgString = JSPMessage.getErr(JSPMessage.ERR_SAVED);
                }
                msgString = JSPMessage.getMessage(JSPMessage.MSG_SAVED);
                break;

            case JSPCommand.EDIT:

                if (appGroupOID != 0) {
                    appGroup = (Group) DbGroup.fetch(appGroupOID);
                }
                break;

            case JSPCommand.ASK:

                if (appGroupOID != 0) {
                    appGroup = (Group) DbGroup.fetch(appGroupOID);
                    excCode = JSPMessage.MSG_ASKDEL;
                    msgString = JSPMessage.getErr(JSPMessage.MSG_ASKDEL);
                }
                break;

            case JSPCommand.DELETE:

                if (appGroupOID != 0) {
                    oid = DbGroupDetail.deleteByGroup(appGroupOID);
                    oid = DbGroup.delete(appGroupOID);
                    DbLogsAction.insertLogs(JSPCommand.DELETE, DbGroup.DB_GROUP, oid, oidUser);

                    if (oid == JSPMessage.NONE) {
                        excCode = JSPMessage.ERR_DELETED;
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
