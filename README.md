# awsp

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Works with Oh My Zsh](https://img.shields.io/badge/Oh%20My%20Zsh-plugin-blue?logo=zsh)](https://ohmyz.sh/)

Switch between AWS profiles interactively using [fzf](https://github.com/junegunn/fzf), or set one directly by name. Automatically triggers `aws sso login` if credentials are expired.

![demo](demo.gif)

## Requirements

- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [fzf](https://github.com/junegunn/fzf)

## Installation

### zsh (plain)

Clone the repo and add a source line to `~/.zshrc`:

```sh
git clone https://github.com/chris-code-lab/awsp ~/.awsp
echo 'source ~/.awsp/awsp.plugin.zsh' >> ~/.zshrc && source ~/.zshrc
```

To update later: `git -C ~/.awsp pull`

### Oh My Zsh

Oh My Zsh has its own plugin loader — clone directly into the custom plugins directory and it will find the plugin automatically:

```sh
git clone https://github.com/chris-code-lab/awsp ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/awsp
```

Then add `awsp` to the `plugins` array in `~/.zshrc` and reload your shell:

```zsh
plugins=(... awsp)
```

```sh
source ~/.zshrc
```

> **Plain zsh vs Oh My Zsh:** with plain zsh you source the file yourself; with Oh My Zsh the framework handles loading — you just register the plugin name.

To update later: `git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/awsp pull`

### zinit

zinit can install directly from GitHub — add this to `~/.zshrc`:

```zsh
zinit light chris-code-lab/awsp
```

### bash

Clone the repo and add a source line to `~/.bashrc`:

```sh
git clone https://github.com/chris-code-lab/awsp ~/.awsp
echo 'source ~/.awsp/awsp.sh' >> ~/.bashrc && source ~/.bashrc
```

To update later: `git -C ~/.awsp pull`


## Usage

```sh
awsp              # open fzf picker to select a profile
awsp my-profile   # set AWS_PROFILE directly
awsp none         # unset AWS_PROFILE
```

## AWS profile configuration

`awsp` switches between profiles defined in `~/.aws/config`. You need at least one profile configured before using it.

To add an SSO profile:
```sh
aws configure sso --profile my-profile
```

This will generate entries in `~/.aws/config` similar to:
```ini
[sso-session my-org]
sso_start_url = https://my-org.awsapps.com/start
sso_region = eu-west-1
sso_registration_scopes = sso:account:access

[profile dev]
sso_session = my-org
sso_account_id = 123456789012
sso_role_name = MyRole
region = eu-west-1

[profile prod]
sso_session = my-org
sso_account_id = 210987654321
sso_role_name = MyRole
region = eu-west-1
```

For non-SSO profiles, use `aws configure --profile my-profile`. See the [AWS CLI configuration docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for the full reference.

---

If you find this useful, give it a ⭐
