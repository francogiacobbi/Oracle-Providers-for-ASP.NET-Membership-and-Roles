CREATE TABLE LOCATIONS
(
  LOCATION_ID     NUMBER(4),
  STREET_ADDRESS  VARCHAR2(40 BYTE),
  POSTAL_CODE     VARCHAR2(12 BYTE),
  CITY            VARCHAR2(30 BYTE) CONSTRAINT LOC_CITY_NN NOT NULL,
  STATE_PROVINCE  VARCHAR2(25 BYTE),
  COUNTRY_ID      CHAR(2 BYTE)
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

COMMENT ON TABLE LOCATIONS IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';

COMMENT ON COLUMN LOCATIONS.LOCATION_ID IS 'Primary key of locations table';

COMMENT ON COLUMN LOCATIONS.STREET_ADDRESS IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';

COMMENT ON COLUMN LOCATIONS.POSTAL_CODE IS 'Postal code of the location of an office, warehouse, or production site
of a company. ';

COMMENT ON COLUMN LOCATIONS.CITY IS 'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';

COMMENT ON COLUMN LOCATIONS.STATE_PROVINCE IS 'State or Province where an office, warehouse, or production site of a
company is located.';

COMMENT ON COLUMN LOCATIONS.COUNTRY_ID IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';



CREATE INDEX LOC_CITY_IX ON LOCATIONS
(CITY)
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


CREATE INDEX LOC_COUNTRY_IX ON LOCATIONS
(COUNTRY_ID)
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


CREATE UNIQUE INDEX LOC_ID_PK ON LOCATIONS
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


CREATE INDEX LOC_STATE_PROVINCE_IX ON LOCATIONS
(STATE_PROVINCE)
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


ALTER TABLE LOCATIONS ADD (
  CONSTRAINT LOC_ID_PK
  PRIMARY KEY
  (LOCATION_ID)
  USING INDEX LOC_ID_PK
  ENABLE VALIDATE);

ALTER TABLE LOCATIONS ADD (
  CONSTRAINT LOC_C_ID_FK 
  FOREIGN KEY (COUNTRY_ID) 
  REFERENCES COUNTRIES (COUNTRY_ID)
  ENABLE VALIDATE);
