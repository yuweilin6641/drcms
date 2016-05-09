package com.databox.drcms.model;

import java.util.List;

import com.databox.common.auth.Users;
import com.databox.core.dao.criteria.PagingParameter;
import com.databox.drcms.web.model.JQResponse;

public interface UserProfileService {
	Users getAccountDtl(String account);
	Users getAccountDtl(Integer id);
	Users updateUser(Users users);
	List<Users> findByQuery(String account, String role);
	JQResponse findByQuery(String account, String role, PagingParameter pagingParameter);
	void removeUser(Integer id);
}
