import 'package:flutter/material.dart';
import 'package:sistema/funcs/encript_senha.dart';
import 'package:sistema/funcs/validador_cpf.dart';
import 'package:sistema/pages/esqueceu_page.dart';
import 'package:sistema/pages/register_page.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sistema/API/api_service.dart';
import 'package:sistema/pages/validCPF_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? loginError = null;
  bool isViewPassword = false;
  var _formKey = new GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  String _hashSenha = "";
  var cpfFormater = new MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')}
  );

  ApiService service = new ApiService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        onMetricsChanged: () {
          final bottom = MediaQuery.of(context).viewInsets.bottom;
          if (bottom == 0) {
            setState(() {});
          } else {
            setState(() {});
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? CelularPe(context)
              : celularDeitado(context);
        }
    );
  }

  Widget CelularPe(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.jpg', width: MediaQuery.of(context).size.width * 0.68),
                  SizedBox(
                    child: Form(
                      key: _formKey,
                      child: Card(
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width * 0.68,
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Text("Login",
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                inputFormatters: [cpfFormater],
                                keyboardType: TextInputType.number,
                                maxLength: 14,
                                onTap: () {
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    counterText: "",
                                    label: Text('CPF'),
                                    prefixIcon: Icon(Icons.account_circle_rounded),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                validator: (value) {
                                  if (!ValidadorCpf.validadeCPF(
                                      cpfFormater.getUnmaskedText() ??
                                          "00000000000")) {
                                    return "CPF INVÁLIDO";
                                  }
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                onTap: () {
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: _controllerPassword,
                                obscureText: !isViewPassword ? true : false,
                                decoration: InputDecoration(
                                    errorText: loginError,
                                    label: Text('Senha'),
                                    prefixIcon: Icon(Icons.security_outlined),
                                    suffixIcon: isViewPassword
                                        ? IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined),
                                      onPressed: () {
                                        setState(() {
                                          isViewPassword = !isViewPassword;
                                        });
                                      },
                                    )
                                        : IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        setState(() {
                                          isViewPassword = !isViewPassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                              ),
                              SizedBox(height: 10,),
                              ElevatedButton(
                                child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Center(
                                        child: Text("ENTRAR",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white
                                            )
                                        ))),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(2, 23, 128, 1.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onPressed: () async {
                                  String senhas = _controllerPassword.text;
                                  String cpf = cpfFormater.getUnmaskedText();

                                  if (_formKey.currentState!.validate()) {
                                    _hashSenha = EncriptSenha.sha256Hash(senhas);

                                    Map<String, dynamic> login = {
                                      'cpf': cpf,
                                      'senha': _hashSenha
                                    };

                                    Map<String, dynamic> retorno =
                                    await service.getLoginSucess(login);

                                    if (retorno["exists"]) {
                                      Map<String, dynamic> nameDoValidado =
                                      await service.getNameByCpf(cpf);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ValidCpfPage(
                                                      name: nameDoValidado["name"]
                                                  )
                                          )
                                      );
                                    } else {
                                      setState(() {
                                        loginError = "Senha ou CPF errados";
                                      });
                                      _formKey.currentState!.validate();
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Text("Registrar",
                                      style: TextStyle(
                                          color: Color.fromRGBO(71, 62, 204, 1.0)
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage()
                                            )
                                        );
                                      });
                                    },
                                  ),
                                  Text(" | "),
                                  GestureDetector(
                                    child: Text('Esqueci a senha',
                                      style: TextStyle(
                                          color: Color.fromRGBO(71, 62, 204, 1.0)
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EsqueceuPage()
                                            )
                                        );
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget celularDeitado(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo.jpg', width: 350),
                    Card(
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        width: 370,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 20,),
                              Text("Login",
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(height: 20,),
                              TextFormField(
                                inputFormatters: [cpfFormater],
                                keyboardType: TextInputType.number,
                                maxLength: 14,
                                onTap: () {
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    counterText: "",
                                    label: Text('CPF'),
                                    prefixIcon: Icon(Icons.account_circle_rounded),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                validator: (value) {
                                  if (!ValidadorCpf.validadeCPF(
                                      cpfFormater.getUnmaskedText() ??
                                          "00000000000")) {
                                    return "CPF INVÁLIDO";
                                  }
                                },
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                onTap: () {
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                controller: _controllerPassword,
                                obscureText: !isViewPassword ? true : false,
                                decoration: InputDecoration(
                                    errorText: loginError,
                                    label: Text('Senha'),
                                    prefixIcon: Icon(Icons.security_outlined),
                                    suffixIcon: isViewPassword
                                        ? IconButton(
                                      icon: Icon(Icons.remove_red_eye_outlined),
                                      onPressed: () {
                                        setState(() {
                                          isViewPassword = !isViewPassword;
                                        });
                                      },
                                    )
                                        : IconButton(
                                      icon: Icon(Icons.remove_red_eye),
                                      onPressed: () {
                                        setState(() {
                                          isViewPassword = !isViewPassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                              ),
                              SizedBox(height: 10,),
                              ElevatedButton(
                                child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: Center(
                                        child: Text("ENTRAR",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white
                                            )
                                        ))),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(2, 23, 128, 1.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    )
                                ),
                                onPressed: () async {
                                  String senhas = _controllerPassword.text;
                                  String cpf = cpfFormater.getUnmaskedText();

                                  if (_formKey.currentState!.validate()) {
                                    _hashSenha = EncriptSenha.sha256Hash(senhas);

                                    Map<String, dynamic> login = {
                                      'cpf': cpf,
                                      'senha': _hashSenha
                                    };

                                    Map<String, dynamic> retorno =
                                    await service.getLoginSucess(login);

                                    if (retorno["exists"]) {
                                      Map<String, dynamic> nameDoValidado =
                                      await service.getNameByCpf(cpf);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ValidCpfPage(
                                                      name: nameDoValidado["name"]
                                                  )
                                          )
                                      );
                                    } else {
                                      setState(() {
                                        loginError = "Senha ou CPF errados";
                                      });
                                      _formKey.currentState!.validate();
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Text("Registrar",
                                      style: TextStyle(
                                          color: Color.fromRGBO(71, 62, 204, 1.0)
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage()
                                            )
                                        );
                                      });
                                    },
                                  ),
                                  Text(" | "),
                                  GestureDetector(
                                    child: Text('Esqueci a senha',
                                      style: TextStyle(
                                          color: Color.fromRGBO(71, 62, 204, 1.0)
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EsqueceuPage()
                                            )
                                        );
                                      });
                                    },
                                  ),
                                ],
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
          );
        },
      ),
    );
  }
}

class LifecycleEventHandler with WidgetsBindingObserver {
  final VoidCallback onMetricsChanged;

  LifecycleEventHandler({required this.onMetricsChanged});

  @override
  void didChangeMetrics() {
    onMetricsChanged();
  }
}
