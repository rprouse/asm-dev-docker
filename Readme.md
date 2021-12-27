# 8-Bit CPU development tools docker container

[![asm-dev](https://github.com/rprouse/asm-dev-docker/actions/workflows/main.yml/badge.svg)](https://github.com/rprouse/asm-dev-docker/actions/workflows/main.yml)

Compilers and assemblers for 8-bit computer programming. This is intended to be
used as a [dev container](https://code.visualstudio.com/docs/remote/containers)
in Visual Studio Code. Contains the following,

| Program | Version | Description |
| --- | --- | --- |
| [cc65](https://cc65.github.io/) | 2.19 | Cross compiler and assembler for 6502 based computers |
| [SjASMPlus](https://z00m128.github.io/sjasmplus/documentation.html) | 1.18.3 | Z80 assembly cross compiler |
| [RASM](https://github.com/EdouardBERGE/rasm) | 1.6 | Another Z80 Assembler |
| [NASM](https://www.nasm.us/index.php) | 2.15.05 | Assembler for the x86 CPU family, in this case 8080 and 8088 |
| [Minipro](https://gitlab.com/DavidGriffith/minipro) | 0.5 | CLI for the MiniPRO TL866xx series of chip programmers |

## Usage

```sh
docker run --rm -v ${PWD}:/src -w /src -it rprouse/asm-dev
```

## Build

```sh
docker build -t rprouse/asm-dev .
```

## License

[MIT License](LICENSE)
