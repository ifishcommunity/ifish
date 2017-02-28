package com.project.ifish.master;

import com.project.IFishConfig;
import com.project.main.db.CONException;
import com.project.main.entity.I_CONExceptionInfo;
import com.project.main.log.DbLogsAction;
import com.project.util.JSPCommand;
import com.project.util.jsp.Control;
import com.project.util.jsp.JSPMessage;
import com.project.util.lang.I_Language;
import com.project.util.JSPFormater;
import java.util.Date;
import java.util.Vector;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
public class CmdBoat extends Control implements I_Language {

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
    private Boat boat;
    private DbBoat dbBoat;
    private JspBoat jspBoat;
    int language = LANGUAGE_DEFAULT;

    public CmdBoat(HttpServletRequest request) {
        msgString = "";
        boat = new Boat();
        try {
            dbBoat = new DbBoat(0);
        } catch (Exception e) {
            ;
        }
        jspBoat = new JspBoat(request, boat);
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

    public Boat getBoat() {
        return boat;
    }

    public JspBoat getForm() {
        return jspBoat;
    }

    public String getMessage() {
        return msgString;
    }

    public int getStart() {
        return start;
    }

    public int action(int cmd, long oidBoat, long oidUser) {
        msgString = "";
        int excCode = I_CONExceptionInfo.NO_EXCEPTION;
        int rsCode = RSLT_OK;
        switch (cmd) {
            case JSPCommand.ADD:
                break;

            case JSPCommand.SAVE:
                if (oidBoat != 0) {
                    try {
                        boat = DbBoat.fetchExc(oidBoat);
                    } catch (Exception exc) {
                    }
                }

                jspBoat.requestEntityObject(boat);

                if (jspBoat.errorSize() > 0) {
                    msgString = JSPMessage.getMsg(JSPMessage.MSG_INCOMPLATE);
                    return RSLT_FORM_INCOMPLETE;
                }

                // set the value of Boat Machine (HP) to 0 if the boat is not using machine
                if(boat.isEngine() == 0) {
                    boat.setEngineHP(0.0);
                }

                // use Current Date as a Tracker End Date if Tracker Status is Active
                if(boat.getTrackerStatus() == IFishConfig.STATUS_ACTIVE) {
                    boat.setTrackerEndDate(new Date());
                }

                // check whether SpotTrace active on the other boat
                if(boat.getTrackerId() > 0 && boat.getTrackerStatus() == IFishConfig.STATUS_ACTIVE) {
                    String where = DbBoat.colNames[DbBoat.COL_TRACKER_ID]+"="+boat.getTrackerId()+
                            " and "+DbBoat.colNames[DbBoat.COL_TRACKER_STATUS]+"="+IFishConfig.STATUS_ACTIVE+
                            " and "+DbBoat.colNames[DbBoat.COL_OID]+"!="+boat.getOID();
                    String order = DbBoat.colNames[DbBoat.COL_TRACKER_END_DATE]+" desc";
                    Vector list = DbBoat.list(0, 0, where, order);
                    if(list.size() > 0) {
                        Boat bx = (Boat)list.get(0);
                        msgString = "Error, SpotTrace still active on " + bx.getName() + " (" + bx.getHomePort() + ")!";
                        return RSLT_EST_CODE_EXIST;
                    }
                }

                // check whether the Tracker-Start-Date is incorrect, the date is before Tracker-End-Date in the previously active boat
                if(boat.getTrackerId() > 0) {
                    String where = DbBoat.colNames[DbBoat.COL_TRACKER_ID] + "=" + boat.getTrackerId()
                            + " and "+DbBoat.colNames[DbBoat.COL_OID] + "!=" + boat.getOID()
                            + " and (date_trunc('day', " + DbBoat.colNames[DbBoat.COL_TRACKER_START_DATE] + ") <= '" + JSPFormater.formatDate(boat.getTrackerStartDate(), "MMMM d, yyyy") + "'"
                            + " or date_trunc('day', " + DbBoat.colNames[DbBoat.COL_TRACKER_END_DATE] + ") <= '" + JSPFormater.formatDate(boat.getTrackerStartDate(), "MMMM d, yyyy") + "')";
                    String order = DbBoat.colNames[DbBoat.COL_TRACKER_END_DATE] + " desc";
                    Vector list = DbBoat.list(0, 0, where, order);
                    if(list.size() > 0) {
                        Boat bx = (Boat)list.get(0);
                        if(boat.getTrackerStartDate().before(bx.getTrackerEndDate()) || boat.getTrackerStartDate().equals(bx.getTrackerEndDate())) {
                            msgString = "Error, the SpotTrace Start Date is incorrect!"
                                    + " The previously boat " + bx.getName() + " (" + bx.getHomePort() + ")"
                                    + " ended on " + JSPFormater.formatDate(bx.getTrackerEndDate(), "MMMM d, yyyy") + "!";
                            return RSLT_EST_CODE_EXIST;
                        }
                    }
                }

                if (boat.getOID() == 0) {
                    try {
                        long oid = dbBoat.insertExc(this.boat);
                        if(oid != 0) {
                            this.boat.setOID(oid);
                            oid = dbBoat.updateExc(this.boat);
                        }
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.ADD, DbBoat.DB_BOAT, oid, oidUser);
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
                        long oid = dbBoat.updateExc(this.boat);
                        msgString = JSPMessage.getMsg(JSPMessage.MSG_SAVED);
                        DbLogsAction.insertLogs(JSPCommand.UPDATE, DbBoat.DB_BOAT, oid, oidUser);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                DbBoat.generateXML();
                break;

            case JSPCommand.EDIT:
                if (oidBoat != 0) {
                    try {
                        boat = DbBoat.fetchExc(oidBoat);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.ASK:
                if (oidBoat != 0) {
                    try {
                        boat = DbBoat.fetchExc(oidBoat);
                    } catch (CONException dbexc) {
                        excCode = dbexc.getErrorCode();
                        msgString = getSystemMessage(excCode);
                    } catch (Exception exc) {
                        msgString = getSystemMessage(I_CONExceptionInfo.UNKNOWN);
                    }
                }
                break;

            case JSPCommand.DELETE:
                if (oidBoat != 0) {
                    try {
                        long oid = DbBoat.deleteExc(oidBoat);
                        if (oid != 0) {
                            msgString = JSPMessage.getMessage(JSPMessage.MSG_DELETED);
                            excCode = RSLT_OK;
                            DbLogsAction.insertLogs(JSPCommand.DELETE, DbBoat.DB_BOAT, oid, oidUser);
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
