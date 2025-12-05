import 'dart:html' as html;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool keyboardOpen = false;

  @override
  void initState() {
    super.initState();

    // Escuta mensagens vindas do JS (index.html)
    html.window.onMessage.listen((event) {
      if (event.data == "keyboard_open") {
        setState(() => keyboardOpen = true);
      } else if (event.data == "keyboard_close") {
        setState(() => keyboardOpen = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool portrait = constraints.maxHeight > constraints.maxWidth;

        // Quando o teclado abre, você pode exibir outro layout
        if (keyboardOpen) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: _buildKeyboardOpenLayout(),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout(),
        );
      },
    );
  }

  // ------------------------------------------------------------
  //  LAYOUT NORMAL (VERTICAL)
  // ------------------------------------------------------------
  Widget _buildVerticalLayout() {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "Tela em Modo Vertical",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  //  LAYOUT NORMAL (HORIZONTAL)
  // ------------------------------------------------------------
  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue.shade100,
            child: const Center(
              child: Text(
                "Paisagem",
                style: TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(child: _buildInputArea()),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  //  LAYOUT QUANDO O TECLADO ESTÁ ABERTO
  // ------------------------------------------------------------
  Widget _buildKeyboardOpenLayout() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Teclado aberto",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: _buildInputArea(),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  //  CAMPO DE TEXTO (COMPORTA BEM COM TECLADO)
  // ------------------------------------------------------------
  Widget _buildInputArea() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade200,
      ),
      child: Column(
        children: [
          const Text(
            "Digite algo:",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
