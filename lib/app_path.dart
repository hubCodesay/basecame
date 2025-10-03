/// Шляхи для роутінгу
enum AppPath {
  /// Віртуальний перший, перейде або на головну або на логін
  start('/start'),
  /// Онбоардінг
  onboard('/onboard'),
  /// Головний екран
  root('/'),
  /// Map
  rootMap('/map'),
  /// Chats
  rootChats('/chats'),
  /// Shop
  rootShop('/shop'),
  /// Events
  rootEvents('/events'),
  /// Profile
  rootProfile('/profile'),
  /// Екран з вибіром логуванням
  login('/login'),
  /// Локейшен
  location('/map/location'),
  /// Локейшен день
  locationDay('/map/location_day'),
  /// Екран з вибіром логуванням
  registration('/registration'),
  /// Екран з налаштуваннями
  settings('/profile/settings'),
  /// Екран з редагуванням профіля
  editProfile('/profile/edit_profile'),
  /// Підтримка
  support('/profile/support');

  const AppPath(this.path);
  final String path;

  /// First Default Tab
  static AppPath get firstTab => rootShop;
}
