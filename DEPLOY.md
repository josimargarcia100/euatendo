# 🚀 Euatendo - Guia de Deployment

## Step 1: Autenticar no GitHub

### Opção A: GitHub Web Login (Recomendado) ⭐

```bash
gh auth login
```

Responda às perguntas:
- **What is your preferred protocol for Git operations?** → `HTTPS`
- **Authenticate Git with your GitHub credentials?** → `Y`
- **How would you like to authenticate GitHub CLI?** → `Login with a web browser`

Um navegador abrirá - confirme sua identidade e autorize.

### Opção B: Personal Access Token

1. Vá para: https://github.com/settings/tokens/new
2. Escolha **Generate new token (classic)**
3. Selecione permissões:
   - ☑️ `repo` (full control)
   - ☑️ `read:user`
4. Clique em **Generate token**
5. Copie o token

Depois execute:
```bash
gh auth login --with-token
# Cole o token quando pedido
```

### Opção C: SSH (Avançado)

```bash
# Gere a chave SSH
ssh-keygen -t ed25519 -C "seu-email@example.com"

# Copie a chave pública
cat ~/.ssh/id_ed25519.pub
```

Vá para: https://github.com/settings/ssh/new
- Cole a chave
- Clique em **Add SSH key**

## Step 2: Push para GitHub

```bash
cd /Users/josimargarcia/Documents/claude/euatendo

# Usando o script helper
/tmp/push_to_github.sh

# Ou manualmente:
git push -u origin main
```

**Resultado esperado:**
```
✅ Push realizado com sucesso!
```

Verifique: https://github.com/josimargarcia100/euatendo

## Step 3: Deploy no Railway

### 3.1 Criar Conta Railway

1. Acesse: https://railway.app
2. Clique em **GitHub Login**
3. Autorize Railway acessar seus repositórios

### 3.2 Novo Projeto

1. Na dashboard, clique em **New Project**
2. Selecione **Deploy from GitHub Repo**
3. Busque por: `euatendo`
4. Selecione: `josimargarcia100/euatendo`
5. Clique em **Deploy**

Railway começará a fazer o setup:
- Detectará o Procfile
- Criará PostgreSQL automaticamente
- Fará o build do projeto
- Iniciará os serviços

⏳ Espere 3-5 minutos para completar...

### 3.3 Configurar Environment Variables

No painel do Railway, vá para **Variables**:

#### Gerar RAILS_MASTER_KEY:

```bash
bundle exec rails secret
```

Copie a saída e configure:

| Chave | Valor |
|-------|-------|
| `RAILS_MASTER_KEY` | (sua chave secreta) |
| `RAILS_LOG_TO_STDOUT` | `true` |

### 3.4 Verificar Deployment

1. Abra **Deployments** no Railway
2. Veja o status (verde = sucesso ✅)
3. Acesse sua URL do Railway

Exemplo: `https://your-app-xyz.railway.app`

### 3.5 Primeiros Passos em Produção

```bash
# Verificar logs
gh deploy-log

# Ou no painel Railway:
# Deployments → [seu deployment] → Logs
```

## Step 4: Testar em Produção

### Acessar o App

```
https://seu-app.railway.app
```

### Fazer Login

- **Email:** `seller1@test.com`
- **Senha:** `password123`

### Testar Funcionalidades

1. **Loja Dashboard:** Veja a loja criada
2. **Fila Digital:** Clique em "Ver Fila Completa"
3. **Dashboard Manager:** Visualize KPIs
4. **Queue Real-time:** Abra em 2 abas diferentes

## Troubleshooting

### Erro: "Database not found"

Railway cria PostgreSQL automaticamente. Se não funcionar:

1. No painel Railway, vá para **Resources**
2. Clique em **Add Service** → **PostgreSQL**
3. Aguarde criação
4. Rails detectará `DATABASE_URL` automaticamente

### Erro: "RAILS_MASTER_KEY is not set"

Vá para **Variables** e adicione sua chave secreta:

```bash
bundle exec rails secret
```

### App não inicia

Verifique os logs:
1. No Railway: **Deployments** → **Logs**
2. Procure por erros de bundle ou database

### ActionCable não funciona em produção

Verifique `ACTION_CABLE_ALLOWED_REQUEST_ORIGINS`:

```
Variable: ACTION_CABLE_ALLOWED_REQUEST_ORIGINS
Value: seu-app-xyz.railway.app
```

## Próximos Passos

### ✅ Após Confirmar Funcionamento:

1. **Criar usuários de teste:**
   ```bash
   # Via console em produção
   # ou na interface do app
   ```

2. **Monitorar em produção:**
   - Verificar logs regularmente
   - Monitorar database usage
   - Configurar alertas

3. **Melhorias Contínuas:**
   - Adicionar SSL (Railway faz automaticamente)
   - Configurar backups automáticos
   - Escalar recursos se necessário

## 📚 Referências

- **Railway Docs:** https://docs.railway.app
- **Rails Docs:** https://guides.rubyonrails.org
- **ActionCable:** https://guides.rubyonrails.org/action_cable_overview.html
- **GitHub CLI:** https://cli.github.com

## 🆘 Precisa de Ajuda?

1. Verifique os logs: `railway logs`
2. Consulte a documentação Railway
3. Veja o repositório GitHub para issues

---

**Status:** ✅ Pronto para Deployment

**Tempo estimado:** 15-20 minutos

Boa sorte! 🚀
