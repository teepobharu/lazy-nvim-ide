# Quickstart guidelines

## TODOs
- General
    - [x] zoxide setup 
    - [ ] Override lsp config mapping preoprly
    - [x] cmp mapping C-space and more mapping config behavior <TAB> in comment check nvchad
- Git 
    - [ ] Diff view : https://github.com/sindrets/diffview.nvim?tab=readme-ov-file
- Telescopes 
    - [ ] Improve telescope git files an grep
    - [ ] Lazygit and dotfiles 
        - https://github.com/jesseduffield/lazygit/discussions/1201#discussioncomment-2546527 
        - enable file : https://github.com/kdheepak/lazygit.nvim/issues/22#issuecomment-1815426074
-  LSP
    - jsx comment not correct 
    - [x] Omnisharp dotnet setup 



## Configurations

### Examples


#### JellyDN: 
- References: https://github.com/jellydn/lazy-nvim-ide?tab=readme-ov-file#try-with-docker


```sh 
VOLUME=$(pwd)

docker run -w /root -it --rm -v $VOLUME:/root/mount alpine:latest sh -uelic '
  apk add git nodejs npm neovim ripgrep build-base make musl-dev go --update
  go install github.com/jesseduffield/lazygit@latest
  git clone https://github.com/jellydn/lazy-nvim-ide ~/.config/nvim
  nvim
'

```

Features
- CMD LINE 
- nice interface and terminal 
- Native lazy leveration with extras folder to toggle by user 
- Folding pairs guideline
- Cleaner settings on telescope help see
- Find with Telescope f cleaner
- Testing (l-t) ??  - how it works ?
- inline diagnostics 
- Notificaiton

Not have
- gx open link (+ plugin)
- Key maps 
    - resize Windows
    - Sessions saved 
    - tab change ( or use gT ? )
    - custom Cds , and copy file - or not ?


Packages use
- mason-lsp 
- toggleterm
- neo-tree 
- mini{pairs,comment}
- flash ( jump and select scope (S-f-F))


Migration idea
- lazygit install 
- disable hardtime ? 
- keymap import  before (not to conflict)
- Fugitive setup + git root support 
- Session save and start page correct
- neotree key settings change filter not to change when type 
- check keymap lazygit configure : https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
- zoxide setup
(Optional)
- git open branch url telescope 


Some keys 
- C+/ toggle terminal 

### Windows 


| Key            | Description          |
| -------------- | -----------          |
| Esc-hl         | Resize screen        |
| <leader>h/v    | Split                |
| C-\ + C-n      | Terminal Normal Mode | 


### Navigations

gx - custom function to go to links or directly to github page plugin link

- for LSP navigations see below LSP map


#### Help Pages
- C-] go to tags - section (highlighted in red) 
- C-t to go back to previous location tag

| Key        | Description                           |
| ---------- | ----------                            |
| zj / k     | Navigate fold (useful in diff split ) |



#### Files 

Nvim Tree 
| Key   | Description               |
| ---   | -----------               |
| <C-n> | Toggle NvimTree           |
| y     | Copy file name (with ext) |
| ge    | copy base name (no ext)   |

CDs 

| Key            | Description               |
| ---            | -----------               |
| <leader>cd     | Change dir zoxide plugins |
| <localleader>c | Change dir current file   |

Config file settings / debug

| Key       | Description                  |
| ---       | -----------                  |
| <local>rl | include lua (check test.lua) |

### Editing 


| Key         | Description                          |
| ----------  | ----------                           |
| C-s         | Save                                 |
| <ll> w      | Save                                 |
| Y, YY       | copy to system clipboard             |
| <ll> q      | Quit                                 |
| za/A        | fold toggle cursor / All             |
| zd          | fold delete                          |
| <leader> fm | Format whole file                    |
| <leader> fF | Toggle Format on Save Buff(!)/Global |

#### Refactoring 

1. Telescope select with tab + C+Q > send to quicklist 
2. :copen to see the list 
3. :cfdo %s/old/new/g | update  (use c flag substitude to make sure its correct)


`Markdown` - manual enable on md files table mode auto format when type the  
Tables plugin  (manual enabled)

'Notes' : Key works per buffer
| Key         | Description    |
| ----------- | -------------- |
| <leader> tm | Enable         |
| <leader> tc | Delete column  |


### Searching

`Telescope` is main searching tools using <leader>f

| Key            | Description            |
| -------------- | -----------            |
| _ft            | Find Telescope pickers |
|  quick fix history |  (C-q) retrieve again | 
| _ff            | Find Files             |
| _fh            | Help Pages             |
| _fb            | Buffers                |
| 


### Git

Telescope 
| Key            | Description                 |
| -------------- | -----------                 |
| C-A-j/k        | Next Hunk                   |
| ]c, [c         | Next Hunk                   |
| <leader>gbc    | See files                   |
| - enter        | apply commit change to file |
| - split             | compare                     | 


Fugitive 


Status View

| Key        | Description          |
| ---        | -----------          |
| <leader>gz | see git status       |
| = / > \ <  | expand toggle diff   |
| J/K        | next hunk            |
| I          | patch mode           |
| X          | discard under cursor |
| G          | Git Status           |

Commit / Files View

| Key                  | Description                |
| ---                  | -----------                |
| :Gclog               | See clean commit message   |
| :Gclog -- %          | see commit of currnt file  |
| g?                   | help                       |
| gq                   | quit blame / menu          |
| <leader> gb | Git Blame              |
| - l         | Blame Line             |
| - c         | Blame commit Telescope |
| - L       | see commit with blame info |
| C                    | go to commit of the file   |
| <enter> / o / go / O | open file / split          |




### LSP

Setup 



1. Install new LSP server
    Add new language manually 
        :MasonInstall will help download the deps 

    Next time when install in other PC add in config to ensure its installed 
        :MasonInstallAll to install all LSP from config 

2. Put the server in LSP-CONFIG loadup
    - search the server name in server
    - :help lspconfig-all

Using formatters 
`Conform` formatters will work once enable it on the file type config : supported formamter [here](https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters)
- install formatters via Mason
- enable on config
- enable format from lazy  = <leader>fm 

| Key            | Description               |
| -------------- | -----------               |
| K              | see documents params      |
| gd             | See references            |
| gr             | Reference lsp             |
| gR             | References telescope      |
| [d and ]d      | Diagnostics Jump          |
| <leader>ca     | Code action - to help fix |
| <leader>ld     | Line diagnostics          |


### AI 

#### ChatGPT 

plugin: https://www.youtube.com/watch?v=jrFjtwm-R94&ab_channel=NerdSignals 
- Act as (persona)
- Docs 
- Chat Grammar correct Bug fixes, Explain


#### Copilot 

https://github.com/CopilotC-Nvim/CopilotChat.nvim

Copilot Chat


| Key        | Description                                   |
| ---------- | ----------                                    |
| <leader>a  | toggle commands
| - m/M      | get commit message from current diff / staged |
| <enter>    | continue question enter chat                  |

 

## Keyboards

### Views

| Key          | Description                             |
| ----------   | ----------                              |
| <esc>        | toggle fold if exists else no highlight |
| VIM DEFAULTS | ----------                              |
| <C-g>        | Show current file path                  |
 
