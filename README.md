# sbx-templates

Dev-container images for the Docker sandbox (`sbx`), built with **buildx bake**
and tested with **goss/dgoss**. 

## Images

| Variant   | Built on          | Tooling                                                                              |
|-----------|-------------------|--------------------------------------------------------------------------------------|
| `base`    | sandbox-templates | Neovim (+ `vim`/`vi` symlinks, lazy.nvim config), Go, Lua, LuaRocks, tree-sitter CLI |
| `kube`    | `base`            | kubectl, kind, flux                                                                  | 
| `ansible` | `base`            | uv, Python 3.12, ansible, molecule                                                   |                     

User tools live under `/home/agent/.local` and are on the `agent` user's PATH.

## Layout

```
.
├── docker-bake.hcl          # build targets + tagging
├── Makefile                 # build / test / push wrappers
├── base/
│   ├── Dockerfile
│   └── files/home/agent/    # copied into the image home dir (scripts, nvim config)
├── kube/Dockerfile
├── ansible/Dockerfile
└── test/{base,kube,ansible}/goss.yaml
```

## Tagging & publishing

All variants share one repository (`IMAGE`); the variant is the tag. Each build
gets a moving `-latest` tag, plus an immutable `-VERSION` tag when `VERSION` is set.

```sh
make push                       # ttyse/sbx-templates:{base,kube,ansible}-latest
VERSION=2026-06-26 make push    # ...also :<variant>-2026-06-26
IMAGE=ghcr.io/you/sbx make push # publish to a different repo
```

## Versions

Tool versions are pinned as variables in `docker-bake.hcl` (`GO_VERSION`,
`KUBECTL_VERSION`, `TREE_SITTER_VERSION`, …); override on the CLI, e.g.
`KUBECTL_VERSION=1.31.0 make kube`. 
