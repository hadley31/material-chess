import 'package:chess_app/generated/chess.pbgrpc.dart';
import 'package:flutter/widgets.dart';
import 'package:grpc/grpc.dart';
import 'package:chess_app/generated/chess.pb.dart';

class GrpcGameClient extends StatelessWidget {
  Future<void> getTest() async {
    final channel = ClientChannel(
      "127.0.0.1",
      port: 3000,
      options: ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    GameServiceClient client = GameServiceClient(channel);

    client.move(MoveRequest(move: 'e4'));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
