Table of Contents
=================

  * [Table of Contents](#table-of-contents)
  * [bitbucket-bash-api](#bitbucket-bash-api)
    * [Installation](#installation)
    * [Configuration](#configuration)
    * [Warning !](#warning-)

Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc.go)


# bitbucket-bash-api

Access [bitbucket](https://www.atlassian.com/software/bitbucket/server) API from bash. This piece of code

[bitbucket](https://www.atlassian.com/software/bitbucket/server) from Atlassian is proprietary software
but probably the most mature git server solution.

Last version is available on GitHub: https://github.com/cClaude/bitbucket-bash-api


## Installation

This tool require `bash`, `curl`, `jq` and `git`.

```bash
sudo apt update
sudo apt upgrade
sudo apt install curl jq git

git clone https://github.com/cClaude/gitlab-bash-api.git
```

## Configuration

You can create a `my-config` folder (ignored by git) to configure/customize this application
or just copy content of `custom-config-sample/`.

This `my-config` folder is taken in account by default by the API


## Warning !

This code is still in alpha version
