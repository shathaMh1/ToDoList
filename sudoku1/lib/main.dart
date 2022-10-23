import 'package:flutter/material.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sudoku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Sudoku"),
            centerTitle: true,
          ),
          body: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List displaygrid = List.generate(81, (i) => 0);
  List displaygridSolved = List.generate(81, (i) => 0);
  String resault = 'Good Luck!';

  List<List<int>> newsudoku = [];
  List<List<int>> solvedsudoku = [];
  sudokuGen() {
    setState(() {
      resault = 'Good Luck';
    });
    var sudokuGenerator = SudokuGenerator(emptySquares: 1);
    SudokuUtilities.printSudoku(sudokuGenerator.newSudoku);

    newsudoku = sudokuGenerator.newSudoku;
    var index = 0;
    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        displaygrid[index] = newsudoku[i][j];
        index++;
      }
    }

    SudokuUtilities.printSudoku(sudokuGenerator.newSudokuSolved);
    solvedsudoku = sudokuGenerator.newSudokuSolved;
    var index1 = 0;

    for (var i = 0; i < 9; i++) {
      for (var j = 0; j < 9; j++) {
        displaygridSolved[index1] = solvedsudoku[i][j];
        index1++;
      }
    }
  }

  isGridSolved() {
    if (displaygrid.join() == displaygridSolved.join()) {
      setState(() {
        resault = 'Congratulations';
      });
    } else {
      setState(() {
        resault = 'Try Again';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              itemCount: 81,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                displaygrid[index] = value;
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {
                                displaygrid[index] = value;
                              });
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('ok'),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${displaygrid[index]}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sudokuGen();
                    });
                  },
                  child: const Text('New Game'),
                ),
              ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    isGridSolved();
                  },
                  child: const Text('Check'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              resault,
              style: Theme.of(context).textTheme.headline4,
            ),
          )
        ],
      ),
    );
  }
}
