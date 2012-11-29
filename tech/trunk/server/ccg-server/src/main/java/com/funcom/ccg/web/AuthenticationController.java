package com.funcom.ccg.web;

import javax.inject.Inject;
import javax.inject.Singleton;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
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
	
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthenticationController.class);
	
	private final ThriftHttpHandler handler;
	private final ThriftHttpHandler jsonHandler;
	
	@Inject
	public AuthenticationController(AuthenticationService service) {
		final Authentication.Processor<Iface> processor = new Authentication.Processor<Iface>(service);
		handler = new ThriftHttpHandler(processor, ThriftUtils.BINARY_PROTOCOL_FACTORY);
		jsonHandler = new ThriftHttpHandler(processor, ThriftUtils.JSON_PROTOCOL_FACTORY);
	}
	
	@RequestMapping(value = "/auth", method = RequestMethod.POST, consumes = ThriftUtils.APPLICATION_THRIFT_VALUE)
	public void authenticate(HttpServletRequest req, HttpServletResponse res) {
		handler.handle(req, res);
	}
	
	@RequestMapping(value = "/auth", method = RequestMethod.POST, consumes = MediaType.APPLICATION_XML_VALUE)
	public void authenticateJson(HttpServletRequest req, HttpServletResponse res) {
		jsonHandler.handle(req, res);
	}
}
