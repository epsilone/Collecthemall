package com.funcom.ccg.http 
{
	import com.funcom.ccg.thrift.Authentication;
	import com.funcom.ccg.thrift.AuthenticationImpl;
	import com.funcom.ccg.thrift.AuthInfo;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import flash.net.URLRequest;
	import org.apache.thrift.protocol.TBinaryProtocol;
	import org.apache.thrift.protocol.TProtocol;
	import org.apache.thrift.transport.THttpClient;
	import org.apache.thrift.transport.TTransport;
	
	public class AuthenticationService
	{
		private static const AUTHENTICATE_URL:String = "http://localhost:8080/ccg/auth";

		public static function authenticate(identifier:String, password:String):void
		{
			debug("authenticate", "identifier: " + identifier + " password: " + password);
			buildService().authenticate(identifier, password, onError, onSuccess);
		}

		public static function authenticateFacebook(facebookId:String, facebookToken:String):void
		{
			debug("authenticateFacebook", "facebookId: " + facebookId + " facebookToken: " + facebookToken);
			buildService().authenticateFacebook(facebookId, facebookToken, onError, onSuccess);
		}

		public static function authenticateIOS(udid:String):void
		{
			debug("authenticateIOS", "udid: " + udid);
			buildService().authenticateIOS(udid, onError, onSuccess);
		}
		
		private static function buildService():Authentication
		{
			var urlRequest:URLRequest = new URLRequest(AUTHENTICATE_URL);
			var transport:TTransport = new THttpClient(urlRequest);
			var protocol:TProtocol = new TBinaryProtocol(transport);
			var service:Authentication = new AuthenticationImpl(protocol);
			return service;
		}
		
		private static function onSuccess(authInfo:AuthInfo):void
		{
			// TODO: dispatch authentication success
			debug("onSuccess", "AuthInfo: " + authInfo);
		}
		
		private static function onError():void
		{
			// TODO: dispatch authentication error
			debug("onError", null);
		}
		
		private static function debug(methodName:String, aMessage:*):void
		{
			Logger.log(ELogType.DEBUG, "AuthenticationService", methodName, aMessage);
		}
	}

}