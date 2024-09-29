import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(SpinTheBottleApp());

class SpinTheBottleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottleSpinScreen(),
    );
  }
}

class BottleSpinScreen extends StatefulWidget {
  @override
   createState() => _BottleSpinScreenState();
}

class _BottleSpinScreenState extends State<BottleSpinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Random random = Random();
  String selectedPlayer = '';
  String selectedChallenge = '';
  bool showPopup = false;
  int selectedBottleIndex = -1;

  final List<String> players = [
    'Maryam', 'Zainab', 'Laiba', 'Khadijah', 'Hadia',
    'Hania', 'Hajra', 'Amna', 'Fatima', 'Faiza'
  ];

  final List<String> challenges = [
    'Sing a song',
    'Dance for 30 seconds',
    'Tell a joke',
    'Do 10 push-ups',
    'Imitate a famous person',
    'Share an embarrassing story',
    'Recite a tongue twister',
    'Act like an animal',
    'Describe your dream vacation',
    'Compliment everyone in the room'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        int randomPlayerIndex = random.nextInt(players.length);
        int randomChallengeIndex = random.nextInt(challenges.length);
        setState(() {
          selectedPlayer = players[randomPlayerIndex];
          selectedChallenge = challenges[randomChallengeIndex];
          showPopup = true;
        });

        // Popup remains visible for 30 seconds or until dismissed
        Future.delayed(Duration(seconds: 30), () {
          if (mounted) {
            setState(() {
              showPopup = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spinBottle(int bottleIndex) {
    setState(() {
      selectedBottleIndex = bottleIndex;  // Mark which bottle to spin
      _controller.forward(from: 0);  // Start spinning
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spin the Bottle Game'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row of 2 bottles at the top
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildBottle(0),
                  buildBottle(1),
                ],
              ),
              SizedBox(height: 20),
              // Row of 2 bottles at the bottom
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildBottle(2),
                  buildBottle(3),
                ],
              ),
            ],
          ),
          // Animated pop-up for the selected player and challenge
          if (showPopup)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "It's ${selectedPlayer}'s turn!",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Challenge: $selectedChallenge',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showPopup = false;
                        });
                      },
                      child: Text('OK'),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Function to build a clickable bottle widget
  Widget buildBottle(int bottleIndex) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => spinBottle(bottleIndex),  // Spin only the clicked bottle
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: selectedBottleIndex == bottleIndex
                    ? _animation.value
                    : 0,  // Rotate only the clicked bottle
                child: Image.asset(
                  'assets/images/bottle${bottleIndex + 1}.png',
                  width: 120,  // Increased bottle size
                  height: 120,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () => spinBottle(bottleIndex),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: Text(
            'Spin Out',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
