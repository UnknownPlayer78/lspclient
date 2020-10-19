import 'package:lspclient/models/lsp/workDoneProgressOptions.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

class ExecuteCommandOptions extends WorkDoneProgressOptions {
  /// The commands to be executed on the server
  List<String> commands;
  ExecuteCommandOptions({
    this.commands,
  });

  ExecuteCommandOptions copyWith({
    List<String> commands,
  }) {
    return ExecuteCommandOptions(
      commands: commands ?? this.commands,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commands': commands,
    };
  }

  factory ExecuteCommandOptions.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ExecuteCommandOptions(
      commands: List<String>.from(map['commands']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExecuteCommandOptions.fromJson(String source) =>
      ExecuteCommandOptions.fromMap(json.decode(source));

  @override
  String toString() => 'ExecuteCommandOptions(commands: $commands)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return o is ExecuteCommandOptions && listEquals(o.commands, commands);
  }

  @override
  int get hashCode => commands.hashCode;
}
