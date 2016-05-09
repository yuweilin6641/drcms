package com.databox.core.util.spring;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * @author sam.lin
 *
 */
public class SpringInit implements ServletContextListener {
	private static WebApplicationContext springContext;

	
	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		springContext = null;
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		springContext = WebApplicationContextUtils.getWebApplicationContext(event.getServletContext());
	}
	
	public static ApplicationContext getApplicationContext() {
        return springContext;
    }

}
