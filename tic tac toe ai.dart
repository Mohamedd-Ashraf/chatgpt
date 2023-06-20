 Widget getSmallBoard(int parent) {
    if (!completeBlock[parent] || ultimateParentBoard[parent] == '') {
      return GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _tapped(parent, 0);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][0].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 1);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][1].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 2);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][2].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 3);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][3].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 4);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][4].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 5);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][5].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 6);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][6].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 7);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][7].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _tapped(parent, 8);
              },
              child: Container(
                color: !availableBlock[parent]
                    ? Color(0xFFB388FF)
                    : Colors.grey[300],
                margin: availableBlock[parent]
                    ? EdgeInsets.all(1.0)
                    : EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    boards[parent][8].toString(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontFamily: 'Redressed',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ]);
    } else {
      return Center(
        child: Text(
          ultimateParentBoard[parent],
          style: TextStyle(
            fontSize: 100.0,
            fontFamily: 'Redressed',
          ),
        ),
      );
    }
  }
