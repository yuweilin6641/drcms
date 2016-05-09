package com.databox.core.dao.criteria.projection;

import java.util.ArrayList;
import java.util.List;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Projection;

/**
 * Projection list.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class ProjectionList implements Projection {

    private List<Projection> elements = new ArrayList<Projection>();

    /**
     * Create new projection list.
     */
    protected ProjectionList() {
    }

    /**
     * Create new projection list.
     *
     * @return projection list
     */
    public ProjectionList create() {
        return new ProjectionList();
    }

    /**
     * Add projection to list.
     *
     * @param projection
     * @return projection list
     */
    public ProjectionList add(Projection projection) {
        elements.add(projection);
        return this;
    }

    @Override
    public String toSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        String sql = "";
        for (Projection projection : elements) {
            if (sql.length() > 0) {
                sql += ", ";
            }
            sql += projection.toSqlString(criteria, criteriaQuery);
        }
        return sql;
    }

    @Override
    public String toGroupSqlString(Criteria criteria, Criteria.CriteriaQuery criteriaQuery) {
        String sql = "";
        for (Projection projection : elements) {
            if (projection.isGrouped()) {
                if (sql.length() > 0) {
                    sql += ", ";
                }
                sql += projection.toGroupSqlString(criteria, criteriaQuery);
            }
        }
        return sql;
    }

    @Override
    public boolean isGrouped() {
        for (Projection projection : elements) {
            if (projection.isGrouped()) {
                return true;
            }
        }
        return false;
    }
}
