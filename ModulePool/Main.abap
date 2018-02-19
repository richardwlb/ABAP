*&---------------------------------------------------------------------*
*& Report  YXX_ARROZFRANGO
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  yxx_arrozfrango message-id yxx_pokedex.


tables: yxx_pokedex.

*------------------ Variáveis usadas na imagem inicial
data: go_container type ref to cl_gui_custom_container,
      go_html      type ref to cl_gui_html_viewer.

data: gt_lhtml type standard table of w3html,
      g_url   type char255.

*---- Variável para mudar o numero da tela que aparece no frame.
data  g_tela  type sy-dynnr value '0001'.

*----- Tabela interna para o registro da tela 0101 e qtd
data: gw_pokedex type yxx_pokedex.
data: g_qtd_animais type i.

*----------- Declaração da table control, usada na tela 0102 (OBRIGATÓRIO)
controls: tc_pokedex type tableview using screen 0102.

*----- global table para tela 0102.
data: gt_pokedex type standard table of yxx_pokedex.







initialization.

  call screen 0100.
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0100 output.

  case g_tela.
    when '0102'.
      set pf-status '0102'.
    when others.
      set pf-status '0100'.
  endcase.


  set titlebar '0100' with sy-datum sy-timlo.

endmodule.                 " STATUS_0100  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0100 input.

  case sy-ucomm.
    when 'BACK' or 'CANC' or 'EXIT'.
      leave program.

    when 'RG'.
      g_tela = '0101'.
    when 'CD'.
      g_tela = '0102'.
    when 'RL'.
      g_tela = '0103'.
    when 'ADD'.
      call screen 0200 starting at 10 10.
    when others.
  endcase.


endmodule.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  START_HTML_MENU  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module start_html_menu output.

  check go_container is initial.

  create object go_container
    exporting
      container_name = 'CC_HTMLMENU'.

  create object go_html
    exporting
      parent = go_container.

* Seta a borda.
  call method go_html->set_ui_flag
    exporting
      uiflag = 6.


  refresh gt_lhtml[].

  append '<html><body scroll="no"' to gt_lhtml.
  append 'topmargin="0" bgcolor="DFEBF5" leftmargin="0" >' to gt_lhtml.
  append '<img src=ZANIMAL align=center width=250 height=150>' to gt_lhtml.
  append '</br>' to gt_lhtml.
  append '</body></html>' to gt_lhtml.

  call method go_html->load_mime_object( object_id = 'ZANIMAL'
    object_url = 'ZANIMAL' ).

  call method go_html->load_data(
    importing
      assigned_url = g_url
    changing
      data_table   = gt_lhtml ).

  call method go_html->show_url( url = g_url ).


endmodule.                 " START_HTML_MENU  OUTPUT


*&---------------------------------------------------------------------*
*&      Module  GET_DATA_0101  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module get_data_0101 output.

  perform get_data_0101.

endmodule.                 " GET_DATA_0101  OUTPUT


*&---------------------------------------------------------------------*
*&      Form  GET_DATA_0101
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_data_0101 .


  data: l_ficha type yxx_pokedex-ficha.

  "... Pega ultimo registro
  select max( ficha ) from yxx_pokedex into l_ficha.

  g_qtd_animais = l_ficha.

  select single * from yxx_pokedex into  gw_pokedex
    where ficha = l_ficha.



endform.                    " GET_DATA_0101
*&---------------------------------------------------------------------*
*&      Module  GET_DATA_0102  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module get_data_0102 output.

  check gt_pokedex[] is initial.

  select * from yxx_pokedex into table gt_pokedex.



endmodule.                 " GET_DATA_0102  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  TRATA_CAMPOS_TC  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module trata_campos_tc output.

  "Faz um loop nos objetos da tela.
  loop at screen.
    " Para habilitar apenas o botão de edição.
    case screen-name.
      when 'G_EDIT'.
        "Não faz nada.
      when others.
        screen-input = 0.
    endcase.

    modify screen.

  endloop.

endmodule.                 " TRATA_CAMPOS_TC  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module status_0200 output.
  set pf-status '0200'.
  set titlebar '0200'.

endmodule.                 " STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0200 input.

  case sy-ucomm.
    when 'BACK' or 'CANC' or 'EXIT'.
      set screen 0. leave screen.
    when 'OK'.
      perform check_ok.
    when others.
  endcase.


endmodule.                 " USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*&      Form  CHECK_OK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form check_ok .

  if yxx_pokedex-idade is initial or
    yxx_pokedex-nome is initial or
    yxx_pokedex-telefone is initial or
    yxx_pokedex-raca is initial or
    yxx_pokedex-religiao is initial.

    message s001 display like 'E'.
    exit.

  endif.

  "Adiciona no banco
  insert yxx_pokedex from yxx_pokedex.

  if sy-subrc = 0.

    message s002.

    " Adiiona o registro inserido na table control da tela 0102.
    " gt_pokedex é referencia naquela table control.
    append yxx_pokedex to gt_pokedex.

  else.
    message s003 display like 'E'.

  endif.



endform.                    " CHECK_OK
