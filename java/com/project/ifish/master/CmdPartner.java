package com.project.ifish.master;

import com.project.main.db.CONException;
import com.project.main.entity.I_CONExceptionInfo;
import com.project.main.log.DbLogsAction;
import com.project.util.JSPCommand;
import com.project.util.MD5;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;
import com.project.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class CmdPartner extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}
    };
    private int start;
    private String msgString;
    private Partner partner;
    private DbPartner dbPartner;
    private JspPartner jspPartner;
    int language = LANGUAGE_DEFAULT;

    public CmdPartner(HttpServletRequest request) {
        msgString = "";
        partner = new Partner();
        try {
            dbPartner = new DbPartner(0);
        } catch (Exception e) {
            ;
        }
        jspPartner = new JspPartner(request, partner);
    }

    private String getSystemMessage(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return resultText[language][RSLT_EST_CODE_EXIST];
            default:
                return resultText[language][RSLT_UNKNOWN_ERROR];
        }
    }

    private int getControlMsgId(int msgCode) {
        switch (msgCode) {
            case I_CONExceptionInfo.MULTIPLE_ID:
                return RSLT_EST_CODE_EXIST;
            default:
                return RSLT_UNKNOWN_ERROR;
        }
    }

    public int getLanguage() {
        return language;
    }

    public void setLanguage(int language) {
        this.language = language;
    }

    public Partner getPartner() {
        return partner;
    }

    public JspPartner getForm() {
        return jspPartner;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidPartner, long oidUser) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidPartner != 0) {
                    try {
                        partner = DbPartner.fetchExc(oidPartner);
                    } catch (Exception exc) {
                    }
                }

                jspPartner.requestEntityObject(partner);

                if (jspPartner.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (partner.getOID() == 0) {
                    try {
                        long oid = dbPartner.insertExc(this.partner);
                        if(oid != 0) {
                            this.partner.setOID(oid);
                            this.partner.setToken(MD5.getMD5Hash(String.valueOf(this.partner.getOID())));
                            oid = dbPartner.updateExc(this.partner);
                        }
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.ADD, DbPartner.DB_PARTNER, oid, oidUser);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                        return getControlMsgId(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                        return getControlMsgId(I_CONExceptionInfo.UNKNOWN);
                    }
                } else {
                    try {
                        this.partner.setToken(MD5.getMD5Hash(String.valueOf(this.partner.getOID())));
                        long oid = dbPartner.updateExc(this.partner);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.UPDATE, DbPartner.DB_PARTNER, oid, oidUser);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.EDIT:
                if (oidPartner != 0) {
                    try {
                        partner = DbPartner.fetchExc(oidPartner);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidPartner != 0) {
                    try {
                        partner = DbPartner.fetchExc(oidPartner);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidPartner != 0) {
                    try {
                        long oid = DbPartner.deleteExc(oidPartner);
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                            DbLogsAction.insertLogs(JSPCommand.DELETE, DbPartner.DB_PARTNER, oid, oidUser);
                        } else {
                            msgString = JSPMessage.getMessage(JSPMessage.ERR_DELETED);
                            excCode = RSLT_FORM_INCOMPLETE;
                        }
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            default:

        }
        return rsCode;
    }
}
