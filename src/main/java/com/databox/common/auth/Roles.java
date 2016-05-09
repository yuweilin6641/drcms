package com.databox.common.auth;

import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


/**
 * The persistent class for the "ROLES" database table.
 * 
 */
@Entity
@Table(name="ROLES")
public class Roles implements Serializable, com.databox.core.dao.api.IEntity<Integer> {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="ROLE_ID", unique=true, nullable=false, precision=18)
	private Integer id;

    @Temporal( TemporalType.TIMESTAMP)
	@Column(name="CREATE_DATE")
	private Date createDate;

	@Column(name="ROLE_DESC", length=50)
	private String roleDesc;
	
	@Column(name="ROLE_NAME", length=50)
	private String roleName;

	@Column(name="ROLE_TYPE", length=5)
	private String roleType;

	//bi-directional many-to-many association to Roles
    @ManyToMany
	@JoinTable(
		name="PERMISSION_POLICY"
		, joinColumns={
			@JoinColumn(name="ROLE_ID", nullable=false)
			}
		, inverseJoinColumns={
			@JoinColumn(name="FUNCTION_ID", nullable=false)
			}
		)
	private List<Functions> functions;

    public Roles() {
    }

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getRoleDesc() {
		return this.roleDesc;
	}

	public void setRoleDesc(String roleDesc) {
		this.roleDesc = roleDesc;
	}

	public String getRoleType() {
		return this.roleType;
	}

	public void setRoleType(String roleType) {
		this.roleType = roleType;
	}
	
	public List<Functions> getFunctions() {
		return this.functions;
	}

	public void setFunctions(List<Functions> functions) {
		this.functions = functions;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}
	
	
}