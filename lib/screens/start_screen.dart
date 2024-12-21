import 'package:flutter/material.dart';
import 'package:coffee_shop_app/screens/coffee_dashboard.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade800, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 78, 78, 78).withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1),
                child: Image.asset(
                  'assets/product/logo.jpg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Fall in Love with Coffee\nat NAKAMA!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Welcome to our cozy NAKAMA, where every\ncup is a delightful experience for you.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(104, 2, 2, 2),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Get Started Button
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: ElevatedButton(
                onPressed: () {
                  // Directly navigate to the next screen (ProductStockScreen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoffeeDashboard(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 15),
                  backgroundColor: _isHovering
                      ? const Color.fromARGB(255, 63, 105, 255)
                      : const Color.fromARGB(
                          209, 54, 139, 209),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: _isHovering
                      ? Colors.blue.withOpacity(0.6)
                      : Colors.transparent,
                  elevation: _isHovering ? 10 : 5,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
