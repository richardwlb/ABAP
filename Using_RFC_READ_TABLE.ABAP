FORM select_pum .

data fields type standard table of rfc_db_fld.
data field type rfc_db_fld.
data data type standard table of tab512.
data line type tab512.

field-fieldname = 'TRKORR'.
append field to fields.

field-fieldname = 'OWNER'.
append field to fields.

call function 'RFC_READ_TABLE' destination 'TRUSTING_SYSTEM@PUM'
  exporting
    query_table          = 'TMSBUFTXT'
  tables
    fields               = fields
    data                 = data
  exceptions
    table_not_available  = 1
    table_without_data   = 2
    option_not_valid     = 3
    field_not_valid      = 4
    not_authorized       = 5
    data_buffer_exceeded = 6
    others               = 7.

if sy-subrc <> 0.
  WRITE: 'Erro. ', sy-subrc.
else.
  loop at data into line.
    write: / line.
  endloop.
endif.

ENDFORM.
