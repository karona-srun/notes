import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chart_plus/flutter_chart.dart';

class DisplayChart extends StatefulWidget {
  final VoidCallback refresh;
  final List<Map<String, dynamic>> myDataList;
  const DisplayChart(
      {super.key, required this.myDataList, required this.refresh});

  @override
  State<DisplayChart> createState() => _DisplayChartState();
}

class _DisplayChartState extends State<DisplayChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    Intl.defaultLocale = 'en';
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animationController.addStatusListener((status) {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool refreshSecondScreen = false;
  void refresh() {
    setState(() {
      refreshSecondScreen = !refreshSecondScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 5),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.myDataList.isEmpty
                    ? SizedBox(
                        height: 250,
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 70),
                              child: Center(
                                  child: Image.asset(
                                      "assets/images/icon/loading.gif")),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 40),
                              child: const Text(
                                'កំពុងទាញទិន្នន័យ....',
                                style: TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Hanuman'),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 250,
                        child: ChartWidget(
                          coordinateRender: ChartCircularCoordinateRender(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 25),
                            charts: [
                              Pie(
                                guideLine: true,
                                spaceWidth: 0.9,
                                direction: RotateDirection.reverse,
                                startAngle: 180,
                                data: widget.myDataList,
                                position: (item) =>
                                    (double.parse(item['value'].toString())),
                                holeRadius: 50,
                                valueTextOffset: 20,
                                legendFormatter: (item) {
                                  return (item['time']);
                                },
                                legendTextStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Hanuman',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                centerTextStyle: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Hanuman',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                valueFormatter: (item) => "\$${item['value']}",
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
