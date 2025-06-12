class NameUtils {

  static String extractNameInitials(String name) {
    List<String> nameParts = name.split(" ");
    if (nameParts.length >= 2) {
      return "${nameParts[0][0]}${nameParts[1][0]}".toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0].substring(0, 2).toUpperCase();
    }
    return "??";
  }
}