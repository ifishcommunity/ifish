package com.project.general;

import com.project.util.jsp.I_JSPInterface;
import com.project.util.jsp.I_JSPType;
import com.project.util.jsp.JSPHandler;
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author gwawan
 */
class JspGroupDetail extends JSPHandler implements I_JSPInterface, I_JSPType {

    private GroupDetail groupDetail;
    public static final String JSP_GROUP_DETAIL = "JSP_GROUP_DETAIL";
    
    public static final int JSP_GROUP_DETAIL_ID = 0;
    public static final int JSP_GROUP_ID = 1;
    public static final int JSP_MN_1 = 2;
    public static final int JSP_MN_2 = 3;
    public static final int JSP_CMD_ADD = 4;
    public static final int JSP_CMD_EDIT = 5;
    public static final int JSP_CMD_VIEW = 6;
    public static final int JSP_CMD_DELETE = 7;
    public static final int JSP_CMD_PRINT = 8;
    public static final int JSP_CMD_POSTING = 9;
    
    
    public static String[] colNames = {
        "JSP_GROUP_DETAIL_ID",
        "JSP_GROUP_ID",
        "JSP_MN_1",
        "JSP_MN_2",
        "JSP_CMD_ADD",
        "JSP_CMD_EDIT",
        "JSP_CMD_VIEW",
        "JSP_CMD_DELETE",
        "JSP_PRINT",
        "JSP_POSTING"
    };
    public static int[] fieldTypes = {
        TYPE_LONG,
        TYPE_LONG,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT,
        TYPE_INT
    };

    public JspGroupDetail() {
    }

    public JspGroupDetail(GroupDetail GroupDetail) {
        this.groupDetail = GroupDetail;
    }

    public JspGroupDetail(HttpServletRequest request, GroupDetail GroupDetail) {
        super(new JspGroupDetail(GroupDetail), request);
        this.groupDetail = GroupDetail;
    }

    public String getFormName() {
        return JSP_GROUP_DETAIL;
    }

    public int[] getFieldTypes() {
        return fieldTypes;
    }

    public String[] getFieldNames() {
        return colNames;
    }

    public int getFieldSize() {
        return colNames.length;
    }

    public GroupDetail getEntityObject() {
        return groupDetail;
    }

    public void requestEntityObject(GroupDetail GroupDetail) {
        try {
            this.requestParam();
            GroupDetail.setGroupId(getLong(JSP_GROUP_ID));
            GroupDetail.setMn1(getInt(JSP_MN_1));
            GroupDetail.setMn2(getInt(JSP_MN_2));
            GroupDetail.setCmdAdd(getInt(JSP_CMD_ADD));
            GroupDetail.setCmdEdit(getInt(JSP_CMD_EDIT));
            GroupDetail.setCmdView(getInt(JSP_CMD_VIEW));
            GroupDetail.setCmdDelete(getInt(JSP_CMD_DELETE));
            GroupDetail.setCmdEdit(getInt(JSP_CMD_PRINT));
            GroupDetail.setCmdView(getInt(JSP_CMD_POSTING));
        } catch (Exception e) {
            System.out.println("[Exception] " + e.toString());
        }
    }
}
