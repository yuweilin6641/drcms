package com.databox.core.dao.criteria.restriction;

import java.util.ArrayList;
import java.util.List;

import com.databox.core.dao.criteria.Criteria;
import com.databox.core.dao.criteria.Criterion;

/**
 * Junction expression.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class Junction implements Criterion {

    private final List<Criterion> criteria = new ArrayList<Criterion>();
    private final String operator;

    /**
     * Create new junction.
     *
     * @param operator operator (and, or)
     */
    protected Junction(String operator) {
        this.operator = operator;
    }

    /**
     * Add criterion to junction.
     *
     * @param criterion criterion
     * @return junction
     */
    public Junction add(Criterion criterion) {
        criteria.add(criterion);
        return this;
    }

    @Override
    public String toSqlString(Criteria crit, Criteria.CriteriaQuery criteriaQuery) {
        if (criteria.size() == 0) {
            return "1=1";
        }
        String sql = "(";

        for (Criterion criterion : criteria) {
            if (sql.length() > 1) {
                sql += " " + operator + " ";
            }
            sql += criterion.toSqlString(crit, criteriaQuery);
        }

        return sql += ")";
    }
}
