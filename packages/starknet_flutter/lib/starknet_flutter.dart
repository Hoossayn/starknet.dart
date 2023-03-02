import 'package:starknet_flutter/src/stores/starknet_store.dart';

export 'src/crypto/crypto_helper.dart';

// TODO: split this file into multiple files
export 'src/exchange_rates/exchange_rates.dart';
export 'src/models/models.dart';
export 'src/stores/starknet_store.dart';
export 'src/views/views.dart';

class StarknetFlutter {
  static Future<void> init() async {
    await StarknetStore.init();
  }
}
