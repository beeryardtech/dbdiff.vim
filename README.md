# dbdiff.vim
Ever want to compare previous versions of your dropbox file right inside VIM!!?? Now you can!

## Installing
The plugin depends on [dbdiff.py], a collection of libs and a CLI script.


### Vundle
```vimscript
" Add bundle to .vimrc
Bundle 'beeryardtech/dbdiff.vim'
:source ~/.vimrc
:BundleInstall
:DBDiffInstall
```

### Manually
```sh
git clone https://github.com/beeryardtech/dbdiff.vim ~/.vim/bundle/dbdiff.vim
cd ~/.vim/bundle/dbdiff.vim
git submodule init

# Then run install command
vim +DBDiffInstall
```

