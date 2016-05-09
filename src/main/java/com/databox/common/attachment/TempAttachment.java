package com.databox.common.attachment;

import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("TEMP")
public class TempAttachment extends Attachment {

	private static final long serialVersionUID = 1L;

}
