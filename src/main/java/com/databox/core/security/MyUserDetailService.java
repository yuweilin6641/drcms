package com.databox.core.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

public class MyUserDetailService implements UserDetailsService{
	
	@Autowired
	private SecurityDAO securityDAO;

	public UserDetails loadUserByUsername(String userAccount)
			throws UsernameNotFoundException, DataAccessException {
		
		Collection<GrantedAuthority> auths = new ArrayList<GrantedAuthority>();   
        String password = null;   
        Users newUser = securityDAO.findUserByUserAccount(userAccount);
        if(newUser==null) {   
            throw new UsernameNotFoundException("��? "+userAccount+" ���s�b");   
        }   
        password = newUser.getUserPassword();   
        List<Roles> roles = securityDAO.findRoleByUserAccount(userAccount);
        for(Roles role: roles){
        	GrantedAuthorityImpl grantedAuthorityImpl =    
                    new GrantedAuthorityImpl("ROLE_" + role.getRoleName());  
        	auths.add(grantedAuthorityImpl);  
        }
         /*  
         * ��?�Y��?�Ӧ�UserDetails��User�ݭn��?�䤤��equals�MhashCode��k�A  
         * �_??�k�q?session-management����max-sessions="1"   
         */  
        return new User(userAccount, password, true, true, true, true, auths);
	}

	public SecurityDAO getSecurityDAO() {
		return securityDAO;
	}

	public void setSecurityDAO(SecurityDAO securityDAO) {
		this.securityDAO = securityDAO;
	}
	

}
