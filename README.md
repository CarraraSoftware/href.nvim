# Href.Nvim

A simple mimic of href in nvim, in the format @[<path_to_file>].

The configuration available is the following:
```lua
require("href").setup({
    open_link_cmd="<some sequence of keys>",
    preview_link_cmd="<some sequence of keys>",
});
```
where 'open_link_cmd' is the command for openning the file
in a completely new window
and 'preview_link_cmd' is the command for opennig a preview of 
the file in a floating window.

But you can setup plugin using the default values:
```lua
require("href").setup(); 
```
In which case the commands will be:
```lua
open_link_cmd = "<leader>ol"
preview_link_cmd="<leader>pl"
```


