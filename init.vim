" Always show absolute + relative numbers in editable buffers
set number
set norelativenumber  " Disable relative numbers completely
" Set the leader key to Space
let mapleader = " "
set mouse=a " Enable mouse 
" Always force absolute-only line numbers
augroup AbsoluteNumbers
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter,FocusGained * setlocal number norelativenumber
augroup END

" Hide ~ symbols on unused lines
set fillchars=eob:\ 

" Configurar el gestor de plugins Vim-Plug
call plug#begin('~/.vim/plugged')

" Plugin list
Plug 'preservim/nerdtree'
Plug 'voldikss/vim-floaterm'
Plug 'ayu-theme/ayu-vim'
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'toppair/peek.nvim', { 'do': 'deno task --quiet build:fast' }
Plug 'nanotech/jellybeans.vim'
Plug 'vimlab/split-term.vim'
Plug 'f-person/git-blame.nvim'
Plug 'shaunsingh/nord.nvim'
Plug 'MeanderingProgrammer/render-markdown.nvim'
Plug 'ryanoasis/vim-devicons'  " Make sure nvim-web-devicons is installed
Plug 'sainnhe/gruvbox-material'
Plug 'dart-lang/dart-vim-plugin'
Plug 'nvim-flutter/flutter-tools.nvim'
Plug 'stevearc/dressing.nvim' " better UI for device selection
Plug 'romgrk/barbar.nvim'  " Tabline plugin for better tab management

" C# support
Plug 'seblyng/roslyn.nvim'              " The modern C# LSP
Plug 'Hoffs/omnisharp-extended-lsp.nvim' " Improves 'Go to Definition' for libraries
Plug 'NicholasMata/nvim-dap-cs'    " Better .NET Debugging integration

" LSP Support & Autocompletion
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'  " Easy LSP installation
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'mfussenegger/nvim-jdtls'  " Java LSP
Plug 'hrsh7th/nvim-cmp'  " Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path' " <--- ADDED: Path source for nvim-cmp (just in case)
Plug 'L3MON4D3/LuaSnip'  " Snippets
Plug 'saadparwaiz1/cmp_luasnip'

" Treesitter (Syntax Highlighting & Better Parsing)
Plug 'nvim-treesitter/nvim-treesitter',  {'do': ': TSUpdate'}

" Debugging (DAP)
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'mfussenegger/nvim-java-dap'

" File Navigation & Search
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Git Integration
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'

" UI Improvements
Plug 'folke/trouble.nvim'  " Better error list
Plug 'hoob3rt/lualine.nvim'  " Better status line

call plug#end()

autocmd FileType NERD_tree,neo-tree,peek,floatterm setlocal norelativenumber
lua << EOF
require('render-markdown').setup({

})
EOF

let g:floaterm_shell = '/bin/bash'

" Change the arrow for closed (expandable) folders
let g:NERDTreeDirArrowExpandable = '▶'  " triangle pointing right

" Change the arrow for open (collapsible) folders
let g:NERDTreeDirArrowCollapsible = '▼'  " triangle pointing down

let g:NERDTreeIndicatorMap = {
  \ "Modified"  : "✹",
  \ "Selected"  : "❯",
  \ }

lua << EOF
require('peek').setup({
  app = 'browser',  -- switch from webview to browser
  auto_load = true,
  close_on_bdelete = true,
  syntax = true,
  theme = 'dark',
  update_on_change = true,
  filetype = { 'markdown' },
})
vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
EOF

" ENABLE MARKDOWN PLUGIN FOR MARKDOWN FILES
let g:mkdp_filetypes = ['markdown']

" NERDTree configuration
function! FindAndRevealPath()
  let l:current_file = expand('%:p:h')
  let g:NERDTreeShowHidden = 1 " show hidden files
  execute 'NERDTreeFind' l:current_file
  normal! zx
endfunction
autocmd VimEnter * call FindAndRevealPath()
autocmd VimEnter * NERDTree

" Airline tabline configuration
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

" Barbar tabline plugin configuration
lua << EOF
require('barbar').setup({
  icons = {
    buffer_index = true,  -- Show the buffer number
    filetype = { enabled = true }  -- Enable filetype icons (requires nvim-web-devicons)
  },
  highlight = {
    -- Force dark tab colors
    active = { guibg = "#3c3836", guifg = "#ebdbb2" },  -- Selected tab with light text
    inactive = { guibg = "#2e2e2e", guifg = "#b3b3b3" },  -- Inactive tabs with lighter gray text
    separator = { guibg = "#2e2e2e", guifg = "#b3b3b3" },  -- Tab separator color
  }
})
EOF

