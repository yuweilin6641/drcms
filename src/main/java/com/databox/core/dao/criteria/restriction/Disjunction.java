package com.databox.core.dao.criteria.restriction;

/**
 * Disjunction (OR).
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class Disjunction extends Junction {

    /**
     * Create new disjunction.
     */
    protected Disjunction() {
        super("or");
    }
}
