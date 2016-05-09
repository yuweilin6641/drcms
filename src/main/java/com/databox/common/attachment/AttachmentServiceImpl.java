package com.databox.common.attachment;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.FileCopyUtils;

import com.databox.core.util.PropertyFile;
import com.databox.core.util.PropertyRegistry;
import com.databox.core.util.UUIDHexGenerator;

@Service("attachmentService")
@Transactional
public class AttachmentServiceImpl implements AttachmentService {
	
	private final static PropertyFile propertyFile = PropertyRegistry.getInstance().getPropertyFile("EMP");	
	
	@Autowired
    private AttachmentDAO attachmentDAO;


	@Override
	public Attachment findById(Long attachmentId) {
		Attachment attachment = attachmentDAO.get(attachmentId);
		return attachment;
	}
	
	@Override
	public Attachment findByIdWithContent(Long attachmentId) throws IOException{
		Attachment attachment = attachmentDAO.get(attachmentId);
		String defaultDir = propertyFile.getString("wiwynn.fileUploadRoot.realPath");
		String fileName = defaultDir + attachment.getStorePath();
		FileInputStream inputStream = new FileInputStream(fileName);
		attachment.setContents(FileCopyUtils.copyToByteArray(inputStream));
		return attachment;
	}
	
	@Override
	public File getAttachFile(Attachment attachment) throws FileNotFoundException{
		File returnFile = new File(attachment.getStorePath());
		if(returnFile.exists()==false){
			throw new FileNotFoundException("attachIndex="+attachment.getId());
		}
		else{
			return returnFile;
		}
	}	
	
	@Override
	public Attachment save(Attachment attachment) throws IOException {
		attachment = attachmentDAO.save(attachment);
		if(attachment.getContents()!=null){
			attachment = this.saveFile(attachment);
		}
		return attachmentDAO.save(attachment);
	} 
	
	@Override
	public List<Attachment> findAttachment(String referenceId, AttachmentType attachmentType){
		return attachmentDAO.findAttachment(referenceId, attachmentType);
	}

	public Attachment saveFile(Attachment attachment) throws IOException{
		AttachmentType referenceType = attachment.getAttachmentType();
		String subFolder = this.generateSubFolder(referenceType);
		String attachIndex = null;
		if(attachment.getId()==null){
			attachIndex = UUIDHexGenerator.getInstance().generate();
		}
		else{
			attachIndex = attachment.getId().toString();
		} 
		String postfixName = FilenameUtils.getExtension(attachment.getFileName());
		String targetFileName = FilenameUtils.getName(attachIndex + "." + postfixName);
		
		attachment.setExtName(postfixName);
		attachment.setStorePath(subFolder + targetFileName);
        this.copy(attachment.getContents(), subFolder, targetFileName);
        return attachment;
	}
	
	private String generateSubFolder(AttachmentType attachmentType) throws IOException {
		Calendar cal = Calendar.getInstance();
		String month = (cal.get(Calendar.MONTH) + 1) + "";
		if (month.length() == 1){
			month = "0" + month;
		}

		String folderPath = "/" + attachmentType + "/"
				+ cal.get(Calendar.YEAR) + month + "/";
		return folderPath;
	}
	
	public boolean copy(byte[] fromFile, String subFolder, String toFileName) throws IOException {
		String defaultDir = propertyFile.getString("wiwynn.fileUploadRoot.realPath");
		File newdir = new File(defaultDir + subFolder);
		if (!newdir.exists()) {
			boolean isCreateSuccess = newdir.mkdir();
			if (isCreateSuccess == false) {
				throw new IOException("create dir failed:" + newdir.getName());
			}
		}
		
		File toFile = new File(newdir, toFileName);
		
		if (toFile.exists()) {
			if (!toFile.canWrite()) {
				return false;
			}
		} else {
			String parent = toFile.getParent();
			if (parent == null) {
				parent = System.getProperty("user.dir");
			}
			File dir = new File(parent);
			if (!dir.exists() || dir.isFile() || !dir.canWrite()) {
				return false;
			}
		}
		
		FileCopyUtils.copy(fromFile, toFile);
		return true;
	}



	
}
