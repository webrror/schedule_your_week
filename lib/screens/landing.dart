import 'package:flutter/material.dart';
import 'package:scheduler/services/pref_services.dart';
import 'package:scheduler/utils/constants.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _prefServices = PrefServices();
  var schedule = {};

  @override
  void initState() {
    getDays();
    super.initState();
  }

  void getDays() async {
    var weeklySchedule = await _prefServices.getSchedulePref();

    setState(() {
      schedule = weeklySchedule;
    });
  }

  void goToScheduler() async {
    final reload = await Navigator.pushNamed(context, 'scheduler');
    if (reload != null && reload == true) {
      getDays();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data filter
    var typedMap = schedule.map((key, value) => MapEntry(key, value));
    var displayData = [];
    typedMap.forEach((key, value) {
      if (value.isNotEmpty) {
        displayData.add([key, value]);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your schedule for the week'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          children: [
            // Text Container to display schedule
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Card(
                    child: Center(
                  child: displayData.isEmpty
                      ? Text('$greeting, you are busy this week.',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
                      : Text.rich(
                        // Data formatting
                          TextSpan(children: [
                            TextSpan(text: greeting),
                            TextSpan(text: availability),
                            for (int i = 0; i < displayData.length; i++)
                              WidgetSpan(
                                  child: Text.rich(
                                TextSpan(children: [
                                  if (i == displayData.length - 1 &&
                                      displayData.length != 1)
                                    const TextSpan(text: ' and '),
                                  TextSpan(text: displayData[i][0].toString()),
                                  displayData[i][1].length == 3
                                      ? const TextSpan(text: ' whole day ')
                                      : TextSpan(
                                          text: displayData[i][1]
                                              .toString()
                                              .replaceAll('[', ' ')
                                              .replaceAll(']', '')
                                              .replaceAll(",", "")),
                                  if (i != displayData.length - 1 && i != displayData.length - 1)
                                    const TextSpan(text: ',')
                                ]),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ))
                            // TextSpan(text: displayData[i][0].toString()),
                          ]),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // Button to add/edit schedule
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                onPressed: () {
                  goToScheduler();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: schedule.isEmpty
                    ? const Text('Add Schedule')
                    : const Text('Edit Schedule'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
