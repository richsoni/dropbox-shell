#Dropbox Shell (dbsh)

dbsh is a simple shell allowing command line navigation of the dropbox virtual file system.

## Setup

Setting up the project is two steps:

### 1. Installation

```sh
git clone https://github.com/richsoni/dropbox-shell
cd dropbox-shell
bundle
```

### 2. Setup API Token and Secret

For now, you have set up your own token and secret from dropbox.

```https://www.dropbox.com/developers/apps```

Paste the *token* and *secret* into data/config.yml

## Usage

```./app.rb``` starts the console

### Commands

Supported commands are:

1. ```cd```
2. ```ls```
3. ```pwd```

### Ruby

The console is a pry session e.g. you can use any ruby to manipulate the shell.
