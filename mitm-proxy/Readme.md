# MITM Proxy

## Reverse proxy

> for debug outgouing HTTPS traffic of services

```
# https://github.com/nginx-proxy/nginx-proxy
NGINX_PROXY_NETWORK=nginx-proxy
NGINX_PROXY_VIRTUAL_PORT=8080
ORIGIN_HOST=company.com
ORIGIN_PORT=443
docker run --rm -ti --network ${NGINX_PROXY_NETWORK} -p ${NGINX_PROXY_VIRTUAL_PORT}:8080 mitmproxy/mitmproxy \
    mitmproxy --mode reverse:${ORIGIN_HOST}:${ORIGIN_PORT} --ssl-insecure --set keep_host_header
```
