import 'package:flutter/material.dart';

class ValidCpfPage extends StatelessWidget {
  final  String? name;
  const ValidCpfPage({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: Center(
          child: Card(
              elevation: 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("AVISO", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,)),
                      SizedBox(width: 20,),
                      Icon(Icons.warning)

                    ],
                  ),
                  Container(
                      width: 300,
                      // height: 500,
                      child: Text("CPF autorizado, bem vindo: ${name} liberando, seu acesso á internet em instantes....",
                        style: TextStyle(color: Colors.green, fontSize: 25),)),
                ],
              ))),
    );
  }
}
