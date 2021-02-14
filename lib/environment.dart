import 'package:meta/meta.dart';

class Environment {
  final _value;
  final EnvSettings _settings;


  EnvSettings get settings => _settings;

  const Environment._internal(this._value, this._settings);

  toString() => 'Enum.$_value';

  static const DEV = const Environment._internal('DEV', _developmentSettings);
  static const STG = const Environment._internal('STG', _developmentSettings);
  static const PROD = const Environment._internal('PROD', _productionSettings);
}

const _developmentSettings = EnvSettings(
    pointServiceBaseUrl: "https://host-service-develop.dev.qdoo.io",
    chatServiceBaseUrl: "https://host-service-develop.dev.qdoo.io",
    showLogs: true);

const _productionSettings = EnvSettings(
    pointServiceBaseUrl: "https://host-service-develop.dev.qdoo.io",
    chatServiceBaseUrl: "https://host-service-develop.dev.qdoo.io",
    showLogs: true);

@immutable
class EnvSettings {
  const EnvSettings({
    this.pointServiceBaseUrl = "",
    this.chatServiceBaseUrl = "",
    this.showLogs = true,
  });

  final String pointServiceBaseUrl;
  final String chatServiceBaseUrl;
  final bool showLogs;
}
