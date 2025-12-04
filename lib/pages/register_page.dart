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

  ApiService service = new ApiService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.pop(context);
        }),
      ),

      body: Center(
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

                                  final nome = await service.getNameByCpf(cpf);

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => ValidCpfPage(name: nome["name"])));
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
      )
    );
  }
}
