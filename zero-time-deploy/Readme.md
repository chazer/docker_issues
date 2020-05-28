# How-To realize Zero Downtime with Docker

> Upgrade Docker Compose projects with zero downtime


## Algotithm

1. Up temp project

    1. Rename project with temp name (use copy of `.env` file)

    2. Start backend services first, start frontend router with delay

2. Wait until primary host router resolve new upstream

3. Remove old project with temp volumes

4. Up new project

    1. Start backend services first, start frontend router with delay
 
2. Wait until primary host router resolve new upstream

5. Remove temp project with temp volumes


## Usage

```bash
switch-version.sh new_tag_version
```
