import 'package:flutter/material.dart';

class BaseTimerLayout extends StatelessWidget {
  final String titulo;
  final String tempoFormatado;
  final Widget controleAdicional;
  final List<Widget> botoesPrincipais;

  const BaseTimerLayout({
    super.key,
    required this.titulo,
    required this.tempoFormatado,
    required this.controleAdicional,
    required this.botoesPrincipais,
  });

  @override
  Widget build(BuildContext context) {
    const Color corDoTitulo = Colors.white; 

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), 
      appBar: AppBar(
        title: Text(titulo),

        iconTheme: const IconThemeData(
          color: corDoTitulo, 
        ),
        titleTextStyle: const TextStyle(
          color: corDoTitulo, 
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tempoFormatado,
            style: const TextStyle(
                fontSize: 75, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          controleAdicional,
          const SizedBox(height: 40),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: botoesPrincipais),
        ],
      ),
    );
  }
}