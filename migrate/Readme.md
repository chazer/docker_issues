# Migrate project to another host

## Copy images

```
SSH_TARGET=user@host
for image in "$(docker images --format '{{ .Repository }}:{{ .Tag }}')"; do
    docker save $image | ssh ${SSH_TARGET} docker load
done
```

## Copy folder with docker-compose stuff

```
SSH_TARGET=user@host
sudo tar -cz -C `pwd` . \
    | ssh ${SSH_TARGET} "sudo mkdir -p $(pwd) && sudo tar --same-owner --same-permissions -xzv -C $(pwd)"
```
