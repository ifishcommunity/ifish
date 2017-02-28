

package com.project.main.db;

public interface I_CONInterface {
    
    public int getFieldSize();
    public String getTableName();
    public String[] getFieldNames();
    public int[] getFieldTypes();
    
    public String getPersistentName();
   
}
