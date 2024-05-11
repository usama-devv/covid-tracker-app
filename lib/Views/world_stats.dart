import 'package:covid_tracker/Model/world_stats_model.dart';
import 'package:covid_tracker/Services/stats_services.dart';
import 'package:covid_tracker/Views/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class WorldStatsScreen extends StatefulWidget {
  const WorldStatsScreen({super.key});

  @override
  State<WorldStatsScreen> createState() => _WorldStatsScreenState();
}

class _WorldStatsScreenState extends State<WorldStatsScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                FutureBuilder(
                    future: statsServices.fetchWorldStatsRecords(),
                    builder:
                        (context, AsyncSnapshot<WorldStatsModel> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                          flex: 1,
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50,
                            controller: _controller,
                          ),
                        );
                      }else {
                        return Column(
                          children: [
                            PieChart(
                              dataMap: {
                                "Total": double.parse(
                                    snapshot.data!.cases!.toString()),
                                "Recovered": double.parse(
                                    snapshot.data!.recovered!.toString()),
                                "Deaths": double.parse(
                                    snapshot.data!.deaths!.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              chartRadius:
                                  MediaQuery.of(context).size.width / 3.2,
                              legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left,
                              ),
                              animationDuration:
                                  const Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: colorList,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.06),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReusableRow(
                                      title: 'Total Cases',
                                      value: snapshot.data!.cases.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Total Deaths',
                                      value: snapshot.data!.deaths.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Total Recovered',
                                      value:
                                          snapshot.data!.recovered.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Active Cases',
                                      value: snapshot.data!.active.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Critical Cases',
                                      value: snapshot.data!.critical.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Today Cases',
                                      value:
                                          snapshot.data!.todayCases.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Today Deaths',
                                      value:
                                          snapshot.data!.todayDeaths.toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Today Recovered',
                                      value: snapshot.data!.todayRecovered
                                          .toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Active Per One Million',
                                      value: snapshot.data!.activePerOneMillion
                                          .toString(),
                                    ),
                                    ReusableRow(
                                      title: 'Affected Countries',
                                      value: snapshot.data!.affectedCountries
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> const CountriesList()));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('Track Countries'),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10.0, top: 10.0, right: 10.0, bottom: 5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider()
        ],
      ),
    );
  }
}
