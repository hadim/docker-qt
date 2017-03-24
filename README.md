# docker-qt

Compile a C++/Qt project within Docker.

Qt version used is `5.7.1`.

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

## Author

- Hadrien Mary