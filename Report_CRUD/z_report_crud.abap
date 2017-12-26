*&---------------------------------------------------------------------*
*& Report Z_REPORT_CRUD
*&---------------------------------------------------------------------*
*& Richard W. L. Brehmer
*&---------------------------------------------------------------------*
report z_report_crud.

*&---------------------------------------------------------------------*
*&      Variaveis
*&---------------------------------------------------------------------*
data: gw_zlivros type zlivros.


*&---------------------------------------------------------------------*
*&      Tabelas
*&---------------------------------------------------------------------*
tables: zlivros.

*&---------------------------------------------------------------------*
*&      Tela Seleção
*&---------------------------------------------------------------------*
selection-screen begin of block b1 with frame title text-001.

parameters:   p_id      type zlivro_id
            , p_nome    type zlivro_nome
            , p_edicao  type zlivros-edicao
            , p_tipo    type zlivro_tipo.
**select-options s_tipo for zlivros-tipo.

selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002.

parameters:  p_del radiobutton group g1
            ,p_ins radiobutton group g1
            ,p_mod radiobutton group g1
            ,p_rea radiobutton group g1.

selection-screen end of block b2.

*&---------------------------------------------------------------------*
*&      Inicio da execução
*&---------------------------------------------------------------------*
start-of-selection.

  gw_zlivros-id     = p_id.
  gw_zlivros-nome   = p_nome.
  gw_zlivros-edicao = p_edicao.
  gw_zlivros-tipo   = p_tipo.


  if p_del = 'X'.
    perform del.
  elseif p_ins = 'X'.
    perform ins.
  elseif p_mod = 'X'.
    perform mod.
  elseif p_rea = 'X'.
    perform rea.
  endif.
*&---------------------------------------------------------------------*
*&      Form  DEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form del .
  delete from zlivros where id = gw_zlivros-id.

  if sy-subrc = 0.
    message 'Dados deletados com sucesso!' type 'S'.

    clear:  p_id
       ,p_nome
       ,p_edicao
       ,p_tipo.

  else.
    message 'Erro na deleção!' type 'E'.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  INS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form ins .

  insert zlivros from gw_zlivros.

  if sy-subrc = 0.
    message 'Dados inseridos com sucesso!' type 'S'.
  else.
    message 'Erro na inserção!' type 'E'.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  MOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form mod .

  modify zlivros from gw_zlivros.

  if sy-subrc = 0.
    message 'Dados modificados com sucesso!' type 'S'.
  else.
    message 'Erro na modificação!' type 'E'.
  endif.

endform.
*&---------------------------------------------------------------------*
*&      Form  REA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form rea .

  clear: gw_zlivros.

  data: t_zlivros type standard table of zlivros.

  select * from zlivros into table t_zlivros.

  loop at t_zlivros into gw_zlivros.

    write: / gw_zlivros-id, gw_zlivros-nome, gw_zlivros-edicao.

  endloop.



endform.
