package com.databox.core.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.ConfigAttribute;
import org.springframework.security.access.SecurityConfig;
import org.springframework.security.web.FilterInvocation;
import org.springframework.security.web.access.intercept.FilterInvocationSecurityMetadataSource;
import org.springframework.security.web.util.AntPathRequestMatcher;
import org.springframework.security.web.util.RequestMatcher;


public class MyInvocationSecurityMetadataSource implements
		FilterInvocationSecurityMetadataSource {
	
	private static Map<String, Collection<ConfigAttribute>> resourceMap = null;
	
	protected static Logger logger = Logger.getLogger(MyInvocationSecurityMetadataSource.class);

	
	public MyInvocationSecurityMetadataSource(SecurityDAO securityDAO) {
		loadResourceDefine(securityDAO);
	}

	private void loadResourceDefine(SecurityDAO securityDAO) {
		resourceMap = new HashMap<String, Collection<ConfigAttribute>>();
		List<Resources> list = securityDAO.findAllResourceToRole();
		for(Resources resource : list){
			if(resourceMap.containsKey("/"+resource.getUrl())){
				Collection<ConfigAttribute> atts = resourceMap.get("/"+resource.getUrl());
				atts.add(new SecurityConfig("ROLE_" + resource.getRoleName()));
			}
			else{
				Collection<ConfigAttribute> atts = new ArrayList<ConfigAttribute>();
				atts.add(new SecurityConfig("ROLE_" + resource.getRoleName()));
				resourceMap.put("/"+resource.getUrl(), atts);
			}
		}
	}

	// According to a URL, Find out permission configuration of this URL.
	public Collection<ConfigAttribute> getAttributes(Object object)
			throws IllegalArgumentException {
		HttpServletRequest requesat = ((FilterInvocation) object).getHttpRequest();
		Iterator<String> ite = resourceMap.keySet().iterator();
		while (ite.hasNext()) {
			String resURL = ite.next();
			RequestMatcher urlMatcher = new AntPathRequestMatcher(resURL);
			if (urlMatcher.matches(((FilterInvocation) object).getHttpRequest())) {
				return resourceMap.get(resURL);
			}
		}
		logger.warn("getAttributes() no right:" + requesat.getRequestURL().toString());
		throw new AccessDeniedException("getAttributes() no right:"+requesat.getRequestURL().toString());
//		Collection<ConfigAttribute> atts = new ArrayList<ConfigAttribute>();
//		atts.add(new SecurityConfig("ROLE_FORBIDDEN"));
//		return atts;
	}

	public boolean supports(Class<?> clazz) {
		return true;
	}

	public Collection<ConfigAttribute> getAllConfigAttributes() {
		return null;
	}

}
