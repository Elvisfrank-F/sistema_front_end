import 'dart:io';

class ValidadorCpf {

  // void main(){
  //
  //   String entrada = stdin.readLineSync()!;
  //
  //   if(validadeCPF(entrada)){
  //     print("CPF VÁLIDO");
  //   }
  //   else {
  //     print("CPF INVALIDO");
  //   }
  //
  //
  //
  //
  //
  //
  // }


 static  bool validadeCPF(String cpf) {

   if(cpf.length !=11){
     return false;
   }


   //primeira etapa da varificação

    int cont = 10;
    int soma = 0;

    //10 primeiros digitos

    //-3 para pegar os 10 primeiros digitos

    for (int i = 0; i < (cpf.length - 2); i++) {
      String a = cpf[i];

      int? num = int.tryParse(a);
      if (num == null) {
        return false;
      }
      else {
        //  print("${a}")
        //stdout.write("$num * $cont + \n");
        soma += (cont * num);
        cont--;
      }
    }

    //caso o primeiro digito tenha sido confirmado
    // print("soma = $soma");
    //
    // print("resto = ${((soma * 10) % 11).toString()}");
    //
    // print("${(soma * 10) % 11} == ${cpf[cpf.length - 2]} ");

    if (((soma * 10) % 11) == int.parse(cpf[cpf.length - 2])) {
      cont = 11;
      soma = 0;

      //seguir para segunda etapa da verificação


      for (int i = 0; i < (cpf.length - 1); i++) {
        String a = cpf[i];

        int? num = int.tryParse(a);
        if (num == null) {
          return false;
        }
        else {
          //stdout.write("$num * $cont + \n");
          soma += (cont * num);
          cont--;
        }
      }

      //print("soma = $soma");

      //print("resto = ${((soma * 10) % 11).toString()}");

      if ((soma * 10) % 11 == int.parse(cpf[cpf.length - 1])) {
        return true;
      }
    }
    else {
      return false;
    }

    return false; //so para ele parar de gritar

  }

}


