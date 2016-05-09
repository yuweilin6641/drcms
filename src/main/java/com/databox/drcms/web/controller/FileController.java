package com.databox.drcms.web.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Iterator;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.databox.common.attachment.Attachment;
import com.databox.common.attachment.AttachmentService;
import com.databox.common.attachment.TempAttachment;

@Controller
@RequestMapping("/fileController")
public class FileController {

	@Autowired
	private AttachmentService attachmentService;

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public @ResponseBody
	Attachment upload(MultipartHttpServletRequest request,
			HttpServletResponse response) throws IOException {

		// 1. build an iterator
		Iterator<String> itr = request.getFileNames();
		MultipartFile mpf = null;
		Attachment attachment = null;

		// 2. get each file
		while (itr.hasNext()) {

			// 2.1 get next MultipartFile
			mpf = request.getFile(itr.next());

			// 2.3 create new fileMeta
			attachment = new TempAttachment();
			attachment.setFileName(mpf.getOriginalFilename());
			attachment.setFileSize(new BigDecimal(mpf.getSize() / 1024));
			attachment.setMimeType(mpf.getContentType());
			attachment.setContents(mpf.getBytes());
		}
		return attachment;

	}

	@RequestMapping(value = "/get/{attachmentId}", method = RequestMethod.GET)
	public void getFile(HttpServletResponse response, @PathVariable String attachmentId) throws NumberFormatException, IOException {
		Attachment attachment = attachmentService.findByIdWithContent(Long.valueOf(attachmentId));
		try {
			response.setContentType(attachment.getMimeType());
			response.setHeader("Content-disposition", "attachment; filename=\"" + attachment.getFileName() + "\"");
			FileCopyUtils.copy(attachment.getContents(), response.getOutputStream());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}