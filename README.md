# Euatendo - Fila Digital para Lojas

Sistema de fila digital em tempo real para gerenciamento de atendimentos em lojas físicas pequenas e independentes.

## 🎯 Funcionalidades

### SPEC-001: Digital Queue (Lista da Vez)
- ✅ Fila digital em tempo real via WebSockets (ActionCable)
- ✅ Posicionamento automático na fila
- ✅ Indicação de vendedor sendo atendido
- ✅ Botões "Iniciar Atendimento" / "Finalizar com Venda" / "Finalizar sem Venda"

### SPEC-002: Dashboard
- ✅ KPI: Taxa de Conversão (vendas/atendimentos)
- ✅ KPI: Total de Atendimentos
- ✅ Gráfico de Atendimentos por Hora
- ✅ Tabela de Performance de Vendedores
- ✅ Filtros de Período

### Extras
- ✅ Autenticação com Devise
- ✅ Autorização por Roles (Seller, Manager, Owner)
- ✅ Background Job para limpeza de atendimentos antigos (>4h)
- ✅ Real-time updates com ActionCable

## 🛠️ Stack Técnico

- **Backend**: Ruby on Rails 8.1
- **Frontend**: Rails Views + TailwindCSS + Hotwire (Turbo + Stimulus)
- **Database**: PostgreSQL (Railway) / SQLite3 (Desenvolvimento)
- **Real-time**: ActionCable (WebSockets)
- **Background Jobs**: Solid Queue
- **Auth**: Devise
- **Deploy**: Railway.com

## 🚀 Instalação & Setup

### Desenvolvimento

1. Clone o repositório:
```bash
git clone <seu-repo>
cd euatendo
```

2. Instale dependências:
```bash
bundle install
bundle exec rails tailwindcss:install
```

3. Configure o banco de dados:
```bash
bundle exec rails db:create
bundle exec rails db:migrate
```

4. Inicie o servidor:
```bash
./bin/dev
# ou manualmente:
bundle exec rails server
```

5. Acesse: http://localhost:3000

### Environment Variables

**Desenvolvimento**: `.env` (opcional)
**Produção (Railway)**: Configure via painel do Railway

Variáveis necessárias:
- `DATABASE_URL` (auto-configurado pelo Railway)
- `RAILS_MASTER_KEY` (gerar com `rails secret`)
- `ACTION_CABLE_ALLOWED_REQUEST_ORIGINS` (seu domínio no Railway)

## 📊 Modelos

### User
```ruby
has_many :stores, dependent: :destroy
has_many :attendances, foreign_key: 'seller_id'
has_many :seller_queue_statuses, foreign_key: 'seller_id'
ROLES = %w[seller manager owner]
```

### Store
```ruby
belongs_to :user
has_many :attendances, dependent: :destroy
has_many :seller_queue_statuses, dependent: :destroy
```

### Attendance
```ruby
belongs_to :store
belongs_to :seller, class_name: 'User'
RESULTS = %w[sale no_sale pending]
```

### SellerQueueStatus
```ruby
belongs_to :store
belongs_to :seller, class_name: 'User'
STATUSES = %w[idle attending paused]
```

## 🔄 Fluxo de Uso

### Para Vendedores:
1. Login com email/senha
2. Entrar na fila da loja
3. Aguardar sua vez (indicador de posição)
4. Quando chamar: "Iniciar Atendimento"
5. Finalizar com "Vendeu" ou "Não Vendeu"
6. Sistema registra a venda e reseta para "Sair" fila

### Para Gerentes/Donos:
1. Login com role "manager" ou "owner"
2. Acessar Dashboard da loja
3. Ver KPIs em tempo real:
   - Taxa de conversão
   - Total de atendimentos
   - Performance por vendedor
   - Gráfico hourly

## 📁 Estrutura

```
euatendo/
├── app/
│   ├── models/          # User, Store, Attendance, SellerQueueStatus
│   ├── controllers/     # StoresController, AttendancesController, QueuesController, DashboardsController
│   ├── views/          # Views com TailwindCSS
│   ├── channels/       # QueueChannel (ActionCable)
│   ├── jobs/           # CleanupStaleAttendancesJob
│   └── javascript/
│       └── controllers/ # Stimulus: queue_updater_controller
├── config/
│   ├── routes.rb
│   ├── cable.yml       # ActionCable (async em dev, solid_cable em prod)
│   ├── schedule.yml    # Job scheduling
│   └── importmap.rb
├── db/
│   ├── migrate/        # Migrações
│   └── schema.rb
├── lib/tasks/
│   └── scheduler.rake  # Rake tasks para jobs
├── Procfile            # Processos para Railway
└── README.md
```

## 🔧 Configurações Importantes

### ActionCable (Real-time)
- **Dev**: Async adapter (em processo)
- **Prod**: Solid Cable (database-backed)

Ativar em views:
```erb
<div data-controller="queue-updater" data-queue-updater-store-id-value="<%= @store.id %>">
  <%= render 'shared/queue_widget', store: @store %>
</div>
```

### Background Jobs
```bash
# Rodar job de limpeza manualmente
bundle exec rake scheduler:run_once

# Em produção, Railway executará automaticamente
```

## 🚀 Deploy no Railway

### 1. Conectar Repositório
- Vá para [Railway.com](https://railway.app)
- Novo Projeto > Deploy from GitHub Repo
- Selecione seu repositório

### 2. Configurar Variáveis
No painel do Railway, configure:

```
RAILS_MASTER_KEY=<sua-chave-secreta>
DATABASE_URL=<auto-preenchido>
RAILS_LOG_TO_STDOUT=true
```

### 3. Procfile
Railway automaticamente detecta `Procfile` e inicia:
- `web`: Rails server
- `worker`: Solid Queue (background jobs)
- `cable`: Solid Cable (ActionCable)

### 4. Database
- Crie um serviço PostgreSQL no Railway
- Ou use Postgres remoto (Railway adiciona `DATABASE_URL` automaticamente)

### 5. Deploy
```bash
# Local: commit e push
git add .
git commit -m "Deploy para Railway"
git push origin main

# Railway automaticamente fará:
# - bundle install
# - rails db:migrate
# - rails assets:precompile
# - inicia os processos do Procfile
```

## 🧪 Testes

```bash
# Rodar testes
bundle exec rails test

# Com coverage
bundle exec rails test --coverage
```

## 📝 Logs & Debug

**Local:**
```bash
tail -f log/development.log
```

**Railway:**
- Vá ao painel do projeto
- Abra "Logs" para ver logs de produção

## 🔒 Segurança

- Devise para autenticação
- CSRF protection via Rails
- ActionCable WebSocket seguro
- SQL injection prevention via ORM
- Environment variables para secrets

## 📞 Suporte

Para dúvidas sobre a implementação:
- Funcionalidades: Veja SPEC-001 e SPEC-002 acima
- Railway docs: https://docs.railway.app
- Rails docs: https://guides.rubyonrails.org

## 📄 Licença

MIT License

---

**Criado com ❤️ usando Rails 8 + Hotwire + ActionCable**
