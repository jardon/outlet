# Outlet

Linux application GUI storefront.

## Build Outlet

### Install Dependencies

#### Debian-based distros
> **NOTE:** Package names may change depending on the distro version
```bash
sudo apt-get update -y && sudo apt-get upgrade -y;
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa \
      clang cmake git \
      ninja-build pkg-config \
      libgtk-3-dev liblzma-dev \
      libstdc++-12-dev libsysprof-6-dev \
      libcloudproviders-dev
```
### Setup Flutter
Install flutter in your environment.  This may vary per distribution.  Generic instructions are described in their [docs](https://docs.flutter.dev/get-started/install/linux/desktop).

### Compile Project
```bash
flutter build linux
```

## Flutter Resources

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
