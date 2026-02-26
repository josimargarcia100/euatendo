# Euatendo 📱

Plataforma SaaS de Gestão de Varejo Físico — Fila digital de atendimento e indicadores de conversão em tempo real.

## Stack

- **Framework**: Ruby on Rails 8.1+
- **Database**: PostgreSQL (Railway)
- **Frontend**: Rails Views + TailwindCSS + Hotwire (Turbo + Stimulus)
- **Auth**: Devise
- **Realtime**: ActionCable

## Setup Local

### Pré-requisitos

- Ruby 3.3+
- Rails 8.1+
- PostgreSQL 15+
- Node.js 18+

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/josimargarcia100/euatendo.git
cd euatendo
```

2. **Instale as dependências**
```bash
bundle install
yarn install
```

3. **Configure o banco de dados**
```bash
cp .env.example .env.local
# Edite .env.local com suas credenciais do PostgreSQL
```

4. **Crie o banco e execute as migrations**
```bash
rails db:create
rails db:migrate
```

5. **Inicie o servidor**
```bash
./bin/dev
# Ou separadamente:
# rails server (porta 3000)
# ./bin/rails tailwindcss:watch (em outro terminal)
```

Acesse: **http://localhost:3000**

---

## Deploy no Railway

### 1. Crie uma conta Railway
- Acesse [railway.app](https://railway.app)
- Faça login com GitHub (josimargarcia100)

### 2. Crie um novo projeto
- Clique em "New Project"
- Selecione "Deploy from GitHub"
- Conecte o repositório `euatendo`

### 3. Adicione PostgreSQL
- No painel do projeto, clique "Add Service"
- Selecione "PostgreSQL"
- Railway criará o banco automaticamente

### 4. Configure variáveis de ambiente
No painel do Railway, em "Variables":
```
RAILS_ENV=production
SECRET_KEY_BASE=<gere com: rails secret>
RAILS_LOG_TO_STDOUT=true
```

(DATABASE_URL será criado automaticamente pelo PostgreSQL)

### 5. Deploy
- Railway faz deploy automático ao fazer push para a branch padrão (main)
- Acesse a URL gerada (ex: `https://euatendo-production.railway.app`)

---

## Estrutura do Projeto

```
euatendo/
├── app/
│   ├── models/          # User, Store, Attendance, etc
│   ├── controllers/     # Controllers principais
│   └── views/           # Views ERB + Tailwind
├── config/              # Rails config
├── db/                  # Migrations
├── test/                # Testes
└── Gemfile             # Dependências
```

## Models

- **User** — Vendedores, gerentes e donos de loja
- **Store** — Lojas/filiais
- **Attendance** — Registros de atendimento
- **SellerQueueStatus** — Status de cada vendedor na fila

## Features (MVP)

### SPEC-001: Lista da Vez + Taxa de Conversão
- [ ] Fila digital em tempo real
- [ ] Botão iniciar/finalizar atendimento
- [ ] Cálculo automático de conversão
- [ ] Modo automático (round-robin)

### SPEC-002: Dashboard de Indicadores
- [ ] KPI cards (conversão, atendimentos, etc)
- [ ] Gráfico de atendimentos por hora
- [ ] Tabela de performance por vendedor
- [ ] Filtros por período

## Testes

```bash
rails test                    # Executa todos os testes
rails test test/models        # Apenas testes de models
rails test:system             # Testes de sistema (navegador)
```

## Troubleshooting

### Erro: "could not find driver (PG::Error)"
```bash
gem install pg -- --with-pg-config=/opt/homebrew/bin/pg_config
bundle install
```

### Erro: "database does not exist"
```bash
rails db:create
rails db:migrate
```

### Rails server não inicia
```bash
rails db:reset
./bin/dev
```

---

## Roadmap

**Fase 1 (MVP)**: Lista da Vez + Dashboard
**Fase 2**: Motivos de Perda, Metas, Gamificação
**Fase 3**: Multilojas, Integrações, App nativo

---

## Suporte

Para dúvidas ou issues, abra uma issue no GitHub.

---

**Desenvolvido com ❤️ para pequenos lojistas**
