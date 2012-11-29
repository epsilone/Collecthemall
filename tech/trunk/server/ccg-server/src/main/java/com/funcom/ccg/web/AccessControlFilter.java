package com.funcom.ccg.web;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

public class AccessControlFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException,
			ServletException {
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		httpResponse.setHeader("Access-Control-Allow-Origin", "*");
		httpResponse.setHeader("Access-Control-Allow-Methods", "GET,POST");
		httpResponse.setHeader("Access-Control-Max-Age", "360");
		httpResponse.setHeader("Access-Control-Allow-Headers", "Content-Type");

        chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
		
	}

}
