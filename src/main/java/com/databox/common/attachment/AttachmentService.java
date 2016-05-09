package com.databox.common.attachment;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.List;


//@Service(AttachmentServiceImpl.COMPONENT_NAME)
public interface AttachmentService {

	Attachment findById(Long attachmentId);
	
	Attachment findByIdWithContent(Long attachmentId) throws IOException;
	
	File getAttachFile(Attachment attachment) throws FileNotFoundException;
	
	Attachment save(Attachment attachment) throws IOException;

	List<Attachment> findAttachment(String referenceId, AttachmentType attachmentType);
} 
