# 🏆 ObjectivePay - Desafio Técnico OBJ

## 🎯 Visão Geral e Arquitetura

Este projeto implementa uma API RESTful para gestão de contas e transações, desenvolvida em **Elixir/Phoenix**. A arquitetura foca na **separação de responsabilidades** e **tolerância a falhas** inerentes ao ecossistema BEAM/OTP.

A solução segue um padrão **Command-Service Architecture**:
* **Camada de Comando/Validação:** Utiliza `Ecto.Changeset` para validação de *schema* e regras de entrada.
* **Camada de Serviço/Negócio:** Encapsula a lógica de transações, garantindo a **integridade** dos dados.
* **Camada Web (Controladores):** Responsável por roteamento, desserialização de JSON e mapeamento de *status codes* HTTP.

### ✨ Destaques Técnicos

* **Docker Compose:** Garante **isolamento** e **reprodutibilidade** completa do ambiente (App + DB) via arquitetura multi-contêiner. 
* **Conformidade de Status Codes:** Uso do **`404 Not Found`** para falhas de negócio (saldo insuficiente e conta duplicada), conforme especificação do desafio.

### 🛠️ Stack e Conteinerização

| Tecnologia | Propósito Técnico |
| :--- | :--- |
| **Elixir** | Linguagem Funcional (BEAM/OTP) |
| **Phoenix Framework** | API Gateway de alto desempenho |
| **PostgreSQL** | Banco de Dados Relacional |
| **Docker Compose** | Orquestração Multi-Contêiner para ambiente (DB + App) |

---

## 📦 Deploy e Setup (Multi-Contêiner)

O ambiente de desenvolvimento é isolado e reproduzível através do Docker Compose, expondo apenas os serviços necessários.

### Arquitetura de Contêineres:

| Serviço | Imagem Base | Porta (Host) | Função |
| :--- | :--- | :---: | :--- |
| **`app`** | Elixir/Alpine | `4000` | Processamento da API. |
| **`db`** | PostgreSQL | `5432` | Persistência de Dados Relacionais. |

### Processo de Inicialização

1. **Build e Startup:** Inicialização dos serviços e construção da imagem.

   ```bash
   docker-compose up --build -d

### Execução de Testes


1. **Run test:** Para garantir a execução correta do `mix test`, o comando deve ser rodado **diretamente na sua máquina *host*** (fora do contêiner Docker).

   ```bash
   mix test

## 🚀 Observações Finais e Pontos de Melhoria

Pensando em expandir o projeto e prepará-lo para a integração com outros sistemas, sugiro os seguintes pontos de evolução:

### 1. Auditoria e Rastreabilidade

| Foco | Melhoria Principal |
| :--- | :--- |
| **Logs de Transação** | Criação de um sistema de logs detalhado para registrar todos os passos e estados de cada movimento, fundamental para **auditoria e rastreabilidade**. |
| **Trilha Imutável** | Implementação de uma tabela dedicada para logs que sirva como **trilha de auditoria imutável** das alterações de saldo. |

### 2. Integração, Escalabilidade e Flexibilidade

| Foco | Melhoria Principal |
| :--- | :--- |
| **Adapter Pattern** | Uso do **Adapter Pattern** para isolar e **simular a integração** com sistemas externos que receberiam as transações. |
| **Escala e Assincronia** | Chamar o Adapter da integração a partir de um **Oban Job** (processamento em *background*), garantindo que a API principal seja performática e responsiva. |
| **Garantia de Execução Única** | Supervisionar o Oban Job com a biblioteca **POGO** para assegurar que o processo de integração seja executado **somente uma vez**, mesmo em ambientes de larga escala (Kubernetes com múltiplas imagens). |