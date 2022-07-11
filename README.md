# duoauthproxy-docker
Duo Authentication Proxy in a container

Mount your `authproxy.cfg` file at `/opt/duoauthproxy/conf/authproxy.cfg`
```sh
docker run -d -v $PWD/authproxy.cfg:/opt/duoauthproxy/conf/authproxy.cfg:ro nickadam/duoauthproxy
```

Or use environment variables:
- DUO_CLOUD_IKEY
- DUO_CLOUD_SKEY
- DUO_CLOUD_SKEY_FILE
- DUO_CLOUD_API_HOST
- SERVICE_ACCOUNT_PASSWORD
- SERVICE_ACCOUNT_PASSWORD_FILE
- SERVICE_ACCOUNT_USERNAME

Variables ending in `_FILE` are used to specify paths to files that contain the values. Useful when using a secrets manager.
