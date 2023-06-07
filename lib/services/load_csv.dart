import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

Future<Map<String, List<String>>> loadCSV() async {
  List<String> name = [], content = [];
  Map<String, List<String>> list = {'name': name, 'content': content};

  final myData = await rootBundle.loadString("assets/etc/metadata.csv");
  var csvList = const CsvToListConverter(textEndDelimiter: ".")
      .convert(myData, eol: "\n");

  for (var entry in csvList) {
    name.add(entry[0].toString().split("|")[0]);
    content.add(entry[0].toString().split("|")[1]);
  }
  return list;
}
