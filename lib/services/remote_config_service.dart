import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:dartz/dartz.dart';

import 'api_failure.dart';

class RemoteConfigService {
  Future<Either<FirebaseRemoteConfig, ApiFailure>> getRemoteConfig() async {
    try {
      final FirebaseRemoteConfig firebaseRemoteConfig =
          FirebaseRemoteConfig.instance;

      firebaseRemoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await firebaseRemoteConfig.fetch();
      await firebaseRemoteConfig.activate();

      print(firebaseRemoteConfig.getString('appVersion'));

      return left(firebaseRemoteConfig);
    } on FirebaseException catch (e) {
      final error = e.code;
      return right(ApiFailure(error));
    }
  }
}
