import 'package:bluetooth_app/get_its.dart';
import 'package:bluetooth_app/services/remote_config_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigNotifier = StateNotifierProvider<RemoteConfigNotifier,
    AsyncValue<FirebaseRemoteConfig>>(
      (ref) {
    return RemoteConfigNotifier(remoteConfigService);
  },
);

class RemoteConfigNotifier extends StateNotifier<AsyncValue<FirebaseRemoteConfig>> {
  final RemoteConfigService remoteConfigService;

  RemoteConfigNotifier(this.remoteConfigService) : super(AsyncValue.loading());

  Future getRemoteConfig() async {
    final status = await remoteConfigService.getRemoteConfig();
    status.fold(
          (success) {
        state = AsyncValue.data(success);
      },
          (error) {
        state = AsyncValue.error(error);
      },
    );
  }
}