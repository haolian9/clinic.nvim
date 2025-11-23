an example to integrate external linters into nvim

## features
* lint current content of a buffer, no need to save first
* utilize vim.diagnostic, rather than flooding qf/loclist directly
* run multiple linters in parallel by spawning processes
* no going through lsp protocol, vim.lsp
* supports: ruff, selene, shellcheck

## status
* just works
* feature-complete
* merely an example

## prerequisites
* linux
* nvim 0.11.*
* haolian9/infra.nvim
* haolian9/cthulhu.nvim
* ruff, shellcheck, selene

## usage
* `:lua require'cotton'.lint()`

---
this project used to be called `cotton`, so:

弹棉花啊弹棉花  
半斤棉弹成八两八哟  
旧棉花弹成了新棉花哟  
弹好了棉被那个姑娘要出嫁  
哎哟勒哟勒　哎哟勒哟勒  
弹好了棉被那个姑娘要出嫁  
那个姑娘要出嫁  
弹棉花罗弹棉花  
半斤棉弹出八两八哟  
旧棉花弹成了新棉花哟  
弹好了棉被姑娘要出嫁  
