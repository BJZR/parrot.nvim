# parrot.nvim

Plugin de Neovim para el lenguaje [Parrot](https://github.com/bjzr/parrot) (.pt).

## Caracteristicas

- `:ParrotRun` — transpila, compila y ejecuta el `.pt` actual en una terminal
- `:ParrotBuild` — transpila y compila a binario
- `:ParrotFmt` — formatea el codigo `.pt` actual
- Resaltado de sintaxis (Vim regex, sin dependencias)
- Deteccion automatica de archivos `.pt`

## Instalacion

### lazy.nvim

```lua
{
  dir = "/ruta/a/comunidad/parrot.nvim",
  -- o desde GitHub:
  -- "bjzr/parrot.nvim",
  config = function()
    require("parrot").setup({
      auto_fmt_on_save = false, -- true para formatear al guardar
    })
  end,
}
```

### vim-plug

```vim
Plug '/ruta/a/comunidad/parrot.nvim'
" o desde GitHub:
" Plug 'bjzr/parrot.nvim'
lua require('parrot').setup({})
```

### packer.nvim

```lua
use {
  '/ruta/a/comunidad/parrot.nvim',
  config = function()
    require('parrot').setup({})
  end,
}
```

## Requisitos

- [Parrot](https://github.com/bjzr/parrot) instalado y en el `PATH` (o configurar `parrot_cmd`)
- `gcc` para compilar los archivos generados

## Uso

```vim
:ParrotRun     " Transpila, compila y ejecuta
:ParrotBuild   " Transpila y compila a binario
:ParrotFmt     " Formatea el codigo
```

## Tree-sitter (opcional)

Para resaltado de sintaxis mas preciso, instala el parser tree-sitter manualmente:

```bash
cd /ruta/a/comunidad/tree-sitter-parrot
make          # compila parser.so
```

Luego en Neovim:

```lua
vim.treesitter.language.register('parrot', 'parrot')

local parser = vim.treesitter
  .language
  .add_registrations({
    { name = 'parrot', path = '/ruta/a/comunidad/tree-sitter-parrot/parser.so' }
  })
```

## Configuracion

```lua
require("parrot").setup({
  parrot_cmd = "parrot",         -- ruta al binario parrot
  gcc_flags = "-Wall -Wextra",   -- flags para gcc
  auto_fmt_on_save = false,      -- formatear al guardar
})
```
