
# docker-webtop-3asl

## Why

This image provides a linux with a GUI running either on a local docker or on MyDocker. 
It is based on [WebTop image from LinuxServer.io](https://github.com/linuxserver/docker-webtop) 
which is maintained and quite often updated.

This image uses Ubuntu 24.04 and the [IceWM](https://ice-wm.org) window manager.

It is available on [Docker hub](https://hub.docker.com/r/fredblgr/docker-webtop-3asl)
and on [GitHub](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl)

## Details

- The exposed ports are 3000 (HTTP/VNC) and 3001 (HTTPS/VNC).
- The user folder is `/config`.
- the user is `abc`, its password also, sudo is without password.
- if docker is installed on your computer, you can run (amd64 or arm64 architecture) this 
  image, assuming you are in a specific folder containing a "config" subfolder that will 
  be shared with the container at `/config`, with:
  
  `docker run --rm --detach \
  						--publish 3000:3000 \
  						--publish 3001:3001 \
  						--volume "$(pwd)/config:/config:rw" \
    			fredblgr/docker-webtop-3asl:2025`

You may also use the scripts [start-3asl.sh](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.sh) or [start-3asl.ps1](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.ps1).

The start-3asl.ps1 script can be used after allowing the execution of scripts with the command ```Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser```.

## Using with distrobox (Linux)

On Linux, the tools can also run as ordinary windows on your own desktop, in your own
home directory, with [distrobox](https://distrobox.it) (with podman or docker):

```
distrobox create --name 3asl --image docker.io/fredblgr/docker-webtop-3asl:2026
distrobox enter 3asl
```

The first `distrobox enter` takes a minute to set the container up. In the container,
`eclipse`, `isabelle`, `isabelle-latest`, `why3`, `coqide`, `frama-c`, `frama-c-gui`,
`logisim`, `alt-ergo`, `z3`, `cvc4` and `cvc5` are available. On the first login, the
course configuration is copied to `~/.why3.conf` and `~/.isabelle`, unless you already
have them.

To get Eclipse and Isabelle in your desktop's application menu, run in the container:

```
distrobox-export --app Eclipse
distrobox-export --app Isabelle
```

With a window manager that does not reparent windows (sway, niri, ...), Java applications
(Logisim, Isabelle) may show empty windows: add
`--additional-flags "--env _JAVA_AWT_WM_NONREPARENTING=1"` to `distrobox create`.

On a HiDPI screen, if the applications look too small to read, also add
`--env GDK_SCALE=2 --env GDK_DPI_SCALE=0.875` to `--additional-flags`. With both
adjustments, the creation command becomes:

```
distrobox create --name 3asl --image docker.io/fredblgr/docker-webtop-3asl:2026 --additional-flags "--env _JAVA_AWT_WM_NONREPARENTING=1 --env GDK_SCALE=2 --env GDK_DPI_SCALE=0.875"
```

These flags are recorded when the container is created: to change them, remove the
container with `distrobox rm -f 3asl` and run `distrobox create` again. Your home
directory and the course configuration (`~/.why3.conf`, `~/.isabelle`) are on the host
side and are kept.
