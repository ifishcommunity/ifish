package com.project.main.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class CONResultSet {

    private CONConnectionBroker connPool = null;
    private Connection connection = null;
    private Statement statement = null;
    private PreparedStatement pStatement = null;
    private ResultSet resultSet = null;

    public CONResultSet(CONConnectionBroker cPool, Connection conn, Statement stmt, ResultSet rs) {
        this.connPool = cPool;
        this.connection = conn;
        this.statement = stmt;
        this.resultSet = rs;
    }

    public CONResultSet(CONConnectionBroker cPool, Connection conn, PreparedStatement dbmt, ResultSet rs) {
        this.connPool = cPool;
        this.connection = conn;
        this.pStatement = dbmt;
        this.resultSet = rs;
    }

    public Connection getConnection() {
        return this.connection;
    }

    public Statement getStatement() {
        return this.statement;
    }

    public PreparedStatement getPreparedStatement() {
        return this.pStatement;
    }

    public ResultSet getResultSet() {
        return this.resultSet;
    }

    public static void close(CONResultSet conrs) {
        if (conrs == null) {
            return;
        }

        try {
            conrs.closeResultSet();
        } catch (Exception rsExc) {
            rsExc.printStackTrace(System.err);
        }
        try {
            conrs.closeStatement();
        } catch (Exception StExc) {
            StExc.printStackTrace(System.err);
        }
        try {
            conrs.closeConnection();
        } catch (Exception ConExc) {
            ConExc.printStackTrace(System.err);
        }
    }

    public static void closePstmt(CONResultSet conrs) {
        if (conrs == null) {
            return;
        }

        try {
            conrs.closeResultSet();
        } catch (Exception exc) {
            exc.printStackTrace(System.err);
        }
        try {
            conrs.closePreparedStatement();
        } catch (Exception exc1) {
            exc1.printStackTrace(System.err);
        }
        try {
            conrs.closeConnection();
        } catch (Exception exc2) {
            exc2.printStackTrace(System.err);
        }
    }

    public void closeConnection()
            throws SQLException {
        try {
            if (connection != null) {
                int i = connPool.idOfConnection(connection);
                connPool.freeConnection(connection);
                //dbLog.info("Released connection no. " + i);
            }
        } catch (Exception exception) {
            exception.printStackTrace(System.err);
            throw new SQLException("DBResutSet.closeConnection() " + exception.toString());
        }
    }

    public void closeStatement()
            throws SQLException {
        try {
            if (statement != null) {
                statement.close();
                //dbLog.info("Closed a statement: " + statement.toString());
            }
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new SQLException("DBResutSet.closeStatement() " + sqlexception.toString());
        }
    }

    public void closePreparedStatement()
            throws SQLException {
        try {
            if (pStatement != null) {
                pStatement.close();
                //dbLog.info("Closed a statement: " + statement.toString());
            }
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new SQLException("DBResutSet.closePreparedStatement() " + sqlexception.toString());
        }
    }

    public void closeResultSet()
            throws SQLException {
        try {
            if (resultSet != null) {
                resultSet.close();
                //dbLog.info("Closed a statement: " + statement.toString());
            }
        } catch (SQLException sqlexception) {
            sqlexception.printStackTrace(System.err);
            throw new SQLException("DBResutSet.closeResultSet() " + sqlexception.toString());
        }
    }
} // end of CONResultSet
