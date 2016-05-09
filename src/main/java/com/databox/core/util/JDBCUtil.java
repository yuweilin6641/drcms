package com.databox.core.util;

import java.util.Collection;
import java.util.Iterator;

import org.apache.commons.lang.StringUtils;

public class JDBCUtil {
  /**
   * escape sql reserved word "'" with "''"
   *
   * @param sqlString string.
   * @return escaped sql string
   */
  public static String escapeSql(String sqlString) {
    StringBuffer returnString = new StringBuffer();
    for (int i = 0; i < sqlString.length(); i++) {
      char c = sqlString.charAt(i);
      switch (c) {
        case '\'':
          returnString.append('\'');
          break;
        default:
          break;
      }
      returnString.append(c);
    }
    return returnString.toString();
  }
  
	 /**
   * get in sql string.
   * @param   s      original string
   * @return  sql string
   */
  public static String toSqlInString(String s) {
      if (StringUtils.isNotEmpty(s) && !s.equals("null")) {
          if(s.indexOf("*")==-1){
          	return " '" + s.replaceAll("'", "''").replaceAll(",", "','") + "' ";
          } else {
          	return " '' ";
          }
          
      } else {
          return " '' ";
      }
  }
  
  public static String stringToStringSplit(String st) {
	  return JDBCUtil.stringToStringSplit(st, 0, "0");
  }
  
  /**
   * @param st
   * @param padSize
   * @param padChar
   * @return
   */
  public static String stringToStringSplit(String st,int padSize,String padChar) {
      String[] stringArray = st.split(",");
      StringBuffer sb = new StringBuffer();
      for (int i = 0; i < stringArray.length; i++) {
          sb.append("'").append(StringUtils.leftPad(stringArray[i].trim(), padSize, padChar)).append("'");
          if (i < (stringArray.length - 1)) {
              sb.append(",");
          }
      }
      return sb.toString();
  }
  
  /**
   * @param st
   * @param padSize
   * @param padChar
   * @return
   */
  public static String stringToStringSplit(String st,int padSize) {
	  return JDBCUtil.stringToStringSplit(st, padSize, "0");
  }
  
  
  /**
   * Generate string for List interface (mainly for SQL in statement)
   * Expected to compatiable with Type String and none String object list
   * @param collection List
   * @return String
   */
  public static String toSqlInString(Collection<?> collection) {
      StringBuffer sb = new StringBuffer();
      if(collection==null){
      	return sb.toString();
      }
      else{
      	boolean isString = false;
          for(Iterator<?> i = collection.iterator(); i.hasNext();){
          	sb.append(",");
          	Object obj = i.next();
          	isString = obj instanceof String;
              if (isString) {
                  sb.append("'");
              }
              sb.append(obj.toString());
              if (isString) {
                  sb.append("'");
              }
          }
          return sb.substring(1);
      }
  }
  
  
  
  
}
