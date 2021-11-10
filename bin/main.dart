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

  // Init Args
  listOpt['folder'] = Directory.current.path;
  listOpt['min'] = '1';
  listOpt['max'] = '99999';
  parser = initArgs(listOpt);
  valueArgs = parser.parse(args);

  // Show Args
  print(
      '[Args]\n - folder: ${valueArgs['folder']}\n - Min: ${valueArgs['min']}\n - Max: ${valueArgs['max']}\n\n');
  // Get all file in folder
  final listFile = getListFile(pathFolder: valueArgs['folder']);
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
          int nameNew = randomNum(min: 1, max: 99999);
          String fileNameNew = '${valueArgs["folder"]}\\$nameNew$ext';
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
  exit(-1);
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
  if (pathFolder != '' && Directory(pathFolder).existsSync()) {
    return Directory(pathFolder).listSync().toList();
  }
  return Directory.current.listSync().toList();
}

int randomNum({int min = 1, int max = 100}) {
  return min + Random().nextInt(max - min);
}
