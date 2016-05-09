package com.databox.core.security;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.SqlParameter;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.object.MappingSqlQuery;

public class SecurityDAOImpl extends JdbcDaoSupport implements SecurityDAO{
	
	private UsersByIdQuery usersByIdQuery;
	private RolesByIdQuery rolesByIdQuery;
	private ResourcesToRoleQuery resourcesToRoleQuery;

	public Users findUserByUserAccount(String userAccount) {
		List<Users> list = usersByIdQuery.execute(userAccount);

        if (list.size() == 0) {
            return null;
        } else {
            return list.get(0);
        }
	}

	public List<Roles> findRoleByUserAccount(String userAccount) {
		return rolesByIdQuery.execute(userAccount);
	}
	
	public List<Resources> findAllResourceToRole() {
		return resourcesToRoleQuery.execute();
	}
	
	protected void initDao() throws Exception {
		usersByIdQuery = new UsersByIdQuery(getDataSource());
		rolesByIdQuery = new RolesByIdQuery(getDataSource());
		resourcesToRoleQuery = new ResourcesToRoleQuery(getDataSource());
    }
	
	protected class UsersByIdQuery extends MappingSqlQuery<Users> {
        protected UsersByIdQuery(DataSource ds) {
            super(ds, "select user_id, account, user_password from Users WHERE account = ? ORDER BY user_id");
            declareParameter(new SqlParameter(Types.VARCHAR));
            compile();
        }

        protected Users mapRow(ResultSet rs, int rownum) throws SQLException {
        	Users user = new Users();
            user.setUserID(rs.getString("user_id"));
            user.setUserAccount(rs.getString("account"));
            user.setUserPassword(rs.getString("user_password"));
            return user;
        }
    }
	
	protected class RolesByIdQuery extends MappingSqlQuery<Roles> {
        protected RolesByIdQuery(DataSource ds) {
            super(ds, "select distinct r.role_id from Users u inner join User_Role ur on u.user_id=ur.user_id inner join Roles r on ur.role_id=r.role_id where u.account=?");
            declareParameter(new SqlParameter(Types.VARCHAR));
            compile();
        }

        protected Roles mapRow(ResultSet rs, int rownum) throws SQLException {
        	Roles user = new Roles();
            user.setRoleName(rs.getString("role_id"));
            return user;
        }
    }

	protected class ResourcesToRoleQuery extends MappingSqlQuery<Resources> {
        protected ResourcesToRoleQuery(DataSource ds) {
            super(ds, "select distinct f.function_resource, r.role_id from Functions f inner join Permission_policy p on f.function_id=p.function_id inner join Roles r on p.role_id=r.role_id where f.function_resource is not null order by f.function_resource");
            compile();
        }

        protected Resources mapRow(ResultSet rs, int rownum) throws SQLException {
        	Resources url = new Resources();
            url.setUrl(rs.getString("function_resource"));
            url.setRoleName(rs.getString("role_id"));
            return url;
        }
    }
}
