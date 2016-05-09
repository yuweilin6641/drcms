package com.databox.common.auth;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository("userDAO")
public interface UserDAO extends CrudRepository<Users, Integer> {
	Users findByAccount(String userAccount);
	List<Functions> findFunctionsByAccount(String userAccount);
	List<Users> namedQueryByRoleName(String roleName);
}
