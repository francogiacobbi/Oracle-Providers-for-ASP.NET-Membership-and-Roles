
CREATE TABLE DEPARTMENTS
(
  DEPARTMENT_ID    NUMBER(4),
  DEPARTMENT_NAME  VARCHAR2(30 BYTE) CONSTRAINT DEPT_NAME_NN NOT NULL,
  MANAGER_ID       NUMBER(6),
  LOCATION_ID      NUMBER(4)
)
TABLESPACE USERS
RESULT_CACHE (MODE DEFAULT)
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

COMMENT ON TABLE DEPARTMENTS IS 'Departments table that shows details of departments where employees
work. Contains 27 rows; references with locations, employees, and job_history tables.';

COMMENT ON COLUMN DEPARTMENTS.DEPARTMENT_ID IS 'Primary key column of departments table.';

COMMENT ON COLUMN DEPARTMENTS.DEPARTMENT_NAME IS 'A not null column that shows name of a department. Administration,
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public
Relations, Sales, Finance, and Accounting. ';

COMMENT ON COLUMN DEPARTMENTS.MANAGER_ID IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';

COMMENT ON COLUMN DEPARTMENTS.LOCATION_ID IS 'Location id where a department is located. Foreign key to location_id column of locations table.';



CREATE UNIQUE INDEX DEPT_ID_PK ON DEPARTMENTS
(DEPARTMENT_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


CREATE INDEX DEPT_LOCATION_IX ON DEPARTMENTS
(LOCATION_ID)
LOGGING
TABLESPACE USERS
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
NOPARALLEL;


ALTER TABLE DEPARTMENTS ADD (
  CONSTRAINT DEPT_ID_PK
  PRIMARY KEY
  (DEPARTMENT_ID)
  USING INDEX DEPT_ID_PK
  ENABLE VALIDATE);

ALTER TABLE DEPARTMENTS ADD (
  CONSTRAINT DEPT_LOC_FK 
  FOREIGN KEY (LOCATION_ID) 
  REFERENCES LOCATIONS (LOCATION_ID)
  ENABLE VALIDATE,
  CONSTRAINT DEPT_MGR_FK 
  FOREIGN KEY (MANAGER_ID) 
  REFERENCES EMPLOYEES (EMPLOYEE_ID)
  ENABLE VALIDATE);
