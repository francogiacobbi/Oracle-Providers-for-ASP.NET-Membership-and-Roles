-- Copyright (c) 2002, 2008, Oracle. All rights reserved.
Rem
Rem    NAME
Rem      InstallOracleRoles.sql
Rem
Rem    DESCRIPTION
Rem      Create table, view, roles, and public synonyms, run a PLB file and   
Rem      grant privileges for the installation of the OracleRoleProvider.
Rem

-- get current username
col USER NEW_VALUE CurrentUser;
select USER from dual;

-- create tables for Oracle Role Provider

BEGIN

-- first check if the table already exists
IF ( (ora_aspnet_TableExists('ORA_ASPNET_ROLES') = 0) OR
     (ora_aspnet_TableExists('ORA_ASPNET_USERSINROLES') = 0)) THEN

-- tables for Oracle Role Provider
execute immediate 'CREATE TABLE ora_aspnet_Roles
(
ApplicationId        RAW (16) NOT NULL,
RoleId               RAW (16) DEFAULT SYS_GUID() PRIMARY KEY,
RoleName             nvarchar2(256) NOT NULL,
LoweredRoleName      nvarchar2(256) NOT NULL,
Description          nvarchar2(256),
CONSTRAINT fk_ApplicationId FOREIGN KEY (ApplicationId) REFERENCES ora_aspnet_Applications(ApplicationId)
)';
execute immediate 'CREATE UNIQUE INDEX aspnet_Roles_index1 ON ora_aspnet_Roles(ApplicationId, LoweredRoleName)';


execute immediate 'CREATE TABLE ora_aspnet_UsersInRoles
(
UserId     	RAW(16)  NOT NULL,
RoleId    	RAW(16)  NOT NULL,
CONSTRAINT pk_aspnet_UsersInRoles PRIMARY KEY(UserId, RoleId)
)';
execute immediate 'ALTER TABLE ora_aspnet_UsersInRoles ADD CONSTRAINT fk_aspnet_UsersInRoles_UserId FOREIGN KEY (UserId) 
       REFERENCES ora_aspnet_Users (UserId)';
execute immediate 'ALTER TABLE ora_aspnet_UsersInRoles ADD CONSTRAINT fk_aspnet_UsersInRoles_RoleId FOREIGN KEY (RoleId) 
       REFERENCES ora_aspnet_Roles (RoleId)';
execute immediate 'CREATE INDEX aspnet_UsersInRoles_index ON ora_aspnet_UsersInRoles(RoleId)';



execute immediate 'CREATE VIEW ora_vw_aspnet_Roles AS
 SELECT ApplicationId, RoleId, RoleName, LoweredRoleName, Description
  FROM ora_aspnet_Roles
   WITH READ ONLY';

execute immediate 'CREATE VIEW ora_vw_aspnet_UIR AS
  SELECT UserId, RoleId
   FROM ora_aspnet_UsersInRoles
    WITH READ ONLY';

-- create roles
execute immediate 'CREATE ROLE ora_aspnet_Roles_BasicAccess';
execute immediate 'CREATE ROLE ora_aspnet_Roles_ReportAccess';
execute immediate 'CREATE ROLE ora_aspnet_Roles_FullAccess';



-- create synonyms
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Roles_CreateRole    for &CurrentUser..ora_aspnet_Roles_CreateRole';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Roles_DeleteRole    for &CurrentUser..ora_aspnet_Roles_DeleteRole';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Roles_GetAllRoles   for &CurrentUser..ora_aspnet_Roles_GetAllRoles';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Roles_RoleExists    for &CurrentUser..ora_aspnet_Roles_RoleExists';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_UIR_AddUsersToRoles for &CurrentUser..ora_aspnet_UIR_AddUsersToRoles';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_UIR_FindUsersInRole for &CurrentUser..ora_aspnet_UIR_FindUsersInRole';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_UIR_GetRolesForUser for &CurrentUser..ora_aspnet_UIR_GetRolesForUser';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_UIR_GetUsersInRoles for &CurrentUser..ora_aspnet_UIR_GetUsersInRoles';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_UIR_IsUserInRole    for &CurrentUser..ora_aspnet_UIR_IsUserInRole';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_UIR_RemUsersFmRoles for &CurrentUser..ora_aspnet_UIR_RemUsersFmRoles';

END IF;

END;
/


-- setup Stored Procedures
@@InstallOracleRolesSP.plb;





-- ReportAccess will have all privileges of BasicAccess
GRANT ora_aspnet_Roles_BasicAccess  TO ora_aspnet_Roles_ReportAccess;

-- FullAccess will have privileges of ReportAccess which in turn has privileges of BasicAccess
GRANT ora_aspnet_Roles_ReportAccess TO ora_aspnet_Roles_FullAccess;	


-- grant execute sp privileges to BasicAccess
GRANT EXECUTE ON ora_aspnet_UIR_IsUserInRole    to ora_aspnet_Roles_BasicAccess;
GRANT EXECUTE ON ora_aspnet_UIR_GetRolesForUser to ora_aspnet_Roles_BasicAccess;


-- grant execute sp privileges to ReportAccess
GRANT EXECUTE ON ora_aspnet_UIR_FindUsersInRole to ora_aspnet_Roles_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Roles_GetAllRoles   to ora_aspnet_Roles_ReportAccess;
GRANT EXECUTE ON ora_aspnet_UIR_GetUsersInRoles to ora_aspnet_Roles_ReportAccess;
GRANT EXECUTE ON ora_aspnet_Roles_RoleExists    to ora_aspnet_Roles_ReportAccess;


-- grant execute sp privileges to FullAccess
GRANT EXECUTE ON ora_aspnet_Roles_CreateRole    to ora_aspnet_Roles_FullAccess;
GRANT EXECUTE ON ora_aspnet_Roles_DeleteRole    to ora_aspnet_Roles_FullAccess;
GRANT EXECUTE ON ora_aspnet_UIR_AddUsersToRoles to ora_aspnet_Roles_FullAccess;
GRANT EXECUTE ON ora_aspnet_UIR_RemUsersFmRoles to ora_aspnet_Roles_FullAccess;


-- grant view privileges
GRANT SELECT ON ora_vw_aspnet_Applications TO ora_aspnet_Roles_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_Users        TO ora_aspnet_Roles_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_Roles        TO ora_aspnet_Roles_ReportAccess;
GRANT SELECT ON ora_vw_aspnet_UIR          TO ora_aspnet_Roles_ReportAccess;