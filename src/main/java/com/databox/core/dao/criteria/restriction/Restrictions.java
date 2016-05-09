package com.databox.core.dao.criteria.restriction;

import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

import com.databox.core.dao.criteria.Criterion;

/**
 * Restrictions builder.
 * 
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public class Restrictions {

  Restrictions() {
  }

  /**
   * Create new "equal" expression to identifier property.
   * 
   * @param value value
   * @return identifier "eqault" expression
   */
  public static Criterion idEq(Object value) {
    return new IdentifierEqExpression(value);
  }

  /**
   * Create new "equal" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "equals" expression
   */
  public static Criterion eq(String property, Object value) {
    return new SimpleExpression(property, value, "=");
  }

  /**
   * Create new "not equal" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "not equals" expression
   */
  public static Criterion ne(String property, Object value) {
    return new SimpleExpression(property, value, "<>");
  }

  /**
   * Create new "like" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "like" expression
   */
  public static Criterion like(String property, Object value) {
    return new LikeExpression(property, value, null, false);
  }

  /**
   * Create new case-sensitive "like" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "ilike" expression
   */
  public static Criterion ilike(String property, Object value) {
    return new LikeExpression(property, value, null, true);
  }

  /**
   * Create new "greater than" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "greaten than" expression
   */
  public static Criterion gt(String property, Object value) {
    return new SimpleExpression(property, value, ">");
  }

  /**
   * Create new "less than" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "less than" expression
   */
  public static Criterion lt(String property, Object value) {
    return new SimpleExpression(property, value, "<");
  }

  /**
   * Create new "less than or equal" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "less than or equal" expression
   */
  public static Criterion le(String property, Object value) {
    return new SimpleExpression(property, value, "<=");
  }

  /**
   * Create new "greater than or equal" expression to property.
   * 
   * @param property property
   * @param value value
   * @return "greater than or equal" expression
   */
  public static Criterion ge(String property, Object value) {
    return new SimpleExpression(property, value, ">=");
  }

  /**
   * Create new "between" expression to property.
   * 
   * @param property property
   * @param lo lower value
   * @param hi higher value
   * @return "beetwen" expression
   */
  public static Criterion between(String property, Object lo, Object hi) {
    return new BetweenExpression(property, lo, hi);
  }

  /**
   * Create new "in" expression to property.
   * 
   * @param property property
   * @param values values
   * @return "in" expression
   */
  public static Criterion in(String property, Object[] values) {
    return new InExpression(property, values);
  }

  /**
   * Create new "in" expression to property.
   * 
   * @param property property
   * @param values values
   * @return "in" expression
   */
  public static Criterion in(String property, Collection values) {
    return new InExpression(property, values.toArray());
  }

  /**
   * Create new insensitive "in" expression to property.
   * 
   * @param property property
   * @param values values
   * @return "in" expression
   */
  public static Criterion iin(String property, String[] values) {
    return new InsensitiveInExpression(property, values);
  }

  /**
   * Create new insensitive "in" expression to property.
   * 
   * @param property property
   * @param values values
   * @return "in" expression
   */
  public static Criterion iin(String property, Collection<String> values) {
    return new InsensitiveInExpression(property, values.toArray(new String[values.size()]));
  }

  /**
   * Create new "is null" expression to property.
   * 
   * @param property property
   * @return "is null" expression
   */
  public static Criterion isNull(String property) {
    return new NullExpression(property);
  }

  /**
   * Create new "equal" expression to two properties.
   * 
   * @param property property
   * @param otherProperty other property
   * @return "equal" expression
   */
  public static Criterion eqProperty(String property, String otherProperty) {
    return new PropertyExpression(property, otherProperty, "=");
  }

  /**
   * Create new "not equal" expression to two properties.
   * 
   * @param property property
   * @param otherProperty other property
   * @return "not equal" expression
   */
  public static Criterion neProperty(String property, String otherProperty) {
    return new PropertyExpression(property, otherProperty, "<>");
  }

  /**
   * Create new "less than" expression to two properties.
   * 
   * @param property property
   * @param otherProperty other property
   * @return "less than" expression
   */
  public static Criterion ltProperty(String property, String otherProperty) {
    return new PropertyExpression(property, otherProperty, "<");
  }

  /**
   * Create new "less than or equal" expression to two properties.
   * 
   * @param property property
   * @param otherProperty other property
   * @return "less than on equal" expression
   */
  public static Criterion leProperty(String property, String otherProperty) {
    return new PropertyExpression(property, otherProperty, "<=");
  }

  /**
   * Create new "greater than" expression to two properties.
   * 
   * @param property property
   * @param otherProperty other property
   * @return "greater than" expression
   */
  public static Criterion gtProperty(String property, String otherProperty) {
    return new PropertyExpression(property, otherProperty, ">");
  }

  /**
   * Create new "greater than or equal" expression to two properties.
   * 
   * @param property property
   * @param otherProperty other property
   * @return "greater than on equal" expression
   */
  public static Criterion geProperty(String property, String otherProperty) {
    return new PropertyExpression(property, otherProperty, ">=");
  }

  /**
   * Create new "is not null" expression to property.
   * 
   * @param property property
   * @return "is not null" expression
   */
  public static Criterion isNotNull(String property) {
    return new NotNullExpression(property);
  }

  /**
   * Create new conjuction of two expressions.
   * 
   * @param lhs left site criterion
   * @param rhs right site criterion
   * @return conjuction
   */
  public static Criterion and(Criterion lhs, Criterion rhs) {
    return new LogicalExpression(lhs, rhs, "and");
  }

  /**
   * Create new disjuction of two expressions.
   * 
   * @param lhs left site criterion
   * @param rhs right site criterion
   * @return disjuction
   */
  public static Criterion or(Criterion lhs, Criterion rhs) {
    return new LogicalExpression(lhs, rhs, "or");
  }

  /**
   * Create negation of an expression.
   * 
   * @param expression criterion
   * @return negation
   */
  public static Criterion not(Criterion expression) {
    return new NotExpression(expression);
  }

  /**
   * Create a group of expressions (A and B and C).
   * 
   * @return conjuction
   */
  public static Conjunction conjunction() {
    return new Conjunction();
  }

  /**
   * Create a group of expressions (A or B or C).
   * 
   * @return disjunction
   */
  public static Disjunction disjunction() {
    return new Disjunction();
  }

  /**
   * Create new "is empty" expression to collection property.
   * 
   * @param property property
   * @return emptiness expression
   */
  public static Criterion isEmpty(String property) {
    return new EmptyExpression(property);
  }

  /**
   * Create new "is not empty" expression to collection property.
   * 
   * @param property property
   * @return not emptiness expression
   */
  public static Criterion isNotEmpty(String property) {
    return new NotEmptyExpression(property);
  }

  /**
   * Create new "size equal" expression to collection property.
   * 
   * @param property property
   * @param size size
   * @return size "equal" expression
   */
  public static Criterion sizeEq(String property, long size) {
    return new SizeExpression(property, size, "=");
  }

  /**
   * Create new "size not equal" expression to collecion property.
   * 
   * @param property property
   * @param size size
   * @return size "not equal" expression
   */
  public static Criterion sizeNe(String property, long size) {
    return new SizeExpression(property, size, "<>");
  }

  /**
   * Create new "size less than" expression to collecion property.
   * 
   * @param property property
   * @param size size
   * @return size "less than" expression
   */
  public static Criterion sizeGt(String property, long size) {
    return new SizeExpression(property, size, "<");
  }

  /**
   * Create new "size greater than" expression to collecion property.
   * 
   * @param property property
   * @param size size
   * @return size "greater than" expression
   */
  public static Criterion sizeLt(String property, long size) {
    return new SizeExpression(property, size, ">");
  }

  /**
   * Create new "size less than or equal" expression to collecion property.
   * 
   * @param property property
   * @param size size
   * @return size "less than or equal" expression
   */
  public static Criterion sizeGe(String property, long size) {
    return new SizeExpression(property, size, "<=");
  }

  /**
   * Create new "size greater than or equal" expression to collecion property.
   * 
   * @param property property
   * @param size size
   * @return size "greater than or equal" expression
   */
  public static Criterion sizeLe(String property, long size) {
    return new SizeExpression(property, size, ">=");
  }

  /**
   * Create new conjuction of "equals" expressions using property:value map.
   * 
   * @param propertyValues values
   * @return "equals" conjuction
   */
  public static Criterion allEq(Map propertyValues) {
    Conjunction conj = conjunction();
    Iterator iter = propertyValues.entrySet().iterator();
    while (iter.hasNext()) {
      Map.Entry me = (Map.Entry) iter.next();
      conj.add(eq((String) me.getKey(), me.getValue()));
    }
    return conj;
  }
}
