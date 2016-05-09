package com.databox.core.bpm;

import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.springframework.beans.factory.annotation.Autowired;

import com.databox.common.auth.UserService;
import com.databox.common.auth.Users;
import com.databox.core.util.spring.BeanFactory;


public class NotificationTaskListener implements TaskListener {

	private static final long serialVersionUID = 1L;
	
	@Autowired
	private UserService userService;
	
	{
		if(userService==null){
			userService = (UserService) BeanFactory.getBean("userService");
		}
	}
	
	@Override
	public void notify(DelegateTask delegateTask) {
		String account = delegateTask.getAssignee();
		Users user = userService.findByAccount(account);
		System.out.println("delegateTask.account=" + user.getAccount());
		System.out.println("delegateTask.email=" + user.getEmail());
	}

}
