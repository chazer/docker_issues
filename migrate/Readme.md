# Migrate project to another host

## Allow `sudo` without password on remote side

```
SSH_TARGET=user@host
ssh -tt ${SSH_TARGET} "sudo sh -c 'echo \"${USER} ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/${USER/./_}'"
```

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
