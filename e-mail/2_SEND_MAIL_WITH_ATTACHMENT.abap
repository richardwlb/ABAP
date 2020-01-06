*--- Takes the ZIP file from method 1 and send it

*--- Parameters
-> Importing@	I_TEXT	          TYPE BCSY_TEXT
-> Importing@	I_SUBJECT	        TYPE SOOD-OBJDES
-> Importing@	I_ATTACHMENT	    TYPE SOLIX_TAB
-> Importing@	I_ATTACHMENT_NAME	TYPE STRING
-> Importing@	I_RECIPIENTS	    TYPE TY_RECIPIENTS
*--- Parameters

method send_mail_with_attachment.

    data: lo_send_request type ref to cl_bcs value is initial.
    class cl_bcs definition load.

    data: lo_document  type ref to cl_document_bcs value is initial, "document object
          l_attsubject type sood-objdes,
          l_data       type string,
          lo_sender    type ref to if_sender_bcs value is initial, "sender
          lo_recipient type ref to if_recipient_bcs value is initial. "recipient

    field-symbols: <wa_recipients> type tty_recipient.

    lo_send_request = cl_bcs=>create_persistent( ).

    lo_document = cl_document_bcs=>create_document( "create document
      i_type      = 'TXT'                           "Type of document HTM, TXT etc
      i_text      = i_text                         "email body internal table
      i_subject   = i_subject ).                    "email subject here p_sub input parameter
    lo_send_request->set_document( lo_document ).

* Set the attachment name
    concatenate i_attachment_name '_' sy-datum into l_data.
    l_attsubject = l_data.
    clear l_data.

* Create Attachment
    lo_document->add_attachment( exporting
      i_attachment_type     = 'ZIP'
      i_attachment_subject  = l_attsubject
      i_att_content_hex     = i_attachment   ).

    lo_sender = cl_sapuser_bcs=>create( sy-uname ). "sender is the logged in user
* Set sender to send request
    lo_send_request->set_sender(
    exporting
    i_sender = lo_sender ).

**Set recipient
    loop at i_recipients assigning <wa_recipients>.

      lo_recipient = cl_cam_address_bcs=>create_internet_address( <wa_recipients>-email ).

      lo_send_request->add_recipient(
        exporting
          i_recipient = lo_recipient
          i_express = 'X' ).

    endloop.

    call method lo_send_request->set_send_immediately
      exporting
        i_send_immediately = 'X'. "here selection screen input p_send

** Send email
    lo_send_request->send(
      exporting
      i_with_error_screen = 'X' ).

    commit work.

    if sy-subrc = 0. "mail sent successfully
      write :/ 'Mail sent successfully'.
    endif.

  endmethod.
