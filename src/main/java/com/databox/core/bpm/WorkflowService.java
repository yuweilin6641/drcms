package com.databox.core.bpm;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;


public interface WorkflowService {
	
	ProcessInstance findProcessInstance(String processInstanceId);
	
	ProcessInstance createProcessInstance(String processDefnKey);
	
	ProcessInstance startProcessInstanceByKey(String processDefnKey, Map<String, Object> variables);
	
	void endProcessInstance(String processInstanceId);
	
	ProcessInstance moveProcessInstance(String processInstanceId, String transition);
	
	boolean isProcessInstanceRuning(String processInstanceId);
	
	void setupProcessDefinitions(String fileName) throws IOException;
	
	List<Task> findPersonalTasks(String taskOwnerName);
	
	List<Task> findActiveTaskByProcessInstanceId(String processInstanceId);
	
	void completeTask(String taskId, Map<String, Object> variables);
	
	List<Task> findAllActiveTasks();
	
	void signalEventReceived(String signalName, String processInstanceId);
	
	void saveTask(Task task);
	
	void changeAssignee(String processInstanceId, String userAccount);

	void changeInstanceVariable(String processInstanceId, String key, String value);

}
