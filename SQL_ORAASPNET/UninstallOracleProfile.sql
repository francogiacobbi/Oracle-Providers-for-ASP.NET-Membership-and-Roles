-- Copyright (c) 2002, 2007, Oracle. All rights reserved. 
Rem
Rem    NAME
Rem      UninstallOracleProfile.sql
Rem
Rem    DESCRIPTION
Rem      Drop table, view, roles, functions and public synonyms for 
Rem      the deinstallation of the OracleProfileProvider.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    shsu       12/20/06 - Created
Rem


-- Drop table
DROP TABLE ora_aspnet_Profile;

-- Drop roles
DROP ROLE ora_aspnet_Prof_BasicAccess;
DROP ROLE ora_aspnet_Prof_ReportAccess;
DROP ROLE ora_aspnet_Prof_FullAccess;

-- Drop view
DROP VIEW ora_vw_aspnet_Profiles;

-- Drop functions
DROP FUNCTION ora_aspnet_Prof_DeleteInactPf;
DROP FUNCTION ora_aspnet_Prof_DeleteProfiles;
DROP FUNCTION ora_aspnet_Prof_GetProfiles;
DROP FUNCTION ora_aspnet_Prof_GetNOfInactPf;
DROP FUNCTION ora_aspnet_Prof_GetProperties;
DROP FUNCTION ora_aspnet_Prof_SetProperties;
DROP PACKAGE ora_aspnet_Prof_pkg;

-- Drop public synonym. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_Prof_DeleteInactPf;
DROP PUBLIC SYNONYM ora_aspnet_Prof_DeleteProfiles;
DROP PUBLIC SYNONYM ora_aspnet_Prof_GetProfiles;
DROP PUBLIC SYNONYM ora_aspnet_Prof_GetNOfInactPf;
DROP PUBLIC SYNONYM ora_aspnet_Prof_GetProperties;
DROP PUBLIC SYNONYM ora_aspnet_Prof_SetProperties;
DROP PUBLIC SYNONYM ora_aspnet_Prof_pkg;
