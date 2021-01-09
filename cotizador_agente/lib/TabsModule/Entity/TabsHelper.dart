class TabsHelper {
  static final TabsHelper _tabsHelper = TabsHelper._internal();
  HideDelegate delegate;

  factory TabsHelper() {
    return _tabsHelper;
  }

  static void statusChanged(bool visible) {
    TabsHelper().delegate?.visibilityChanged(visible);
  }

  TabsHelper._internal();
}

abstract class HideDelegate {
  void visibilityChanged(bool visible);
}