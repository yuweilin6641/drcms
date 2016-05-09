package com.databox.core.util;

import java.sql.Connection;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import javax.transaction.UserTransaction;

import org.apache.commons.lang.StringUtils;

/**
 * 
 * <p>
 * Title:
 * </p>
 * <p>
 * Description:
 * </p>
 * <p>
 * Copyright: Copyright (c) 2008
 * </p>
 * <p>
 * Company:
 * </p>
 * 
 * @author not attributable
 * @version 1.0
 */
public class JNDIUtils {
	
	private static final String JNDI_USERTRANSACTION = "javax.transaction.UserTransaction";

	/**
	 * Get a connection from connection pool. The caller is responsible for
	 * closing the connection when it is no longer needed.
	 * 
	 * @throws Exception
	 * @return Connection
	 */
	public static Connection getConnection() throws Exception {
		return getConnection(true);
	}

	/**
	 * Get a connection from connection pool with a boolean value to different
	 * 
	 * @param aUpdatable
	 *            boolean
	 * @throws Exception
	 * @return Connection
	 */
	public static Connection getConnection(boolean aUpdatable) throws Exception {
		PropertyFile config = PropertyRegistry.getInstance().getPropertyFile(
				"EMP");
		InitialContext ctx = getInitialContext();
		DataSource ds = (DataSource) ctx.lookup(config
				.getString("bnslink.db.dataSource"));
		return ds.getConnection();
	}

	/**
	 * 
	 * @throws Exception
	 * @return Connection
	 */
	public static Connection getCSISConnection() throws Exception {
		PropertyFile config = PropertyRegistry.getInstance().getPropertyFile(
				"EMP");
		InitialContext ctx = getInitialContext();
		DataSource ds = (DataSource) ctx.lookup(config
				.getString("csis.db.TXDataSource"));
		return ds.getConnection();
	}

	/**
	 * Lookup and returns an EJB home interface. The caller still needs to call
	 * PortableRemoteObject.narrow() to cast the return value into appropriate
	 * type.
	 * 
	 * @param aBeanLookupName
	 *            String
	 * @param aClass
	 *            Class
	 * @throws Exception
	 * @return Object
	 */
	public static Object JNDILookup(String aBeanLookupName, Class aClass)
			throws Exception {
		return ServiceLocator.getInstance().getService(aBeanLookupName, aClass);
	}

	/**
	 * reset JNDI cache data
	 * 
	 * @throws NamingException
	 */
	public static void reload() throws NamingException {
		ServiceLocator.getInstance().reset();
	}

	/**
	 * get Initial Context
	 * 
	 * @return InitialContext
	 */
	public static InitialContext getInitialContext() throws NamingException {
		Properties p = new Properties();

		PropertyFile config = PropertyRegistry.getInstance().getPropertyFile("EMP");

		p.put(Context.INITIAL_CONTEXT_FACTORY, config.getString("bnslink.jndi.initialContextFactory"));
		p.put(Context.PROVIDER_URL, config.getString("bnslink.jndi.providerURL"));
		String jbossPrefixes = config.getString("bnslink.jndi.URL_PKG_PREFIXES");
		if(StringUtils.isNotEmpty(jbossPrefixes)){
			p.put(Context.URL_PKG_PREFIXES, jbossPrefixes);
		}
		InitialContext ctx = new InitialContext(p);
		return ctx;

	}

	public static UserTransaction getUserTransaction() throws Exception {
		InitialContext initialContext = getInitialContext();
		return (UserTransaction) initialContext.lookup(JNDI_USERTRANSACTION);
	}

}
