package com.project.main.db;

// import java
import com.project.main.entity.I_CONExceptionInfo;

import java.sql.SQLException;

public class CONException extends Exception implements I_CONExceptionInfo
{

    protected CONHandler conHandler;
    protected int errorIndex;
    protected SQLException SQLEx;
    protected Exception Ex;

    public CONException(CONHandler dbhandler, int i)
    {
        conHandler = dbhandler;
        errorIndex = i;
    }

    public CONException(CONHandler dbhandler, Exception exception)
    {
        conHandler = dbhandler;
        Ex = exception;
        errorIndex = UNKNOWN;
    }

    public CONException(CONHandler dbhandler, SQLException sqlexception)
    {
        conHandler = dbhandler;
        SQLEx = sqlexception;
        errorIndex = parseSQLErrIdx(SQLEx);
    }

    public static int parseSQLErrIdx(SQLException sqlexception) {
           String sqlErr =  sqlexception.getMessage();

           final String  SQL_DUPLICATE_KEY = "Duplicate entry";
           final String  SQL_COLUMN_NOT_FOUND = "Column not found";
           final String  SQL_DELETE_RESTRICT = "foreign key constraint fails";

           int checkStr =sqlErr.indexOf(SQL_DUPLICATE_KEY);
           if (checkStr >-1)
            	return  MULTIPLE_ID;

           checkStr =sqlErr.indexOf(SQL_COLUMN_NOT_FOUND);
           if (checkStr >-1)
            	return COLUMN_NOT_FOUND ;

           checkStr =sqlErr.indexOf(SQL_DELETE_RESTRICT);
           if (checkStr >-1)
            	return DEL_RESTRICTED ;

          return SQL_ERROR;
    }

    public int getErrorCode()
    {
        return errorIndex;
    }

    public String getMessage()
    {
        String s = "";
        if(conHandler != null)
            s = s + "[Table: " + conHandler.getCONTableName() + "] ";
        s = s + errorMsg[errorIndex];
        if(errorIndex == SQL_ERROR || errorIndex == UNKNOWN)
            s = s + SQLEx.getMessage();
        return s;
    }

    public int getSQLErrorCode()
    {
        if(errorIndex == SQL_ERROR)
            return SQLEx.getErrorCode();
        else
            return -1;
    }

}
