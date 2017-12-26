REPORT  Z_EMAIL_STATUS.

* Data Declarations
DATA: LT_MAILSUBJECT     TYPE SODOCCHGI1.
DATA: LT_MAILRECIPIENTS  TYPE STANDARD TABLE OF SOMLREC90 WITH HEADER LINE.
DATA: LT_MAILTXT         TYPE STANDARD TABLE OF SOLI      WITH HEADER LINE.
* Recipients
LT_MAILRECIPIENTS-REC_TYPE = 'U'.
LT_MAILRECIPIENTS-RECEIVER = 'richard.brehmer@teiko.com.br'.
APPEND LT_MAILRECIPIENTS .
CLEAR LT_MAILRECIPIENTS .
* Subject.
LT_MAILSUBJECT-OBJ_NAME = 'TEST'.
LT_MAILSUBJECT-OBJ_LANGU = SY-LANGU.
LT_MAILSUBJECT-OBJ_DESCR = 'Email Subject Goes Here'.
* Mail Contents

LT_MAILTXT = 'This is a test mail'.
LT_MAILTXT = '<HTML><BODY><H1>This is a test</H1></BODY></HTML>'.


**************

************


APPEND LT_MAILTXT. CLEAR LT_MAILTXT.

* Send Mail
* Calls the SO_NEW_DOCUMENT_SEND_API1 function.
* Always use SAP functions instead of creating your own.
CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
  EXPORTING
    DOCUMENT_DATA              = LT_MAILSUBJECT
    DOCUMENT_TYPE              = 'HTM'
  TABLES
    OBJECT_CONTENT             = LT_MAILTXT
    RECEIVERS                  = LT_MAILRECIPIENTS
  EXCEPTIONS
    TOO_MANY_RECEIVERS         = 1
    DOCUMENT_NOT_SENT          = 2
    DOCUMENT_TYPE_NOT_EXIST    = 3
    OPERATION_NO_AUTHORIZATION = 4
    PARAMETER_ERROR            = 5
    X_ERROR                    = 6
    ENQUEUE_ERROR              = 7
    OTHERS                     = 8.
IF SY-SUBRC EQ 0.
  COMMIT WORK.
*   Push mail out from SAP outbox
  SUBMIT RSCONN01 WITH MODE = 'INT' AND RETURN.

  write: / 'Success, go check your inbox'.
else.
  write: / 'There was a problem:', sy-subrc.
ENDIF.

" I always add a line like this so that you can at least see your program ran.
write: / 'program is all done'.
