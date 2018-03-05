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

*--- Variáveis para o ALV
data: go_alv_container type ref to cl_gui_custom_container,
      go_alv           type ref to cl_gui_alv_grid,
      gs_layout        type lvc_s_layo.


*----- Tabela interna para o registro da tela 0101 e qtd
data: gw_pokedex type yxx_pokedex.
data: g_qtd_animais type i.

*----------- Declaração da table control, usada na tela 0102 (OBRIGATÓRIO)
controls: tc_pokedex type tableview using screen 0102.

*----- global table para tela 0102.
data: gt_pokedex type standard table of yxx_pokedex.
*----- global table para tela 0103. Vai usar no ALV
data: gt_pokedex_alv type standard table of yxx_pokedex.

*----- Flag para a tela de ADICIONAR / EDITAR.
" Obs: CHAR de 1 ja vem implicito. Não precisa declarar.
data: g_edit.


*-- Declaração da tela usada na seleção do ALV - Tela 0103.
selection-screen begin of screen 9999 as subscreen.
selection-screen begin of block b1  with frame title text-001.

select-options: ficha for yxx_pokedex-ficha,
                nome for yxx_pokedex-nome.

selection-screen end of block b1.
selection-screen end of screen 9999.
*-- Declaração da tela usada na seleção do ALV - Tela 0103.

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
    when '0103'.
      set pf-status '0103'.

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

  data: l_lines type i.

*  if gt_pokedex[] is initial.
  select * from yxx_pokedex into table gt_pokedex.
*  endif.

  describe table gt_pokedex lines l_lines.

  g_qtd_animais = l_lines.

  clear gw_pokedex.
  read table gt_pokedex into gw_pokedex index l_lines.



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

  "Check para limpar apenas se estiver adicionando.
  check g_edit is initial.

  clear yxx_pokedex.

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

  " Valida se campos esta vazio
  if yxx_pokedex-nome is initial.

    message s001 display like 'E'.
    exit.

  endif.


  " Verifica se esta adicionando ou alterando.
  if g_edit = space.

    "Gera um novo numero a partir do range criado via SNRO
    perform get_num_ficha.
    "Adiciona no banco
    insert yxx_pokedex from yxx_pokedex.

    " Verifica se erro
    if sy-subrc = 0.
      message s002.
      " Adiciona o registro inserido na table control da tela 0102.
      " gt_pokedex é referencia naquela table control.
      append yxx_pokedex to gt_pokedex.
    else.
      message s003 display like 'E'.
    endif.

    " Se Edição da linha.
  else.

    modify yxx_pokedex from yxx_pokedex.

    " Verifica se erro
    if sy-subrc = 0.
      message s002.
      " Atualiza table control.
      " gt_pokedex é referencia naquela table control.
      modify gt_pokedex from yxx_pokedex
      transporting
      ficha
      nome
      telefone
      idade
      peso
      raca
      religiao
      v_raiva
      v_pulga
      v_sarna
      where ficha = yxx_pokedex-ficha.

    else.
      message s003 display like 'E'.
    endif.

  endif.


  " Volta para a tela anterior.
  set screen 0. leave screen.

endform.                    " CHECK_OK
*&---------------------------------------------------------------------*
*&      Form  GET_NUM_FICHA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form get_num_ficha .


  call function 'NUMBER_GET_NEXT'
    exporting
      nr_range_nr                   = 'PK'
      object                        = 'YXX_PK'
*     QUANTITY                      = '1'
*     SUBOBJECT                     = ' '
*     TOYEAR                        = '0000'
*     IGNORE_BUFFER                 = ' '
   importing
      number                        = yxx_pokedex-ficha
*     QUANTITY                      =
*     RETURNCODE                    =
*   EXCEPTIONS
*     INTERVAL_NOT_FOUND            = 1
*     NUMBER_RANGE_NOT_INTERN       = 2
*     OBJECT_NOT_FOUND              = 3
*     QUANTITY_IS_0                 = 4
*     QUANTITY_IS_NOT_1             = 5
*     INTERVAL_OVERFLOW             = 6
*     BUFFER_OVERFLOW               = 7
*     OTHERS                        = 8
            .
  if sy-subrc <> 0.
* Implement suitable error handling here
  endif.



endform.                    " GET_NUM_FICHA
*&---------------------------------------------------------------------*
*&      Module  GET_ATTRIBUTES_TC  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module get_attributes_tc output.
  describe table gt_pokedex lines tc_pokedex-lines.
endmodule.                 " GET_ATTRIBUTES_TC  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0102 input.

  case sy-ucomm.
    when 'EDIT'.
      perform edit_line.
    when others.
  endcase.


endmodule.                 " USER_COMMAND_0102  INPUT
*&---------------------------------------------------------------------*
*&      Form  EDIT_LINE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form edit_line .

  data : l_line type i.

  g_edit = 'X'.

  "Traz o numero da linha atual.
  get cursor line l_line.
  " AJusta para que traga a linha correta.
  l_line = l_line + tc_pokedex-top_line - 1.

  "Le os registros da linha seleciona e joga para o yxx_pokedex.
  clear yxx_pokedex.
  read table gt_pokedex into yxx_pokedex index l_line.

  call screen 0200 starting at 10 10.

  clear g_edit.


endform.                    " EDIT_LINE
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_0103 input.

  case sy-ucomm.
    when 'EXEC'.
      perform exec.
    when others.
  endcase.


endmodule.                 " USER_COMMAND_0103  INPUT
*&---------------------------------------------------------------------*
*&      Module  START_ALV  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module start_alv output.

*-- Para nao criar o objeto denovo.
CHECK go_alv_container is INITIAL.

*-- parte copiada como base do progrma BCALV_GRID_02
  create object go_alv_container
    exporting
      container_name = 'CC_ALV'.

* create an instance of alv control
  create object go_alv
    exporting
      i_parent = go_alv_container.

  gs_layout-grid_title = 'Relatório'(100).
  gs_layout-cwidth_opt = 'X'.

* Set a titlebar for the grid control
*
  gs_layout-grid_title = 'Relatório'(100).

  call method go_alv->set_table_for_first_display
    exporting
      i_structure_name = 'YXX_POKEDEX'
      is_layout        = gs_layout
    changing
      it_outtab        = gt_pokedex_alv.

endmodule.                 " START_ALV  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  EXEC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form exec .

  refresh gt_pokedex_alv[].

  select * from yxx_pokedex into table gt_pokedex_alv
    where nome in nome
    and ficha in ficha.

    call METHOD go_alv->refresh_table_display( ).

endform.                    " EXEC
