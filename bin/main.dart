import 'dart:io';
import 'dart:math';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  /*
  if (args.isEmpty) {
    print('[Error]: Missing Args!');
    exit(-1);
  }
  */
  Map<String, String> listOpt = <String, String>{};
  ArgParser? parser;
  ArgResults? valueArgs;
  String folderCrr = Directory.current.path;
  String min = "1";
  String max = "999999";

  // Init Args
  listOpt['folder'] = folderCrr;
  listOpt['min'] = min;
  listOpt['max'] = max;
  parser = initArgs(listOpt);
  valueArgs = parser.parse(args);

  // Check Arg
  if (int.parse(valueArgs['min']) < int.parse(valueArgs['max'])) {
    min = valueArgs['min'];
    max = valueArgs['max'];
  }
  folderCrr = valueArgs['folder'].toString();

  // Show Args
  print('[Input Args]\n - folder: $folderCrr\n - Min: $min\n - Max: $max\n');

  // Get all file in folder
  final listFile = getListFile(pathFolder: folderCrr);
  if (listFile.isEmpty) {
    // Error Folder
    print('[Error] Folder not found!');
  } else {
    for (var e in listFile) {
      if (e is File) {
        // Get path file name
        String fileName = e.path;
        // Get extension of file
        String ext = p.extension(fileName);
        while (true) {
          // Check if ext == 'ext' => break
          if (ext == '.exe') break;
          // Create random number
          int nameNew = randomNum(min: int.parse(min), max: int.parse(max));
          String fileNameNew = '$folderCrr\\$nameNew$ext';
          // Check file exist
          if (!File(fileNameNew).existsSync()) {
            final resultFile = File(fileName).renameSync(fileNameNew);
            // Show file name new
            print(resultFile.path);
            break;
          }
        }
      }
    }
  }
}

ArgParser initArgs(Map<String, String> listOpt) {
  var parser = ArgParser();
  if (listOpt.isNotEmpty) {
    listOpt.forEach((key, value) {
      parser.addOption(key, defaultsTo: value, valueHelp: value);
    });
  }
  return parser;
}

List<FileSystemEntity> getListFile({String pathFolder = ''}) {
  return Directory(pathFolder).listSync().toList();
}

int randomNum({int min = 1, int max = 100}) {
  return min + Random().nextInt(max - min);
}
