package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Property expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class PropertyExpression implements Criterion {

    private final String property;
    private final String otherProperty;
    private final String operator;

    /**
     * Create new property expresion.
     *
     * @param property property
     * @param otherProperty other property
     * @param operator operator
     */
    protected PropertyExpression(String property, String otherProperty, String operator) {
        this.property = property;
        this.otherProperty = otherProperty;
        this.operator = operator;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        return criteriaQuery.getPropertyName(property, criteria) + operator + criteriaQuery.getPropertyName(otherProperty, criteria);
    }
}
