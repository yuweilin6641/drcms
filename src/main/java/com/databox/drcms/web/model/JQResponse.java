package com.databox.drcms.web.model;

import java.util.List;

public class JQResponse {
	private int page;
	private int total;
	private int records;
	private List<?> rows;

	public JQResponse(int page, int total, int records, List<?> list) {
		this.setPage(page);
		this.setTotal(total);
		this.setRecords(records);
		this.setRows(list);
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getRecords() {
		return records;
	}

	public void setRecords(int records) {
		this.records = records;
	}

	public List<?> getRows() {
		return rows;
	}

	public void setRows(List<?> rows) {
		this.rows = rows;
	}

}
