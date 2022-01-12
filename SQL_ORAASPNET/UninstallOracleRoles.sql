-- Copyright (c) 2002, 2007, Oracle. All rights reserved.

-- Drop public synonyms. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM  ora_aspnet_Roles_CreateRole;
DROP PUBLIC SYNONYM  ora_aspnet_Roles_DeleteRole;
DROP PUBLIC SYNONYM  ora_aspnet_Roles_GetAllRoles;
DROP PUBLIC SYNONYM  ora_aspnet_Roles_RoleExists;
DROP PUBLIC SYNONYM  ora_aspnet_UIR_AddUsersToRoles;
DROP PUBLIC SYNONYM  ora_aspnet_UIR_FindUsersInRole;
DROP PUBLIC SYNONYM  ora_aspnet_UIR_GetRolesForUser;
DROP PUBLIC SYNONYM  ora_aspnet_UIR_GetUsersInRoles;
DROP PUBLIC SYNONYM  ora_aspnet_UIR_IsUserInRole;
DROP PUBLIC SYNONYM  ora_aspnet_UIR_RemUsersFmRoles;


-- Drop roles
DROP ROLE ora_aspnet_Roles_BasicAccess;
DROP ROLE ora_aspnet_Roles_ReportAccess;
DROP ROLE ora_aspnet_Roles_FullAccess;


-- Drop functions
DROP FUNCTION ora_aspnet_UIR_IsUserInRole;
DROP FUNCTION ora_aspnet_UIR_GetRolesForUser;
DROP FUNCTION ora_aspnet_Roles_CreateRole;
DROP FUNCTION ora_aspnet_Roles_DeleteRole;
DROP FUNCTION ora_aspnet_Roles_RoleExists;
DROP FUNCTION ora_aspnet_UIR_AddUsersToRoles;
DROP FUNCTION ora_aspnet_UIR_RemUsersFmRoles;
DROP FUNCTION ora_aspnet_UIR_GetUsersInRoles;
DROP FUNCTION ora_aspnet_UIR_FindUsersInRole;
DROP FUNCTION ora_aspnet_Roles_GetAllRoles;

DROP PACKAGE  ORA_ASPNET_ROLES_PKG;


-- Drop views
DROP VIEW ora_vw_aspnet_Roles;
DROP VIEW ora_vw_aspnet_UIR;


-- Drop tables
DROP TABLE ora_aspnet_UsersInRoles;
DROP TABLE ora_aspnet_Roles;

