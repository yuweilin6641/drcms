/*
 * openwms.org, the Open Warehouse Management System.
 *
 * This file is part of openwms.org.
 *
 * openwms.org is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as 
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * openwms.org is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this software. If not, write to the Free
 * Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301 USA, or see the FSF site: http://www.fsf.org.
 */
package com.databox.core.service.exception;

import java.io.Serializable;

/**
 * A ServiceRuntimeException is an unchecked application exception thrown in
 * service layer classes.
 * 
 * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
 * @version $Revision: 1538 $
 * @since 0.1
 */
public class ServiceRuntimeException extends RuntimeException implements Serializable {

    private static final long serialVersionUID = 3091182786979000919L;

    /**
     * Create a new ServiceRuntimeException with a message text.
     * 
     * @param message
     *            Detail message
     */
    public ServiceRuntimeException(String message) {
        super(message);
    }

    /**
     * Create a new ServiceRuntimeException with a cause exception.
     * 
     * @param cause
     *            Root cause
     */
    public ServiceRuntimeException(Throwable cause) {
        super(cause);
    }

    /**
     * Create a new ServiceRuntimeException with a message text and the cause
     * exception.
     * 
     * @param message
     *            Detail message
     * @param cause
     *            Root cause
     */
    public ServiceRuntimeException(String message, Throwable cause) {
        super(message, cause);
    }
}