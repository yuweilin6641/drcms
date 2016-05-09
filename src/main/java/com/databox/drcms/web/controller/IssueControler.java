package com.databox.drcms.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.databox.drcms.model.issue.Issue;
import com.databox.drcms.model.issue.IssueService;

import java.io.IOException;

import org.apache.log4j.Logger;

@Controller
@RequestMapping("/issue")
public class IssueControler {
	protected static Logger logger = Logger.getLogger(IssueControler.class);

	@Autowired
	private IssueService issueService;
	
	// get one issue data...
		@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
		public @ResponseBody
		Issue getIssue(@PathVariable Integer id) throws IOException {
			Issue csr = issueService.findIssue(id);
			return csr;
		}


}
