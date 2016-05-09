package com.databox.core.dao.criteria;

/**
 * Criterion used for manipulating where clauses.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public interface Criterion {

    /**
     * Generate part of EQL where clause with given criteria.
     *
     * @param criteria criteria used in criterion
     * @param criteriaQuery current query
     * @return part of select clause
     */
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) ;
}
