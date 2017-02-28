package com.project.general;

import com.project.main.db.CONException;
import com.project.main.entity.I_CONExceptionInfo;
import com.project.main.log.DbLogsAction;
import com.project.util.JSPCommand;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;
import com.project.util.lang.I_Language;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class CmdFile extends Control implements I_Language {

    public static int RSLT_OK = 0;
    public static int RSLT_UNKNOWN_ERROR = 1;
    public static int RSLT_EST_CODE_EXIST = 2;
    public static int RSLT_FORM_INCOMPLETE = 3;
    public static String[][] resultText = {
        {"Berhasil", "Tidak dapat diproses", "NoPerkiraan sudah ada", "Data tidak lengkap"},
        {"Succes", "Can not process", "Estimation code exist", "Data incomplete"}};
    private int start;
    private String msgString;
    private File file;
    private JspFile jspFile;
    int language = LANGUAGE_DEFAULT;

    public CmdFile(HttpServletRequest request) {
        msgString = "";
        file = new File();
        jspFile = new JspFile(request, file);
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

    public File getFile() {
        return file;
    }

    public JspFile getForm() {
        return jspFile;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidFile, long oidUser) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidFile != 0) {
                    try {
                        file = DbFile.fetchExc(oidFile);
                    } catch (Exception e) {
                        System.out.println("[Exception] " + e.toString());
                    }
                }

                jspFile.requestEntityObject(file);

                if (jspFile.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                if (file.getOID() == 0) {
                    try {
                        long oid = DbFile.insertExc(this.file);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.ADD, DbFile.DB_FILE, oid, oidUser);
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
                        long oid = DbFile.updateExc(this.file);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.UPDATE, DbFile.DB_FILE, oid, oidUser);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.EDIT:
                if (oidFile != 0) {
                    try {
                        file = DbFile.fetchExc(oidFile);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidFile != 0) {
                    try {
                        file = DbFile.fetchExc(oidFile);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidFile != 0) {
                    try {
                        long oid = DbFile.deleteExc(oidFile);
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                            DbLogsAction.insertLogs(JSPCommand.DELETE, DbFile.DB_FILE, oid, oidUser);
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
