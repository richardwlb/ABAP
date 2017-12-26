*----------------------------------------------------------------------*
*                                                                      *
*----------------------------------------------------------------------*
*Autor......: Richard W. L. Brehmer                                    *
*Data.......: 15.09.2015                                               *
*Request....:                                                          *
*----------------------------------------------------------------------*

REPORT  z_checklist2.

DATA i TYPE i VALUE 0.

********** SM51 INICIO
WRITE 'SM51:' COLOR COL_HEADING.

DATA list_tab2 TYPE TABLE OF abaplist.

SUBMIT rsm51000_alv EXPORTING LIST TO MEMORY
             AND RETURN.

CALL FUNCTION 'LIST_FROM_MEMORY'
  TABLES
    listobject = list_tab2
  EXCEPTIONS
    not_found  = 1
    OTHERS     = 2.

IF sy-subrc = 0.
  CALL FUNCTION 'WRITE_LIST'
    TABLES
      listobject = list_tab2.
ENDIF.
********** SM51 FIM

********** SM66 INICIO
WRITE 'SM66:' COLOR COL_HEADING.

DATA list_tab TYPE TABLE OF abaplist.

SUBMIT sapmsm66 EXPORTING LIST TO MEMORY
             AND RETURN.

CALL FUNCTION 'LIST_FROM_MEMORY'
  TABLES
    listobject = list_tab
  EXCEPTIONS
    not_found  = 1
    OTHERS     = 2.

IF sy-subrc = 0.
  CALL FUNCTION 'WRITE_LIST'
    TABLES
      listobject = list_tab.
ENDIF.
********** SM66 - FIM

********** Tablespaces INICIO
WRITE 'Tablespaces:' COLOR COL_HEADING.

DATA list_tab4 TYPE TABLE OF abaplist.

SUBMIT rsoratbm EXPORTING LIST TO MEMORY
             AND RETURN.

CALL FUNCTION 'LIST_FROM_MEMORY'
  TABLES
    listobject = list_tab4
  EXCEPTIONS
    not_found  = 1
    OTHERS     = 2.

IF sy-subrc = 0.
  CALL FUNCTION 'WRITE_LIST'
    TABLES
      listobject = list_tab4.
ENDIF.
********** Tablespaces - FIM

********** Check Oracle INICIO
WRITE 'Database Check:' COLOR COL_HEADING.
WRITE sy-datum COLOR COL_HEADING.

DATA: wa_dbmsgora TYPE dbmsgora.
DATA: it_dbmsgora TYPE STANDARD TABLE OF dbmsgora.
DATA: level TYPE string.
DATA: l_data TYPE string.
DATA: l_time TYPE string.
DATA: l_hour TYPE string.

** Formata data para comparação:
CONCATENATE sy-datum(6) sy-datum+6(2) '%' INTO l_data.
WRITE l_data.

**  Seleciona Jobs cancelados das últimas 24 horas.
SELECT * FROM dbmsgora INTO TABLE it_dbmsgora WHERE
time LIKE l_data AND lindex = 1.

WRITE /.
ULINE (150).
FORMAT INTENSIFIED COLOR = 1.
WRITE:/ sy-vline,'Level' , AT 10 sy-vline, 'Date' , AT 25 sy-vline,'Time', AT 35 sy-vline,'Type'
, AT 42 sy-vline,'Name', AT 65 sy-vline,'Description', AT 150 sy-vline.

ULINE (150).

IF sy-subrc <> 0.
  WRITE: / sy-vline, 'Nenhuma informação, verifique o JOB CHECKORACLE.', AT 150 sy-vline .
ENDIF.

