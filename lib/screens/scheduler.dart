import 'package:flutter/material.dart';
import 'package:parent_child_checkbox/parent_child_checkbox.dart';
import 'package:scheduler/model/schedule.dart';
import 'package:scheduler/services/pref_services.dart';
import 'package:scheduler/utils/constants.dart';

class Scheduler extends StatefulWidget {
  const Scheduler({super.key});

  @override
  State<Scheduler> createState() => _SchedulerState();
}

class _SchedulerState extends State<Scheduler> {
  final _prefServices = PrefServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set your weekly hours'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display the Week
            ListView.separated(
              itemCount: weekDays.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20),
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 1,
                  color: Colors.deepPurple[100],
                );
              },
              itemBuilder: (context, index) {
                // Grouped checkboxes
                /*
                     day (parent)
                      |
                      -> morning | afternoon | evening (children)
                     
                */
                // if parent check box selected, then children selectable containers showed
                return ParentChildCheckbox(
                  parentCheckboxColor: Colors.green,
                  childrenCheckboxColor: Colors.deepPurple,
                  parent: Text(
                    weekDays[index].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: const [
                    Text('Morning'),
                    Text('Afternoon'),
                    Text('Evening'),
                  ],
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            // Save Button
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.width * 0.12,
                child: ElevatedButton(
                  onPressed: () {
                    saveSchedule();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40))),
                  child: const Text("Save"),
                )),
          ],
        ),
      ),
    );
  }

  // Method called on pressing Save button
  void saveSchedule() async {
    final schedulePref =
        WeeklySchedule(schedule: ParentChildCheckbox.selectedChildrens);

    // if saving was success, return to landing page (also refresh landing page) 
    if (await _prefServices.saveSchedulePref(schedulePref)) {
      Navigator.pop(context, true);
    }
  }
}
