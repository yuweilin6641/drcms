package com.databox.common.attachment;

import java.util.List;

import com.databox.core.dao.api.IDao;

public interface AttachmentDAO extends IDao<Attachment,Long>{

	List<Attachment> findAttachment(String referenceId, AttachmentType attachmentType);
}
