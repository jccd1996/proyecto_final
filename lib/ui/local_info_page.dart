import 'dart:convert';

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:proyectofinal/models/country.dart';
import 'package:proyectofinal/models/summary_response.dart';
import 'package:http/http.dart' as http;

class LocalInfoPage extends StatefulWidget {
  @override
  _LocalInfoPageState createState() => _LocalInfoPageState();
}

class _LocalInfoPageState extends State<LocalInfoPage> {
  Future<SummaryResponse> summaryResponse;

  @override
  void initState() {
    super.initState();
    summaryResponse = getSummaryData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0)
                      .copyWith(top: 8.0),
                  child: Image.asset('assets/logo_sofka.png'),
                ),
                RichText(
                  text: TextSpan(
                    text: '#',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontSize: 30.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'MeQuedoEnCasa',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: <Widget>[
                  Text('Covid-19 en Colombia'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CircleAvatar(
                      radius: 50.0,
                      child: ClipOval(
                        child: Flag(
                          'CO',
                          height: 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  FutureBuilder<SummaryResponse>(
                      future: summaryResponse,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: _InfoWidgets(
                                  title: 'Confirmados totales',
                                  data: getColombiaData(snapshot.data.countries)
                                      .totalConfirmed
                                      .toString(),
                                  color: Colors.red,
                                ),
                              ),
                              Expanded(
                                child: _InfoWidgets(
                                  title: 'Bajas totales',
                                  data: getColombiaData(snapshot.data.countries)
                                      .totalDeaths
                                      .toString(),
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: _InfoWidgets(
                                  title: 'Recuperados totales',
                                  data: getColombiaData(snapshot.data.countries)
                                      .totalRecovered
                                      .toString(),
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('error');
                        } else {
                          return CircularProgressIndicator();
                        }
                      })
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<SummaryResponse> getSummaryData() async {
    return await Future.delayed(Duration(seconds: 10), () async {
      final response = await http.get('https://api.covid19api.com/summary');
      if (response.statusCode == 200) {
        var summaryResponse =
            SummaryResponse.fromJson(json.decode(response.body));

        print(summaryResponse?.global?.totalDeaths ?? 0);
        return summaryResponse;
      } else {
        throw Exception('Fallo al cargada la data');
      }
    });
  }

  Country getColombiaData(List<Country> countries) {
    return countries.firstWhere((country) => country.slug == 'colombia');
  }
}

class _InfoWidgets extends StatelessWidget {
  final String title;
  final String data;
  final Color color;

  _InfoWidgets({
    this.title,
    this.data,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        Text(
          data,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}
