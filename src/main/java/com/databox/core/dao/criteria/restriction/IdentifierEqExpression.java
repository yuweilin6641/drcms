package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.api.IEntity;
import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Identifier expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class IdentifierEqExpression implements Criterion {

    private final Object value;

    /**
     * Create new identifier expression.
     *
     * @param value value
     */
    protected IdentifierEqExpression(Object value) {
        this.value = value;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        criteriaQuery.setParam(value);
        return criteriaQuery.getPropertyName(IEntity.P_ID, criteria) + " = ?";
    }
}