LOOP AT it_dbmsgora INTO wa_dbmsgora.    "loops around the data in table it_ekko
  FORMAT COLOR COL_TOTAL INTENSIFIED OFF.

  CASE wa_dbmsgora-severity.
    WHEN 'W'.
      level ='Warning'.
      i = 3.
      FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
    WHEN 'E'.
      level = 'Error'.
      i = 6.
      FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
    WHEN OTHERS.
      level = wa_dbmsgora-severity.
      FORMAT COLOR COL_TOTAL INTENSIFIED OFF.
  ENDCASE.

  CONCATENATE wa_dbmsgora-time+6(2) wa_dbmsgora-time+4(2) wa_dbmsgora-time(4) INTO l_time SEPARATED BY '.'.
  CONCATENATE wa_dbmsgora-time+8(2) wa_dbmsgora-time+10(2) wa_dbmsgora-time+12(2) INTO l_hour SEPARATED BY ':'.

  WRITE:/  sy-vline, level,AT 10 sy-vline, l_time, AT 25 sy-vline, l_hour, AT 35 sy-vline, wa_dbmsgora-type
  , AT 42 sy-vline, wa_dbmsgora-param , AT 65 sy-vline, wa_dbmsgora-msgdesc(80), AT 150 sy-vline.

ENDLOOP.
ULINE (150).
WRITE /.
************* Check Oracle - FIM

********** SM37 INICIO
WRITE 'SM37 - Last 24 hours canceled/active jobs:' COLOR COL_HEADING.

DATA: new_date TYPE sy-datum.
DATA: jstatus TYPE string.
DATA: wa_tbtco TYPE tbtco.
DATA: it_tbtco TYPE STANDARD TABLE OF tbtco.

new_date = sy-datum - 1.

**  Seleciona Jobs cancelados/Ativos das últimas 24 horas.
SELECT * FROM tbtco INTO TABLE it_tbtco WHERE
strtdate >= new_date AND status IN ('A', 'R').

WRITE /.
ULINE (130).
FORMAT INTENSIFIED COLOR = 1.
WRITE:/ sy-vline, 'Job Name' , AT 50 sy-vline,'Start Date', AT 63 sy-vline,'Start Time'
, AT 75 sy-vline,'Status', AT 87 sy-vline,'End Date', AT 100 sy-vline,'End Time', AT 115 sy-vline,'User', AT 130 sy-vline.

ULINE (130).

IF sy-subrc <> 0.
  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
  WRITE: / sy-vline, 'Nenhum JOB cancelado ou ativo desde as últimas 24 horas.', AT 130 sy-vline.
ENDIF.
FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

LOOP AT it_tbtco INTO wa_tbtco.

  CASE wa_tbtco-status.
    WHEN 'F'.
      jstatus ='Finished'.
      i = 5.
    WHEN 'A'.
      jstatus = 'Canceled'.
      i = 6.
    WHEN 'R'.
      jstatus = 'Running'.
      i = 3.
    WHEN OTHERS.
      jstatus = wa_tbtco-status.
  ENDCASE.

  WRITE:/ sy-vline, wa_tbtco-jobname , AT 50 sy-vline, wa_tbtco-strtdate, AT 63 sy-vline, wa_tbtco-strttime
  , AT 75 sy-vline, jstatus INTENSIFIED COLOR = i , AT 87 sy-vline, wa_tbtco-enddate , AT 100 sy-vline, wa_tbtco-endtime
  , AT 115 sy-vline, wa_tbtco-sdluname, AT 130 sy-vline.
ENDLOOP.
ULINE (130).
WRITE /.
********** SM37 - FIM

********** SM37 DBA JOBS INICIO
* data jobs
WRITE 'SM37 - Status DBA Jobs, last 24 hours - ' COLOR COL_HEADING.

DATA: wa_tbtcoj TYPE tbtco.
DATA: it_tbtcoj TYPE STANDARD TABLE OF tbtco.

SELECT * FROM tbtco INTO TABLE it_tbtcoj WHERE
strtdate >= new_date AND jobname LIKE 'DBA:%' ORDER BY strtdate.

WRITE /.
ULINE (130).
FORMAT INTENSIFIED COLOR = 1.
WRITE:/ sy-vline, 'Job Name' , AT 50 sy-vline,'Start Date', AT 63 sy-vline,'Start Time'
, AT 75 sy-vline,'Status', AT 87 sy-vline,'End Date', AT 100 sy-vline,'End Time', AT 115 sy-vline,'User', AT 130 sy-vline.

