
String getISODate(DateTime date){
  return '${date.toIso8601String().substring(0,23)}Z';
}
String getCurrentISODate(){
  return getISODate(DateTime.now());
}