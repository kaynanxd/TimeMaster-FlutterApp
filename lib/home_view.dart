import 'package:flutter/material.dart';
import 'cronometro_view.dart';
import 'temporizador_view.dart';
import 'pomodoro_view.dart';
import 'treino_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Time Master",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              
   
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuCard(
                    context,
                    title: "Cronômetro",
                    icon: Icons.timer,
                    color: Colors.blueAccent,
                    destination: const CronometroView(),
                  ),
                  const SizedBox(width: 20),
                  _buildMenuCard(
                    context,
                    title: "Temporizador",
                    icon: Icons.hourglass_top,
                    color: Colors.orangeAccent,
                    destination: const TemporizadorView(),
                  ),
                ],
              ),
              
              const SizedBox(height: 20), 

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMenuCard(
                    context,
                    title: "Pomodoro",
                    icon: Icons.shutter_speed,
                    color: Colors.redAccent,
                    destination: const PomodoroView(),
                  ),
                  const SizedBox(width: 20),
                  _buildMenuCard(
                    context,
                    title: "Treino HIIT",
                    icon: Icons.fitness_center,
                    color: Colors.greenAccent,
                    destination: const TreinoView(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função auxiliar para não repetir código de estilo
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    // Media Query para garantir que o quadrado se ajuste a telas diferentes
    final double size = MediaQuery.of(context).size.width * 0.4; 

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      borderRadius: BorderRadius.circular(25), // Borda arredondada no clique
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}