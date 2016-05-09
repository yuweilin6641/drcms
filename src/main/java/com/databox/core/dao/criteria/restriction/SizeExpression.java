package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Size expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class SizeExpression implements Criterion {

    private final String property;
    private final long size;
    private final String operator;

    /**
     * Create new size expression.
     *
     * @param property property
     * @param size size
     * @param operator operator
     */
    protected SizeExpression(String property, long size, String operator) {
        this.property = property;
        this.size = size;
        this.operator = operator;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        criteriaQuery.setParam(size);
        return "? " + operator + " (select count(*) from " + criteriaQuery.getPropertyName(property, criteria) + ")";
    }
}
