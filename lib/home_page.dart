import 'package:flutter/material.dart';

// Olympic Boxing Scoring App
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Boxer> _boxerList = [
    Boxer(
      displayName: 'HARRINGTON Kellie Anne',
      team: 'IRELAND',
      flag: 'assets/images/flag_ireland.png',
      corner: Corner.red,
    ),
    Boxer(
      displayName: 'SEESONDEE Sudaporn',
      team: 'THAILAND',
      flag: 'assets/images/flag_thailand.png',
      corner: Corner.blue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OLYMPIC BOXING SCORING'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', height: 45.0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Women\'s Light (57-60kg) Semi-final',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            _buildBoxerRow(_boxerList[0]),
            _buildBoxerRow(_boxerList[1]),
            SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                    child:
                    Container(color: Color(0xFFA00000), height: 6.0)),
                Expanded(
                    child:
                    Container(color: Color(0xFF0000A0), height: 6.0)),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < _boxerList[0].scoreList.length; i++)
                      _buildScoreRow(
                        'ROUND ${i + 1}',
                        _boxerList[0].scoreList[i],
                        _boxerList[1].scoreList[i],
                      ),
                    if (_boxerList[0].scoreList.length == 3)
                      _buildScoreRow(
                        'TOTAL',
                        _boxerList[0].totalScores,
                        _boxerList[1].totalScores,
                      ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                if (_boxerList[0].scoreList.length < 3)
                  _buildButton(Corner.red),
                if (_boxerList[0].scoreList.length < 3)
                  _buildButton(Corner.blue),
                if (_boxerList[0].scoreList.length == 3) _buildButton(null),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String title, int scoreRed, int scoreBlue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 12.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  scoreRed.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
              Expanded(
                child: Text(
                  scoreBlue.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(Corner? corner) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () {
            var redCorner = _boxerList[0];
            var blueCorner = _boxerList[1];

            if (corner == null) {
              setState(() {
                redCorner.scoreList.clear();
                redCorner.win = false;
                blueCorner.scoreList.clear();
                blueCorner.win = false;
              });
            } else {
              setState(() {
                redCorner.scoreList.add(corner == Corner.red ? 10 : 9);
                blueCorner.scoreList.add(corner == Corner.red ? 9 : 10);

                if (redCorner.scoreList.length == 3) {
                  if (redCorner.totalScores > blueCorner.totalScores) {
                    redCorner.win = true;
                  } else {
                    blueCorner.win = true;
                  }
                }
              });
            }
          },
          style: ElevatedButton.styleFrom(
            primary: corner == null
                ? Color(0xFF000000)
                : (corner == Corner.red
                ? Color(0xFFA00000)
                : Color(0xFF0000A0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(corner == null ? Icons.clear : Icons.person,
                color: Colors.white, size: 30.0),
          ),
        ),
      ),
    );
  }

  Widget _buildBoxerRow(Boxer boxer) {
    return Row(
      children: [
        Icon(
          Icons.person,
          color: boxer.corner == Corner.red
              ? Color(0xFFA00000)
              : Color(0xFF0000A0),
          size: 70.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(boxer.flag, height: 24.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(boxer.team, style: TextStyle(fontSize: 20.0)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child:
                Text(boxer.displayName, style: TextStyle(fontSize: 16.0)),
              )
            ],
          ),
        ),
        if (boxer.win) Icon(Icons.check, size: 40.0, color: Colors.green),
      ],
    );
  }
}

enum Corner { red, blue }

class Boxer {
  final String displayName;
  final String team;
  final String flag;
  final Corner corner;
  bool win = false;
  final List<int> scoreList = [];

  int get totalScores =>
      scoreList.fold(0, (previousValue, element) => previousValue + element);

  Boxer({
    required this.displayName,
    required this.team,
    required this.flag,
    required this.corner,
  });
}