package com.databox.core.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

/**
 * This is a utility class for DBMS sequence.  This class is used by entity bean class to get database sequence.
 */
public class SequenceUtils {
	protected static Logger log = Logger.getLogger(UUIDHexGenerator.class);
    /**
     * Retrieve the next sequence by specified sequence name.  The sequence name allows different table
     * to have different sequence number.
     *
     * @param            aSequeceName dbms sequece name.
     * @return           return value -1 if any error.
     */
    public static int getNextSequence(String aSequenceName) {
        String sql = "SELECT " + aSequenceName + ".NEXTVAL FROM DUAL";
        return getSequence(sql);
    }

    /**
     * Retrieve the current sequence by specified sequence name.
     *
     * @param            aSequeceName dbms sequece name.
     * @return           return value -1 if any error.
     */
    public static int getCurrentSequence(String aSequenceName) {
        String sql = "SELECT " + aSequenceName + ".CURRVAL FROM DUAL";
        return getSequence(sql);
    }

    /**
     * Retrieve squence number from dbms with given sql claus.  This method is used by method getNextSequence()
     * and getCurrentSequence().
     *
     * @param            aSql sql string
     * @return           return value -1 if any error.
     */
    public static int getSequence(String aSql) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet result = null;
        int value = -1;

        try {
            conn = JNDIUtils.getConnection();
            stmt = conn.createStatement();
            result = stmt.executeQuery(aSql);
            while (result.next()) {
                value = result.getInt(1);
                break;
            }
        } catch (SQLException ex) {
            log.error(sqlError(ex, aSql), ex);
        } catch (NamingException ex) {
        	log.error("exception", ex);
        } catch (Exception ex) {
        	log.error("exception", ex);
        } finally {
            try {
                if (result != null) {
                    result.close();
                }
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ex) {
            	log.error("exception", ex);
            }
        }
        return value;
    }

    /**
     * Retrieve the reason why sql query failed.  This method is used by getSequence() to generate well formatted
     * sql error.
     *
     * @param            aEx SQLException.
     * @param            aSQL SQL string.
     * @return           reason why sql query failed.
     */
    public static String sqlError(SQLException aEx, String aSQL) {
        return "[SQL error] sql=" + aSQL + "\n\tcode="
                + aEx.getErrorCode() + " state="
                + aEx.getSQLState() + " message=" + aEx.getMessage();
    }
}
