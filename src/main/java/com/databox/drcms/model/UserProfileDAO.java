package com.databox.drcms.model;

import java.util.List;

import com.databox.common.auth.Users;
import com.databox.core.dao.api.IDao;
import com.databox.core.dao.criteria.PagingParameter;
import com.databox.drcms.web.model.JQResponse;

public interface UserProfileDAO extends IDao<Users, Integer> {
	
	List<Users> getAccountDtl(String account);
	List<Users> findByQuery(String account, String role);
	JQResponse findByQuery(String account, String role, PagingParameter pagingParameter);

}
