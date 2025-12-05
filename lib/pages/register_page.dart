import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sistema/funcs/encript_senha.dart';
import 'package:sistema/funcs/validador_cpf.dart';
import 'package:sistema/pages/invalidCPF_page.dart';
import 'package:sistema/API/api_service.dart';
import 'dart:async';

import 'package:sistema/pages/validCPF_page.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  var _formKey = new GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();

  var _cpfFormater = new MaskTextInputFormatter(
      mask: "###.###.###-##",
      filter: { "#" : RegExp(r'[0-9]')}
  );

  String _hashSenha="";

  int error = 0;
  int errorSecond =0;

  ApiService service = new ApiService();

  bool cond = false;

  String nomeCPF = ""; //passar o nome por parametro para secondMoment
  bool _isViewPassword = false; // varivel de visualizar a senha

  //controllers o secondmoment

  TextEditingController _controllerPasswordFirst = new TextEditingController();
  TextEditingController _controllerPasswordSecond = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            Navigator.pop(context);
          }),
        ),

        body: cond ? secondMoment(context) : firstMoment(context)
    );
  }


  Widget firstMoment(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset('assets/logo.jpg', width: 350),

              Card(
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(30),
                  width: 370,
                  height: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        SizedBox(height: 20,),
                        Text("Register", style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),),
                        SizedBox(height: 20,),
                        TextFormField(

                          inputFormatters: [_cpfFormater],
                          keyboardType: TextInputType.number,
                          maxLength: 14,

                          decoration: InputDecoration(
                              counterText:"",

                              label: Text('CPF'),

                              prefixIcon: Icon(Icons.account_circle_rounded),
                              border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                          validator: (value){
                            if(!ValidadorCpf.validadeCPF(_cpfFormater.getUnmaskedText() ?? "00000000000")) {
                              return "CPF INVÁLIDO";
                            }else if(error == 1){
                              error = 0;
                              return "USUARIO JÁ REGISTRADO";
                            }

                          },
                        ),
                        SizedBox(height: 10,),

                        ElevatedButton(child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(child: Text("ENTRAR", style: TextStyle(fontSize: 20, color: Colors.white)))),
                          style: ElevatedButton.styleFrom(

                              backgroundColor: Color.fromRGBO(2, 23, 128, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          )


                          , onPressed: () async {



                            String cpf = _cpfFormater.getUnmaskedText();

                            if(_formKey.currentState!.validate()){
                              // _hashSenha = EncriptSenha.sha256Hash(_controllerPassword.text);



                              //  );

                              bool cpfExist = await service.getExistCpf("cpf", cpf);


                              if(cpfExist){




                                if(await service.getRegisterUser(cpf)){
                                  Map<String, dynamic> r = await service.getNameByCpf(cpf);
                                  nomeCPF = r["name"];
                                  setState(() {
                                    cond = true;
                                  });


                                }
                                else {
                                  setState(() {
                                    error = 1;
                                    //_formKey.currentState!.validate();
                                  });

                                }


                              }
                              else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => InvalidCpfPage()));
                              }


                            }

                          },),
                        SizedBox(height: 10,),





                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


Widget secondMoment(BuildContext context) {






    return Center(

      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset('assets/logo.jpg', width: 350),

              Card(
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(30),
                  width: 370,
                  height: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        SizedBox(height: 20,),
                        Text("Bem vindo ${nomeCPF}", style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),),
                        SizedBox(height: 20,),
                        TextFormField(
                          inputFormatters: [_cpfFormater],
                          keyboardType: TextInputType.number,
                          maxLength: 14,

                          decoration: InputDecoration(
                              counterText:"",

                              label: Text('CPF'),

                              prefixIcon: Icon(Icons.account_circle_rounded),
                              border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                          validator: (value){
                            if(!ValidadorCpf.validadeCPF(_cpfFormater.getUnmaskedText() ?? "00000000000")) {
                              return "CPF INVÁLIDO";
                            }

                          },
                        ),
                        SizedBox(height: 10,),
                        TextFormField(

                          controller: _controllerPasswordFirst,

                          obscureText: !_isViewPassword ? true:false,

                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'INSIRA UMA SENHA';
                            }
                          },
                          decoration: InputDecoration(


                              label: Text('Senha'),
                              prefixIcon: Icon(Icons.security_outlined),
                              suffixIcon: _isViewPassword ? IconButton(icon: Icon(Icons.remove_red_eye_outlined),
                                onPressed: (){
                                  setState(() {
                                    _isViewPassword = !_isViewPassword;
                                  });
                                },):IconButton(icon: Icon(Icons.remove_red_eye),
                                onPressed: (){
                                  setState(() {
                                    _isViewPassword = !_isViewPassword;
                                  });
                                },),
                              border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        ),

                        SizedBox(height: 10,),
                        TextFormField(

                          validator: (value){
                            if(value == null || value.isEmpty){
                              return 'INSIRA UMA SENHA';
                            }
                            if(_controllerPasswordSecond.text != _controllerPasswordFirst.text){
                              return 'AS SENHAS SÃO DIFERENTES';
                            }
                            if(errorSecond == 1){
                              errorSecond =0;
                              return 'CPF JÁ CADASTRADO';
                            }
                          },

                          controller: _controllerPasswordSecond,

                          obscureText: !_isViewPassword ? true:false,


                          decoration: InputDecoration(


                              label: Text('Repita Senha'),
                              prefixIcon: Icon(Icons.security_outlined),
                              suffixIcon: _isViewPassword ? IconButton(icon: Icon(Icons.remove_red_eye_outlined),
                                onPressed: (){
                                  setState(() {
                                    _isViewPassword = !_isViewPassword;
                                  });
                                },):IconButton(icon: Icon(Icons.remove_red_eye),
                                onPressed: (){
                                  setState(() {
                                    _isViewPassword = !_isViewPassword;
                                  });
                                },),
                              border:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          ),
                        ),



                        SizedBox(height: 10,),

                        ElevatedButton(child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: Center(child: Text("ENTRAR", style: TextStyle(fontSize: 20, color: Colors.white)))),
                          style: ElevatedButton.styleFrom(

                              backgroundColor: Color.fromRGBO(2, 23, 128, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              )
                          )


                          , onPressed: () async {

                            String cpf = _cpfFormater.getUnmaskedText();

                            if(_formKey.currentState!.validate()){
                              _hashSenha = EncriptSenha.sha256Hash(_controllerPasswordFirst.text);



                              //  );

                              bool cpfExist = await service.getExistCpf("cpf", cpf);


                              if(cpfExist) {
                                Map<String, dynamic> registrar = {
                                  "cpf": cpf,
                                  "senha": _hashSenha
                                };

                                if(await service.getRegisterUser(cpf)){
                                  if (await service.atualizarPassword(
                                      registrar)) {

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            ValidCpfPage(name: nomeCPF)));


                                  }
                                  else {
                                    MaterialPageRoute(builder: (context) =>
                                        InvalidCpfPage());
                                  }
                                }
                                else {
                                  setState(() {
                                    errorSecond = 1;
                                  });

                                }


                              }






                            }

                          },),
                        SizedBox(height: 10,),





                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }


}
