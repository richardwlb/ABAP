
process before output.
* MODULE STATUS_0103.
*

  module start_alv.

*-- Define a tela, declarada no inicio do programa principal.
*-- dentro da area SUBCEL
  call subscreen subcel including sy-cprog '9999'.


  process after input.

*-- necessário:
  call subscreen subcel.

  module user_command_0103.
