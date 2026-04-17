# Dotfiles

Personal configuration files for tools in this repo.

## Nvim

### Prefixes

| Key | Meaning |
| --- | --- |
| `<leader>` | `Space` |
| `<localleader>` | `\\` |

### Shortcuts

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `<leader>pv` | Open netrw explorer | |
| Normal | `<leader>ff` | Telescope find files | |
| Normal | `<leader>fg` | Telescope live grep | |
| Normal | `<C-p>` | Telescope git files | |
| Normal | `<leader>lg` | Open LazyGit | |
| Normal | `<leader>mp` | Toggle markdown rendering | render-markdown.nvim |
| Normal | `gd` | Go to definition | LSP buffer-local |
| Normal | `gr` | List references | LSP buffer-local |
| Normal | `K` | Hover documentation | LSP buffer-local |
| Normal | `<leader>rn` | Rename symbol | LSP buffer-local |
| Normal, Visual | `<leader>ca` | Code action | LSP buffer-local |
| Normal | `<leader>e` | Open diagnostic float | LSP buffer-local |
| Normal | `[d` | Previous diagnostic | LSP buffer-local |
| Normal | `]d` | Next diagnostic | LSP buffer-local |
| Normal | `<leader>fm` | Format buffer | LSP buffer-local |
| Normal | `]c` | Next git hunk | Gitsigns |
| Normal | `[c` | Previous git hunk | Gitsigns |
| Normal, Visual | `<leader>hs` | Stage hunk | Gitsigns |
| Normal, Visual | `<leader>hr` | Reset hunk | Gitsigns |
| Normal | `<leader>hp` | Preview hunk | Gitsigns |
| Normal | `<leader>hb` | Blame line | Gitsigns |
| Normal | `<leader>hS` | Stage buffer | Gitsigns |
| Normal | `<leader>hR` | Reset buffer | Gitsigns |
| Insert | `<C-b>` | Scroll completion docs up | nvim-cmp |
| Insert | `<C-f>` | Scroll completion docs down | nvim-cmp |
| Insert | `<C-Space>` | Trigger completion | nvim-cmp |
| Insert | `<leader>.` | Trigger completion | nvim-cmp |
| Insert | `<C-e>` | Abort completion | nvim-cmp |
| Insert | `<CR>` | Confirm selected completion item | nvim-cmp |

### Cmdline Completion

| Mode | Key | Action |
| --- | --- | --- |
| Cmdline | `/` | Buffer completion preset |
| Cmdline | `?` | Buffer completion preset |
| Cmdline | `:` | Command and path completion preset |
