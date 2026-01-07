import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../cronometro_controller.dart';
import 'base_timer_layout.dart';

class PomodoroView extends StatefulWidget {
  const PomodoroView({super.key});

  @override
  State<PomodoroView> createState() => _PomodoroViewState();
}

class _PomodoroViewState extends State<PomodoroView> {
  final controller = CronometroController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isFoco = true;
  double _minutosFoco = 25;
  double _minutosPausa = 5;

  @override
  void initState() {
    super.initState();
    controller.onUpdate = () {
      if (mounted) setState(() {});
    };

    controller.onTimerFinished = () {
      _tocarSom();
      trocarModoPomodoro();
    };

    controller.setTempo(Duration(minutes: _minutosFoco.toInt()));
  }

  Future<void> _tocarSom() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/ring.mp3'), volume: 1.0);
    } catch (e) {
      debugPrint('Erro ao tocar áudio: $e');
    }
  }

  void trocarModoPomodoro() {
    if (!mounted) return;
    setState(() {
      isFoco = !isFoco;
      controller.setTempo(
        Duration(minutes: (isFoco ? _minutosFoco : _minutosPausa).toInt()),
      );
    });
    controller.iniciarTemporizador();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    controller.onUpdate = null;
    controller.onTimerFinished = null;
    controller.parar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTimerLayout(
      titulo: "Pomodoro",
      tempoFormatado: controller.tempoFormatado,
      controleAdicional: Column(
        children: [
          Text(
            isFoco ? "FOCO 🔥" : "PAUSA ☕",
            style: TextStyle(
              color: isFoco ? Colors.redAccent : Colors.greenAccent,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Foco: ${_minutosFoco.toInt()}m | Pausa: ${_minutosPausa.toInt()}m",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 5),
          Slider(
            value: _minutosFoco,
            min: 1, max: 60, divisions: 59,
            activeColor: Colors.redAccent,
            onChanged: controller.model.estaRodando ? null : (v) {
              setState(() {
                _minutosFoco = v;
                if (isFoco) controller.setTempo(Duration(minutes: v.toInt()));
              });
            },
          ),
          Slider(
            value: _minutosPausa,
            min: 1, max: 30, divisions: 29,
            activeColor: Colors.greenAccent,
            onChanged: controller.model.estaRodando ? null : (v) {
              setState(() {
                _minutosPausa = v;
                if (!isFoco) controller.setTempo(Duration(minutes: v.toInt()));
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
          style: ElevatedButton.styleFrom(
            backgroundColor: isFoco ? const Color.fromARGB(255, 118, 255, 125) : Colors.lightBlue,
          ),
          child: Text(controller.model.estaRodando ? "Pausar" : "Iniciar"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => controller.adicionar30Segundos(),
          child: const Text("+30s"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => controller.zerar(),
          child: const Text("Reset"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Home"),
        ),
      ],
    );
  }
}