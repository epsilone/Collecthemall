package com.funcom.ccg.web;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/test")
public class TestController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(TestController.class);
	
	@RequestMapping(value = "/{name}", method = RequestMethod.GET)
	public String getTest(@PathVariable String name, ModelMap model) {
		model.addAttribute("test", name);
		LOGGER.trace("Model returned {}", model);
		return "test";
	}
}
