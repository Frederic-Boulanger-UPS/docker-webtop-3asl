docker images | grep '/docker-webtop-' | cut -w -f 3 | xargs docker rmi
make build_eclipse
make build_isabelle
make build_souffle
make build_framac
make build
