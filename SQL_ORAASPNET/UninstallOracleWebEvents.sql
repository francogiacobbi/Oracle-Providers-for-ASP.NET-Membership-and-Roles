Rem
Rem $Header: UninstallOracleWebEvents.sql 09-mar-2007.03:22:52 aruns Exp $
Rem
Rem UninstallOracleWebEvents.sql
Rem
Rem Copyright (c) 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      UninstallOracleWebEvents.sql - Drops procedure & table from the Database.
Rem
Rem    DESCRIPTION
Rem      Drops OracleWebEventProvider specific stored procedure & table from the Database.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aruns       03/09/07 - Drop roles and synonyms.
Rem    aruns       02/26/07 - Created
Rem

-- drop the Webevents specific stored procedure.
DROP PROCEDURE ora_aspnet_LogWebEvents;

-- drop the Webevents specific table from the database.
DROP TABLE ora_aspnet_WebEvents;

-- Drop roles
DROP ROLE ora_aspnet_Wevnt_FullAccess;

-- Drop public synonym. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_LogWebEvents;
