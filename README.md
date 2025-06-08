Cada subpasta é chamada de **pacote** pelo Stow, e deve conter os arquivos com a **mesma estrutura que você deseja ver no `$HOME`**.

---

## ⚙️ Como usar

```bash
git clone https://github.com/Jacksoan-Eufrosino/dotfiles.git
cd dotfiles
./setup_new.sh
```

##  Remover um symlink

Navegue até a pasta que contém as subpastas dos dotfiles (ex: `dotfiles/`):

```bash
cd dotfiles
stow -D zsh
```

