package com.databox.core.util;

import java.net.InetAddress;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
/**
 *
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2008</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */
public class UUIDHexGenerator {
	private static final Log log = LogFactory.getLog(UUIDHexGenerator.class);
    private UUIDHexGenerator() {
    }

    private static UUIDHexGenerator generator = null;
    /**
     *
     * @param bytes byte[]
     * @return int
     */
    public static int toInt(byte[] bytes) {
        int result = 0;
        for (int i = 0; i < 4; i++) {
            result = (result << 8) - Byte.MIN_VALUE + (int) bytes[i];
        }
        return result;
    }
    /**
     *
     */
    private static final int IP;
    static {
        int ipadd;
        try {
            ipadd = toInt(InetAddress.getLocalHost().getAddress());
        } catch (Exception e) {
            ipadd = 0;
        }
        IP = ipadd;
    }

    private static short counter = (short) 0;
    private static final int JVM = (int) (System.currentTimeMillis() >>> 8);
    private String sep = "";

    /**
     * Unique across JVMs on this machine (unless they load this class
     * in the same quater second - very unlikely)
     *
     * @return int
     */
    protected int getJVM() {
        return JVM;
    }

    /**
     * Unique in a millisecond for this JVM instance (unless there
     * are > Short.MAX_VALUE instances created in a millisecond)
     *
     * @return short
     */
    protected short getCount() {
        synchronized (UUIDHexGenerator.class) {
            if (counter < 0) {
                counter = 0;
            }
            return counter++;
        }
    }

    /**
     * Unique in a local network
     *
     * @return int
     */
    protected int getIP() {
        return IP;
    }

    /**
     * Unique down to millisecond
     *
     * @return short
     */
    protected short getHiTime() {
        return (short) (System.currentTimeMillis() >>> 32);
    }
    /**
     *
     * @return int
     */
    protected int getLoTime() {
        return (int) System.currentTimeMillis();
    }

    /**
     *
     * @param intval int
     * @return String
     */
    protected String format(int intval) {
        String formatted = Integer.toHexString(intval);
        StringBuffer buf = new StringBuffer("00000000");
        buf.replace(8 - formatted.length(), 8, formatted);
        return buf.toString();
    }
    /**
     *
     * @param shortval short
     * @return String
     */
    protected String format(short shortval) {
        String formatted = Integer.toHexString(shortval);
        StringBuffer buf = new StringBuffer("0000");
        buf.replace(4 - formatted.length(), 4, formatted);
        return buf.toString();
    }
    /**
     *
     * @return Serializable
     */
    public String generate() {
        return new StringBuffer(36)
                .append(format(getHiTime())).append(sep)
                .append(format(getLoTime())).append(sep)
                .append(format(getCount()))
                .toString();
    }
    /**
     *
     * @return UUIDHexGenerator
     */
    synchronized public static UUIDHexGenerator getInstance(){
      if(generator == null){
        generator = new UUIDHexGenerator();
      }
      return generator;
    }

    public static void main(String[] args) throws Exception {
        UUIDHexGenerator gen = new UUIDHexGenerator();
        for (int i = 0; i < 1000; i++) {
            String id = (String) gen.generate();
            log.debug(id);
        }
    }
}
