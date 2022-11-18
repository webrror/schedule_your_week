import 'dart:convert';
import 'package:scheduler/model/schedule.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefServices {
  // Method to save the schedule to shared_preferences
  Future<bool> saveSchedulePref(WeeklySchedule weeklySchedule) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final encodedSchedule = jsonEncode(weeklySchedule.schedule);
    if (await sharedPreferences.setString('weekSchedule', encodedSchedule)) {
      return true;
    }
    return false;
  }

  // Method to retrieve the schedule from shared_preferences
  Future getSchedulePref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final weekSchedule = sharedPreferences.getString('weekSchedule');
    var decodedSchedule = jsonDecode(weekSchedule!);

    return decodedSchedule;
  }
}
