# Dotfiles

```sh
# Install
make

# Restore
make restore
```

## Testing

```sh
python3 test_makefile.py
```

## Gotchas

### Git

```shell
$ cp git/host-config.example git/host-config

# Then update git/host-config with actual values
# See more at https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key
```

## Todo

- [ ] Distro support other than MacOS
    - Arch
    - Ubuntu
    - ...
