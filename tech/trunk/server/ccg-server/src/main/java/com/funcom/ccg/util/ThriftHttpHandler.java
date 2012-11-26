package com.funcom.ccg.util;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.thrift.TException;
import org.apache.thrift.TProcessor;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.protocol.TProtocolFactory;
import org.apache.thrift.transport.TIOStreamTransport;
import org.apache.thrift.transport.TTransport;

public class ThriftHttpHandler {
	private final TProcessor processor;
	private final TProtocolFactory protocolFactory;
	
	public ThriftHttpHandler(TProcessor processor, TProtocolFactory protocolFactory) {
		this.processor = processor;
		this.protocolFactory = protocolFactory;
	}
	
	public void handle(HttpServletRequest req, HttpServletResponse res) {
		try {
			res.setContentType(ThriftUtils.APPLICATION_THRIFT_VALUE);
			final TTransport transport = new TIOStreamTransport(req.getInputStream(), res.getOutputStream());
			final TProtocol inProtocol = protocolFactory.getProtocol(transport);
			final TProtocol outProtocol = protocolFactory.getProtocol(transport);
			processor.process(inProtocol, outProtocol);
		}
		catch (IOException e) {
			throw new RuntimeException(e);
		}
		catch (TException e) {
			throw new RuntimeException(e);
		}
	}
}