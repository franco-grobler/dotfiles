# After the first switch

Open a new terminal (Ghostty is installed now). `just` and the rest of the
toolchain are on `PATH` from here on.

## SSH keys

The 1Password agent offers every key it has, and servers give up after about six
attempts ("Too many authentication failures"). `dotfiles.ssh.keys` ties each
host to one key. This recipe writes the public halves to
`~/.ssh/<host>/key.pub`:

```bash
just ssh-keys
```

Run it again whenever you add a key. Only public keys are written to disk; the
private keys stay in 1Password.

Check that it works, then switch the repo to SSH:

```bash
ssh -T git@github.com
git -C ~/dotfiles remote set-url origin git@github.com:franco-grobler/dotfiles.git
```

## Git hooks

Entering the repo loads the dev shell through direnv, and the dev shell installs
the prek hooks:

```bash
cd ~/dotfiles
direnv allow
```

## Claude Code

```bash
just claude-setup # registers the figma-desktop MCP server
```

## Check commit signing

```bash
git commit --allow-empty -m "test signing" && git log --show-signature -1
git reset --hard HEAD~1
```

If the commit fails with `No such file or directory`, 1Password is not in
`/Applications`. See [Before you
start](prerequisites.md#5-install-and-set-up-1password).
