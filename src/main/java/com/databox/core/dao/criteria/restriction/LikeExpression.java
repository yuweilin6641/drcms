package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Like expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class LikeExpression implements Criterion {

    private final String property;
    private final Object value;
    private final Character escapeChar;
    private final boolean ignoreCase;

    /**
     * Create new like expression.
     *
     * @param property property
     * @param value value
     * @param escapeChar escape char
     * @param ignoreCase set case sensitive
     */
    protected LikeExpression(String property, Object value, Character escapeChar, boolean ignoreCase) {
        this.property = property;
        this.value = value;
        this.escapeChar = escapeChar;
        this.ignoreCase = ignoreCase;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        criteriaQuery.setParam(ignoreCase ? value.toString().toLowerCase() : value);
        String lhs = ignoreCase ? "lower(" + criteriaQuery.getPropertyName(property, criteria) + ")" : criteriaQuery.getPropertyName(property, criteria);
        return lhs + " like ?" + (escapeChar == null ? "" : " escape \'" + escapeChar + "\'");
    }
}
