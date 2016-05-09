package com.databox.core.util;

import java.util.HashMap;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.rmi.PortableRemoteObject;

/**
 *
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2008</p>
 * <p>Company: </p>
 * @author not attributable
 * @version 1.0
 */
public class ServiceLocator {
    /**
     * Singleton Instance of this class
     */
    private static ServiceLocator serviceLocator = null;

    /**
     * InitialContext object
     */
    InitialContext context = null;

    /**
     * Cache where the objects can be stored for later retrieval.
     * This enhances the performance.
     */
    HashMap serviceCache = null;

    /**
     * Constructor to initialize the class
     *
     * @exception NamingException In case an exception is generated
     */
    private ServiceLocator() throws NamingException {
      // Start the initial context
      Properties p = new Properties();
      PropertyFile config = PropertyRegistry.getInstance().getPropertyFile("EMP");

      p.put(Context.INITIAL_CONTEXT_FACTORY,
            config.getString("bnslink.jndi.initialContextFactory"));
      p.put(Context.PROVIDER_URL,
            config.getString("bnslink.jndi.providerURL"));
      context = new InitialContext(p);

      //context = new InitialContext();

      serviceCache = new HashMap();
    }

    /**
     * Returns the singleton instance
     *
     * @exception NamingException In case an exception is generated
     * @return Singleton Instance
     */
    public static ServiceLocator getInstance() throws NamingException {
      if (serviceLocator == null) {
        // If the object is not created, then create it
        serviceLocator = new ServiceLocator();
      }

      // Return the singleton instance
      return serviceLocator;
    }

    /**
     * This is the method that returns the service
     *
     * @param jndiName JNDI Lookup needed for invoking the service
     * @exception NamingException In case an exception is generated
     * @return Service Object
     */
    public Object getService(String jndiName, Class aclass) throws NamingException {
      if (!serviceCache.containsKey(jndiName)) {
        // If the object is not saved in the cache, then do a lookup and save it
        serviceCache.put(jndiName, context.lookup(jndiName));
      }

      // Return the required object
      return PortableRemoteObject.narrow(serviceCache.get(jndiName), aclass);
      //return serviceCache.get(jndiName);
    }

    public void reset() {
       serviceCache = null;
       serviceCache = new HashMap();
    }


}
