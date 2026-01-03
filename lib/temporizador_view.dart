import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 
import '../cronometro_controller.dart';
import 'base_timer_layout.dart';

class TemporizadorView extends StatefulWidget {
  const TemporizadorView({super.key});
  @override
  State<TemporizadorView> createState() => _TemporizadorViewState();
}

class _TemporizadorViewState extends State<TemporizadorView> {
  final controller = CronometroController();
  final AudioPlayer _audioPlayer = AudioPlayer(); 
  double _segundos = 0;

  @override
  void initState() {
    super.initState();
    
    controller.onUpdate = () {
      if (mounted) {
        setState(() {});
      }
    };

    controller.onTimerFinished = () {
      _tocarSom();
    };
  }


  Future<void> _tocarSom() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(
        AssetSource('audio/ring.mp3'),
        volume: 1.0,
      );
    } catch (e) {
      debugPrint('Erro ao tocar áudio: $e');
    }
  }

  @override
  void dispose() {
    controller.onUpdate = null;
    controller.onTimerFinished = null; 
    controller.parar();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTimerLayout(
      titulo: "Temporizador",
      tempoFormatado: controller.tempoFormatado,
      controleAdicional: Column(
        children: [
          Slider(
            value: _segundos,
            min: 0,
            max: 3600,
            divisions: 120, 
            label: "${(_segundos / 60).floor()}m ${(_segundos % 60).toInt()}s",
            onChanged: controller.model.estaRodando 
                ? null 
                : (v) {
                    setState(() { 
                      _segundos = v; 
                      controller.setTempo(Duration(seconds: v.toInt())); 
                    });
                  },
          ),
        ],
      ),
      botoesPrincipais: [
        ElevatedButton(
          onPressed: () => controller.model.estaRodando 
              ? controller.parar() 
              : controller.iniciarTemporizador(),
          child: Text(controller.model.estaRodando ? "Pausar" : "Iniciar"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            controller.resetar();
            setState(() => _segundos = 0);
          }, 
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