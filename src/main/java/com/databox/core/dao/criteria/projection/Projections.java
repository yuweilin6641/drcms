package com.databox.core.dao.criteria.projection;

import com.databox.core.dao.criteria.Projection;

/**
 * Projections builder.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public final class Projections {

    private Projections() {
    }

    /**
     * Create a distinct projection from a projection.
     *
     * @param projection projection
     * @return distincted projection
     */
    public static Projection distinct(Projection projection) {
        return new Distinct(projection);
    }

    /**
     * Create a new projection list.
     *
     * @return projection list
     */
    public static ProjectionList projectionList() {
        return new ProjectionList();
    }

    /**
     * The query row count, ie. <code>count(*)</code>.
     *
     * @return row count projection
     */
    public static Projection rowCount() {
        return new RowCountProjection();
    }

    /**
     * A property value count.
     *
     * @param property projection which will be counted
     * @return count projection
     */
    public static Projection count(String property) {
        return new CountProjection(property);
    }

    /**
     * A distinct property value count
     *
     * @param property projection which will be counted
     * @return count projection
     */
    public static Projection countDistinct(String property) {
        return new CountProjection(property).setDistinct();
    }

    /**
     * A property maximum value.
     *
     * @param property property
     * @return maximum projection
     */
    public static Projection max(String property) {
        return new AggregateProjection("max", property);
    }

    /**
     * A property minimum value.
     *
     * @param property property
     * @return minimum projection
     */
    public static Projection min(String property) {
        return new AggregateProjection("min", property);
    }

    /**
     * A property average value
     *
     * @param property property
     * @return average projection
     */
    public static Projection avg(String property) {
        return new AggregateProjection("avg", property);
    }

    /**
     * A property value sum
     *
     * @param property property
     * @return sum projection
     */
    public static Projection sum(String property) {
        return new AggregateProjection("sum", property);
    }

    /**
     * A grouping property value
     *
     * @param property property
     * @return property projection with grouping
     */
    public static Projection groupProperty(String property) {
        return new PropertyProjection(property, true);
    }

    /**
     * A projected property value
     *
     * @param property property
     * @return property projection
     */
    public static Projection property(String property) {
        return new PropertyProjection(property);
    }

    /**
     * A grouping EQL projection, specifying both select clause and group by clause fragments
     *
     * @param eql select clause
     * @param groupEql group by clause
     * @return eql projection
     */
    public static Projection groupEql(String eql, String groupEql) {
        return new EqlProjection(eql, groupEql);
    }

    /**
     * A EQL projection, a typed select clause fragment
     *
     * @param eql select clause
     * @return eql projection
     */
    public static Projection eql(String eql) {
        return new EqlProjection(eql);
    }

    /**
     * A projected identifier value.
     *
     * @return identifier projection
     */
    public static Projection id() {
        return new IdentifierProjection();
    }
}
