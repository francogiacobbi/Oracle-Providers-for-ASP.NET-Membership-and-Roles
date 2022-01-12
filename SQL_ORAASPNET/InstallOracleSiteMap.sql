Rem
Rem $Header: aspnetproviders/sql/InstallOracleSiteMap.sql /main/6 2008/7/09 07:00:41 aruns Exp $
Rem
Rem InstallOracleSiteMap.sql
Rem
Rem Copyright (c) 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      InstallOracleSiteMap.sql - Creates table in the Database.
Rem
Rem    DESCRIPTION
Rem      Creates OracleSiteMapProvider specific tables in the Database.
Rem
Rem    NOTES
Rem      <other useful comments, qualifications, etc.>
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aruns       07/03/08 - Fixed upgrade errors.
Rem    aruns       05/06/07 - Modified constraints on ApplicationId and ID column and also added a composite primary key.
Rem    aruns       03/14/07 - Fix path for calling plb file.
Rem    aruns       03/09/07 - Call SP plb file, create roles, grant privileges to SP's.
Rem    aruns       02/25/07 - Created
Rem

-- Get the user name from the current connection
col USER new_value CurrentUser;
select USER from dual;

BEGIN

  -- first check if the table already exists
  IF (ora_aspnet_TableExists('ORA_ASPNET_SITEMAP') = 0) THEN

    -- sitemap provider specific table.
    execute immediate 'CREATE TABLE ora_aspnet_SiteMap
    (
      ApplicationId  	RAW (16) NOT NULL,
      ID     		NUMBER(10) NOT NULL,
      Title      		NVARCHAR2 (32),
      Description  	NVARCHAR2 (512),
      Url    		NVARCHAR2 (512),
      Roles      		NVARCHAR2 (512),
      Parent      	NUMBER(10)
    )';

    execute immediate 'ALTER TABLE ora_aspnet_SiteMap ADD CONSTRAINT fk_SiteMap_Appid FOREIGN KEY (ApplicationId) REFERENCES ora_aspnet_Applications (ApplicationId) ON DELETE CASCADE';
    execute immediate 'ALTER TABLE ora_aspnet_SiteMap ADD CONSTRAINT pk_SiteMap_Appid_id PRIMARY KEY (ApplicationId, ID)';

    -- Create role. create role privilege is required.
    execute immediate 'CREATE ROLE ora_aspnet_Smap_FullAccess';

    -- Create public synonym. Create public synonym privilege is required.
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_GetSiteMapData FOR &CurrentUser..ora_aspnet_GetSiteMapData';

  END IF;

END;

/

-- Run the plb file to create stored functions/procedures
@@InstallOracleSiteMapSP.plb

-- Grant execution privilege to ora_aspnet_SMap_FullAccess role
GRANT EXECUTE ON ora_aspnet_GetSiteMapData TO ora_aspnet_SMap_FullAccess;

