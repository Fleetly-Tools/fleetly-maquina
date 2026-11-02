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
  # o Node que o instalador usou (fica no service.json); senão, o do PATH
  local node; node=$(sed -n 's/.*"node": *"\([^"]*\)".*/\1/p' "$HOME/.fleetly/collector/service.json" 2>/dev/null | head -1)
  [ -x "$node" ] || node=$(command -v node)
  # o vigia religa o coletor quando ele sai (atualização automática); um vigia novo encerra o anterior.
  # setsid -f: numa sessão própria, para não morrer quando o comando de partida do codespace termina
  setsid -f "$node" "$COLETOR" supervise < /dev/null >> "$HOME/.fleetly/maquina.log" 2>&1
  sleep 3
  pgrep -f "fleetly-collector.mjs supervise" >/dev/null && echo "coletor ligado ($node)" || echo "o coletor não ficou de pé"
}

if [ "$1" = instalar ]; then
  command -v claude >/dev/null || [ -x "$HOME/.local/bin/claude" ] || curl -fsSL https://claude.ai/install.sh | bash
  command -v codex >/dev/null || npm i -g @openai/codex
  if [ -n "${FLEETLY_TOKEN:-}" ]; then
    # baixa antes de rodar: com "curl | bash < /dev/null", o bash leria o script do vazio
    curl -fsSL "$CENTRAL/install.sh" -o /tmp/fleetly-install.sh \
      && bash /tmp/fleetly-install.sh --token "$FLEETLY_TOKEN" < /dev/null \
      || echo "falhou a instalação do coletor"
  else
    echo "sem FLEETLY_TOKEN: o coletor não foi instalado (crie a máquina pelo Fleetly)"
  fi
  # no Codespaces, o postStartCommand não espera esta instalação: o instalador já deixa o coletor ligado
  exit 0
fi
[ "$1" = ligar ] && ligar
exit 0
