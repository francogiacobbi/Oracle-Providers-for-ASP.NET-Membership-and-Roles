-- Copyright (c) 2002, 2008, Oracle. All rights reserved.

-- Create the common tables
DECLARE n NUMBER;
BEGIN 
   SELECT count(*) INTO n FROM tab WHERE tname='ORA_ASPNET_APPLICATIONS';
   IF n <= 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE ora_aspnet_Applications
(
  ApplicationName               NVARCHAR2 (256) NOT NULL UNIQUE,
  LoweredApplicationName  	NVARCHAR2 (256) NOT NULL UNIQUE,
  ApplicationId	RAW (16) DEFAULT SYS_GUID() NOT NULL PRIMARY KEY,
  Description             	NVARCHAR2 (256)
)';
  END IF;
END;
/

DECLARE n NUMBER;
BEGIN 
   SELECT count(*) INTO n FROM tab WHERE tname='ORA_ASPNET_USERS';
   IF n <= 0 THEN
EXECUTE IMMEDIATE
'CREATE TABLE ora_aspnet_Users
(
  ApplicationId    		RAW (16)  NOT NULL,
  UserId           		RAW (16) DEFAULT SYS_GUID() NOT NULL PRIMARY KEY,
  UserName         		NVARCHAR2 (256) NOT NULL,
  LoweredUserName  	NVARCHAR2 (256) NOT NULL,
  MobileAlias      		NVARCHAR2 (16) DEFAULT NULL,
  IsAnonymous      		INTEGER DEFAULT 0 NOT NULL,
  LastActivityDate 		DATE 	 NOT NULL,
  CONSTRAINT fk_users_appid FOREIGN KEY (ApplicationId) 
    REFERENCES ora_aspnet_Applications(ApplicationId)
)';
EXECUTE IMMEDIATE
'CREATE UNIQUE INDEX aspnet_Users_Index ON ora_aspnet_Users (ApplicationId, LoweredUserName)';
EXECUTE IMMEDIATE
'CREATE INDEX aspnet_Users_Index2 ON ora_aspnet_Users (ApplicationId, LastActivityDate)';
  END IF;
END;
/

-- Create read-only view
CREATE OR REPLACE VIEW ora_vw_aspnet_Applications AS
SELECT ApplicationName,
       LoweredApplicationName,
       ApplicationId,
       Description
FROM ora_aspnet_Applications
WITH READ ONLY;

CREATE OR REPLACE VIEW ora_vw_aspnet_Users AS
SELECT ApplicationId,
       UserId,
       UserName,
       LoweredUserName,
       MobileAlias,
       IsAnonymous,
       LastActivityDate
FROM ora_aspnet_Users
WITH READ ONLY;


-- Run the plb file to create stored functions/procedures or packages
@@InstallOracleASPNETCommonSP.plb



