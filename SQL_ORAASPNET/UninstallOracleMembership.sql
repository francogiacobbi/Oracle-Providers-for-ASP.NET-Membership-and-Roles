-- Copyright (c) 2002, 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      UninstallOracleMembership.sql
Rem
Rem    DESCRIPTION
Rem      Drop table, view, roles, functions and public synonyms for 
Rem      the deinstallation of the OracleMembershipProvider.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    shsu       12/20/06 - Created
Rem

-- Drop table
DROP TABLE ora_aspnet_Membership;

-- Drop roles
DROP ROLE ora_aspnet_Mem_BasicAccess;
DROP ROLE ora_aspnet_Mem_ReportAccess;
DROP ROLE ora_aspnet_Mem_FullAccess;

-- Drop view
DROP VIEW ora_vw_aspnet_MemUsers;

-- Drop functions
DROP FUNCTION ora_aspnet_Mem_ChangePwdQAndA;
DROP FUNCTION ora_aspnet_Mem_CreateUser;
DROP FUNCTION ora_aspnet_Mem_FindUsersByName;
DROP FUNCTION ora_aspnet_Mem_FindUsersByEml;
DROP FUNCTION ora_aspnet_Mem_GetPwdWithFmt;
DROP FUNCTION ora_aspnet_Mem_GetPassword;
DROP FUNCTION ora_aspnet_Mem_SetPassword;
DROP FUNCTION ora_aspnet_Mem_GetUserByUid;
DROP FUNCTION ora_aspnet_Mem_GetUserByName;
DROP FUNCTION ora_aspnet_Mem_GetUserByEml;
DROP FUNCTION ora_aspnet_Mem_GetAllUsers;
DROP FUNCTION ora_aspnet_Mem_GetNumOfUsersOn;
DROP FUNCTION ora_aspnet_Mem_ResetPassword;
DROP FUNCTION ora_aspnet_Mem_UpdateUser;
DROP FUNCTION ora_aspnet_Mem_UnlockUser;
DROP FUNCTION ora_aspnet_Mem_UpdateUserInfo;
DROP FUNCTION ora_aspnet_Mem_DeleteUser;


-- Drop public synonym. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_Users_DeleteUser;
DROP PUBLIC SYNONYM ora_aspnet_Mem_DeleteUser;
DROP PUBLIC SYNONYM ora_aspnet_Mem_ChangePwdQAndA;
DROP PUBLIC SYNONYM ora_aspnet_Mem_CreateUser;
DROP PUBLIC SYNONYM ora_aspnet_Mem_FindUsersByName;
DROP PUBLIC SYNONYM ora_aspnet_Mem_FindUsersByEml;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetPwdWithFmt;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetPassword;
DROP PUBLIC SYNONYM ora_aspnet_Mem_SetPassword;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetUserByUid;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetUserByName;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetUserByEml;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetAllUsers;
DROP PUBLIC SYNONYM ora_aspnet_Mem_GetNumOfUsersOn;
DROP PUBLIC SYNONYM ora_aspnet_Mem_ResetPassword;
DROP PUBLIC SYNONYM ora_aspnet_Mem_UpdateUser;
DROP PUBLIC SYNONYM ora_aspnet_Mem_UnlockUser;
DROP PUBLIC SYNONYM ora_aspnet_Mem_UpdateUserInfo;