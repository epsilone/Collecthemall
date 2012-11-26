package com.funcom.ccg.web;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.funcom.ccg.service.AuthenticationService;
import com.funcom.ccg.thrift.Authentication;
import com.funcom.ccg.thrift.Authentication.Iface;
import com.funcom.ccg.util.ThriftHttpHandler;
import com.funcom.ccg.util.ThriftUtils;

@Singleton
@Controller
public class AuthenticationController {
	
	private final ThriftHttpHandler handler;
	
	@Inject
	public AuthenticationController(AuthenticationService service) {
		final Authentication.Processor<Iface> processor = new Authentication.Processor<Iface>(service);
		handler = new ThriftHttpHandler(processor, ThriftUtils.BINARY_PROTOCOL_FACTORY);
	}
	
	@RequestMapping(value = "/auth", method = RequestMethod.POST, consumes = ThriftUtils.APPLICATION_THRIFT_VALUE)
	public void authenticate(HttpServletRequest req, HttpServletResponse res) {
		handler.handle(req, res);
	}
}
