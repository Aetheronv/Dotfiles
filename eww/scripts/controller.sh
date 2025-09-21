#!/usr/bin/env bash

# Pega todos os dispositivos de bateria disponíveis via upower
BATTERY_PATH=$(upower -e | grep battery | head -n 1)

if [ -n "$BATTERY_PATH" ]; then
    # Pega a porcentagem e remove o %
    PERCENT=$(upower -i "$BATTERY_PATH" | grep -E "percentage" | awk '{print $2}' | tr -d '%')
    
    # Verifica se PERCENT é um número
    if [[ "$PERCENT" =~ ^[0-9]+$ ]]; then
        echo "$PERCENT"
    else
        echo "0"
    fi
else
    # Se não encontrou, retorna 0
    echo "0"
fi

