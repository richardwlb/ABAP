REPORT  z_teste01.

*———————————————————————-*
*       CLASS flight DEFINITION
*———————————————————————-*
* Definition, where are the data and the methods definitions
*———————————————————————-*
CLASS flight DEFINITION.

PUBLIC SECTION.

DATA: it_flight TYPE STANDARD TABLE OF sflight.
DATA: wa_flight TYPE sflight.

METHODS: get_flight IMPORTING fldate TYPE sflight–fldate
connid TYPE sflight–connid.

ENDCLASS.                    “flight DEFINITION

*———————————————————————-*
*       CLASS fligh IMPLEMENTATION
*———————————————————————-*
* Where are the execution of the methods
*———————————————————————-*
CLASS flight IMPLEMENTATION.

METHOD get_flight.

SELECT * FROM sflight INTO TABLE it_flight
WHERE fldate = fldate AND connid = connid.

IF sy–subrc = 0.
LOOP AT it_flight INTO wa_flight.
WRITE: / wa_flight–connid, wa_flight–fldate, wa_flight–price.
ENDLOOP.
ENDIF.

ENDMETHOD.                    “show_flight

ENDCLASS.                    “fligh IMPLEMENTATION

START-OF-SELECTION.

* Input of selection parameters
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text–001.
PARAMETERS: p_date TYPE sflight–fldate,
p_connid TYPE sflight–connid.
SELECTION-SCREEN END OF BLOCK b1.

* Creating the object.
DATA o_flight TYPE REF TO flight.
CREATE OBJECT o_flight.

* Calling the method.
o_flight->get_flight( fldate = p_date connid = p_connid ).
