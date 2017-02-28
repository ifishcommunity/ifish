package com.project.general;

public class SystemProperty extends com.project.main.entity.Entity {

    private String name = "";
    private String value = "";
    private String valType = "";//value type, e.g. TEXT, INTEGER
    private String note = "";

    public SystemProperty() {
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        name = name.toUpperCase();
        this.name = name.replace(' ', '_');
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getValueType() {
        return valType;
    }

    public void setValueType(String type) {
        this.valType = type;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}

