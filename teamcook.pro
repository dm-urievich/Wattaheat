QT += qml quick core bluetooth charts gui widgets androidextras

CONFIG += c++11

SOURCES += main.cpp \
    notificationclient.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = .

# Default rules for deployment.
target.path = $$[QT_INSTALL_EXAMPLES]/androidextras
INSTALLS += target

DISTFILES += \
    Button.qml \
    InputBox.qml \
    Search.qml \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/src/org/qtproject/example/TeamCook.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += \
    notificationclient.h
