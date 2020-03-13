# docker-qt

Compile a C++/Qt project within Docker.

[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/chibigold/docker-qt) 

Qt version used is `5.9.4`.

## Usage

Create a `build.sh` file :

```bash
cd /src
qmake -r
make
make install 
```

Then a `docker-compose.yml` file : 

```yml
version: '2.1'
services:

  builder:
    image: hadim/docker-qt
    volumes:
      - ./src:/src
      - ./local/:/local
      - ./build.sh:/build.sh
```

Launch the automatic build script `/build.sh` with `docker-compose up` or launch a bash session with `docker-compose run builder bash`.

## Author

- Hadrien Mary
