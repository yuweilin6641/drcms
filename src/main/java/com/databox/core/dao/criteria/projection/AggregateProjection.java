package com.databox.core.dao.criteria.projection;

import com.databox.core.dao.criteria.Criteria;

/**
 * Aggregate projection.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class AggregateProjection extends SimpleProjection {

    protected final String property;

    private final String aggregate;

    /**
     * Create new aggregate projection using given function and property.
     * 
     * @param aggregate aggregate function
     * @param property aggregated property
     */
    protected AggregateProjection(String aggregate, String property) {
        this.aggregate = aggregate;
        this.property = property;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        return aggregate + "(" + criteriaQuery.getPropertyName(property, criteria) + ")";
    }
}
