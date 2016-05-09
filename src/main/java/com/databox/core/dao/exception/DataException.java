
package com.databox.core.dao.exception;

/**
 * A DataException is a general type of DAO exception.
 * <p>
 * Superclass of exceptions thrown in the persistence integration layer
 * regarding data access errors.
 * </p>
 * 
 * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
 * @version $Revision: 1540 $
 * @since 0.1
 */
public class DataException extends RuntimeException {

    private static final long serialVersionUID = -4896951691234279331L;

    /**
     * Create a new <code>DataException</code>.
     */
    public DataException() {
        super();
    }

    /**
     * Create a new <code>DataException</code> with a message text.
     * 
     * @param message
     *            Message text as String
     */
    public DataException(String message) {
        super(message);
    }

    /**
     * Create a new <code>DataException</code> with the root exception.
     * 
     * @param cause
     *            The root exception
     */
    public DataException(Throwable cause) {
        super(cause);
    }

    /**
     * Create a new <code>DataException</code> with a message text and the root
     * exception.
     * 
     * @param message
     *            Message text as String
     * @param cause
     *            The root exception
     */
    public DataException(String message, Throwable cause) {
        super(message, cause);
    }
}