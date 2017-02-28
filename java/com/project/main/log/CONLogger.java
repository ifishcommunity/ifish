package com.project.main.log;

import com.project.main.db.CONHandler;
import com.project.main.db.OIDGenerator;
import com.project.general.DbSystemProperty;
import java.util.Date;
import java.util.StringTokenizer;
import java.util.Vector;

public class CONLogger {

    public static final int OUT_TARGET_STDIO = 0;
    public static final int OUT_TARGET_FILE = 1;
    public static final int OUT_TARGET_RDBMS = 2;

    static final int CRITICAL_ERROR = 1;
    static final int ERROR = 2;
    static final int WARNING = 3;
    static final int INFO = 4;
    static final int TRACE = 5;

    public static String LOGS_STRING_DELIMETER = "^";

    String logfile;
    int loglevel;

    public CONLogger() {
    }

    public static void insertLogs(String queryString, String tableName) {
        try {
            switch (CONHandler.CONSVR_TYPE) {
                case CONHandler.CONSVR_MYSQL:
                    queryString = queryString.replace("'", "\\'");
                    break;
                case CONHandler.CONSVR_POSTGRESQL:
                    queryString = queryString.replace("'", "''");
                    break;
                default:
                    break;
            }

            if (notInExceptionTable(tableName)) {
                long log_id = OIDGenerator.generateOID();
                String sql = "insert into logs (log_id, query_string, table_name, date)"
                        + " values (" + log_id + ", '" + queryString + "','" + tableName + "','" + new Date() + "')";
                CONHandler.execUpdate(sql);
            }
        } catch (Exception e) {
            System.out.println(e.toString());
        }
    }

    public static boolean notInExceptionTable(String tableName) {
        String exceptTable = DbSystemProperty.getValueByName("NON_SYNCHRONIZED_TABLES");
        StringTokenizer strTok = new StringTokenizer(exceptTable, ",");
        Vector temp = new Vector();

        while (strTok.hasMoreTokens()) {
            temp.add((String) strTok.nextToken().trim());
        }

        if(tableName.equalsIgnoreCase("logs_action") || tableName.equalsIgnoreCase("logs")) {
            return false;
        }

        if (temp.size() > 0) {
            for (int i = 0; i < temp.size(); i++) {
                String s = (String) temp.get(i);
                if (s.equalsIgnoreCase(tableName)) {
                    return false;
                }
            }
        }

        return true;
    }
}
