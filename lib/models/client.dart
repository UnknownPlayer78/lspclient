import 'dart:async';
import 'dart:io';
import 'package:lspclient/models/lsp/serverCapabilities.dart';
import 'package:lspclient/models/message.dart';
import 'dart:math';
import 'dart:convert';

class LspClient {
  String inputType = 'std';
  String command;
  List<String> args;
  int processId = pid;
  String logLevel;
  Process currentProcess;

  LspClient(
      {this.command, this.args, this.inputType, this.processId, this.logLevel});

  Future<bool> initialize() async {
    var completer = Completer<bool>();
    var lspserver = await Process.start(command, args);
    var id = Random().nextInt(100000);

    var message = InitializeMessage(
            id: id,
            params: InitializeParams(
                processId: pid,
                rootUri: '/home/daniel/lspclient',
                capabilities: {
                  'definition': {
                    'dynamicRegistration': true,
                    'linkSupport': true
                  }
                },
                trace: 'verbose'))
        .toString();
    print('sending initialize with id $id');
    currentProcess = lspserver;
    currentProcess.stdin.write(BaseProtocol(
            content: message,
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());

    var response_message = '';
    var count = 0;
    await for (var event in lspserver.stdout) {
      if (!(count >= 2)) {
        response_message += utf8.decode(event);
        count++;
        if (count >= 2) {
          break;
        }
      }
    }
    var base = BaseProtocol.fromLSPMessage(response_message);
    var message_map = json.decode(base.content);

    if (json.decode(base.content)['id'] == id) {
      print('Got initialize() response with id $id');
      print(ServerCapabilities.fromMap(message_map['result']['capabilities']));

      completer.complete(true);
    }

    return completer.future;
  }

  Future<bool> shutdown() async {
    var completer = Completer<bool>();
    var id = Random().nextInt(100000);
    print('called shutdown()');
    var message = ShutdownMessage(id: id).toString();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
    completer.complete(true);
    return completer.future;
  }

  Future<bool> exit() async {
    var completer = Completer<bool>();
    var id = Random().nextInt(100000);
    print('called exit()');
    var message = ExitMessage(id: id).toString();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
    return completer.future;
  }
}
