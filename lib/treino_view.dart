import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; 
import '../cronometro_controller.dart';
import 'base_timer_layout.dart';

class TreinoView extends StatefulWidget {
  const TreinoView({super.key});

  @override
  State<TreinoView> createState() => _TreinoViewState();
}

class _TreinoViewState extends State<TreinoView> {
  final controller = CronometroController();
  final AudioPlayer _audioPlayer = AudioPlayer(); 

  double _tempoAcao = 30;    
  double _tempoDescanso = 10; 
  double _totalSeries = 5;    
  
  int _serieAtual = 1;
  bool _estaEmAcao = true; 
  bool _treinoConcluido = false; 

  @override
  void initState() {
    super.initState();
    
    controller.onUpdate = () {
      if (mounted) setState(() {});
    };

    controller.onTimerFinished = () {
      _proximoPassoHIIT();
    };

    controller.setTempo(Duration(seconds: _tempoAcao.toInt()));
  }


  Future<void> _tocarSom() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/ring.mp3'), volume: 1.0);
    } catch (e) {
      debugPrint('Erro ao tocar áudio no Treino: $e');
    }
  }

  void _proximoPassoHIIT() {
    if (!mounted || _treinoConcluido) return;

    _tocarSom(); 

    setState(() {
      if (_estaEmAcao) {
        _estaEmAcao = false;
        controller.setTempo(Duration(seconds: _tempoDescanso.toInt()));
      } else {

        if (_serieAtual < _totalSeries) {
          _serieAtual++;
          _estaEmAcao = true;
          controller.setTempo(Duration(seconds: _tempoAcao.toInt()));
        } else {

          _treinoConcluido = true; 
          controller.parar();
          _mostrarFimTreino();
          return; 
        }
      }
    });

    if (!_treinoConcluido) {
      controller.iniciarTemporizador();
    }
  }

  void _mostrarFimTreino() {

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(" Parabéns! Treino Concluído!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
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
      titulo: "Treino HIIT", 
      tempoFormatado: controller.tempoFormatado,
      controleAdicional: Column(
        children: [

          Text(
            _estaEmAcao ? "AÇÃO 🔥" : "DESCANSO ❄️",
            style: TextStyle(
              color: _estaEmAcao ? Colors.orangeAccent : Colors.blueAccent,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            "Série: $_serieAtual / ${_totalSeries.toInt()}",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 30),

          _buildAjusteCard(
            label: "Tempo de Ação",
            valor: _tempoAcao,
            min: 5, max: 120,
            cor: Colors.orangeAccent,
            onChanged: (v) {
              setState(() {
                _tempoAcao = v;
                if (_estaEmAcao) controller.setTempo(Duration(seconds: v.toInt()));
              });
            },
          ),
          _buildAjusteCard(
            label: "Tempo de Descanso",
            valor: _tempoDescanso,
            min: 5, max: 60,
            cor: Colors.blueAccent,
            onChanged: (v) {
              setState(() {
                _tempoDescanso = v;
                if (!_estaEmAcao) controller.setTempo(Duration(seconds: v.toInt()));
              });
            },
          ),
          _buildAjusteCard(
            label: "Número de Séries",
            valor: _totalSeries,
            min: 1, max: 20,
            cor: Colors.greenAccent,
            onChanged: (v) => setState(() => _totalSeries = v),
          ),
        ],
      ),
      botoesPrincipais: [
        ElevatedButton(
          onPressed: () {

            if (_treinoConcluido) {
              setState(() {
                _treinoConcluido = false;
                _serieAtual = 1;
                _estaEmAcao = true;
                controller.setTempo(Duration(seconds: _tempoAcao.toInt()));
              });
            }
            controller.model.estaRodando 
                ? controller.parar() 
                : controller.iniciarTemporizador();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _estaEmAcao ? Colors.orange : Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: Text(
            controller.model.estaRodando ? "Pausar" : "Iniciar Treino",
            style: const TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(width: 15),
        ElevatedButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text("Home"),
        ),
      ],
    );
  }

  Widget _buildAjusteCard({
    required String label,
    required double valor,
    required double min,
    required double max,
    required Color cor,
    required Function(double) onChanged,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: cor, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(label.contains("Séries") ? "${valor.toInt()}" : "${valor.toInt()}s", 
                   style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Slider(
          value: valor,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: cor,
          onChanged: controller.model.estaRodando ? null : onChanged,
        ),
      ],
    );
  }
}