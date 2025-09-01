<div align="center">

# asdf-rip2 [![Build](https://github.com/jahands/asdf-rip2/actions/workflows/build.yml/badge.svg)](https://github.com/jahands/asdf-rip2/actions/workflows/build.yml) [![Lint](https://github.com/jahands/asdf-rip2/actions/workflows/lint.yml/badge.svg)](https://github.com/jahands/asdf-rip2/actions/workflows/lint.yml)

[rip2](https://github.com/MilesCranmer/rip2) plugin for the [asdf version manager](https://asdf-vm.com).

rip2 is a fast and safe alternative to `rm` that moves files to trash instead of permanently deleting them.

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `unzip` - required for Windows binary extraction (if on Windows/WSL).

## Supported Platforms

- **macOS**: Intel (x86_64) and Apple Silicon (ARM64)
- **Linux**: x86_64, ARM64, ARMv7, i686, PowerPC64, PowerPC64LE, s390x
- **FreeBSD**: x86_64
- **Windows**: x86_64, i686 (requires `unzip`)

# Install

Plugin:

```shell
asdf plugin add rip2
# or
asdf plugin add rip2 https://github.com/jahands/asdf-rip2.git
```

rip2:

```shell
# Show all installable versions
asdf list-all rip2

# Install specific version
asdf install rip2 latest

# Set a version globally (on your ~/.tool-versions file)
asdf global rip2 latest

# Now rip2 commands are available
rip --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/jahands/asdf-rip2/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jacob Hands](https://github.com/jahands/)
