package com.databox.core.dao.criteria.restriction;

import com.databox.core.dao.criteria.Criterion;

public class NotEmptyExpression extends AbstractEmptinessExpression implements Criterion {

    /**
     * Create new not empty expression.
     *
     * @param property property
     */
    protected NotEmptyExpression(String property) {
        super(property);
    }

    @Override
    protected boolean excludeEmpty() {
        return true;
    }
}
