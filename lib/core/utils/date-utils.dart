
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getISODate(DateTime date){
  return '${date.toIso8601String().substring(0,23)}Z';
}
String getCurrentISODate(){
  return getISODate(DateTime.now());
}
String formatTimeOfDay(TimeOfDay timeOfDay) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final format = DateFormat.jm();  //"6:00 AM"
  return format.format(dt);
}