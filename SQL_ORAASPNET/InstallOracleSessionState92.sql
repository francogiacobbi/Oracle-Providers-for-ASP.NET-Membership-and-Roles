-- For Oracle 9iR2(9.2.x) database
-- For Oracle 10gR1(10.1.0.2) database and higher, run InstallOracleSessionState.sql instead


-- tables for Oracle Session State Store Provider

CREATE TABLE ora_aspnet_SessionApplications
(
AppId     	RAW(16)            NOT NULL PRIMARY KEY,
AppName   	nvarchar2(280)     NOT NULL
);
CREATE INDEX aspnet_SessionState_App_Index ON ora_aspnet_SessionApplications(AppName);

CREATE TABLE ora_aspnet_Sessions
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
);
CREATE INDEX aspnet_SessionState_Index ON ora_aspnet_Sessions(Expires);


-- get current username
col USER NEW_VALUE CurrentUser;
select USER from dual;

CREATE VIEW ora_vw_aspnet_Sessions AS
 SELECT SessionId, Created, Expires, LockDate, LockDateLocal, LockCookie, Timeout, 
        Locked, LENGTH(SessionItemShort) + LENGTH(SessionItemLong) DataSize, Flags
  FROM ora_aspnet_Sessions
   WITH READ ONLY;


-- setup Stored Procedures
@@InstallOracleSessionStateSP.plb;


-- create role
CREATE ROLE ora_aspnet_Sessn_FullAccess;

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

-- create synonyms
CREATE PUBLIC SYNONYM ora_aspnet_SessnApp_GetAppID   for &CurrentUser..ora_aspnet_SessnApp_GetAppID;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_InsUninitItem for &CurrentUser..ora_aspnet_Sessn_InsUninitItem;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_RelStateItmEx for &CurrentUser..ora_aspnet_Sessn_RelStateItmEx;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_RmStateItem   for &CurrentUser..ora_aspnet_Sessn_RmStateItem;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_ResetTimeout  for &CurrentUser..ora_aspnet_Sessn_ResetTimeout;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_UpdStateItem  for &CurrentUser..ora_aspnet_Sessn_UpdStateItem;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_InsStateItem  for &CurrentUser..ora_aspnet_Sessn_InsStateItem;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItem  for &CurrentUser..ora_aspnet_Sessn_GetStateItem;
CREATE PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItmEx for &CurrentUser..ora_aspnet_Sessn_GetStateItmEx;

-- create a database job to cleanup expired session items
-- For Oracle 9iR2(9.2.x) database
VARIABLE jobno NUMBER;
BEGIN
DBMS_JOB.SUBMIT(:jobno, 'DELETE FROM &CurrentUser..ora_aspnet_Sessions WHERE Expires < SYS_EXTRACT_UTC(SYSTIMESTAMP);', SYSDATE, 
'SYSDATE + 1/1440');
COMMIT;
END;
/