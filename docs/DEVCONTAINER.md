# Dev Container

The dev container builds and tests Blackburn. The iOS Simulator keeps running on the Linux host: it needs KVM, a Vulkan GPU, Docker, and a macOS disk, which this image does not include.

## Configurations

Reopen the folder in a container and pick one:

| Config | Use it for |
| :--- | :--- |
| **Blackburn** (`.devcontainer/code`) | `go test`, `bin/blackburn`, and the bundled `xcross` launcher on any machine. |
| **Blackburn (host devices)** (`.devcontainer/host`) | The same toolchain, plus the host Docker socket, `/dev/kvm`, and `/dev/dri/renderD128`. Use this on a Linux laptop that already runs macbox. |

The host config fails to start when those devices are absent. Use the code config there.

Both images are Debian bookworm with Go 1.23.12, Dart 3.14.1, `gcc` (for `go test -race`), Python 3, and OpenSSH. The host image also installs the Docker client. Cache volumes keep the module download, Go build cache, pub cache, and `~/.cache/blackburn` across rebuilds.

On create, the container downloads Go modules and runs `dart pub get` in `xcross/`.

## Check

```bash
scripts/devcontainer-check.sh
```

That runs `go test -race -count=1 ./...`, `bin/blackburn --help`, and `bin/xcross --version`. The first `xcross` invocation compiles the bundled workspace and needs network access to pub.dev.

`blackburn doctor` in the code container reports failing `kvm`, render-node, Vulkan, Docker, and simulator SSH checks. Those checks describe the host appliance, not the compiler toolchain.
