package com.databox.core.dao.criteria;

import java.io.Serializable;

public class PagingParameter implements Serializable {

	private static final long serialVersionUID = 0x41657bcd3f5724e9L;
	private int startIndex;
	private int sizePerPage;

	protected PagingParameter(int startIndex, int sizePerPage) {
		this.sizePerPage = 20;
		this.startIndex = startIndex;
		this.sizePerPage = sizePerPage;
	}

	public static PagingParameter startIndexAt(int startIndex, int sizePerPage) {
		return new PagingParameter(startIndex, sizePerPage);
	}

	public static PagingParameter pageIndexAt(int pageIndex, int sizePerPage) {
		return new PagingParameter((pageIndex -1) * sizePerPage, sizePerPage);
	}

	public int getSizePerPage() {
		return sizePerPage;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public int getPageIndex() {
		if (sizePerPage == 0)
			return 0;
		else
			return startIndex / sizePerPage;
	}
	
	public int getPage() {
		if (sizePerPage == 0)
			return 0;
		else
			return (startIndex / sizePerPage) + 1;
	}

}