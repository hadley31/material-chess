

proto:
	@mkdir -p lib/generated
	@protoc -I=proto --dart_out=grpc:lib/generated proto/*.proto

	@mkdir -p server/src/generated
	@protoc -I=proto --go_out=grpc:server/src/generated proto/*.proto