package com.databox.drcms.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.databox.common.auth.Users;
import com.databox.core.security.SecurityUtil;
import com.databox.drcms.model.UserProfileService;


@Controller
@RequestMapping("/password")
public class PasswordController {
	protected static Logger logger = Logger.getLogger(PasswordController.class);
	
	@Autowired
	private UserProfileService userProfileService;
	
	@RequestMapping(produces = "text/html", method = RequestMethod.GET)
	public String home(HttpServletRequest req, HttpServletResponse resp) {
		return "W2_datacenter_passwordHome";
	}
	
	
	@RequestMapping(value = "/changePasswd", method = RequestMethod.POST)
	public @ResponseBody boolean ChangePasswd(
			@RequestParam(value = "currentPasswd") String currentPasswd, 
			@RequestParam(value = "newPasswd") String newPasswd){
		
		String account = SecurityUtil.getCurrentUser().getUsername();
		Users users = userProfileService.getAccountDtl(account);
		
		if ( currentPasswd.equals(users.getUserPassword()) ) {
			users.setUserPassword(newPasswd);
			userProfileService.updateUser(users);
			return true;
		}
		else {
			return false;
		}
	}
	
}
