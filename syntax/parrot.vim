if exists("b:current_syntax")
  finish
endif

syn keyword parrotImport import
syn keyword parrotType      type
syn keyword parrotMacro     macro
syn keyword parrotFunc      func
syn keyword parrotStruct    struct
syn keyword parrotUnion     union
syn keyword parrotEnum      enum
syn keyword parrotReturn    return
syn keyword parrotIf        if
syn keyword parrotElif      elif
syn keyword parrotElse      else
syn keyword parrotWhile     while
syn keyword parrotFor       for
syn keyword parrotSwitch    switch
syn keyword parrotCase      case
syn keyword parrotDefault   default

syn keyword parrotTypeName  i8 u8 i16 u16 i32 u32 i64 u64 i128 u128
syn keyword parrotTypeName  f32 f64 f80
syn keyword parrotTypeName  string char bool null void

syn match   parrotNumber    "\<\d\+\(\.\d\+\)\?\>"
syn region  parrotString    start='"' end='"'

syn keyword parrotBoolean   true false

syn match   parrotComment   "//.*$"

syn match   parrotMacroBody ".*$" contained
syn region  parrotMacroDef  start="macro" end="$" contains=parrotMacro,parrotIdentifier,parrotMacroBody

syn match   parrotIdentifier "[a-zA-Z_][a-zA-Z0-9_]*"

hi def link parrotImport    Include
hi def link parrotType      Keyword
hi def link parrotMacro     PreProc
hi def link parrotFunc      Keyword
hi def link parrotStruct    Structure
hi def link parrotUnion     Structure
hi def link parrotEnum      Structure
hi def link parrotReturn    Keyword
hi def link parrotIf        Conditional
hi def link parrotElif      Conditional
hi def link parrotElse      Conditional
hi def link parrotWhile     Repeat
hi def link parrotFor       Repeat
hi def link parrotSwitch    Keyword
hi def link parrotCase      Label
hi def link parrotDefault   Label
hi def link parrotTypeName  Type
hi def link parrotNumber    Number
hi def link parrotString    String
hi def link parrotBoolean   Boolean
hi def link parrotComment   Comment
hi def link parrotMacro     PreProc
hi def link parrotMacroBody PreProc

let b:current_syntax = "parrot"
