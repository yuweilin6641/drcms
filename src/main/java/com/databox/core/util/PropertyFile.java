package com.databox.core.util;

import java.text.MessageFormat;
import java.util.Enumeration;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;

/**
 * @version 1.0
 */
public class PropertyFile {
	private static final Logger logger = Logger.getLogger(PropertyFile.class);
	private ResourceBundle iResources;

	/**
	 * Creates a new PropertyFile, given the property name to read from.
	 * 
	 * @param aFileSpec String
	 */
	public PropertyFile(String aFileSpec) {
		try {
			iResources = ResourceBundle.getBundle(aFileSpec, Locale
					.getDefault());
		} catch (MissingResourceException mre) {
			logger.error(aFileSpec + ".properties not found");
		}
	}

	/**
	 * Returns a string value from a resource key. If the key can't be found,
	 * the key is returned as value (so we known which key is missing)
	 * 
	 * @param aKey String
	 * @return String
	 */
	public String getString(String aKey) {
		String str = null;

		try {
			str = iResources.getString(aKey);
		} catch (MissingResourceException mre) {
			str = aKey;
			logger.error("resource " + aKey + " not found!");
		}
		return str;
	}

	/**
	 * Parameterized message with one argument.
	 * 
	 * @param aKey String
	 * @param aParam1 String
	 * @return String
	 */
	public String getString(String aKey, String aParam1) {
		Object[] args = { aParam1 };
		String message = getString(aKey);

		return MessageFormat.format(message, args);
	}

	public Enumeration<String> getKeys() {
		return iResources.getKeys();
	}

	/**
	 * Parameterized message with multiple argument. The second argument is an
	 * array of strings. The order of the strings must match the order of
	 * parameters in the message.
	 * 
	 * @param aKey String
	 * @param aParams Object[]
	 * @return String
	 */
	public String getString(String aKey, Object[] aParams) {
		String message = getString(aKey);

		return MessageFormat.format(message, aParams);
	}
}
