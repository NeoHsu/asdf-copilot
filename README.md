<div align="center">

# asdf-copilot [![Build](https://github.com/NeoHsu/asdf-copilot/actions/workflows/build.yml/badge.svg)](https://github.com/NeoHsu/asdf-copilot/actions/workflows/build.yml) [![Lint](https://github.com/NeoHsu/asdf-copilot/actions/workflows/lint.yml/badge.svg)](https://github.com/NeoHsu/asdf-copilot/actions/workflows/lint.yml)


[copilot](https://aws.github.io/copilot-cli/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Build History

[![Build history](https://buildstats.info/github/chart/NeoHsu/asdf-copilot?branch=main)](https://github.com/NeoHsu/asdf-copilot/actions)

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add aws-copilot
# or
asdf plugin add aws-copilot https://github.com/NeoHsu/asdf-copilot.git
```

copilot:

```shell
# Show all installable versions
asdf list-all aws-copilot

# Install specific version
asdf install aws-copilot latest

# Set a version globally (on your ~/.tool-versions file)
asdf global aws-copilot latest

# Now copilot commands are available
copilot --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/NeoHsu/asdf-copilot/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Neo Hsu](https://github.com/NeoHsu/)
