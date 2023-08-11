// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  return runApp(_ChartApp());
}

class _ChartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_NumeroFib> data = [];
  final _numController = TextEditingController();

  int fibonacci(int n) {
    return n < 2 ? n : (fibonacci(n - 1) + fibonacci(n - 2));
  }

  gerarFibonacci({required int num}) {
    setState(() {
      _isLoading = true;
    });
    for (int i = 0; i <= num; i++) {
      final numFibonacci = _NumeroFib(num: i, numFib: fibonacci(i));
      data.add(numFibonacci);
    }
    setState(() {
      _isLoading = false;
    });
  }

  String numText = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gerador do número de Fibonacci'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: !_isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Initialize the chart widget
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextField(
                              onChanged: (String text) {
                                setState(() {
                                  try {
                                    //  gerarFibonacci(num: int.parse(text));
                                  } catch (e, s) {
                                    print(s);
                                  }
                                  numText = text;
                                });
                              },
                              controller: _numController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText:
                                      "Digite o tamanho da Sequência que deseja (Limite 40):"),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled))
                                    return Colors.grey;
                                  return null; // Defer to the widget's default.
                                }),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled))
                                    return Colors.red;
                                  return null; // Defer to the widget's default.
                                }),
                              ),
                              onPressed: numText.isNotEmpty
                                  ? () {
                                      setState(() {
                                        data.clear();
                                        _numController.clear();
                                        numText = "";
                                      });
                                    }
                                  : null,
                              child: const Text(
                                'Limpar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled))
                                    return Colors.grey;
                                  return null; // Defer to the widget's default.
                                }),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled))
                                    return Colors.red;
                                  return null; // Defer to the widget's default.
                                }),
                              ),
                              onPressed: numText.isNotEmpty
                                  ? () {
                                      setState(() {
                                        gerarFibonacci(
                                            num:
                                                int.parse(_numController.text));
                                      });
                                    }
                                  : null,
                              child: const Text(
                                'Calcular',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                      child: Text(
                    "Fórmula: Num Fib n = (n-2) + (n-1)",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: const Text(
                      "Sequência Numérica: ",
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Text(
                              "${data[index].numFib} - ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          );
                        }),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        // Chart title
                        title: ChartTitle(
                            text:
                                'Gráfico da Sequência do Número de Fibonacci:'),
                        // Enable legend
                        legend: Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ChartSeries<_NumeroFib, int>>[
                          LineSeries<_NumeroFib, int>(
                              dataSource: data,
                              xValueMapper: (_NumeroFib num, _) => num.num,
                              yValueMapper: (_NumeroFib num, _) => num.numFib,
                              name: 'Fibonnaci',
                              // Enable data label
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true))
                        ]),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class _NumeroFib {
  _NumeroFib({required this.num, required this.numFib});

  int num;
  int numFib;
}
