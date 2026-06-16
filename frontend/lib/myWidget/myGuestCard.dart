import 'package:flutter/material.dart';

class Myguestcard extends StatefulWidget {
  final String t1;
  final String t2;
  final String t3;
  final IconData I1;

  const Myguestcard({
    super.key,
    required this.t1,
    required this.t2,
    required this.t3,
    required this.I1,
  });

  @override
  State<Myguestcard> createState() => _MyguestcardState();
}

class _MyguestcardState extends State<Myguestcard> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          scale = 1.08;
        });
      },

      onTapUp: (_) {
        setState(() {
          scale = 1.0;
        });
      },

      onTapCancel: () {
        setState(() {
          scale = 1.0;
        });
      },

      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,

        child: SizedBox(
          width: 170,
          height: 190,

          child: Card(
            shadowColor: const Color.fromARGB(255, 174, 169, 169),

            elevation: scale == 1.08 ? 15 : 10,

            color: const Color.fromARGB(255, 40, 39, 39),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            child: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 20,
                bottom: 12,
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Text(
                    widget.t1,
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Icon(widget.I1, color: Colors.white, size: 50),

                  Text(
                    widget.t2,
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),

                  Text(
                    widget.t3,
                    textAlign: TextAlign.center,

                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
