package com.databox.core.security;

import java.util.List;

public interface SecurityDAO {
	public Users findUserByUserAccount(String userAccount);
	public List<Roles> findRoleByUserAccount(String userAccount);
	public List<Resources> findAllResourceToRole();
}
