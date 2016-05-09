package com.databox.core.bpm;

import org.activiti.engine.delegate.DelegateExecution;
import org.activiti.engine.delegate.JavaDelegate;

import com.databox.common.auth.Users;

public class NotificationDelegate implements JavaDelegate {

	@Override
	public void execute(DelegateExecution execution) throws Exception {
		System.out.println("Aaaaaaaaaaaaaaaaaaaaaaaaaa");
		execution.getVariables();
		Users user = (Users)execution.getVariable("notificationUser");
		System.out.println("Aaaaaaaaaa  user.email="+ user.getEmail());
	}

}
