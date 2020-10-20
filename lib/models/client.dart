import 'dart:async';
import 'dart:io';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:lspclient/models/message.dart';
import 'package:lspclient/models/lsp/serverCapabilities.dart';
import 'dart:math';
import 'dart:convert';

class LspClient {
  String inputType = 'std';
  String command;
  List<String> args;
  int processId = pid;
  String logLevel;
  Process currentProcess;
  ServerCapabilities serverCapabilities;

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
    print('sending initialize() with id $id');
    currentProcess = lspserver;
    currentProcess.stdin.write(BaseProtocol(
            content: message,
            header: HeaderPart(contentLength: utf8.encode(message).length))
        .toMessage());
    final reader = ChunkedStreamIterator(currentProcess.stdout);
    // first, parse the stream of bytes until a '\r\n\r\n' token, which indicated the end of the header.
    var headerparts = '';
    while (true) {
      if (headerparts.endsWith('\r\n\r\n')) {
        break;
      } else {
        var data = await reader.read(1);
        headerparts += utf8.decode(data);
      }
    }
    headerparts = headerparts.trim();
    var length = HeaderPart.fromHeader(headerparts).contentLength;
    var body = json.decode(utf8.decode(await reader.read(length)));
    await reader.cancel();

    if (body['id'] == id) {
      print('Got initialize() response with id $id');
      serverCapabilities =
          ServerCapabilities.fromMap(body['result']['capabilities']);
      completer.complete(true);
      await initializedNotification();
    }

    return completer.future;
  }

  Future<bool> initializedNotification() async {
    var completer = Completer<bool>();
    print('sending initialized notification');
    var message = InitializedNotification().toJson();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length),
            content: message)
        .toMessage());
    completer.complete(true);

    return completer.future;
  }

  Future<bool> shutdown() async {
    var completer = Completer<bool>();
    var id = Random().nextInt(100000);
    print('called shutdown()');
    var message = ShutdownMessage(id: id).toString();
    currentProcess.stdin.write(BaseProtocol(
            header: HeaderPart(contentLength: utf8.encode(message).length),
            content: message)
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
            header: HeaderPart(contentLength: utf8.encode(message).length),
            content: message)
        .toMessage());
    completer.complete(true);
    return completer.future;
  }
}
