package com.databox.common.attachment;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.databox.core.dao.api.IEntity;


/**
 * The persistent class for the attachment database table.
 * 
 */
@Entity
@Inheritance
@DiscriminatorColumn(name="REFERENCE_TYPE", length=100)
@Table(name="attachment")
public abstract class Attachment implements IEntity<Long>, Serializable {
	private static final long serialVersionUID = 1L;
	
	@Transient
	private AttachmentType attachmentType = AttachmentType.TEMP;
    
    @Transient
    private byte[] contents;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="ATTACHMENT_ID", unique=true, nullable=false, precision=18)	
	private Long id;

	@Column(length=255)
	private String description;

	@Column(name="EXT_NAME", length=25)
	private String extName;

	@Column(name="FILE_NAME", length=100)
	private String fileName;

	@Column(name="FILE_SIZE", precision=10)
	private BigDecimal fileSize;

	@Column(name="MIME_TYPE", length=100)
	private String mimeType;

	@Column(name="STORE_PATH", length=255)
	private String storePath;

	@Column(name="SUB_FOLDER", length=100)
	private String subFolder;
	
	@Column(name="REFERENCE_ID", length=100)
	private String referenceId;


    public Attachment() {
    }


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getExtName() {
		return this.extName;
	}

	public void setExtName(String extName) {
		this.extName = extName;
	}

	public String getFileName() {
		return this.fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public BigDecimal getFileSize() {
		return this.fileSize;
	}

	public void setFileSize(BigDecimal fileSize) {
		this.fileSize = fileSize;
	}

	public String getMimeType() {
		return this.mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public String getStorePath() {
		return this.storePath;
	}

	public void setStorePath(String storePath) {
		this.storePath = storePath;
	}

	public String getSubFolder() {
		return this.subFolder;
	}

	public void setSubFolder(String subFolder) {
		this.subFolder = subFolder;
	}

	public byte[] getContents() {
		return contents;
	}

	public void setContents(byte[] contents) {
		this.contents = contents;
	}

	public AttachmentType getAttachmentType() {
		return attachmentType;
	}

	public void setAttachmentType(AttachmentType attachmentType) {
		this.attachmentType = attachmentType;
	}

	public String getReferenceId() {
		return referenceId;
	}

	public void setReferenceId(String referenceId) {
		this.referenceId = referenceId;
	}
	
}