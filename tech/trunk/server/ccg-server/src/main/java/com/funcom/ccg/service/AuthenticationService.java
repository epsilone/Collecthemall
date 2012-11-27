package com.funcom.ccg.service;

import java.util.UUID;

import javax.inject.Singleton;

import org.apache.thrift.TException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.funcom.ccg.thrift.AuthInfo;
import com.funcom.ccg.thrift.AuthStatus;
import com.funcom.ccg.thrift.Authentication.Iface;

@Singleton
@Service
public class AuthenticationService implements Iface {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticationService.class);

	@Override
	public AuthInfo authenticate(String identifier, String password) throws TException {
		LOGGER.trace("identifier: [{}], password: [{}]", identifier, password);
		final AuthInfo authInfo = new AuthInfo();
		authInfo.setUserId(UUID.randomUUID().toString());
		authInfo.setSession(UUID.randomUUID().toString());
		authInfo.setStatus(AuthStatus.SUCCESS);
		return authInfo;
	}

	@Override
	public AuthInfo authenticateFacebook(String facebookId, String facebookToken) throws TException {
		LOGGER.trace("facebookId: [{}], facebookToken: [{}]", facebookId, facebookToken);
		final AuthInfo authInfo = new AuthInfo();
		authInfo.setUserId(UUID.randomUUID().toString());
		authInfo.setSession(UUID.randomUUID().toString());
		authInfo.setStatus(AuthStatus.SUCCESS);
		return authInfo;
	}

	@Override
	public AuthInfo authenticateIOS(String udid) throws TException {
		LOGGER.trace("udid: [{}]", udid);
		final AuthInfo authInfo = new AuthInfo();
		authInfo.setUserId(UUID.randomUUID().toString());
		authInfo.setSession(UUID.randomUUID().toString());
		authInfo.setStatus(AuthStatus.SUCCESS);
		return authInfo;
	}

}
