package com.databox.core.dao.criteria.projection;

import com.databox.core.dao.criteria.Criteria;

/**
 * EQL projection.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class EqlProjection extends SimpleProjection {

    private String eql;

    private String groupEql;

    /**
     * Create new EQL projection with select and group by clause.
     *
     * @param eql select clause
     * @param groupEql group by clase
     */
    protected EqlProjection(String eql, String groupEql) {
        this.eql = eql;
        this.groupEql = groupEql;
        if (groupEql != null) {
            this.grouped = true;
        }
    }

    /**
     * Create new EQL projection with select clause.
     *
     * @param eql select clause
     */
    protected EqlProjection(String eql) {
        this(eql, null);
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        return eql;
    }

    @Override
    public String toGroupSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        if (!grouped) {
            return super.toGroupSqlString(criteria, criteriaQuery);
        } else {
            return groupEql;
        }
    }
}
