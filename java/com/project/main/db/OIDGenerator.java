package com.project.main.db;

import java.util.Date;

public class OIDGenerator {

    private static int appIdx = CONHandler.APP_INDEX_WEB;
    private static OIDGenerator oidGenerator = null;
    static long lastOID = 0;

    public OIDGenerator() {
    }

    public OIDGenerator(int appIndex) {
        getOIDGenerator();
        appIdx = appIndex;
    }

    public static OIDGenerator getOIDGenerator() {
        if (oidGenerator == null) {
            oidGenerator = new OIDGenerator();
        }
        return oidGenerator;
    }

    public int getAppIndex() {
        return appIdx;
    }

    public void setAppIndex(int idx) {
        appIdx = idx;
    }

    synchronized public static long generateOID() {
        Date dateGenerated = new Date();
        long oid = dateGenerated.getTime() + (0x0100000000000000L * appIdx);
        while (lastOID == oid) {
            try {
                Thread.sleep(1);
            } catch (Exception e) {
            }
            dateGenerated = new Date();
            oid = dateGenerated.getTime() + (0x0100000000000000L * appIdx);
            //System.out.print("try oid="+oid);
        }
        //System.out.print("new oid="+oid);
        lastOID = oid;
        return oid;
    }
} // end of OIDGenerator

