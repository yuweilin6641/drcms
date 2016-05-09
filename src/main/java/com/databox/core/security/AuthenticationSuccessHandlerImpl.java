package com.databox.core.security;

import java.io.IOException;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;

import com.databox.common.auth.Functions;
import com.databox.common.auth.UserService;
import com.databox.common.auth.Users;

public class AuthenticationSuccessHandlerImpl extends SimpleUrlAuthenticationSuccessHandler {
	
	@Autowired
	private UserService userService;

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		String userAccount = SecurityUtil.getCurrentUser().getUsername();
		Users user = userService.findByAccount(userAccount);
		request.getSession().setAttribute("LOGIN_USER", user);
		request.getSession().setAttribute("LOGIN_ACCOUNT", userAccount);
		List<Functions> functions = userService.findFunctions(userAccount);
		Set<String> functionSet = new HashSet<String>();
		for(Iterator<Functions> i= functions.iterator(); i.hasNext();){
			Functions function = i.next();
			String functionName = function.getFunctionName();
			functionSet.add(functionName);
		}
		request.getSession().setAttribute("FUNCTIONS", functionSet);
		
		Set<String> roleSet = new HashSet<String>();
		Collection<? extends GrantedAuthority> roles = SecurityContextHolder.getContext().getAuthentication().getAuthorities();
		for(Iterator<? extends GrantedAuthority> i= roles.iterator(); i.hasNext();){
			GrantedAuthority role = i.next();
			String roleName = role.getAuthority();
			roleSet.add(roleName);
		}
		request.getSession().setAttribute("USER_ROLES", roleSet);
		super.onAuthenticationSuccess(request, response, authentication);
	}

}
