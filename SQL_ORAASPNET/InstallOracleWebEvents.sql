Rem
Rem $Header: aspnetproviders/sql/InstallOracleWebEvents.sql /main/4 2008/7/09 07:00:40 aruns Exp $
Rem
Rem InstallOracleWebEvents.sql
Rem
Rem Copyright (c) 2007, Oracle. All rights reserved.  
Rem
Rem    NAME
Rem      InstallOracleWebEvents.sql - Creates table in the Database.
Rem
Rem    DESCRIPTION
Rem      <short description of component this file declares/defines>
Rem
Rem    NOTES
Rem      Creates OracleWebEventProvider specific tables in the Database.
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    aruns       06/25/08 - Changed Details column type to NCLOB and added data migration logic.
Rem                           Also fixed the ugrade errors.
Rem    aruns       03/14/07 - Fix path for calling plb file.
Rem    aruns       03/09/07 - Call SP plb file, create roles, grant privileges to SP's.
Rem    aruns       02/25/07 - Created
Rem

-- Create a table to store published web events from the Oracle
-- WebEvents provider for ASP.NET.

    -- Get the user name from the current connection
col USER new_value CurrentUser;
select USER from dual;

BEGIN

  -- first check if the table already exists
  IF (ora_aspnet_TableExists('ORA_ASPNET_WEBEVENTS') = 1) THEN
    
    -- Rename the existing table
    execute immediate 'rename ora_aspnet_WebEvents to ora_aspnet_WebEvents_bk';

    -- create the table with new schema.
    execute immediate 'CREATE TABLE ora_aspnet_WebEvents
    ( 
      EventId                 char(32),
      EventTimeUtc            DATE,
      EventTime               DATE,
      EventType               NVARCHAR2(256),
      EventSequence           NUMBER(19, 0),
      EventOccurence          NUMBER(19, 0),
      EventCode               NUMBER(10),
      EventDetailCode         NUMBER(10),
      Message                 NVARCHAR2(1000),
      applicationpath         NVARCHAR2(256),
      applicationvirtualpath  NVARCHAR2(256),
      machinename             NVARCHAR2(256),
      requesturl              NVARCHAR2(256),
      exceptiontype           NVARCHAR2(256),
      details                 NCLOB
    )';

    -- Copy the data from the old table to new table
    execute immediate 'insert into ora_aspnet_WebEvents
    (
      EventId,
      EventTimeUtc,
      EventTime,
      EventType,
      EventSequence,
      EventOccurence,
      EventCode,
      EventDetailCode,
      Message,
      applicationpath,
      applicationvirtualpath,
      machinename,
      requesturl,
      exceptiontype,
      details
    )
    (
      SELECT  EventId,
              EventTimeUtc,
              EventTime,
              EventType,
              EventSequence,
              EventOccurence,
              EventCode,
              EventDetailCode,
              Message,
              applicationpath,
              applicationvirtualpath,
              machinename,
              requesturl,
              exceptiontype,
              details
      FROM    ora_aspnet_WebEvents_bk
    )';

    execute immediate 'DROP TABLE ora_aspnet_WebEvents_bk';

  ELSE

    execute immediate 'CREATE TABLE ora_aspnet_WebEvents
    ( 
      EventId                 char(32),
      EventTimeUtc            DATE,
      EventTime               DATE,
      EventType               NVARCHAR2(256),
      EventSequence           NUMBER(19, 0),
      EventOccurence          NUMBER(19, 0),
      EventCode               NUMBER(10),
      EventDetailCode         NUMBER(10),
      Message                 NVARCHAR2(1000),
      applicationpath         NVARCHAR2(256),
      applicationvirtualpath  NVARCHAR2(256),
      machinename             NVARCHAR2(256),
      requesturl              NVARCHAR2(256),
      exceptiontype           NVARCHAR2(256),
      details                 NCLOB
    )';

    -- Create roles. create role privilege is required.
    execute immediate 'CREATE ROLE ora_aspnet_Wevnt_FullAccess';

    -- Create public synonym. Create public synonym privilege is required.
    execute immediate 'CREATE PUBLIC SYNONYM ora_aspnet_LogWebEvents FOR &CurrentUser..ora_aspnet_LogWebEvents';

  END IF;
END;

/

-- Run the plb file to create stored functions/procedures
@@InstallOracleWebEventsSP.plb;

-- Grant execution privilege to ora_aspnet_Wevnt_FullAccess role
GRANT EXECUTE ON ora_aspnet_LogWebEvents TO ora_aspnet_Wevnt_FullAccess;
