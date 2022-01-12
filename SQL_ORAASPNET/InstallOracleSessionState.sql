-- Copyright (c) 2002, 2008, Oracle. All rights reserved.

-- For Oracle 10gR1(10.1.0.2) database and higher
-- For Oracle 9iR2(9.2.x) database, run InstallOracleSessionState92.sql instead

Rem
Rem    NAME
Rem      InstallOracleSessionState.sql
Rem
Rem    DESCRIPTION
Rem      Create table, view, roles, and public synonyms, run a PLB file and   
Rem      grant privileges for the installation of the OracleSessionStateStoreProvider.
Rem


-- get current username
col USER NEW_VALUE CurrentUser;
select USER from dual;

-- create tables for Oracle Session State Store Provider

BEGIN

-- first check if the table already exists
IF ( (ora_aspnet_TableExists('ORA_ASPNET_SESSIONAPPLICATIONS') = 0) OR
     (ora_aspnet_TableExists('ORA_ASPNET_SESSIONS') = 0)) THEN

-- tables for Oracle Session State Store Provider

execute immediate 'CREATE TABLE ora_aspnet_SessionApplications
(
AppId     	RAW(16)            NOT NULL PRIMARY KEY,
AppName   	nvarchar2(280)     NOT NULL
)';
execute immediate 'CREATE INDEX aspnet_SessionState_App_Index ON ora_aspnet_SessionApplications(AppName)';

execute immediate 'CREATE TABLE ora_aspnet_Sessions
(
SessionId          	nvarchar2(116)    	NOT NULL PRIMARY KEY,
Created             	DATE 			DEFAULT SYS_EXTRACT_UTC(SYSTIMESTAMP) NOT NULL,
Expires            	DATE			NOT NULL,
LockDate            	DATE 			NOT NULL,
LockDateLocal       	DATE 			NOT NULL,
LockCookie          	INTEGER			NOT NULL,
Timeout             	INTEGER			NOT NULL,
Locked             	INTEGER        		NOT NULL,
SessionItemShort    	RAW(2000) 		NULL,
SessionItemLong     	BLOB           		NULL,
Flags               	INTEGER			DEFAULT 0 NOT NULL
)';
execute immediate 'CREATE INDEX aspnet_SessionState_Index ON ora_aspnet_Sessions(Expires)';




execute immediate 'CREATE VIEW ora_vw_aspnet_Sessions AS
 SELECT SessionId, Created, Expires, LockDate, LockDateLocal, LockCookie, Timeout, 
        Locked, LENGTH(SessionItemShort) + LENGTH(SessionItemLong) DataSize, Flags
  FROM ora_aspnet_Sessions
   WITH READ ONLY';

-- create role
execute immediate 'CREATE ROLE ora_aspnet_Sessn_FullAccess';

-- create synonyms
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_SessnApp_GetAppID   for &CurrentUser..ora_aspnet_SessnApp_GetAppID';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_InsUninitItem for &CurrentUser..ora_aspnet_Sessn_InsUninitItem';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_RelStateItmEx for &CurrentUser..ora_aspnet_Sessn_RelStateItmEx';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_RmStateItem   for &CurrentUser..ora_aspnet_Sessn_RmStateItem';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_ResetTimeout  for &CurrentUser..ora_aspnet_Sessn_ResetTimeout';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_UpdStateItem  for &CurrentUser..ora_aspnet_Sessn_UpdStateItem';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_InsStateItem  for &CurrentUser..ora_aspnet_Sessn_InsStateItem';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItem  for &CurrentUser..ora_aspnet_Sessn_GetStateItem';
execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItmEx for &CurrentUser..ora_aspnet_Sessn_GetStateItmEx';

-- schedule a database job to cleanup expired session items
-- For Oracle 10gR1(10.1.0.2) database and higher
DBMS_SCHEDULER.CREATE_JOB (
   job_name             => 'REMOVEEXPIRED_ASPNET_SESSITEMS',
   job_type            	=> 'PLSQL_BLOCK',
   job_action  		=> 'DELETE FROM ora_aspnet_Sessions WHERE Expires < SYS_EXTRACT_UTC(SYSTIMESTAMP);',
   start_date           =>  SYSTIMESTAMP,
   repeat_interval      =>  'FREQ = MINUTELY',
   enabled              =>  TRUE,
   comments             => 'EXPIRED SESSION ITEM DELETION');


END IF;

END;
/

-- setup Stored Procedures
@@InstallOracleSessionStateSP.plb;


-- grant execute sp privileges to FullAccess
GRANT EXECUTE ON ora_aspnet_SessnApp_GetAppID   to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_InsUninitItem to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_RelStateItmEx to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_RmStateItem   to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_ResetTimeout  to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_UpdStateItem  to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_InsStateItem  to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_GetStateItem  to ora_aspnet_Sessn_FullAccess;
GRANT EXECUTE ON ora_aspnet_Sessn_GetStateItmEx to ora_aspnet_Sessn_FullAccess;

-- grant view privileges
GRANT SELECT ON ora_vw_aspnet_Sessions TO ora_aspnet_Sessn_FullAccess;