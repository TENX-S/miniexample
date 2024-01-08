import 'package:json_annotation/json_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings {
  bool alwaysOnTop = false;

  Settings();

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}

class SettingsCubit extends HydratedCubit<Settings> {
  SettingsCubit() : super(Settings());

  set alwaysOnTop(bool pinned) => emit(state..alwaysOnTop=pinned);

  @override
  Settings? fromJson(Map<String, dynamic> json) {
    return Settings.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Settings state) {
    return state.toJson();
  }
}
