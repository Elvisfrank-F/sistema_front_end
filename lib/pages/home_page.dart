import 'package:flutter/material.dart';
import 'package:sistema/funcs/encript_senha.dart';
import 'package:sistema/funcs/validador_cpf.dart';
import 'package:sistema/pages/esqueceu_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isViewPassword = false;

  var _formKey = new GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  String hashSenha="";

  var cpfFormater = new MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: { "#": RegExp(r'[0-9]')}
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,

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
                          Text("Login", style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),),
                          SizedBox(height: 20,),
                          TextFormField(
                            inputFormatters: [cpfFormater],
                            keyboardType: TextInputType.number,
                            maxLength: 14,

                            decoration: InputDecoration(
                              counterText:"",

                              label: Text('Usuário'),

                              prefixIcon: Icon(Icons.account_circle_rounded),
                              border:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                            validator: (value){
                              if(!ValidadorCpf.validadeCPF(cpfFormater.getUnmaskedText() ?? "00000000000")) {
                                return "CPF INVÁLIDO";
                              }

                            },
                          ),
                          SizedBox(height: 10,),
                          TextField(

                            controller: _controllerPassword,

                            obscureText: !isViewPassword ? true:false,

                            decoration: InputDecoration(

                                label: Text('Senha'),
                                prefixIcon: Icon(Icons.security_outlined),
                                suffixIcon: isViewPassword ? IconButton(icon: Icon(Icons.remove_red_eye_outlined),
                                onPressed: (){
                                  setState(() {
                                    isViewPassword = !isViewPassword;
                                  });
                                },):IconButton(icon: Icon(Icons.remove_red_eye),
                                onPressed: (){
                                  setState(() {
                                    isViewPassword = !isViewPassword;
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


                            , onPressed: (){

                            if(_formKey.currentState!.validate()){
                              hashSenha = EncriptSenha.sha256Hash(_controllerPassword.text);
                            }

                            },),
                          SizedBox(height: 10,),
                          GestureDetector(
                            child: Text('Esqueceu a senha?', style: TextStyle(color: Color.fromRGBO(
                                71, 62, 204, 1.0)),),
                            onTap: (){
                              setState(() {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => EsqueceuPage()
                                ));
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
