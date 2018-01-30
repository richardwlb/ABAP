*&---------------------------------------------------------------------*
*& Report  Z_TEST_RBAPI
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT z_test_rbapi.

CLASS flight DEFINITION.

  PUBLIC SECTION.

    METHODS: getflidetails IMPORTING airid  TYPE bapisflkey-airlineid
                                     connid TYPE bapisflkey-connectid
                                     fldate TYPE bapisflkey-flightdate.

  PRIVATE SECTION.

    DATA: it_fldata TYPE bapisfldat.
    DATA: it_return TYPE STANDARD TABLE OF bapiret2.

ENDCLASS.


CLASS flight IMPLEMENTATION.


  METHOD: getflidetails.

    CALL FUNCTION 'BAPI_FLIGHT_GETDETAIL'
      EXPORTING
        airlineid    = airid
        connectionid = connid
        flightdate   = fldate
      IMPORTING
        flight_data  = it_fldata
*       ADDITIONAL_INFO       =
*       AVAILIBILITY =
      TABLES
*       EXTENSION_IN =
*       EXTENSION_OUT         =
        return       = it_return.

    WRITE: / 'Company: ', it_fldata-airline, ' From: ', it_fldata-cityfrom, ' To: ', it_fldata-cityto.



  ENDMETHOD.


ENDCLASS.

START-OF-SELECTION.

* Selection Screen
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
  PARAMETERS: p_airid   TYPE bapisflkey-airlineid,
              p_connid  TYPE bapisflkey-connectid,
              p_fldate  TYPE bapisflkey-flightdate.
  SELECTION-SCREEN END OF BLOCK b1.

* Create object and execute Function Module.
  DATA: oflight TYPE REF TO flight.
  CREATE OBJECT oflight.

  oflight->getflidetails( airid = p_airid connid = p_connid fldate = p_fldate ).
