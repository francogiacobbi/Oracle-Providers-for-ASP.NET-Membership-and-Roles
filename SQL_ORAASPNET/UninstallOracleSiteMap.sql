Rem
Rem $Header: UninstallOracleSiteMap.sql 09-mar-2007.03:22:29 aruns Exp $
Rem
Rem UninstallOracleSiteMap.sql
Rem
Rem Copyright (c) 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      UninstallOracleSiteMap.sql - Drops procedure & table from the Database.
Rem
Rem    DESCRIPTION
Rem      Drops OracleSiteMapProvider specific stored procedure & table from the Database.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aruns       03/09/07 - Drop roles and synonyms.
Rem    aruns       02/25/07 - Created
Rem

-- drop the sitemap provider specific stored procedure from the database.
DROP PROCEDURE ora_aspnet_GetSiteMapData;

-- drop the sitemap provider specifc table from the database.
DROP TABLE ora_aspnet_SiteMap;

-- Drop roles
DROP ROLE ora_aspnet_Smap_FullAccess;

-- Drop public synonym. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_GetSiteMapData;
