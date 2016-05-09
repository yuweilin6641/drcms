package com.databox.drcms.model.issue;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

import com.databox.common.attachment.Attachment;
import com.databox.common.attachment.AttachmentType;

@Entity
@DiscriminatorValue("ISSUE")
public class IssueAttachment extends Attachment {
	private static final long serialVersionUID = 1L;
	
	public IssueAttachment(){
		this.setAttachmentType(AttachmentType.ISSUE);
	}
//	
//	//bi-directional many-to-one association to Issue
//    @ManyToOne
//	@JoinColumn(name="REFERENCE_ID")
//	private Issue issue;
//
//	public Issue getIssue() {
//		return issue;
//	}
//
//	public void setIssue(Issue issue) {
//		this.issue = issue;
//	}
}
