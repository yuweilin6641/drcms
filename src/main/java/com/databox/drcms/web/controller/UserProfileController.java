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
import com.databox.drcms.model.UserProfile;
import com.databox.drcms.model.UserProfileService;


@Controller
@RequestMapping("/userprofile")
public class UserProfileController {
	protected static Logger logger = Logger.getLogger(UserProfileController.class);
	
	@Autowired
	private UserProfileService userProfileService;
	
	@RequestMapping(produces = "text/html", method = RequestMethod.GET)
	public String home(HttpServletRequest req, HttpServletResponse resp) {
		return "W2_datacenter_userProfileHome";
	}
	
	@RequestMapping(value = "/userInfo", method = RequestMethod.GET)
	public @ResponseBody UserProfile userDtl(){
		
		UserProfile userProfile = new UserProfile();
		String account = SecurityUtil.getCurrentUser().getUsername();
		Users users = userProfileService.getAccountDtl(account);
		
		userProfile.setAccount(users.getAccount());
		userProfile.setEmail(users.getEmail());
		userProfile.setFirstName(users.getFirstName());
		userProfile.setLastName(users.getLastName());
		userProfile.setMiddleName(users.getMiddleName());
		userProfile.setPhoneWork(users.getPhoneWork());
		userProfile.setPhoneCell(users.getPhoneCell());
		
		return userProfile;
	}
	
	
	@RequestMapping(value = "/applyChange", method = RequestMethod.POST)
	public @ResponseBody boolean applyChange( 
			@RequestParam(value = "firstName") String firstName, 
			@RequestParam(value = "lastName") String lastName, 
			@RequestParam(value = "email") String email, 
			@RequestParam(value = "phoneWork") String phoneWork, 
			@RequestParam(value = "phoneCell") String phoneCell ) {
		
		String account = SecurityUtil.getCurrentUser().getUsername();
		Users users = userProfileService.getAccountDtl(account);
		
		users.setFirstName(firstName);
		users.setLastName(lastName);
		users.setEmail(email);
		users.setPhoneWork(phoneWork);
		users.setPhoneCell(phoneCell);
		userProfileService.updateUser(users);
		
		return true;
	}
	
	
}
