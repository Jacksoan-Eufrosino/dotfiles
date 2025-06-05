#!/bin/bash

# Instalar pacotes essenciais
sudo apt update && sudo apt install -y zsh fzf git curl stow xclip bat

# Garantir que o Zsh esteja nos shells válidos
ZSH_PATH=$(which zsh)
if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

# Definir Zsh como shell padrão
chsh -s "$ZSH_PATH"

# Instalar Oh My Zsh sem prompt interativo
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Definir caminho customizado do Oh My Zsh
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Clonar plugins
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# Clonar e configurar tema spaceship
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo "✅ Script concluído. Reinicie o terminal para que o Zsh seja ativado como shell padrão."

