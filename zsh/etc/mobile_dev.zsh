# For Android dev
# https://docs.expo.dev/workflow/android-studio-emulator/#install-watchman-and-jdk

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export ANDROID_HOME=$HOME/Library/Android/sdk

PATH_ENTRIES+=("$ANDROID_HOME/emulator","$ANDROID_HOME/platform-tools")