ULINE (130).

IF sy-subrc <> 0.
  FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
  WRITE: / sy-vline, 'Nenhum JOB DBA encontrado desde as últimas 24 horas.', AT 130 sy-vline.
ENDIF.
FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

LOOP AT it_tbtcoj INTO wa_tbtcoj.

  CASE wa_tbtcoj-status.
    WHEN 'F'.
      jstatus ='Finished'.
      i = 5.
    WHEN 'A'.
      jstatus = 'Canceled'.
      i = 6.
    WHEN 'R'.
      jstatus = 'Running'.
      i = 3.
    WHEN OTHERS.
      jstatus = wa_tbtcoj-status.
  ENDCASE.

  WRITE:/ sy-vline, wa_tbtcoj-jobname , AT 50 sy-vline, wa_tbtcoj-strtdate, AT 63 sy-vline, wa_tbtcoj-strttime
  , AT 75 sy-vline, jstatus INTENSIFIED COLOR = i , AT 87 sy-vline, wa_tbtcoj-enddate , AT 100 sy-vline, wa_tbtcoj-endtime
  , AT 115 sy-vline, wa_tbtcoj-sdluname, AT 130 sy-vline.
ENDLOOP.
ULINE (130).
WRITE /.
********** SM37 DBA - FIM

********** ST22 INICIO
* data jobs
WRITE 'ST22 - Today´s dump´s, Last 20.' COLOR COL_HEADING.

DATA: wa_snap TYPE snap.
DATA: it_snap TYPE STANDARD TABLE OF snap.
DATA: l_datum TYPE string.

CONCATENATE sy-datum(6) sy-datum+6(2) INTO l_datum.

**  Seleciona dumps de hoje.
SELECT * UP TO 20 ROWS FROM snap INTO TABLE it_snap
  WHERE
  datum = l_datum AND
  seqno = '000' ORDER BY uzeit ASCENDING.

WRITE /.
ULINE (150).
FORMAT INTENSIFIED COLOR = 1.
WRITE:/ sy-vline, 'Time' , AT 13 sy-vline,'App. Server', AT 30 sy-vline,'User Name'
, AT 45 sy-vline,'Client', AT 52 sy-vline,'Runtime error', AT 85 sy-vline,'Terminated Program', AT 150 sy-vline.

ULINE (150).

IF sy-subrc <> 0.
  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
  WRITE: / sy-vline, 'Nenhum Dump.', AT 150 sy-vline.
ENDIF.

FORMAT COLOR COL_NORMAL INTENSIFIED OFF.

LOOP AT it_snap INTO wa_snap.    "loops around the data in table it_ekko
  WRITE:/ sy-vline, wa_snap-uzeit , AT 13 sy-vline, wa_snap-ahost, AT 30 sy-vline, wa_snap-uname
  , AT 45 sy-vline, wa_snap-mandt , AT 52 sy-vline, wa_snap-flist+5(25) , AT 85 sy-vline, wa_snap-flist+112(25), AT 150 sy-vline.
  "Writes data currently stored in wa_ekko-ebeln field
ENDLOOP.
ULINE (150).

**  Seleciona dumps de ontem.
DATA: l_datum2 TYPE string.
DATA: count TYPE i.

CONCATENATE new_date(6) new_date+6(2) INTO l_datum2.

SELECT COUNT(*) FROM snap INTO count
  WHERE
  datum = l_datum2 AND
  seqno = '000'.

WRITE: /.

ULINE (150).

IF count > 0.
  FORMAT COLOR COL_NEGATIVE INTENSIFIED OFF.
ELSEIF count = 0.
  FORMAT COLOR COL_POSITIVE INTENSIFIED OFF.
ENDIF.

WRITE:/ sy-vline, 'Dumps yesterday: ', count, AT 150 sy-vline..
ULINE (150).
********** ST22 - FIM
