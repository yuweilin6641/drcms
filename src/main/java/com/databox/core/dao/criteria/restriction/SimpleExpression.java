package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Simple expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class SimpleExpression implements Criterion {

    private final String property;
    private final Object value;
    private final String operator;

    /**
     * Create new simple expression.
     *
     * @param property property
     * @param value value
     * @param operator operator
     */
    protected SimpleExpression(String property, Object value, String operator) {
        this.property = property;
        this.value = value;
        this.operator = operator;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        criteriaQuery.setParam(value);
        return criteriaQuery.getPropertyName(property, criteria) + operator + "?";
    }
}
