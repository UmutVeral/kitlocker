abstract final class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const home = '/home';
  static const onboardingCamera = '/onboarding/camera';
  static const locker = '/locker';
  static const lockerAdd = '/locker/add';
  static String lockerDetail(String id) => '/locker/$id';
}
