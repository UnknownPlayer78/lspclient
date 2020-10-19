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

  Future<Process> initialize() async {
    var lspserver = await Process.start(command, args);
    var id = Random().nextInt(10000);
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

    currentProcess = lspserver;
    lspserver.stdin.write(BaseProtocol(
            content: message,
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
    await for (var response in lspserver.stdout) {
      var response_text = utf8.decode(response);
      print(response_text);
      var message;
      try {
        message =
            json.decode(BaseProtocol.fromLSPMessage(response_text).content);
      } catch (e) {
        print('\nERROR: $e');
        message =
            json.decode(BaseProtocol.fromLSPMessage(response_text).content);
      }
      if (message['id'] == id) {
        print('response appears to respond to respond to InitializeMessage');
      }
    }
    return lspserver;
  }

  void shutdown() async {
    print('called shutdown()');
    var message = ShutdownMessage(id: Random().nextInt(10000)).toString();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
  }
}
