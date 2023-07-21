import 'package:args/command_runner.dart';
import 'package:plugin_channel/plugin_channel.dart';

abstract class BaseCommand<Req, Res> extends Command {
  BaseCommand() {
    argParser.addOption(
      'identifier',
      abbr: 'i',
      help: '请求的唯一标识符!',
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    final identifier = argResults?['identifier'];
    if (identifier is! String) {
      throw 'identifier not exist';
    }
    final channelIdentifier = ChannelIdentifier(identifier);
    final resource = ChannelResource(channelIdentifier);
    late ChannelResponse response;
    try {
      response = await runPlugin(resource);
    } catch (e) {
      response = ChannelResponse.failure(e.toString());
    }
    await resource.saveResponseResource(response);
  }

  Future<ChannelResponse> runPlugin(ChannelResource resource);
}
