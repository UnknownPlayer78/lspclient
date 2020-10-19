import 'dart:async';
import 'dart:io';
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
    if (json.decode(base.content)['id'] == id) {
      print('Got initialize() response with id $id');
      completer.complete(true);
    }

    return completer.future;
  }

  void shutdown() async {
    print('called shutdown()');
    var message = ShutdownMessage(id: Random().nextInt(10000)).toString();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
  }

  void exit() async {
    print('called exit()');
    var message = ShutdownMessage(id: Random().nextInt(10000)).toString();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
  }
}
