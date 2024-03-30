create:
	podman build -f ./Dockerfile . -t ubuntu-test
	distrobox assemble create

start:
	distrobox enter ubuntu-test

stop:
	distrobox stop ubuntu-test
