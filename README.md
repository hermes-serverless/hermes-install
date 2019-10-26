## Requirements

- [Docker Engine](https://docs.docker.com/engine/): `v19.03.2` or newer
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker): `v2.1.1` or newer 
  - [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver)

## Instalation

After making sure to have the requirements, just run the `start.sh` script and the hermes instance will start. Running it the first time requires to run with `-m` flag, to create the database tables.
You can specify the por on which the server will listen using the `-p $PORT` flag. If not specified the server will listen on `9090`. The host will always be `localhost`.

Examples:

```
First run, starting the server to listen on 8080:
./start -p 8080 -m

Subsequently starts, starting the server to listen on 12345:
./start -p 12345
```

To stop the server gracefully just run `./stop.sh`. 
```
DANGER: To delete all data on that instance run `./stop.sh -v`
```