" 1. IDE-style shortcuts
" Open 'Right-Click' menu for Getters, Setters, and Wrapping Widgets
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>

" Rename variable/class everywhere (Refactor)
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>

" Go to definition (like Ctrl+Click)
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>

" Show documentation (like hovering with a mouse)
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>

" Tab navigation mappings
nnoremap <Leader>t :tabnew<CR>:NERDTree<CR>  " Open new tab
nnoremap <Leader>n :tabnext<CR>  " Next tab
nnoremap <Leader>p :tabprevious<CR>  " Previous tab
nnoremap <Tab> :BufferNext<CR>  " Next tab (barbar)
nnoremap <S-Tab> :BufferPrevious<CR>  " Previous tab (barbar)

" Floating terminal
nnoremap <C-t> :FloatermToggle<CR>

" Create a new floaterm instance
nnoremap <C-n> :FloatermNew<CR>

" Switch to the next floaterm tab
nnoremap <C-o> :FloatermNext<CR>

" Switch to the previous floaterm tab
nnoremap <C-p> :FloatermPrev<CR>

" Map Esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Kill all floaterm instances
nnoremap <C-q> :FloatermKillAll<CR>

" Split terminal window on startup
function! OpenTerminalAndSplit()
  wincmd l
endfunction
autocmd VimEnter * call OpenTerminalAndSplit()

" General settings
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set mouse=a
set showtabline=2  " Always show tabline
set cursorline

" --- DART/FLUTTER FIX ---
" Force spaces ONLY for Dart files so the formatter doesn't delete commas
autocmd FileType dart setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Git Blame
let g:gitblame_enabled = 1

" Enable true colors
if has('termguicolors')
  set termguicolors
endif

" Example: enable bold and italic
let g:nord_bold = 1
let g:nord_italic = 1

" Set the colorscheme
colorscheme nord

" Disable the startup message disappearing too quickly
set shortmess+=I

" Initialize Mason
" Rust analyzer
" Initialize Mason
lua << EOF
require('mason').setup({
  registries = {
    'github:mason-org/mason-registry',    -- The default one
    'github:Crashdummyy/mason-registry', -- This contains the Roslyn server
  },
})

require('mason-lspconfig').setup({
  -- Remove 'roslyn' from this list. 
  -- We manage it via the roslyn.nvim plugin and the community registry instead.
  ensure_installed = { 'rust_analyzer', 'ts_ls', 'jdtls', 'pyright' },
})
EOF


lua << EOF
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = true,
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable("rust_analyzer")
EOF


lua << EOF
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }),
})
EOF


" Normal Mode Duplicate single line (Current setup)
nnoremap <C-b> yyp

" Copy and paste current line below 
vnoremap <C-b> yP
" Insert mode: Duplicate line and insert at the end of the new line
inoremap <C-b> <Esc>yypA

" Move visual selection up or down with Alt+j / Alt+k
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ============================================
" LSP Diagnostics auto-popup on cursor / click
" ============================================

" Faster popup: trigger CursorHold quickly
set updatetime=250

" Automatically show diagnostics in a floating window
lua << EOF
-- Function to show diagnostics for current line
local show_diagnostics = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = line, severity = { min = vim.diagnostic.severity.WARN } })
  if #diagnostics > 0 then
    vim.diagnostic.open_float(nil, { focus = false })
  end
end

-- Trigger on cursor hover (keyboard) or click (mouse)
vim.api.nvim_create_autocmd({"CursorHold", "CursorMoved", "CursorMovedI"}, {
  callback = show_diagnostics
})
EOF

lua << EOF
-- 1. Setup Roslyn (C# LSP)
require('roslyn').setup({
  args = {
    '--logLevel=Information',
    '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
    '--stdio',
  },
  config = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
      local opts = { buffer = bufnr }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end,
  },
})

-- 2. Setup .NET Debugging (DAP)
-- Use 'dap-cs' instead of 'dap-dotnet'
require('dap-cs').setup({
  -- If you installed netcoredbg via Mason, it's usually in your path.
  -- If not, you can specify the absolute path here.
  netcoredbg = {
    path = "netcoredbg" 
  }
})
EOF

lua << EOF
require("flutter-tools").setup({
  lsp = {
    enabled = true,
  },
})
EOF

