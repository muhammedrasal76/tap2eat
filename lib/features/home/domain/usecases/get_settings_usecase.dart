import '../../../../core/usecase/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/home_repository.dart';

/// Use case to fetch global settings
class GetSettingsUseCase implements UseCase<SettingsEntity, NoParams> {
  final HomeRepository repository;

  GetSettingsUseCase(this.repository);

  @override
  Future<SettingsEntity> call(NoParams params) async {
    return await repository.getSettings();
  }
}
