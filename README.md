
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
  
  `docker run --rm --detach --env="PUID=\`id -u\`" --env="PGID=\`id -g\`" \
  	--publish 3000:3000 --publish 3001:3001 --volume "$(pwd)/config:/config:rw" \
    fredblgr/docker-webtop-3asl:2025`

You may also use the scripts [start-3asl.sh](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.sh) or [start-3asl.ps1](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.ps1).

The start-3asl.sh script takes care of setting your user and group id correctly in the container, even if you start docker using sudo.

The start-3asl.ps1 script can be used after allowing the execution of scripts with the command ```Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser```.
