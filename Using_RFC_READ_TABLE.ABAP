DATA fields   TYPE STANDARD TABLE OF rfc_db_fld.
  DATA field    TYPE rfc_db_fld.
  DATA data     TYPE STANDARD TABLE OF tab512.
  DATA line     TYPE tab512.
  DATA options  TYPE STANDARD TABLE OF rfc_db_opt.
  DATA option	  TYPE rfc_db_opt.
  DATA ld_delimiter	TYPE sonv-flag.

*--- Fields to return.
  field-fieldname = 'OBJECT_ID'.
  APPEND field TO fields.

  field-fieldname = 'DESCRIPTION'.
  APPEND field TO fields.

*--- Where Clause
  option-text = 'OBJECT_ID = 3000000023 '.
  APPEND option TO options.

*--- Delimiter.
ld_delimiter = '|'.

  CALL FUNCTION 'RFC_READ_TABLE' DESTINATION 'TRUSTING_SYSTEM@PUM'
    EXPORTING
      query_table          = 'CRMD_ORDERADM_H'
      delimiter            = ld_delimiter
    TABLES
      fields               = fields
      data                 = data
      options              = options
    EXCEPTIONS
      table_not_available  = 1
      table_without_data   = 2
      option_not_valid     = 3
      field_not_valid      = 4
      not_authorized       = 5
      data_buffer_exceeded = 6
      OTHERS               = 7.

  IF sy-subrc <> 0.
    WRITE: 'Erro. ', sy-subrc.
  ELSE.
    LOOP AT data INTO line.
      WRITE: / line.
    ENDLOOP.
  ENDIF.
