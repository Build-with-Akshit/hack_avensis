import 'package:flutter/material.dart';
import 'package:hack_avensis/core/constants/app_colors.dart';
import 'package:hack_avensis/core/services/location_service.dart';

class SosActivationScreen extends StatefulWidget {
  const SosActivationScreen({super.key});

  @override
  State<SosActivationScreen> createState() => _SosActivationScreenState();
}

class _SosActivationScreenState extends State<SosActivationScreen> {
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 5; i > 0; i--) {
      if (!mounted) return;
      setState(() => _countdown = i);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted) {
      _triggerSos();
    }
  }

  void _triggerSos() async {
    try {
      // Get location
      final position = await LocationService().getCurrentLocation();
      final locationStr = "${position.latitude}, ${position.longitude}";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "SOS ALERT SENT!\nLocation: $locationStr\nNotifications dispatched.",
            ),
            duration: const Duration(seconds: 5),
            backgroundColor: AppColors.error,
          ),
        );
      }
      // In a real app, this would stay on screen or go to a live tracking mode
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("SOS Sent (Location Error: $e)")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.error,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              "SENDING SOS",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Alerting nearby community and contacts...",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 48),
            if (_countdown > 0)
              Text(
                "$_countdown",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                ),
              )
            else
              const Text(
                "SENT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
            const SizedBox(height: 48),
            if (_countdown > 0)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text("CANCEL"),
              )
            else
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text("I AM SAFE NOW"),
              ),
          ],
        ),
      ),
    );
  }
}
