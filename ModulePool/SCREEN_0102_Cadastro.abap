
process before output.

  "Faz select na tabela e joga na IT GT_POKEDEX
  module  get_data_0102.

  module get_attributes_tc.

  " Joga o que esta na IT GT_POKEDEX dentro da table control:
  loop at gt_pokedex into yxx_pokedex
    with control tc_pokedex
    cursor tc_pokedex-current_line.

    " Habilita apenas o botão de edição.
    module trata_campos_tc.


  endloop.

process after input.

  " Parte necessário da table control.
  loop at gt_pokedex.
  endloop.

  module user_command_0102.
