package com.databox.core.dao.impl;

import java.io.Serializable;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import com.databox.core.dao.api.IEntity;

/**
 * Implementation supporting Contexts and Dependency Injection.
 * 
 * @author Simon Lavigne-Giroux
 * 
 * @param <T> entity type, it must implements at least <code>IEntity</code>
 * @param <I> entity's primary key, it must be serializable
 * @see IEntity
 * 
 * @since 1.1
 */
public class CdiGenericDao<T extends IEntity<I>, I extends Serializable> extends GenericDao<T, I> {

  /**
   * Set entity manager.
   * 
   * @param entityManager entity manager
   */
  @Override
  @PersistenceContext
  public void setEntityManager(EntityManager entityManager) {
    super.setEntityManager(entityManager);
  }

}
