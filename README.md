# Oracle Providers for ASP.NET Membership and Roles
# Oracle 11g Release 2
======================

The ASP.NET membership provider is a feature that enables ASP.NET developers to create Web sites that allow users 
to create unique user name and password combinations. With this facility, any user can establish an account with the site, 
and sign in for exclusive access to the site and its services. 
This is in contrast to Windows security, which requires users to have accounts in a Windows domain. 
Instead, any user that supplies their credentials (the user name/password combination) can use the site and its services.

How To Use
==========

This is an example to implement a OracleDatabase store for ASP.NET Membership and Roles.

Steps to run project
==========

1. On ORACLE / TOAD

First of all you need to configure a Schema in Oracle to build data-structure used by Oracle Provider.
I used HR schema present in my Workspace. HR is a schema sample containing data to produce example.
If you want you can create a new one Schema.

To run Script on Oracle (I used TOAD For Oracle) you need administative provileges.
Database Privileges for Setup:

To set up the Oracle database, database administrators must grant the following
database privileges to the Oracle Providers for ASP.NET schema. These privileges
grant the schema privileges to create the tables, views, stored procedures, and other
database objects the Oracle Providers for ASP.NET require. These scripts must be run
against the database from which the ASP.NET providers will retrieve their stored state
information. These SQL scripts can be run using SQL*Plus or within Oracle Developer
Tools for Visual Studio.
Oracle Providers for ASP.NET requires the following privileges during setup:
- **Change notification**
- **Create job**
- **Create procedure**
- **Create public synonym**
- **Create role**
- **Create session**
- **Create table**
- **Create view**
- **Drop public synonym**
- **Grant access to and allocate space in an Oracle tablespace**

Not all database privileges are required for Oracle Providers for ASP.NET runtime
operations. Database administrators may selectively grant and revoke privileges as
required. For runtime operations, all providers require that the CREATE SESSION
privilege be granted to the schema user. In addition, the Site Map and Cache
Dependency providers require the CHANGE NOTIFICATION privilege during runtime.
The remaining privileges can be granted to the schema user just for installation and
deinstallation, then revoked for runtime operations.

Scripts are in folder called SQL_ORAASPNET
You need to open and execute InstallAllOracleASPNETProviders.sql in the Schema above mentioned.

2. On Visual Studio

- Open project in Visual Studio 2013 or later installed (sample has been produced in Visual Studio 2013)
- Build project to restore packages and build project
- Update connection string to use the OracleDatabase database as needed
- Oracle Providers for ASP.NET need connection string called "OraAspNetConString" and i configure this connection in web.config
  In my example "connectionString="DATA SOURCE=XE.PMUSERS;PASSWORD=hr;USER ID=HR' providerName='Oracle.ManagedDataAccess.Client'" read info from TNSNAME.ORA
- Before you do debugging, you must create the tables in the database for HR schema. 
  This is only for the page Default.aspx that shows some data.
  You must create table and then insert data from scripts inb folder SQL_HR.
  I used TOAD for this purpose.
  



