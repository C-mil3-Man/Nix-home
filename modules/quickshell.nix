{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = [
    inputs.quickshell.packages.${pkgs.system}.default

    # Qt6 related kits（for slove Qt5Compat problem）
    pkgs.qt6.qt5compat
    pkgs.qt6.qtbase
    pkgs.qt6.qtquick3d
    pkgs.qt6.qtwayland
    pkgs.qt6.qtdeclarative
    pkgs.qt6.qtsvg

    # alternate options
    # libsForQt5.qt5compat
    pkgs.kdePackages.qt5compat
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];

  # necessary environment variables
  environment.variables = {
    #QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
  };

  # make sure the Qt application is working properly
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
