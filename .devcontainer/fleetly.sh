#!/bin/bash
# Máquina na nuvem do Fleetly: instala o Claude Code, o Codex e o coletor (instalar) e sobe o coletor (ligar).
# O log fica em ~/.fleetly/maquina.log.
CENTRAL="${FLEETLY_CENTRAL:-https://ai.fleetly.tools}"
COLETOR="$HOME/.fleetly/collector/fleetly-collector.mjs"
mkdir -p "$HOME/.fleetly"
exec >>"$HOME/.fleetly/maquina.log" 2>&1
echo "--- $(date '+%F %T') $1"

ligar() {
  [ -f "$COLETOR" ] || { echo "coletor ainda não instalado"; return 0; }
  # o vigia religa o coletor quando ele sai (atualização automática); um vigia novo encerra o anterior
  setsid nohup node "$COLETOR" supervise >/dev/null 2>&1 < /dev/null &
  echo "coletor ligado"
}

if [ "$1" = instalar ]; then
  command -v claude >/dev/null || [ -x "$HOME/.local/bin/claude" ] || curl -fsSL https://claude.ai/install.sh | bash
  command -v codex >/dev/null || npm i -g @openai/codex
  if [ -n "${FLEETLY_TOKEN:-}" ]; then
    curl -fsSL "$CENTRAL/install.sh" | bash -s -- --token "$FLEETLY_TOKEN" < /dev/null || echo "falhou a instalação do coletor"
  else
    echo "sem FLEETLY_TOKEN: o coletor não foi instalado (crie a máquina pelo Fleetly)"
  fi
  exit 0 # o postStartCommand liga o coletor logo depois
fi
[ "$1" = ligar ] && ligar
exit 0
