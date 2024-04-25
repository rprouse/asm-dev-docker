# 8-Bit CPU development tools docker container

[![asm-dev](https://github.com/rprouse/asm-dev-docker/actions/workflows/main.yml/badge.svg)](https://github.com/rprouse/asm-dev-docker/actions/workflows/main.yml)

Compilers and assemblers for 8-bit computer programming. This is intended to be
used as a [dev container](https://code.visualstudio.com/docs/remote/containers)
in Visual Studio Code. Contains the following,

| Program | Version | Description |
| --- | --- | --- |
| [cc65](https://cc65.github.io/) | 2.19 | Cross compiler and assembler for 6502 based computers |
| [SjASMPlus](https://z00m128.github.io/sjasmplus/documentation.html) | 1.20.3 | Z80 assembly cross compiler |
| [RASM](https://github.com/EdouardBERGE/rasm) | 2.2.3 | Another Z80 assembler |
| [SPASM-ng](https://github.com/alberthdev/spasm-ng) | 0.5-beta3 | Another Z80 assembler that supports the eZ80. This is a [fork of the version that supports the Agon](https://github.com/tomm/spasm-ng) align directive |
| [agon-ez80asm](https://github.com/envenomator/agon-ez80asm) | 0.96 | ez80 assembler, running natively on the Agon platform or Linux |
| [NASM](https://www.nasm.us/index.php) | 2.16.01 | Assembler for the x86 CPU family, in this case 8080 and 8088 |
| [z88dk](https://z88dk.org/) | nightly | z88dk is the only C and assembler development kit that comes ready out-of-the-box to create programs for over 100 z80-family machines. |
| [Minipro](https://gitlab.com/DavidGriffith/minipro) | 0.5 | CLI for the MiniPRO TL866xx series of chip programmers |
| [Emulator Kit](https://github.com/EtchedPixels/EmulatorKit) | latest | This is a kit of emulators primarily focussed on the RC2014 environment and some of the Retrobrew (formerly N8VEM) systems |
| [Z80Emu](https://github.com/rprouse/Z80Emu) | latest | A Z80 emulator/monitor program written in C# |

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
