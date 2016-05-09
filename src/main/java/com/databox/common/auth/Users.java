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
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


/**
 * The persistent class for the USERS database table.
 * 
 */
@Entity
@Table(name="USERS")
@NamedQueries({
	@NamedQuery(name = Users.NQ_FIND_BY_ROLE, query = "select u from Users u join u.roles r where  r.roleName = ?1 order by u.id"),
	@NamedQuery(name = Users.NQ_FIND_FUNCTIONS, query = "select f from Users u join u.roles r join r.functions f where u.account = ?1 order by f.id"),
    @NamedQuery(name = Users.NQ_FIND_BY_ACCOUNT, query = "select p from Users p where p.account = ?1") })
public class Users implements Serializable, com.databox.core.dao.api.IEntity<Integer> {
	private static final long serialVersionUID = 1L;
	
	public static final String NQ_FIND_FUNCTIONS = "Users.findFunctionsByAccount";
    public static final String NQ_FIND_BY_ACCOUNT = "Users.findByAccount";
    public static final String NQ_FIND_BY_ROLE = "Users.namedQueryByRoleName";

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="USER_ID", unique=true, nullable=false, precision=18)
	private Integer id;

	@Column(nullable=false, unique=true, length=25)
	private String account;

    @Temporal( TemporalType.TIMESTAMP)
	@Column(name="CREATE_DATE")
	private Date createDate;

	@Column(length=50)
	private String email;

	@Column(name="MEMBER_ID", precision=11)
	private Integer memberId;


	@Column(name="USER_PASSWORD", nullable=false, length=50)
	private String userPassword;

	@Column(name="FIRST_NAME")
	private String firstName;
	
	@Column(name="LAST_NAME")
	private String lastName;
	
	@Column(name="MIDDLE_NAME")
	private String middleName;
	
	@Column(name="PHONE_WORK")
	private String phoneWork;
	
	@Column(name="PHONE_CELL")
	private String phoneCell;
	
	
	//bi-directional many-to-many association to Roles
    @ManyToMany
	@JoinTable(
		name="USER_ROLE"
		, joinColumns={
			@JoinColumn(name="USER_ID", nullable=false)
			}
		, inverseJoinColumns={
			@JoinColumn(name="ROLE_ID", nullable=false)
			}
		)
	private List<Roles> roles;

    public Users() {
    }

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public String getAccount() {
		return this.account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Integer getMemberId() {
		return this.memberId;
	}

	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}

	public String getUserPassword() {
		return this.userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public List<Roles> getRoles() {
		return this.roles;
	}

	public void setRoles(List<Roles> roles) {
		this.roles = roles;
	}
	
	public String getFirstName() {
		return this.firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	
	public String getLastName() {
		return this.lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	
	public String getMiddleName() {
		return this.middleName;
	}

	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}
	
	public String getPhoneWork() {
		return this.phoneWork;
	}

	public void setPhoneWork(String phoneWork) {
		this.phoneWork = phoneWork;
	}
	
	public String getPhoneCell() {
		return this.phoneCell;
	}

	public void setPhoneCell(String phoneCell) {
		this.phoneCell = phoneCell;
	}
	
	public String getRoleNameList() {
		String roleNameList = "";
		for ( Roles r : roles ) 
			roleNameList += r.getRoleName() + ", ";
		return roleNameList;
	}
	
	public String getRoleIdList() {
		String roleIdList = "";
		for ( Roles r : roles ) 
			roleIdList += ",'" + r.getId() + "'";
		if(roleIdList.length()>0){
			return roleIdList.substring(1);
		}
		else{
			return "";
		}
	}
	
	public String getFullName() {
		return firstName + " " + lastName;
	}
}