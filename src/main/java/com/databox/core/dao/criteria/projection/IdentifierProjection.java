package com.databox.core.dao.criteria.projection;

import com.databox.core.dao.api.IEntity;
import com.databox.core.dao.criteria.Criteria;

/**
 * Identifier projection.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class IdentifierProjection extends SimpleProjection {

    /**
     * Create new identifier projection.
     *
     * @param grouped set projection as grouping one
     */
    protected IdentifierProjection(boolean grouped) {
        this.grouped = grouped;
    }

    /**
     * * Create new identifier projection without grouping.
     */
    protected IdentifierProjection() {
        this(false);
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        return criteriaQuery.getPropertyName(IEntity.P_ID, criteria);
    }

    @Override
    public String toGroupSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        if (!grouped) {
            return super.toGroupSqlString(criteria, criteriaQuery);
        } else {
            return criteriaQuery.getPropertyName(IEntity.P_ID, criteria);
        }
    }
}
