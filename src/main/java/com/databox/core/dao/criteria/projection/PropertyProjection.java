package com.databox.core.dao.criteria.projection;

import com.databox.core.dao.criteria.Criteria;

/**
 * Property projection.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class PropertyProjection extends SimpleProjection {

    private String propertyName;

    /**
     * Create new property projection.
     *
     * @param property property
     * @param grouped set projection as grouping one
     */
    protected PropertyProjection(String property, boolean grouped) {
        this.propertyName = property;
        this.grouped = grouped;
    }

    /**
     * Create new property projection without grouping.
     *
     * @param property property
     */
    protected PropertyProjection(String property) {
        this(property, false);
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        return criteriaQuery.getPropertyName(propertyName, criteria);
    }

    @Override
    public String toGroupSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        if (!grouped) {
            return super.toGroupSqlString(criteria, criteriaQuery);
        } else {
            return criteriaQuery.getPropertyName(propertyName, criteria);
        }
    }
}
