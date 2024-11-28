abstract class UserStorage {
  Future<bool> saveUserData(String username, String password, String nickname); 
  Future<Map<String, String>?> getUserData(); 
  Future<bool> validateLogin(String username, String password);
}
