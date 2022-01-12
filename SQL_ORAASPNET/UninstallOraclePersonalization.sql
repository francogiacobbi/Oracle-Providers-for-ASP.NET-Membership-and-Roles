Rem
Rem $Header: UninstallOraclePersonalization.sql 09-mar-2007.03:22:05 aruns Exp $
Rem
Rem UninstallOraclePersonalization.sql
Rem
Rem Copyright (c) 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      UninstallOraclePersonalization.sql - Drops procedures & tables from the Database.
Rem
Rem    DESCRIPTION
Rem      Drops OraclePersonalizationProvider specific stored procedures & tables from the Database.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aruns       02/25/07 - Created
Rem

-- drop all the procedures related to Oracle ASP.NET Personalization provider

drop procedure ora_aspnet_CreatePage;
drop procedure ora_aspnet_CreateUser;
drop procedure ora_aspnet_PA_GetCountOfState;
drop procedure ora_aspnet_PA_ResetSharedState;
drop procedure ora_aspnet_PA_ResetUserState;
drop procedure ora_aspnet_PAU_GetPgSettings;
drop procedure ora_aspnet_PAU_ResetPgSettings;
drop procedure ora_aspnet_PPU_ResetPgSettings;
drop procedure ora_aspnet_PPU_GetPgSettings;
drop procedure ora_aspnet_PAU_SetPgSettings;
drop procedure ora_aspnet_PPU_SetPgSettings;
drop procedure ora_aspnet_PA_FindState;

-- drop all oracle personalization provider specific tables from the database.
drop table ora_aspnet_PersonaliznPerUser;
drop table ora_aspnet_PersonaliznAllUsers;
drop table ora_aspnet_Paths;

-- Drop roles
DROP ROLE ora_aspnet_Pers_BasicAccess;
DROP ROLE ora_aspnet_Pers_ReportAccess;
DROP ROLE ora_aspnet_Pers_FullAccess;

-- Drop public synonym. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_CreatePage;
DROP PUBLIC SYNONYM ora_aspnet_CreateUser;
DROP PUBLIC SYNONYM ora_aspnet_PA_GetCountOfState;
DROP PUBLIC SYNONYM ora_aspnet_PA_ResetSharedState;
DROP PUBLIC SYNONYM ora_aspnet_PA_ResetUserState;
DROP PUBLIC SYNONYM ora_aspnet_PAU_GetPgSettings;
DROP PUBLIC SYNONYM ora_aspnet_PAU_ResetPgSettings;
DROP PUBLIC SYNONYM ora_aspnet_PPU_ResetPgSettings;
DROP PUBLIC SYNONYM ora_aspnet_PPU_GetPgSettings;
DROP PUBLIC SYNONYM ora_aspnet_PAU_SetPgSettings;
DROP PUBLIC SYNONYM ora_aspnet_PPU_SetPgSettings;
DROP PUBLIC SYNONYM ora_aspnet_PA_FindState;
