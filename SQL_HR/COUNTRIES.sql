CREATE TABLE COUNTRIES
(
  COUNTRY_ID    CHAR(2 BYTE) CONSTRAINT COUNTRY_ID_NN NOT NULL,
  COUNTRY_NAME  VARCHAR2(40 BYTE),
  REGION_ID     NUMBER, 
  CONSTRAINT COUNTRY_C_ID_PK
  PRIMARY KEY
  (COUNTRY_ID)
  ENABLE VALIDATE
)
ORGANIZATION INDEX
PCTTHRESHOLD 50
TABLESPACE USERS
RESULT_CACHE (MODE DEFAULT)
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
LOGGING 
NOPARALLEL
NOMONITORING;

COMMENT ON TABLE COUNTRIES IS 'country table. Contains 25 rows. References with locations table.';

COMMENT ON COLUMN COUNTRIES.COUNTRY_ID IS 'Primary key of countries table.';

COMMENT ON COLUMN COUNTRIES.COUNTRY_NAME IS 'Country name';

COMMENT ON COLUMN COUNTRIES.REGION_ID IS 'Region ID for the country. Foreign key to region_id column in the departments table.';



-- Index COUNTRY_C_ID_PK is created automatically by Oracle with index organized table COUNTRIES.


ALTER TABLE COUNTRIES ADD (
  CONSTRAINT COUNTR_REG_FK 
  FOREIGN KEY (REGION_ID) 
  REFERENCES REGIONS (REGION_ID)
  ENABLE VALIDATE);
