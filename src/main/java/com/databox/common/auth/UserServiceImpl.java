package com.databox.common.auth;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("userService")
@Transactional
public class UserServiceImpl implements UserService {

	@Autowired
	private UserDAO userDAO;
	
	@Override
	public List<Users> findByRole(String roleName) {
		return userDAO.namedQueryByRoleName(roleName);
	}
	
	@Override
	public Users findByAccount(String userAccount) {
		return userDAO.findByAccount(userAccount);
	}
	
	@Override
	public List<Functions> findFunctions(String userAccount) {
		return userDAO.findFunctionsByAccount(userAccount);
	}

	@Override
	public Users save(Users entity) {
		return userDAO.save(entity);
	}


	@Override
	public Users findById(Integer id) {
		return userDAO.findOne(id);
	}

	@Override
	public void remove(Users entity) {
		userDAO.delete(entity);
	}

	@Override
	public Users add(Users entity) {
		return userDAO.save(entity);
	}

	@Override
	public List<Users> findAll() {
		
		//TODO
		return null;
	}

	

}
