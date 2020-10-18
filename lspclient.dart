import 'package:lspclient/models/client.dart';

void main(List<String> arguments) async {
  print('starting process');
  var client = LspClient(
      command: 'dart',
      args: [
        '/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot',
        '--lsp',
        '--client-id',
        'flameedit.lspclient',
        '--client-version',
        '1.2'
      ],
      logLevel: 'verbose');
  await client.initialize();
  await client.shutdown();
}
