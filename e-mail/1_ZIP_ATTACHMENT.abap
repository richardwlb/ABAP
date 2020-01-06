*--------- Method that zip the "file" before send

*--- Parameters
-> Importing	I_BIN_SIZE	TYPE I	
-> Importing	I_ATTACHMENT	TYPE TTY_SOLIX	
-> Importing	I_FILE_NAME	TYPE STRING OPTIONAL	
<- Exporting	E_ZIP_BIN	TYPE SOLIX_TAB	GBT: "SOLIX as Table Type
*--- Parameters


  method zip_attachment.

    data :
      buffer_x   type xstring,
      buffer_zip type xstring,
      file_name  type string.


    call function 'SCMS_BINARY_TO_XSTRING'
      exporting
        input_length = i_bin_size
      importing
        buffer       = buffer_x
      tables
        binary_tab   = i_attachment.
    if sy-subrc <> 0.
* message id sy-msgid type sy-msgty number sy-msgno
* with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

*create zip tool
    data : zip_tool     type ref to cl_abap_zip.
    create object zip_tool.

    if i_file_name is initial.
      file_name = 'file.html'.
    else.
      file_name = i_file_name.
    endif.

*add binary file
    call method zip_tool->add
      exporting
        name    = file_name
        content = buffer_x.

*get binary ZIP file
    call method zip_tool->save
      receiving
        zip = buffer_zip.

    data: lit_binary_content type solix_tab,
          l_attsubject       type sood-objdes.

    call function 'SCMS_XSTRING_TO_BINARY'
      exporting
        buffer        = buffer_zip
*      importing
*        output_length = bin_size
      tables
        binary_tab    = e_zip_bin.

  endmethod.
