# update-ipsets

Download and periodically update selected IP lists using FireHOL.

## Usage

```
$ docker run --rm maximbaz/update-ipsets firehol_level1 firehol_level2
```

This might not be useful because you likely want these ipsets to be available on the host, either in a file, or loaded in kernel (or both!).

The container will save ipsets into files in `/etc/firehol/ipsets/` directory, so if you need it on host, mount this directory:

```
$ docker run --rm -v /etc/firehol/ipsets:/etc/firehol/ipsets maximbaz/update-ipsets firehol_level1 firehol_level2
```

Alternatively you can create empty lists on the host (`ipset create firehol_level1 hash:net`) and then use the container to update them directly in kernel.

For this to work you need to run container in the host network and to give it `NET_ADMIN` capability:

```
$ docker run --rm --net=host --cap-add=NET_ADMIN maximbaz/update-ipsets firehol_level1 firehol_level2
```

Here's a `docker-compose` example (it uses the latter approach, but still creates a volume to keep the state and make it easier to restart container):

```yaml
volumes:
  data:

services:
  update-ipsets:
    image: maximbaz/update-ipsets
    restart: always
    volumes:
      - data:/etc/firehol/ipsets
    network_mode: host
    cap_add:
      - NET_ADMIN
    command: firehol_level1 firehol_level2
```

## Related

- https://github.com/devrt/docker-firehol-update-ipsets
- https://github.com/rikez/update-ipset
