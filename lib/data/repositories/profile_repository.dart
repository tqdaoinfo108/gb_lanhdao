import '../models/user_profile_models.dart';
import '../services/profile_service.dart';

/// Repository cầu nối giữa ProfileService và Controller.
class ProfileRepository {
  final ProfileService _service;

  ProfileRepository({ProfileService? service})
    : _service = service ?? ProfileService();

  Future<UserProfile> getProfile() => _service.getProfile();

  Future<UserProfile> updateUser(UserProfile profile) =>
      _service.updateUser(profile);
}
