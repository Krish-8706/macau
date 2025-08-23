import 'package:hive/hive.dart';

part 'call_log.g.dart';

@HiveType(typeId: 0)
class CallLog extends HiveObject {
  @HiveField(0)
  final String caller;

  @HiveField(1)
  final DateTime timeStamp;

  CallLog({
    required this.caller,
    required this.timeStamp,
  });
}
