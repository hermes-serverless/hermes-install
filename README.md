## About

This project was made as an undergraduate thesis. All documentation on the architecture and implementation are available [here (pt-BR)](https://linux.ime.usp.br/~tiagonapoli/mac0499/). The system architecture is outlined by the following schema:

<image src="./imgs/architecture.png" width="75%">

## Requirements

- [Docker Engine](https://docs.docker.com/engine/): `v19.03.2` or newer
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker): `v2.1.1` or newer 
  - [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver)

## Installation

After making sure to have the requirements, just run the `start.sh` script and the hermes instance will start. Running it the first time requires to run with `-m` flag, to create the database tables.
You can specify the port on which the server will listen using the `-p $PORT` flag. If not specified the server will listen on `9090`. The host will always be `localhost`.

Examples:

```
First run, starting the server to listen on 8080:
./start -p 8080 -m

After the first startup the server should be started without the -m flag, e.g:
./start -p 12345
```

To stop the server gracefully just run `./stop.sh`. To delete all data on the instance run `./stop.sh -v`.
