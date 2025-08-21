docker-webtop-3asl
=============

Docker image used for teaching in the "Software Science" 3rd year at [CentraleSupélec](http://www.centralesupelec.fr).

Available on [Docker hub](https://hub.docker.com/r/fredblgr/docker-webtop-3asl)

Source files available on [GitHub](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl).

Based on the ubuntu-icewm webtop image from (https://docs.linuxserver.io/images/docker-webtop)

This image come with the following software installed:
* Isabelle 2022 (for Why3) and 2025
* The Coq IDE
* Why3 1.8.1
* Frama-C 31.0 with MetAcsl
* Various solvers, among which:
  * Alt-Ergo
  * Z3
  * CVC4
  * CVC 5
* Logisim
* Eclipse Modeling 2025-06 with:
  * Acceleo
  * QVT Operational
  * Xtext
  * C/C++ development tools

Typical usage is:

```
docker run --rm --detach --publish 3000:3000 \
           --volume ${PWD}/config:/config:rw \
           --env PUID=`id -u` \
           --env PGID=`id -g` \
           --name webtop-3asl fredblgr/docker-webtop-3asl:2025
```

Very Quick Start
----------------
Run `./start-3asl.sh` (available on [GitHub](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.sh)), you will have Ubuntu in your browser, with the 'config' subdirectory of the current working directory mounted on /config, which is the home directory. The container will be removed when it stops, so save your work in /config if you want to keep it.

There is a [`start-3asl.ps1`](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.ps1) script for the PowerShell of Windows. You may have to allow the execution of scripts with the command:

```Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser```.

You browser should display an Ubuntu desktop. Else, check the console for errors and point your web browser at [http://localhost:3000](http://localhost3000)


If you use the `start-3asl.sh` script, your user and group id in the container will be the same as on the host (even if you need sudo to start Docker), so the files created by the container will belong to you.

License
==================

Apache License Version 2.0, January 2004 http://www.apache.org/licenses/LICENSE-2.0
