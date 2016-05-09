package com.databox.drcms.model;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.databox.common.auth.Users;
import com.databox.core.dao.criteria.PagingParameter;
import com.databox.drcms.web.model.JQResponse;

@Service("userProfileService")
@Transactional
public class UserProfileServiceImpl implements UserProfileService {

	@Autowired
	private UserProfileDAO userProfileDAO;
	
	@Override
	public Users getAccountDtl(String account) {
		List<Users> list = userProfileDAO.getAccountDtl(account);
		if(list!=null && list.size()>0){
			return list.get(0);
		}
		else {
			return null;
		}
	}
	
	@Override
	public Users getAccountDtl(Integer id) {
		return userProfileDAO.get(id);
	}

	@Override
	public Users updateUser(Users users) {
		return userProfileDAO.save(users);
	}

	@Override
	public List<Users> findByQuery(String account, String role) {
		return userProfileDAO.findByQuery(account, role);
	}

	@Override
	public JQResponse findByQuery(String account, String role,
			PagingParameter pagingParameter) {
		return userProfileDAO.findByQuery(account, role, pagingParameter);
	}

	@Override
	public void removeUser(Integer id) {
		userProfileDAO.delete(id);
	}

}
