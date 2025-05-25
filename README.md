Cada subpasta é chamada de **pacote** pelo Stow, e deve conter os arquivos com a **mesma estrutura que você deseja ver no `$HOME`**.

---

## ⚙️ Como usar

### 1. Instalar os dotfiles (symlinks)

Navegue até a pasta que contém as subpastas dos dotfiles (ex: `dotfiles/`):

```bash
cd dotfiles
stow *
```


### 2. Remover um symlink

Navegue até a pasta que contém as subpastas dos dotfiles (ex: `dotfiles/`):


```bash
cd dotfiles
stow -D zsh
```

