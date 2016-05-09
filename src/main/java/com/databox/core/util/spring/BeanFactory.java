package com.databox.core.util.spring;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class BeanFactory {
    private static ApplicationContext context;

    public static Object getBean(String beanName) {
        if (context == null) {
        	newContextByServletContext();
        }
        
        try {
        	Object bean = context.getBean(beanName);
        	return bean;
			
		} catch (Exception e) {
			throw new RuntimeException("fail to get bean : "+beanName, e);
		}
    }
    private static synchronized void newContextByClasspath(String resource) {
        context = new ClassPathXmlApplicationContext(resource);
    }
    
    private static synchronized void newContextByServletContext() {
        context = SpringInit.getApplicationContext();
    }
}
