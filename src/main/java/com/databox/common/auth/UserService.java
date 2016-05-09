package com.databox.common.auth;

import java.util.List;

import com.databox.core.service.EntityService;

public interface UserService extends EntityService<Users, Integer> {

	Users findByAccount(String userAccount);
	List<Functions> findFunctions(String userAccount);
	List<Users> findByRole(String roleName);
	
}
