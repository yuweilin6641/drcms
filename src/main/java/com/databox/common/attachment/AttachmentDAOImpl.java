package com.databox.common.attachment;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.restriction.Restrictions;
import com.databox.core.dao.impl.GenericDao;
import com.databox.drcms.model.issue.IssueAttachment;

@Repository("attachmentDAO")
public class AttachmentDAOImpl extends GenericDao<Attachment, Long> implements AttachmentDAO {
	
	@Override
	public List<Attachment> findAttachment(String referenceId, AttachmentType attachmentType){
		
		Criteria criteria = Criteria.forClass(IssueAttachment.class);
		criteria.add(Restrictions.eq("referenceId", referenceId));
//		criteria.add(Restrictions.eq("attachmentType", attachmentType.toString()));
		return findByCriteria(criteria);
	}

}
