package com.funcom.ccg.service;

import javax.inject.Singleton;

import org.apache.thrift.TException;
import org.springframework.stereotype.Service;

import com.funcom.ccg.thrift.AuthInfo;
import com.funcom.ccg.thrift.Authentication.Iface;

@Singleton
@Service
public class AuthenticationService implements Iface {

	@Override
	public AuthInfo authenticate(String identifier, String password) throws TException {
		final AuthInfo authInfo = new AuthInfo();
		return authInfo;
	}

	@Override
	public AuthInfo authenticateFacebook(String facebookId, String facebookToken) throws TException {
		final AuthInfo authInfo = new AuthInfo();
		return authInfo;
	}

	@Override
	public AuthInfo authenticateIOS(String udid) throws TException {
		final AuthInfo authInfo = new AuthInfo();
		return authInfo;
	}

}
