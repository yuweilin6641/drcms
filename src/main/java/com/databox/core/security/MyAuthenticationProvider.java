package com.databox.core.security;

import java.util.List;

import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority; 

public class MyAuthenticationProvider implements AuthenticationProvider {
	
	private AuthenticationProvider delegate;
    
	public MyAuthenticationProvider(AuthenticationProvider delegate){
		this.delegate = delegate;
	}
    private List<GrantedAuthority> loadRolesFromDatabaseHere(){
    	return null;
    }

	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		final Authentication a = delegate.authenticate(authentication);

        // Load additional authorities and create an Authentication object
		final List<GrantedAuthority> authorities = loadRolesFromDatabaseHere();

        return new AbstractAuthenticationToken(authorities) {
			private static final long serialVersionUID = 1L;

			public Object getCredentials() {
				return null;
                //throw new UnsupportedOperationException();
            }

            public Object getPrincipal() {
                return a.getPrincipal();
            }
        };
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return delegate.supports(authentication);
	}

	public void setDelegate(AuthenticationProvider delegate) {
		this.delegate = delegate;
	}

}
