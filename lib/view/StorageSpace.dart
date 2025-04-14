// import 'dart:io';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:disk_space_plus/disk_space_plus.dart';
// import 'package:system_info_plus/system_info_plus.dart';
//
// class StorageInfoScreen extends StatefulWidget {
//   @override
//   _StorageInfoScreenState createState() => _StorageInfoScreenState();
// }
//
// class _StorageInfoScreenState extends State<StorageInfoScreen> {
//   int totalSpace = 0;
//   int freeSpace = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _getStorageInfo();
//   }
//
//
//
//
//
//   Future<void> _getStorageInfo() async {
//     try {
//       int total = SysInfoPlus().getTotalPhysicalMemory();
//       int free = SysInfoPlus().getFreePhysicalMemory();
//
//       setState(() {
//         totalSpace = total;
//         freeSpace = free;
//       });
//     } catch (e) {
//       print("Error getting storage info: $e");
//     }
//   }
//
//
//
//   Future<Map<String, int>> _getStatFs(String path) async {
//     try {
//       var statFs = await FileStat.stat(path);
//       var total = statFs.size;
//       var free = await _getFreeSpace(path);
//       return {'total': total, 'free': free};
//     } catch (e) {
//       print("Error getting statFs: $e");
//       return {'total': 0, 'free': 0};
//     }
//   }
//
//   Future<int> _getFreeSpace(String path) async {
//     try {
//       var directory = Directory(path);
//       var freeSpace = directory.statSync().size;
//       return freeSpace;
//     } catch (e) {
//       print("Error getting free space: $e");
//       return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Total Storage: ${_formatBytes(totalSpace)}", style: TextStyle(fontSize: 18)),
//           SizedBox(height: 10),
//           Text("Free Storage: ${_formatBytes(freeSpace)}", style: TextStyle(fontSize: 18)),
//         ],
//       ),
//     );
//   }
//
//   String _formatBytes(int bytes, {int decimals = 2}) {
//     if (bytes <= 0) return "0 B";
//     const suffixes = ["B", "KB", "MB", "GB", "TB"];
//     int i = (math.log(bytes) / math.log(1024)).floor();
//     return "${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}";
//   }
// }
