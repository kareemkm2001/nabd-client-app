class AvatarHelper {
  static String getAvatar(String type, String id) {
    switch (type) {
      case 'gulf':
        return "https://api.dicebear.com/7.x/adventurer/png?seed=gulf_$id";

      case 'hijab':
        return "https://api.dicebear.com/7.x/lorelei/png?seed=hijab_$id";

      case 'normal':
      default:
        return "https://api.dicebear.com/7.x/avataaars/png?seed=normal_$id";
    }
  }
}