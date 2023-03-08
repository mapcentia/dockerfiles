# Migrate To Traefik Version 2 - Standalone

Use this guide to migrate from Traefik version 1.7.x to Traefik version 2.x

## Traefik Folder

In the traefik folder add the following files `traefik-certificates-and-tls.yaml` and `traefik.yaml`.

### Traefik Dashboard

The Traefik dashboard is not part of this setup. If you need it add in the `traefik.yaml` file.

### Add Own Certificates

1. In the cert folder add your

- `domain.crt` file and
- `domain.key` file

2. In the traefik folder open the `traefik-certificates-and-tls.yaml` and change the name of the certFiles and keyfiles.

3. In your own docker-compose file delete

- `- ./cert/domain.crt:/domain.crt`
- `- ./cert/domain.key:/domain.key`

4. Below volume (still in the docker-compose file) add

```yaml
- ./traefik.yaml:/traefik.yaml:ro
- ./traefik-certificates-and-tls.yaml:/traefik-certificates-and-tls.yaml
- ./cert/:/cert
```

### Change Labels

In the `docker-compose`file delete the labels and the following labels:

```yaml
- traefik.enable=false
- traefik.http.routers.traefik.rule=Host(`example.com`)
- traefik.http.routers.traefik.tls=true
```

### Docker-compose

Check the new docker-compose file for the changes and be sure that you have the same volume and labels in your own docker-compose file.

### Delete

Delete the old `traefik.toml` file.

### Redeploy Traefik

```sh
docker-compose down
docker-compose up -d
```

## Vidi Folder

In the `vidi folder` you have to change the `labels` in the `docker-compose file`. Delete the labels you have and replace them with the following:

```yaml
- traefik.http.routers.vidi.entrypoints=websecure
- traefik.http.routers.vidi.tls=true
- traefik.http.services.vidi-service.loadbalancer.server.port=3000
- traefik.http.routers.vidi.rule=Host(`vidi.yourDomain.com`) # Set host!
- traefik.docker.network=web
- traefik.frontend.passHostHeader=true
```

Be sure to change the host in `- traefik.http.routers.vidi.rule=Host(`vidi.yourDomain.com`)`.

Check the new docker-compose file for the changes and be sure that you have the labels in your own docker-compose file.

### Redeploy Vidi

```sh
docker-compose down
docker-compose up -d
```

## GC2 Folder

In the `gc2 folder` you have to change the `labels` in the `docker-compose file`. Delete the labels you have and replace them with the following:

```yaml
- traefik.http.routers.gc2core.entrypoints=websecure
- traefik.http.routers.gc2core.tls=true
- traefik.http.routers.gc2core.rule=Host(`gc2.yourDomain.com`) # Set host!
- traefik.docker.network=web
- traefik.frontend.passHostHeader=true
```

Be sure to change the host in `- traefik.http.routers.gc2core.rule=Host(`gc2.yourDomain.com`)`.

Check the new docker-compose file for the changes and be sure that you have the labels in your own docker-compose file.

### Redeploy GC2

```sh
docker-compose down
docker-compose up -d
```

## Postgis Folder

Regards the migration there are no updates in the `docker-compose` file in the postgis folder.

There is added a health check, max logging and updated the docker version. See the docker-compose file if you want to implement it in your own file. It's **not** required to add this for the Traefik version 2.x to work.

## Test SSL

After the migration check that the SSL it's configured right <https://www.ssllabs.com/ssltest/>

Remember to click the box `Do not show the results on the boards`.
