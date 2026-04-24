# Dotfiles

Personal configuration files for tools in this repo.

## Nvim

### Prefixes

| Key | Meaning |
| --- | --- |
| `<leader>` | `Space` |
| `<localleader>` | `\\` |

### Navigation

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `<leader>pv` | Open netrw explorer | |
| Normal | `<leader>ff` | Telescope find files | |
| Normal | `<leader>fg` | Telescope live grep | |
| Normal | `<C-p>` | Telescope git files | |

### In-File Navigation

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `h` | Move left | Standard Vim motion |
| Normal | `j` | Move down | Standard Vim motion |
| Normal | `k` | Move up | Standard Vim motion |
| Normal | `l` | Move right | Standard Vim motion |
| Normal | `w` | Jump to next word start | Standard Vim motion |
| Normal | `b` | Jump to previous word start | Standard Vim motion |
| Normal | `e` | Jump to word end | Standard Vim motion |
| Normal | `0` | Jump to line start | Standard Vim motion |
| Normal | `^` | Jump to first non-blank character | Standard Vim motion |
| Normal | `$` | Jump to line end | Standard Vim motion |
| Normal | `gg` | Jump to top of file | Standard Vim motion |
| Normal | `G` | Jump to bottom of file | Standard Vim motion |
| Normal | `{` | Jump to previous paragraph or block | Standard Vim motion |
| Normal | `}` | Jump to next paragraph or block | Standard Vim motion |
| Normal | `%` | Jump to matching bracket or paren | Standard Vim motion |

### Editing

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Visual | `v` | Start character-wise selection | Standard Vim motion |
| Visual Line | `V` | Start line-wise selection | Standard Vim motion |
| Visual Block | `<C-v>` | Start block-wise selection | Standard Vim motion |
| Normal | `yy` | Copy current line | Standard Vim motion |
| Visual | `y` | Copy selection | Standard Vim motion |
| Normal | `p` | Paste after cursor | Standard Vim motion |
| Normal | `P` | Paste before cursor | Standard Vim motion |
| Visual | `d` | Cut selection | Standard Vim motion |
| Normal | `dd` | Cut current line | Standard Vim motion |
| Normal | `x` | Delete character under cursor | Standard Vim motion |
| Normal | `u` | Undo last change | Standard Vim motion |
| Normal | `<C-r>` | Redo last undone change | Standard Vim motion |
| Cmdline | `:e` | Reload current file from disk | Standard Vim command |
| Cmdline | `:e!` | Reload current file and discard unsaved changes | Standard Vim command |

### LSP

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `gd` | Go to definition | LSP buffer-local |
| Normal | `gr` | List references | LSP buffer-local |
| Normal | `K` | Hover documentation | LSP buffer-local |
| Normal | `<leader>rn` | Rename symbol | LSP buffer-local |
| Normal, Visual | `<leader>ca` | Code action | LSP buffer-local |
| Normal | `<leader>fm` | Format buffer | LSP buffer-local |

### Diagnostics

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `<leader>e` | Open diagnostic float | LSP buffer-local |
| Normal | `[d` | Previous diagnostic | LSP buffer-local |
| Normal | `]d` | Next diagnostic | LSP buffer-local |

### Git

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `<leader>lg` | Open LazyGit | |
| Normal | `]c` | Next git hunk | Gitsigns |
| Normal | `[c` | Previous git hunk | Gitsigns |
| Normal, Visual | `<leader>hs` | Stage hunk | Gitsigns |
| Normal, Visual | `<leader>hr` | Reset hunk | Gitsigns |
| Normal | `<leader>hp` | Preview hunk | Gitsigns |
| Normal | `<leader>hb` | Blame line | Gitsigns |
| Normal | `<leader>hS` | Stage buffer | Gitsigns |
| Normal | `<leader>hR` | Reset buffer | Gitsigns |

### Completion

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Insert | `<C-b>` | Scroll completion docs up | nvim-cmp |
| Insert | `<C-f>` | Scroll completion docs down | nvim-cmp |
| Insert | `<C-Space>` | Trigger completion | nvim-cmp |
| Insert | `<leader>.` | Trigger completion | nvim-cmp |
| Insert | `<C-e>` | Abort completion | nvim-cmp |
| Insert | `<CR>` | Confirm selected completion item | nvim-cmp |

### Other

| Mode | Key | Action | Notes |
| --- | --- | --- | --- |
| Normal | `<leader>mp` | Toggle markdown rendering | render-markdown.nvim |

### Cmdline Completion

| Mode | Key | Action |
| --- | --- | --- |
| Cmdline | `/` | Buffer completion preset |
| Cmdline | `?` | Buffer completion preset |
| Cmdline | `:` | Command and path completion preset |
