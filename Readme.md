# 8-Bit CPU development tools docker container

[![asm-dev](https://github.com/rprouse/asm-dev-docker/actions/workflows/main.yml/badge.svg)](https://github.com/rprouse/asm-dev-docker/actions/workflows/main.yml)

Compilers and assemblers for 8-bit computer programming. This is intended to be
used as a [dev container](https://code.visualstudio.com/docs/remote/containers)
in Visual Studio Code. Contains the following,

| Program | Version | Description |
| --- | --- | --- |
| [cc65](https://cc65.github.io/) | 2.19 | Cross compiler and assembler for 6502 based computers |
| [SjASMPlus](https://z00m128.github.io/sjasmplus/documentation.html) | 1.18.2 | Z80 assembly cross compiler |
| [Minipro](https://gitlab.com/DavidGriffith/minipro) | 0.5 | CLI for the MiniPRO TL866xx series of chip programmers |

## Usage

```sh
docker run --rm -v ${PWD}:${PWD} -w ${PWD} -it rprouse/asm-dev
```

## Build

```sh
docker build -t rprouse/asm-dev .
```

## License

[MIT License](LICENSE)
