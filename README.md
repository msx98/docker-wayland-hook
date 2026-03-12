# contain

Run desktop applications (Chrome, Firefox) in isolated Podman containers with full Wayland, audio, and GPU support.

## Overview

`contain` sandboxes GUI applications using Podman while maintaining native integration with your desktop:

- **Display**: Wayland socket (read-only)
- **Audio**: PipeWire / PulseAudio
- **GPU**: Direct rendering (`/dev/dri`)
- **D-Bus**: Proxied and filtered via `xdg-dbus-proxy`
- **Filesystem**: Per-app persistent home directory, optional Downloads mount

## Requirements

- Podman
- `xdg-dbus-proxy`
- Wayland compositor
- PipeWire (recommended) or PulseAudio

## Usage

```bash
# Build and launch an application
./launch chrome
./launch firefox

# Install .desktop entries into your system application menu
./export
```

Shortcut wrappers in `bin/` delegate to `./launch`:

```bash
./bin/chrome
./bin/firefox
```

## Adding an Application

Create a directory under `specs/<name>/` with:

| File | Purpose |
|------|---------|
| `Containerfile` | Build instructions for the container image |
| `run.args` | Extra arguments passed to the application |
| `run.dbus` | D-Bus service names the app is allowed to access |
| `run.podman` | Extra `podman run` options (devices, mounts, etc.) |
| `desktop` | `.desktop` file for system menu integration |

Then run:

```bash
./build <name>   # Build the image
./launch <name>  # Launch the container
```

## Security Model

- All Linux capabilities dropped except `SYS_CHROOT`
- `--no-new-privileges`
- User namespace: `--userns keep-id` (no privilege escalation)
- Network: `pasta` (isolated namespace)
- D-Bus: only services listed in `run.dbus` are accessible
- Wayland socket mounted read-only

## Directory Structure

```
contain/
├── bin/           # Quick launcher wrappers
├── specs/         # Per-application configs (Containerfile, args, dbus, podman opts)
├── src/
│   ├── dockerfiles/   # Base container images (Ubuntu, Alpine)
│   └── init.sh        # Runtime environment setup
├── Home/          # Persistent per-app home directories
├── build          # Build script
├── launch         # Main launcher
└── export         # Desktop entry installer
```
