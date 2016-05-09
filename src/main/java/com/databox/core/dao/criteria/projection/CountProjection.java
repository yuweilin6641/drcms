package com.databox.core.dao.criteria.projection;

import com.databox.core.dao.criteria.Criteria;

/**
 * Count projection.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class CountProjection extends AggregateProjection {

    private boolean distinct;

    /**
     * Create new count projection.
     *
     * @param property counted property
     */
    protected CountProjection(String property) {
        super("count", property);
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        String sql = "count(";
        if (distinct) {
            sql += "distinct ";
        }
        return sql += criteriaQuery.getPropertyName(property, criteria) + ")";
    }

    /**
     * Set projection as distincted.
     *
     * @return projection
     */
    public CountProjection setDistinct() {
        distinct = true;
        return this;
    }
}
