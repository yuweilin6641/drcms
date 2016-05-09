package com.databox.core.util;

import java.io.File;
import java.io.FilenameFilter;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;

public class PropertyRegistry {
	private Map<String, PropertyFile> propertyFileMap;
	private static PropertyRegistry instance;
	private static Logger logger = Logger.getLogger(PropertyRegistry.class);

	private PropertyRegistry() {
		propertyFileMap = new HashMap<String, PropertyFile>();
	}

	/**
	 * get PropertyRegistry single instance
	 * 
	 * @return PropertyRegistry
	 */
	public static synchronized PropertyRegistry getInstance() {
		if (instance == null) {
			instance = new PropertyRegistry();
			instance.initialize();
		}
		return instance;
	}

	/**
	 * initial all resources directory propert file
	 */

	private void initialize() {
		PropertyFile propertyFile = new PropertyFile("EMP");

		String configdir = propertyFile.getString("resource.path");
		logger.info("PropertyRegistry.initialize defalut dir is " + configdir);
		File dir = new File(configdir);
		if (dir.exists()) {
			String[] list = dir.list(new DirFilter());
			for (int i = 0; i < list.length; i++) {
				int index = list[i].indexOf(".properties");
				String propname = list[i].substring(0, index);
				propertyFileMap.put(propname, new PropertyFile(propname));
			}
		}
		else{
			logger.warn("PropertyRegistry.initialize() can't find directory:"+configdir);
		}
		
	}

	/**
	 * added new PropertyFile instance to PropertyRegistry
	 * 
	 * @param configname
	 *            String
	 * @param config
	 *            PropertyFile
	 */
	public void addConfiguration(String configname, PropertyFile config) {
		propertyFileMap.put(configname, config);
	}

	/**
	 * remove propertyFile instance
	 * 
	 * @param configname
	 *            String
	 */
	public void removeConfiguration(String configname) {
		PropertyFile config = (PropertyFile) propertyFileMap.get(configname);
		if (config != null) {
			propertyFileMap.remove(configname);
		}
	}

	public PropertyFile getPropertyFile(String propertyKey) {
		PropertyFile propertyFile = propertyFileMap.get(propertyKey);
		if(propertyFile==null){
			propertyFile =  new PropertyFile(propertyKey);
			propertyFileMap.put(propertyKey, propertyFile);
		}
		return propertyFile;
	}

	/**
	 * <p>
	 * Title: DirFilter.java
	 * </p>
	 * 
	 * <p>
	 * Description: subclass for filter of directory,this subclass is implement
	 * filter interface, directory file list filter
	 * </p>
	 */
	static class DirFilter implements FilenameFilter {
		String pattern = "^\\w+.properties$";

		public boolean accept(File dir, String name) {
			// Strip path information:
			String filename = new File(name).getName();
			Pattern p = Pattern.compile(pattern);
			Matcher matcher = p.matcher(filename);
			boolean matchFound = matcher.find();
			if (matchFound == true) {
				if (filename.startsWith("i18n"))
					matchFound = false;
			}
			return matchFound;
		}

	}

}
