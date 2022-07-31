///
//  Generated code. Do not modify.
//  source: chess.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'chess.pb.dart' as $0;
export 'chess.pb.dart';

class GameServiceClient extends $grpc.Client {
  static final _$move = $grpc.ClientMethod<$0.MoveRequest, $0.MoveResponse>(
      '/GameService/Move',
      ($0.MoveRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MoveResponse.fromBuffer(value));

  GameServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.MoveResponse> move($0.MoveRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$move, request, options: options);
  }
}

abstract class GameServiceBase extends $grpc.Service {
  $core.String get $name => 'GameService';

  GameServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.MoveRequest, $0.MoveResponse>(
        'Move',
        move_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MoveRequest.fromBuffer(value),
        ($0.MoveResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.MoveResponse> move_Pre(
      $grpc.ServiceCall call, $async.Future<$0.MoveRequest> request) async {
    return move(call, await request);
  }

  $async.Future<$0.MoveResponse> move(
      $grpc.ServiceCall call, $0.MoveRequest request);
}
