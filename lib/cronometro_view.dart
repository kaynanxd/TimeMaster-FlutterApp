import 'package:flutter/material.dart';
import '../cronometro_controller.dart';
import 'base_timer_layout.dart';

class CronometroView extends StatefulWidget {
  const CronometroView({super.key});

  @override
  State<CronometroView> createState() => _CronometroViewState();
}

class _CronometroViewState extends State<CronometroView> {
  final controller = CronometroController();

  @override
  void initState() {
    super.initState();
    controller.onUpdate = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void dispose() {

    controller.onUpdate = null; 
    
    controller.parar(); 
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTimerLayout(
      titulo: "Cronômetro",
      tempoFormatado: controller.tempoFormatado,
      controleAdicional: const SizedBox(height: 20), 
      botoesPrincipais: [
        ElevatedButton(
          onPressed: () => controller.model.estaRodando 
              ? controller.parar() 
              : controller.iniciarCronometro(),
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.model.estaRodando ? Colors.orange : null, 
          ),
          child: Text(controller.model.estaRodando ? "Pausar" : "Iniciar"),
        ),
        
        const SizedBox(width: 10),

        ElevatedButton(
          onPressed: controller.adicionar30Segundos,
          child: const Text("+30s"),
        ),

        const SizedBox(width: 10),

        ElevatedButton(
          onPressed: controller.resetar, 
          child: const Text("Reset")
        ),

        const SizedBox(width: 10),

        ElevatedButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Home")
        ),
      ],
    );
  }
}