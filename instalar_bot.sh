#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# Script de instalación automática del BotClientesRepartidores
# Ejecutado por la app instaladora vía Termux RUN_COMMAND
# ============================================================

set -e  # Detener si hay error

echo ""
echo "========================================"
echo "  INSTALANDO BOT CLIENTES REPARTIDORES"
echo "========================================"
echo ""

# 1. Actualizar paquetes
echo "[1/6] Actualizando paquetes..."
pkg update -y > /dev/null 2>&1
pkg upgrade -y -o Dpkg::Options::="--force-confold" > /dev/null 2>&1
echo "OK"

# 2. Instalar dependencias
echo "[2/6] Instalando Node.js, git y termux-api..."
pkg install nodejs-lts git termux-api -y > /dev/null 2>&1
echo "OK"

# 3. Descargar el bot desde GitHub
echo "[3/6] Descargando bot..."
cd "$HOME"
if [ -d "Bot-clientes" ]; then
    echo "   -> Carpeta existente, actualizando..."
    cd Bot-clientes
    git pull > /dev/null 2>&1 || true
else
    git clone https://github.com/guerrerojfhl-ai/Bot-clientes.git Bot-clientes > /dev/null 2>&1
    cd Bot-clientes
fi
echo "OK"

# 4. Instalar dependencias de Node
echo "[4/6] Instalando dependencias de Node.js (puede tardar)..."
npm install > /dev/null 2>&1
echo "OK"

# 5. Configurar el secret como variable de entorno
echo "[5/6] Configurando secret..."
if ! grep -q "BOT_SECRET" "$HOME/.bashrc" 2>/dev/null; then
    echo 'export BOT_SECRET="botclientes_repartidores_2026_xK9pLmNq7vRt3wYz8bHj"' >> "$HOME/.bashrc"
fi
echo "OK"

# 6. Configurar arranque automático en Termux:Boot
echo "[6/6] Configurando arranque automático..."
mkdir -p "$HOME/.termux/boot"
cat > "$HOME/.termux/boot/start-bot.sh" << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock
export BOT_SECRET="botclientes_repartidores_2026_xK9pLmNq7vRt3wYz8bHj"
cd "$HOME/Bot-clientes"
node server.js > "$HOME/Bot-clientes/bot.log" 2>&1 &
EOF
chmod +x "$HOME/.termux/boot/start-bot.sh"
echo "OK"

# 7. Arrancar el bot ahora
echo ""
echo "Arrancando el bot..."
cd "$HOME/Bot-clientes"
export BOT_SECRET="botclientes_repartidores_2026_xK9pLmNq7vRt3wYz8bHj"
nohup node server.js > bot.log 2>&1 &

sleep 3

echo ""
echo "========================================"
echo "  ✅ INSTALACIÓN COMPLETA"
echo "========================================"
echo ""
echo "El bot está corriendo en segundo plano."
echo "Abre la app 'BotClientes' para configurarlo."
echo ""
echo "Logs: cat ~/Bot-clientes/bot.log"
echo ""