/**
 * 
 */
package com.databox.core.bpm;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.activiti.engine.ManagementService;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.runtime.Execution;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang.NotImplementedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author 10203604
 *
 */

@Service("workflowService")
@Transactional
public class WorkflowServiceImpl implements WorkflowService {
	
	@Autowired
	private RepositoryService repositoryService;
	
	@Autowired
	private RuntimeService runtimeService;
	
	@Autowired
	private TaskService taskService;
	
	@Autowired
	private ManagementService managementService;

	@Override
	public ProcessInstance findProcessInstance(String processInstanceId) {
		return runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult();
	}

	@Override
	public ProcessInstance createProcessInstance(String processDefnKey) {
		return runtimeService.startProcessInstanceByKey(processDefnKey);
	}

	@Override
	public ProcessInstance startProcessInstanceByKey(String processDefnKey,
			Map<String, Object> variables) {
		return runtimeService.startProcessInstanceByKey(processDefnKey, variables);
	}

	@Override
	public void endProcessInstance(String processInstanceId) {
		// TODO Auto-generated method stub
		throw new NotImplementedException();
	}

	@Override
	public ProcessInstance moveProcessInstance(String processInstanceId,
			String transition) {
		// TODO Auto-generated method stub
		throw new NotImplementedException();
		
	}

	@Override
	public boolean isProcessInstanceRuning(String processInstanceId) {
		ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().active().processInstanceId(processInstanceId).singleResult();
		if(processInstance==null || processInstance.isEnded() || processInstance.isSuspended()){
			return false;
		}
		else{
			return true;
		}
	}

	@Override
	public void setupProcessDefinitions(String fileName) throws IOException {
		repositoryService.createDeployment().addInputStream("IssueTracking.bpmn20.xml",
				new FileInputStream(fileName)).deploy();
	}

	@Override
	public List<Task> findPersonalTasks(String taskOwnerName) {
		return taskService.createTaskQuery().taskAssignee(taskOwnerName).list();
	}

	@Override
	public List<Task> findActiveTaskByProcessInstanceId(String processInstanceId) {
		return taskService.createTaskQuery().processInstanceId(processInstanceId).active().list();
	}

	@Override
	public void completeTask(String taskId, Map<String, Object> variables) {
		taskService.complete(taskId, variables);
		
	}

	@Override
	public List<Task> findAllActiveTasks() {
		return taskService.createTaskQuery().active().list();
	}

	@Override
	public void saveTask(Task task) {
		taskService.saveTask(task);
	}

	@Override
	public void signalEventReceived(String signalName, String processInstanceId) {
		Execution execution =runtimeService.createExecutionQuery().processInstanceId(processInstanceId).signalEventSubscriptionName(signalName).singleResult();
		if(execution!=null){
			runtimeService.signalEventReceived(signalName, execution.getId());
		}
	}

	@Override
	public void changeAssignee(String processInstanceId, String userAccount) {
		ProcessInstance processInstance = this.findProcessInstance(processInstanceId);
		List<Task> tasks = this.findActiveTaskByProcessInstanceId(processInstance.getProcessInstanceId());
		Task task = tasks.get(0);
		taskService.setAssignee(task.getId(), userAccount);	
	}
	
	@Override
	public void changeInstanceVariable(String processInstanceId, String key, String value){
		runtimeService.setVariable(processInstanceId, key, value);
	}

}
