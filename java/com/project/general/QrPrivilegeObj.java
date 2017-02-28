package com.project.general;

import java.util.Vector;

public class QrPrivilegeObj {

    /** Creates new SessCOLPrivilegeObj */
    public QrPrivilegeObj() {
    }

    public static boolean existCode(Vector codes, int code) {
        if ((codes == null) || (codes.size() < 1)) {
            return false;
        }

        for (int i = 0; i < codes.size(); i++) {
            if (code == ((Integer) codes.get(i)).intValue()) {
                return true;
            }
        }

        return false;
    }
}
