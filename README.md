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
- SERVICE_ACCOUNT_USERNAME
- SERVICE_ACCOUNT_PASSWORD
- SERVICE_ACCOUNT_PASSWORD_FILE

```sh
docker run -d -e DUO_CLOUD_IKEY=DI32UWUUWUUWUUWU \
  -e DUO_CLOUD_SKEY=CBsaW5lcyBpZiB5b3UgYXJlIHVzaW5nIE5UTE0gb3 \
  -e DUO_CLOUD_API_HOST=api-a11bb1d2.duosecurity.com \
  -e SERVICE_ACCOUNT_USERNAME=bob@example.com \
  -e SERVICE_ACCOUNT_PASSWORD=badpassword \
  nickadam/duoauthproxy
```

Variables ending in `_FILE` are used to specify paths to files that contain the values. Useful when using a secrets manager.
