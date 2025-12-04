import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService{

  final String _baseUrl = 'http://192.168.1.34:8080/api/usuarios';

  //GET

  Future<dynamic> getDados(String endpoint) async{
    final url = Uri.parse('$_baseUrl/$endpoint');

    try{
      final response = await http.get(url);

      if(response.statusCode == 200){
        //Sucesso
        return json.decode(response.body);
      }
      else {
        //erro
        print(response.statusCode);
        return null;
      }
    }
    catch(e){
      //erro de conexão
      print(e);
      return null;
    }
  }

  //GET PARA BUSCAR O NOME POR CPF

  Future<Map<String, dynamic>> getNameByCpf(String cpf) async{
    final url = Uri.parse("$_baseUrl/name/$cpf");

    try{

      final response = await http.get(url);

      if(response.statusCode == 200) {
        return json.decode(response.body);
      }
      else {
        return {};
      }




    }
        catch(e){

       return {};
      //erro
         print(e);
        }
  }

  //GET PARA SABER SE TEM O CPF CADASTRADO (caso nao tenha, o cpf não é autorizado)

  Future<dynamic> getExistCpf(String endpoint, String cpf) async{

    final url = Uri.parse('$_baseUrl/$endpoint/$cpf');

    try{
      final response = await http.get(
        url
      );

      if(response.statusCode == 200){

         final result = response.body.trim();

       if(result == "true"){
         return true;
       }
       else {
         return false;
       }
      }
      else {
        return false;
      }
    }
    catch(e){
      return false;
    }

  }
  //PUT (ATUALIZAR A SENHA)

  Future<dynamic> putDados(String endpoint, String passWord) async {
    final url = Uri.parse('$_baseUrl/$endpoint');

    try{

      final response = await http.put(
        url,
        body: passWord
      );

      if(response.statusCode == 200) {
        return passWord;
      }
      else {
        print("Erro no PUT: ${response.statusCode}");
        return null;
      }

    }
        catch(e){
          print('Exceção ao fazer PUT: $e');
          return null;
        }
  }

}