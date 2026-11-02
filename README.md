# Máquina na nuvem do Fleetly

Um GitHub Codespace que aparece no seu [Fleetly](https://fleetly.tools) como mais uma máquina, para continuar com os seus agentes (Claude Code e Codex) com o notebook desligado. Roda na sua conta do GitHub, dentro da cota grátis dela.

Não use este repositório direto: crie a máquina pelo Fleetly, em **Configurações → Máquinas → Máquina na nuvem**. O Fleetly grava o token da máquina como segredo do Codespaces (`FLEETLY_TOKEN`) e cria o codespace a partir daqui. Depois, entre no Claude, no Codex e no GitHub em **Contas desta máquina**.

O que roda: [`.devcontainer/fleetly.sh`](.devcontainer/fleetly.sh) instala o Claude Code (instalador oficial da Anthropic), o Codex (`npm i -g @openai/codex`) e o coletor do Fleetly, e liga o coletor a cada vez que o codespace liga.
