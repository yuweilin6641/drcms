package com.databox.drcms.model.issue;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("issueService")
@Transactional
public class IssueServiceImpl implements IssueService {

	@Autowired
	private IssueDAO issueDAO;

	@Override
	public Issue findIssue(int id) {
		return issueDAO.findOne(1);
	}

}
