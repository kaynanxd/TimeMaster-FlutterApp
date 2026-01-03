class CronometroModel {
  Duration duracao;
  bool estaRodando;

  CronometroModel({
    this.duracao = const Duration(),
    this.estaRodando = false,
  });
}