package com.databox.drcms.model.issue;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * The persistent class for the issue database table.
 * 
 */
@Entity
@Table(name = "issue")
public class Issue  {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ISSUE_ID", unique = true, nullable = false)
	private Integer id;

	@Column(length = 50)
	private String assignee;

	@Column(name = "CALLER_NAME", length = 25)
	private String callerName;

	@Column(name = "CALLER_PHONE", length = 25)
	private String callerPhone;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CALLER_TIME")
	private Date callerTime;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CLOSE_TIME")
	private Date closeTime;

	@Column(name = "CONTACT_ACCOUNT", length = 100)
	private String contactAccount;

	@Column(name = "CONTACT_CELL", length = 50)
	private String contactCell;

	@Column(name = "CONTACT_NAME", length = 50)
	private String contactName;

	@Column(name = "CONTACT_PHONE", length = 50)
	private String contactPhone;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATE_DATE")
	private Date createDate;

	@Lob
	private String description;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "DUE_DATE")
	private Date dueDate;

	@Lob
	private String environment;

	@Column(precision = 18)
	private BigDecimal fixfor;

	@Column(name = "PHONE_FROM", length = 50)
	private String phoneFrom;

	@Column(name = "RELATIVE_ISSUE_ID", length = 100)
	private String relativeIssueId;

	@Column(length = 50)
	private String reporter;

	@Temporal(TemporalType.TIMESTAMP)
	private Date resolutiondate;

	@Column(name = "SATISFACTION_DESC", length = 25)
	private String satisfactionDesc;

	@Column(name = "SUB_ISSUE_TYPE", length = 25)
	private String subIssueType;

	@Column(length = 255)
	private String summary;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "UPDATE_DATE")
	private Date updateDate;

	@Column(name = "WORKFLOW_ID", length = 25)
	private String workflowId;

	
	@Column(name = "ADDRESS", length = 255)
	private String address;
	
	@Column(name="GOODS_SN", length=255)
	private String goodsSn;
	
	
	@Column(name = "INITIATOR", length = 45)
	private String initiator;
	
	@Column(name = "CURRENT_TASK", length = 45)
	private String currentTask;

	public Issue() {
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getAssignee() {
		return assignee;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getCallerName() {
		return callerName;
	}

	public void setCallerName(String callerName) {
		this.callerName = callerName;
	}

	public String getCallerPhone() {
		return callerPhone;
	}

	public void setCallerPhone(String callerPhone) {
		this.callerPhone = callerPhone;
	}

	public Date getCallerTime() {
		return callerTime;
	}

	public void setCallerTime(Date callerTime) {
		this.callerTime = callerTime;
	}

	public Date getCloseTime() {
		return closeTime;
	}

	public void setCloseTime(Date closeTime) {
		this.closeTime = closeTime;
	}

	public String getContactAccount() {
		return contactAccount;
	}

	public void setContactAccount(String contactAccount) {
		this.contactAccount = contactAccount;
	}

	public String getContactCell() {
		return contactCell;
	}

	public void setContactCell(String contactCell) {
		this.contactCell = contactCell;
	}

	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getDueDate() {
		return dueDate;
	}

	public void setDueDate(Date dueDate) {
		this.dueDate = dueDate;
	}

	public String getEnvironment() {
		return environment;
	}

	public void setEnvironment(String environment) {
		this.environment = environment;
	}

	public BigDecimal getFixfor() {
		return fixfor;
	}

	public void setFixfor(BigDecimal fixfor) {
		this.fixfor = fixfor;
	}

	public String getPhoneFrom() {
		return phoneFrom;
	}

	public void setPhoneFrom(String phoneFrom) {
		this.phoneFrom = phoneFrom;
	}

	public String getRelativeIssueId() {
		return relativeIssueId;
	}

	public void setRelativeIssueId(String relativeIssueId) {
		this.relativeIssueId = relativeIssueId;
	}

	public String getReporter() {
		return reporter;
	}

	public void setReporter(String reporter) {
		this.reporter = reporter;
	}

	public Date getResolutiondate() {
		return resolutiondate;
	}

	public void setResolutiondate(Date resolutiondate) {
		this.resolutiondate = resolutiondate;
	}

	public String getSatisfactionDesc() {
		return satisfactionDesc;
	}

	public void setSatisfactionDesc(String satisfactionDesc) {
		this.satisfactionDesc = satisfactionDesc;
	}

	public String getSubIssueType() {
		return subIssueType;
	}

	public void setSubIssueType(String subIssueType) {
		this.subIssueType = subIssueType;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String summary) {
		this.summary = summary;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public String getWorkflowId() {
		return workflowId;
	}

	public void setWorkflowId(String workflowId) {
		this.workflowId = workflowId;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getGoodsSn() {
		return goodsSn;
	}

	public void setGoodsSn(String goodsSn) {
		this.goodsSn = goodsSn;
	}

	public String getInitiator() {
		return initiator;
	}

	public void setInitiator(String initiator) {
		this.initiator = initiator;
	}

	public String getCurrentTask() {
		return currentTask;
	}

	public void setCurrentTask(String currentTask) {
		this.currentTask = currentTask;
	}

	
}