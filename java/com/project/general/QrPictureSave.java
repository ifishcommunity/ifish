package com.project.general;

import com.project.IFishConfig;
import com.project.util.blob.ImageLoader;
import com.project.util.jsp.JSPMessage;
import java.io.ByteArrayInputStream;
import java.io.InputStream;

public class QrPictureSave {

    private static String APP_PATH = DbSystemProperty.getValueByName("APP_PATH");
    public static final String JSP_USER_PICTURE = "JSP_USER_PICTURE";

    public QrPictureSave() {
    }

    public static int updateImage(Object obj, long oid, int idx) {
        try {
            if (obj == null) {
                return -1;
            }
            byte b[] = null;
            b = (byte[]) obj;

            ByteArrayInputStream ins;
            ins = new ByteArrayInputStream(b);

            int i = ImageLoader.writeCache((InputStream) ins, APP_PATH + oid + "_" + idx, true);

        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return 0;
    }

    public static int updateImage(Object obj, String imageName) {
        try {
            if (obj == null) {
                return -1;
            }
            byte b[] = null;
            b = (byte[]) obj;

            ByteArrayInputStream ins;
            ins = new ByteArrayInputStream(b);

            int i = deleteImage(imageName);
            i = ImageLoader.writeCache((InputStream) ins, APP_PATH + IFishConfig.IMG_PATH + System.getProperty("file.separator") + imageName + IFishConfig.IMG_EXTENSIONS, true);
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return 0;
    }

    public static int deleteImage(long oid, int idx) {
        try {
            ImageLoader.deleteChace(APP_PATH + oid + "_" + idx);

            return JSPMessage.MSG_DELETED;

        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;

    }

    public static int deleteImage(String imageName) {
        try {
            ImageLoader.deleteChace(APP_PATH + IFishConfig.IMG_PATH + System.getProperty("file.separator") + imageName + IFishConfig.IMG_EXTENSIONS);
            return JSPMessage.MSG_DELETED;
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        return -1;
    }
}
