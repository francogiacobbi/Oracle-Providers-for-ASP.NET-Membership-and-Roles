-- For Oracle 9iR2(9.2.x) database
-- For Oracle 10gR1(10.1.0.2) database and higher, run UninstallOracleSessionState.sql instead

-- Remove job(s) that cleanup expired session items
-- For Oracle 9iR2(9.2.x) database

-- get current username
col USER NEW_VALUE CurrentUser;
select USER from dual;

DECLARE
jobno    NUMBER := 0;
m_rowcnt NUMBER := 0;

BEGIN

SELECT count(*) into m_rowcnt FROM USER_JOBS WHERE what like '%DELETE FROM &CurrentUser..ora_aspnet_Sessions WHERE Expires < SYS_EXTRACT_UTC(SYSTIMESTAMP)%';

-- in the event more than one job was created somehow, remove all of them
FOR j IN 1..m_rowcnt LOOP
 select MIN(job) into jobno from USER_JOBS where what like '%DELETE FROM &CurrentUser..ora_aspnet_Sessions WHERE Expires < SYS_EXTRACT_UTC(SYSTIMESTAMP)%';
 DBMS_JOB.REMOVE(jobno);
END LOOP;

END;
/

-- Drop public synonyms. Drop public synonym privilege is required.
DROP PUBLIC SYNONYM ora_aspnet_SessnApp_GetAppID;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_InsUninitItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_RelStateItmEx;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_RmStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_ResetTimeout;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_UpdStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_InsStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItem;
DROP PUBLIC SYNONYM ora_aspnet_Sessn_GetStateItmEx;


-- Drop role
DROP ROLE ora_aspnet_Sessn_FullAccess;


-- Drop functions
DROP FUNCTION ora_aspnet_SessnApp_GetAppID;
DROP FUNCTION ora_aspnet_Sessn_InsUninitItem;
DROP FUNCTION ora_aspnet_Sessn_RelStateItmEx;
DROP FUNCTION ora_aspnet_Sessn_RmStateItem;
DROP FUNCTION ora_aspnet_Sessn_ResetTimeout;
DROP FUNCTION ora_aspnet_Sessn_UpdStateItem;
DROP FUNCTION ora_aspnet_Sessn_InsStateItem;
DROP FUNCTION ora_aspnet_Sessn_GetStateItem;
DROP FUNCTION ora_aspnet_Sessn_GetStateItmEx;


-- Drop view
DROP VIEW ora_vw_aspnet_Sessions;


-- Drop tables
DROP TABLE ora_aspnet_Sessions;
DROP TABLE ora_aspnet_SessionApplications;
