package com.databox.drcms.web.controller;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.databox.common.auth.Roles;
import com.databox.common.auth.Users;
import com.databox.core.dao.criteria.PagingParameter;
import com.databox.drcms.model.UserProfileService;
import com.databox.drcms.web.model.JQResponse;

@Controller
@RequestMapping("/userManagement")
public class UserManagementController {
	
	@Autowired
	private UserProfileService userProfileService;
	
	@RequestMapping(produces = "text/html", method = RequestMethod.GET)
	public String home(HttpServletRequest req, HttpServletResponse resp) {
		return "W2_datacenter_userManagementHome";
	}
	
	@RequestMapping(value = "/add", method = RequestMethod.GET)
	public String useradd(HttpServletRequest req, HttpServletResponse resp) {
		return "W2_datacenter_userAdd";
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public @ResponseBody
	JQResponse getList(
			@RequestParam(value = "account", required = false) String account,
			@RequestParam(value = "role", required = false) String role,
			@RequestParam(value = "page", required = false) int page,
			@RequestParam(value = "rows", required = false) int rows,
			@RequestParam(value = "queryChange", required = false) boolean queryChange)
			throws ParseException {

		if (queryChange) page = 1;

		return userProfileService.findByQuery(account, role, PagingParameter.pageIndexAt(page, rows));
	}
	
	// create new User
	@RequestMapping(value = "/updateUser", method = RequestMethod.POST)
	public @ResponseBody String addNewUser(Users users,
			@RequestParam(value = "rolesId") List<Integer> rolesId) {
		
		List<Roles> list = new ArrayList<Roles>();
		
		for ( int id : rolesId ) {
			Roles roles = new Roles();
			roles.setId(id);
			list.add(roles);
		}
		
		users.setRoles(list);
		
		userProfileService.updateUser(users);
		return "{ \"id\" : \"" + users.getId() + "\" }";
	}

	// get one user data
	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public @ResponseBody
	Users getUser(@PathVariable Integer id) {
		Users user = userProfileService.getAccountDtl(id);
		return user;
	}
	
	//delete user
	@RequestMapping(value="/deleteSubmit/{id}", method=RequestMethod.GET)
    public @ResponseBody boolean deleteUsers(@PathVariable Integer id) {
		userProfileService.removeUser(id);
		return true;
    }
	
}
