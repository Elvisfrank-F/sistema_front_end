import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService{

  final String _baseUrl = 'http://192.168.1.34:9090/api/usuarios';

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

  //GET para saber se o usuario ta cadastrado (caso a senha seja nula, ele não está)

  Future<bool> getRegisterUser(String cpf) async {
    final url = Uri.parse('$_baseUrl/cpf/isRegister/$cpf');

    try{

      final response = await http.get(url);

      if(response.statusCode == 200){
        return json.decode(response.body)["null"] == true? true:false;
      }
      else {
        return false;
      }
    }catch(e){
      print(e);
      return false;

    }
  }

  //POST para saber se o login deu certo

  Future<Map<String, dynamic>> getLoginSucess(Map<String, dynamic> loginho) async {
    final url = Uri.parse("$_baseUrl/login");

    try{

      final response = await http.post(url,

          headers: {
            'Content-Type': 'application/json',
          },

          body: json.encode(loginho));

      if(response.statusCode == 200){



        Map<String, dynamic> retorno = json.decode(response.body);
        return retorno;
      }
      else {
        return {

        };
      }

  }
  catch(e){
  return {};
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

  Future<bool> atualizarPassword(Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl/senha/cpf');

    try{

      final response = await http.put(
        url,
        headers: {
          'Content-Type' : 'Application/json',
        },
        body: json.encode(body)
      );

      if(response.statusCode == 200) {
        return json.decode(response.body)["status"] == 1? true:false;
      }
      else {
        print("Erro no PUT: ${response.statusCode}");
        return false;
      }

    }
        catch(e){
          print('Exceção ao fazer PUT: $e');
          return false;
        }
  }

}