// WalkTogether — Realtime Service (Socket.io)
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/config.dart';

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();

  IO.Socket? _socket;
  bool _connected = false;
  final _storage = const FlutterSecureStorage();

  void Function(bool connected)? onConnectionChange;
  void Function(String requestId, String messageId)? onChatMessage;
  void Function(String groupWalkId, String messageId, String senderId)?
      onGroupChatMessage;

  bool get isConnected => _connected;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;
    final sessionToken = await _storage.read(key: 'socket_token');
    if (sessionToken == null) return;

    _socket = IO.io(
      '${AppConfig.socketUrl}/?XTransformPort=3003',
      IO.OptionBuilder()
          .setPath(AppConfig.socketPath)
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableReconnection()
          .setAuth({'token': sessionToken})
          .build(),
    );

    _socket!.onConnect((_) {
      _connected = true;
      onConnectionChange?.call(true);
      _startHeartbeat();
    });

    _socket!.onDisconnect((_) {
      _connected = false;
      onConnectionChange?.call(false);
    });

    _socket!.on('chat:message', (data) {
      final payload = data as Map<String, dynamic>;
      onChatMessage?.call(
          payload['requestId'] as String, payload['messageId'] as String);
    });

    _socket!.on('group:chat:message', (data) {
      final payload = data as Map<String, dynamic>;
      onGroupChatMessage?.call(
        payload['groupWalkId'] as String,
        payload['messageId'] as String,
        payload['senderId'] as String,
      );
    });
  }

  Timer? _heartbeatTimer;
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (_) {
      _socket?.emit('presence:heartbeat');
    });
  }

  void disconnect() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connected = false;
  }
}
