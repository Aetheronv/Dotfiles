#!/usr/bin/env bash
export PATH=/usr/bin:/bin  

# Pega a janela ativa (Hyprland)
win=$(hyprctl activewindow -j | jq -r '.class // .app_id')

# Se estiver vazio ou null, usa Desktop
[ -z "$win" ] || [ "$win" = "null" ] && win="Desktop"

# Normaliza nomes
win_lc=$(echo "$win" | tr '[:upper:]' '[:lower:]')
case "$win_lc" in
    "org.gnome.nautilus") win="NAUTILUS" ;;
    *) win=$(echo "$win" | tr '[:lower:]' '[:upper:]') ;;
esac

# Limita a 20 caracteres
win="${win:0:11}"

# Quebra em letras (uma por linha)
output=""
for ((i=0; i<${#win}; i++)); do
    output+="${win:i:1}\n"
done

# Imprime
echo -e "$output"

