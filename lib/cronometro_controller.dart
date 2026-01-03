import 'dart:async';
import '../cronometro_model.dart';

class CronometroController {
  final model = CronometroModel();
  Timer? _timer;
  void Function()? onUpdate;
  

  void Function()? onTimerFinished; 

  void iniciarCronometro() {
    model.estaRodando = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      model.duracao += const Duration(seconds: 1);
      onUpdate?.call();
    });
  }

  void iniciarTemporizador() {
    model.estaRodando = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (model.duracao.inSeconds > 0) {
        model.duracao -= const Duration(seconds: 1);
        onUpdate?.call();
      } else {
        parar();

        onTimerFinished?.call(); 
      }
    });
  }

  void adicionar30Segundos() {
    model.duracao += const Duration(seconds: 30);
    onUpdate?.call();
  }

  void parar() {
    model.estaRodando = false;
    _timer?.cancel();
    _timer = null;
    onUpdate?.call();
  }

  void resetar() {
    parar();
    model.duracao = Duration.zero;
    onUpdate?.call();
  }

  void setTempo(Duration novaDuracao) {
    model.duracao = novaDuracao;
    onUpdate?.call();
  }

  String get tempoFormatado {
    String doisDigitos(int n) => n.toString().padLeft(2, '0');
    final h = doisDigitos(model.duracao.inHours);
    final m = doisDigitos(model.duracao.inMinutes.remainder(60));
    final s = doisDigitos(model.duracao.inSeconds.remainder(60));
    return "$h:$m:$s";
  }
}