package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Between expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class BetweenExpression implements Criterion {

    private final String property;
    private final Object lo;
    private final Object hi;

    /**
     * Create new between expresion.
     *
     * @param property property
     * @param lo lower value
     * @param hi higher value
     */
    protected BetweenExpression(String property, Object lo, Object hi) {
        this.property = property;
        this.lo = lo;
        this.hi = hi;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        criteriaQuery.setParam(lo);
        criteriaQuery.setParam(hi);
        return criteriaQuery.getPropertyName(property, criteria) + " between ? and ?";
    }
}
