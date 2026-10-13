# Introduction

This repo configures every machine I use from one nix flake in `nix/`. It uses
the dendritic layout: modules are found by walking the tree, so nothing has to
be listed by hand, and a file's location gives it its name.

| Host                  | Class  | Takes                                                   |
| --------------------- | ------ | ------------------------------------------------------- |
| `Francos-MacBook-Air` | darwin | base, dev, terminal, monitor, **personal**              |
| `work-mbp`            | darwin | base, dev, terminal, **work**                           |
| `nixos-x8664`         | nixos  | base, dev, terminal, monitor, **desktop**, **personal** |

This book covers:

- **Setting up a Mac**: what to install before nix, the bootstrap, the steps
  that come after the first switch, and what is different on the work MacBook.
- **Reference**: the day-to-day `just` recipes and how the module tree is put
  together.

## Building this book

The dev shell includes `mdbook`, so from the repo root:

```bash
just docs       # serve with live reload on http://localhost:3000
just docs-build # write the static site to docs/book/
```
