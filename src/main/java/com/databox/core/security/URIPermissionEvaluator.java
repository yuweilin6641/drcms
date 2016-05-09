package com.databox.core.security;

import java.io.Serializable;

import org.springframework.security.access.PermissionEvaluator;
import org.springframework.security.core.Authentication;

public class URIPermissionEvaluator implements PermissionEvaluator {
	private SecurityDAO securityDAO = null;
	
	public URIPermissionEvaluator(SecurityDAO securityDAO) {
		this.securityDAO = securityDAO;
	}

	public boolean hasPermission(Authentication authentication,
			Object targetDomainObject, Object permission) {
		// TODO Auto-generated method stub
		String name = authentication.getName();
		System.out.println("hasPermission : "+name);
		return true;
	}

	public boolean hasPermission(Authentication authentication,
			Serializable targetId, String targetType, Object permission) {
		// TODO Auto-generated method stub
		String name = authentication.getName();
		System.out.println("hasPermission : "+name);
		return true;
	} 

}
