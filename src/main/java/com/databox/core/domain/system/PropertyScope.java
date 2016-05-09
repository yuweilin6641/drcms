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
package com.databox.core.domain.system;

/**
 * A PropertyScope defines the different scopes for preferences.
 * 
 * @author <a href="mailto:scherrer@openwms.org">Heiko Scherrer</a>
 * @version $Revision: 1583 $
 * @since 0.1
 */
public enum PropertyScope {

    /**
     * These kind of preferences belong to the main application.
     */
    APPLICATION,

    /**
     * These kind of preferences are specific to a <code>Module</code>.
     */
    MODULE,

    /**
     * These kind of preferences belong to a particular <code>Role</code>.
     */
    ROLE,

    /**
     * These kind of preferences belong to a certain <code>User</code>.
     */
    USER;
}