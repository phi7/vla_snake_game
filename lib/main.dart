import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int squaresPerRow = 10;
  final int squaresPerCol = 20;
  final fontStyle = TextStyle(color: Colors.white, fontSize: 20);
  final randomGen = Random();
  var blockImg;

  var snake = [
    [0, 1],
    [0, 0]
  ];
  var food = [0, 2];
  var direction = 'up';
  var isPlaying = false;
  // var preX;
  // var preY;
  var prePos = [];

  void startGame() {
    const duration = Duration(milliseconds: 300);

    snake = [ // Snake head
      [(squaresPerRow / 2).floor(), (squaresPerCol / 2).floor()]
    ];

    snake.add([snake.first[0], snake.first[1]+1]); // Snake body

    createFood();

    isPlaying = true;
    Timer.periodic(duration, (Timer timer) {
      moveSnake();
      if (checkGameOver()) {
        timer.cancel();
        endGame();
      }
    });
  }

  void moveSnake() {
    setState(() {
      switch(direction) {
        case 'up':
          snake.insert(0, [snake.first[0], snake.first[1] - 1]);
          break;

        case 'down':
          snake.insert(0, [snake.first[0], snake.first[1] + 1]);
          break;

        case 'left':
          snake.insert(0, [snake.first[0] - 1, snake.first[1]]);
          break;

        case 'right':
          snake.insert(0, [snake.first[0] + 1, snake.first[1]]);
          break;
      }

      if (snake.first[0] != food[0] || snake.first[1] != food[1]) {
        snake.removeLast();
      } else {
        createFood();
      }
    });
  }

  void createFood() {
    food = [
      randomGen.nextInt(squaresPerRow),
      randomGen.nextInt(squaresPerCol)
    ];
  }

  bool checkGameOver() {
    if (!isPlaying
        || snake.first[1] < 0
        || snake.first[1] >= squaresPerCol
        || snake.first[0] < 0
        || snake.first[0] > squaresPerRow
    ) {
      return true;
    }

    for(var i=1; i < snake.length; ++i) {
      if (snake[i][0] == snake.first[0] && snake[i][1] == snake.first[1]) {
        return true;
      }
    }

    return false;
  }

  void endGame() {
    isPlaying = false;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Game Over'),
            content: Text(
              'Score: ${snake.length - 2}',
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            //???????????????????????????????????????????????????????????????????????????
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: AspectRatio(
                aspectRatio: squaresPerRow / (squaresPerCol + 5),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: squaresPerRow,
                    ),
                    itemCount: squaresPerRow * squaresPerCol,
                    itemBuilder: (BuildContext context, int index) {
                      // var color;
                      var x = index % squaresPerRow;
                      var y = (index / squaresPerRow).floor();

                      bool isSnakeBody = false;
                      for (var pos in snake) {
                        if (pos[0] == x && pos[1] == y) {
                          isSnakeBody = true;
                          break;
                        }
                      }
                      // for (var pos in snake) {
                      //   if (pos[0] == x && pos[1] == y) {
                      //     break;
                      //   }
                      //   prePos = pos;
                      // }


                      if (snake.first[0] == x && snake.first[1] == y) {
                        // color = Colors.green;
                        if(direction=='up'){
                          blockImg = 'images/vla_tiger_head_up.png';
                        }else if(direction=='right'){
                          blockImg = 'images/vla_tiger_head_right.png';
                        }else if(direction=='left'){
                          blockImg = 'images/vla_tiger_head_left.png';
                        }else if(direction=='down'){
                          blockImg = 'images/vla_tiger_head_down.png';
                        }
                        // blockImg = 'images/vla_tiger_head_up.png';
                        // preX = x;
                        // preY = y;
                      } else if (isSnakeBody) {
                        // color = Colors.green[200];
                        // if(direction=='up'&&prePos[0]==x){
                        //   blockImg = 'images/vla_tiger_body_up.png';
                        // }else if(direction=='right'&&prePos[1]==y){
                        //   blockImg = 'images/vla_tiger_body_right.png';
                        // }else if(direction=='left'&&prePos[1]==y){
                        //   blockImg = 'images/vla_tiger_body_left.png';
                        // }else if(direction=='down'&&prePos[0]==x){
                        //   blockImg = 'images/vla_tiger_body_down.png';
                        // }
                        if(direction=='up'){
                          blockImg = 'images/vla_tiger_body_up.png';
                        }else if(direction=='right'){
                          blockImg = 'images/vla_tiger_body_right.png';
                        }else if(direction=='left'){
                          blockImg = 'images/vla_tiger_body_left.png';
                        }else if(direction=='down'){
                          blockImg = 'images/vla_tiger_body_down.png';
                        }
                        // preX = x;
                        // preY = y;
                        // blockImg = 'images/vla_tiger_body_up.png';
                      } else if (food[0] == x && food[1] == y) {
                        // color = Colors.red;
                        blockImg = 'images/vla_chikuwa.jpeg';
                      } else {
                        // color = Colors.grey[800];
                        blockImg = 'images/gray_square.jpeg';
                      }

                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(blockImg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // margin: EdgeInsets.all(1),
                        // child: Image.asset(blockImg),
                        // decoration: BoxDecoration(
                        //   color: color,
                        //   // shape: BoxShape.,
                        // ),
                      );
                    }),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      color: isPlaying ? Colors.red : Colors.blue,
                      child: Text(
                        isPlaying ? 'End' : 'Start',
                        style: fontStyle,
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          isPlaying = false;
                        } else {
                          startGame();
                        }
                      }),
                  Text(
                    'Score: ${snake.length - 2}',
                    style: fontStyle,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}