package com.databox.drcms.model;

import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Repository;

import com.databox.common.auth.Users;
import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.PagingParameter;
import com.databox.core.dao.criteria.projection.Projections;
import com.databox.core.dao.criteria.restriction.Restrictions;
import com.databox.core.dao.impl.GenericDao;
import com.databox.drcms.web.model.JQResponse;

@Repository("userProfileDAO")
public class UserProfileDAOImpl extends GenericDao<Users, Integer> implements
		UserProfileDAO {

	private Criteria queryCriteria(String account, String role) {
		Criteria criteria = Criteria.forClass(Users.class);

		if (StringUtils.isNotBlank(account) && StringUtils.isNotEmpty(account)) {
			criteria.add(Restrictions.like("account", "%" + account + "%"));
		}
		
		if (StringUtils.isNotBlank(role) && StringUtils.isNotEmpty(role)) {
			criteria.createAlias("roles", "rolesAlias");
			criteria.add(Restrictions.like("rolesAlias.roleName", "%" + role + "%"));
		}
		return criteria;
	}

	@Override
	public List<Users> getAccountDtl(String account) {
		return findByCriteria(Criteria.forClass(Users.class).add(
				Restrictions.eq("account", account)));
	}

	@Override
	public List<Users> findByQuery(String account, String role) {
		Criteria criteria = queryCriteria(account, role);
		return findByCriteria(criteria);
	}

	@Override
	public JQResponse findByQuery(String account, String role,
			PagingParameter pagingParameter) {
		Criteria criteria = queryCriteria(account, role);

		criteria.setProjection(Projections.rowCount());
		int rowCounts = ((Long) findUniqueByCriteria(criteria)).intValue();

		criteria.setProjection(null);
		criteria.addPagingParameter(pagingParameter);
		List<Users> list = findByCriteria(criteria);

		int pageSize = pagingParameter.getSizePerPage();
		int totalPage = ((rowCounts % pageSize) == 0) ? rowCounts / pageSize
				: rowCounts / pageSize + 1;

		return new JQResponse(pagingParameter.getPage(), totalPage, rowCounts,
				list);
	}

}
