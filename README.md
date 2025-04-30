# ProcManRuby

**ProcManRuby** é uma ferramenta simples de gerenciamento de processos para sistemas Unix-like (com foco em macOS e Linux), desenvolvida em Ruby durante o desafio do passaporte da [Real Seguro Viagem](https://www.seguroviagem.srv.br/) no mes de Abril. A ferramenta permite **listar processos**, **pausar**, **continuar (resumir)** e **matar** processos usando apenas o **PID**, além de manter um **registro completo das ações** em um arquivo de log.

---

## 🧩 Funcionalidades Implementadas

- 🔍 **Listar processos** com:
  - PID
  - Usuário dono
  - Consumo de CPU (%)
  - Consumo de memória (%)
  - Tempo de execução
  - Estado do processo
  - Comando de execução

- ⏸️ **Pausar processo** (`SIGSTOP`)
- ▶️ **Continuar processo** (`SIGCONT`)
- ❌ **Matar processo** (`SIGTERM`)
- ℹ️ **Ver informações detalhadas** de um processo específico
- 📝 **Log das ações** em `procman.log`:
  - Inclui data/hora, ação realizada e PID envolvido

---

## 🛠️ Requisitos e Instalação

### 📦 Requisitos

- Ruby 3.3+
- Unix-like OS (Linux ou macOS)

### 🚀 Instalação

Clone o repositório e dê permissão de execução:

```bash
git clone https://github.com/carloshendvpm/procmanruby.git
cd procmanruby
chmod +x procman.rb
```

---

## 💡 Uso

Você pode utilizar a ferramenta de duas formas:

### 🔹 Modo direto por comando

```bash
./procman.rb list                 # Lista todos os processos
./procman.rb pause <PID>         # Pausa processo
./procman.rb resume <PID>        # Continua processo
./procman.rb kill <PID>          # Mata processo
./procman.rb info <PID>          # Mostra info detalhada
./procman.rb help                # Mostra ajuda
```

### 🔸 Modo interativo

```bash
./procman.rb interactive
```

A ferramenta exibirá um menu para você escolher as ações interativamente.

---

## 📦 Exemplo de Uso

```bash
./procman.rb list
./procman.rb pause 1234
./procman.rb resume 1234
./procman.rb kill 1234
./procman.rb info 1234
```

---

## 📁 Estrutura de Logs

As ações são registradas em `procman.log` com o seguinte formato:

```
2025-04-30 17:48:57 - Paused process - PID: 1234
2025-04-30 17:48:57 - Killed process - PID: 5678
```

---

## 📌 Justificativa da Linguagem

Embora a proposta inicial sugerisse uso de Shell Script ou C/C++, optei por Ruby pelas seguintes razões:

- Permite manipulação de processos de forma simples com chamadas diretas (`Process.kill`, etc.)
- Suporte nativo a manipulação de arquivos e data/hora para logs
- Escrita mais concisa e fácil de manter
- Facilidade para criar um modo interativo no terminal

Além disso, a ferramenta continua **aderente aos requisitos**, funcionando de forma eficaz tanto no **Linux** quanto no **macOS**.

---

## ✅ Validações Implementadas

- Verificação se o PID existe antes de aplicar sinais
- Tratamento de exceções como:
  - Processo inexistente (`Errno::ESRCH`)
  - Permissão negada (`Errno::EPERM`)
- Mensagens claras ao usuário

---
## 👨‍💻 Autor

Desenvolvido por Carlos Henrique - Full Stack Developer
