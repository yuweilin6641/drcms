package com.databox.common.auth;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;


/**
 * The persistent class for the FUNCTIONS database table.
 * 
 */
@Entity
@Table(name="FUNCTIONS")
public class Functions implements Serializable, com.databox.core.dao.api.IEntity<Integer> {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="FUNCTION_ID", unique=true, nullable=false, precision=18)
	private Integer id;

	@Column(name="FUNCTION_DESC", length=200)
	private String functionDesc;

	@Column(name="FUNCTION_NAME", length=50)
	private String functionName;

	@Column(name="FUNCTION_RESOURCE", nullable=false, length=100)
	private String functionResource;

	@Column(name="FUNCTION_TYPE", nullable=false, length=4)
	private String functionType;

    public Functions() {
    }

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getFunctionDesc() {
		return this.functionDesc;
	}

	public void setFunctionDesc(String functionDesc) {
		this.functionDesc = functionDesc;
	}

	public String getFunctionName() {
		return this.functionName;
	}

	public void setFunctionName(String functionName) {
		this.functionName = functionName;
	}

	public String getFunctionResource() {
		return this.functionResource;
	}

	public void setFunctionResource(String functionResource) {
		this.functionResource = functionResource;
	}

	public String getFunctionType() {
		return this.functionType;
	}

	public void setFunctionType(String functionType) {
		this.functionType = functionType;
	}
	
}