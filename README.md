# Podman Services Collection

A collection of scrips for building services in podman containers. Requires `buildah` and `podman`. Many of these use base images are from DockerHub and can be converted to Docker containers by translating the `buildah` commands to a `Dockerfile`.

## Containers

* [A Dark Room](https://github.com/doublespeakgames/adarkroom): A fun idle game running in browser. Good for simple web testing.
* **LAMP**: A basic PHP - MYSQL setup.
* **Git**: Git server.
* **Nextcloud**: Nextcloud pod with MariaDB and Redis.

# Automatic start on boot

Since podman doesn't have a daemon, starting containers on boot is handled by systemd. For rootless containers run:
```bash
podman generate systemd -nf
```
and put the resulting .service file into `~/.config/systemd/user/`.
Activate the service with `systemctl --user enable --now <container>.service`.

This will only start the container on user login. To restart on system boot, run `loginctl enable-linger <username>`.
