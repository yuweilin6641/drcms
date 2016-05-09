package com.databox.core.dao.api;

/**
 * Interface marks class which cannot be deleted. If someone calls one of DAO's delete
 * methods object will be hidden instead of deleted.
 *
 * @author Maciej Szczytowski <mszczytowski-genericdao@gmail.com>
 * @since 1.0
 */
public interface IHiddenable {

    /**
     * Property which represents hidden flag.
     */
    String P_IS_HIDDEN = "isHidden";

    /**
     * Check if object is hidden.
     *
     * @return true when object is hidden
     */
    boolean isHidden();

    /**
     * Set object as default one.
     *
     * @param isHidden value of hidden flag
     */
    void setHidden(boolean isHidden);
}
