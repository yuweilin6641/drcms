package com.databox.core.security;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ldap.core.DirContextOperations;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.ldap.userdetails.LdapAuthoritiesPopulator;

public class MyLdapAuthoritiesPopulator implements LdapAuthoritiesPopulator {

	@Autowired
	private SecurityDAO securityDAO;
	
	@Override
	public Collection<? extends GrantedAuthority> getGrantedAuthorities(
			DirContextOperations userData, String userAccount) {
		Collection<GrantedAuthority> auths = new ArrayList<GrantedAuthority>();   
        Users newUser = securityDAO.findUserByUserAccount(userAccount);
        if(newUser==null) {   
            throw new UsernameNotFoundException("��? "+userAccount+" ���s�b");   
        }   
        List<Roles> roles = securityDAO.findRoleByUserAccount(userAccount);
        for(Roles role: roles){
        	GrantedAuthority grantedAuthorityImpl =    
                    new SimpleGrantedAuthority("ROLE_" + role.getRoleName());  
        	auths.add(grantedAuthorityImpl);  
        }
        return auths;
	}
	
	public void setSecurityDAO(SecurityDAO securityDAO) {
		this.securityDAO = securityDAO;
	}

}
