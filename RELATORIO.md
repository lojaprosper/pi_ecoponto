# Relatório — Chat com IA no Projeto Integrador (UC10)

**Integrantes:** _preencher_
**Projeto Integrador:** Ecopontos da cidade de São Paulo (assistente EcoIA SP)
**Repositório GitHub:** _preencher_

## 1. Adaptações realizadas
- Identidade do PI (título, descrição, ícone, rótulo do banco, orientação à IA) configurada por variáveis `PI_*` no `.env`.
- Base de conhecimento (RAG): `ecopontos_sp_regras_e_servicos.txt` (regras, horários, limites, legislação) e `ecopontos_sp.csv` (126 ecopontos com subprefeitura, endereço, bairro, CEP e se recebe gesso). Fonte: página da Prefeitura de SP de 02/05/2024.
- Banco de dados de teste `ecopontos_sp` (MySQL), com as tabelas `subprefeituras` (31 registros) e `ecopontos` (126 registros), criado por `sql/01_schema_e_dados.sql`.
- Usuário `ecoia_leitura` com permissão apenas de `SELECT` nas duas tabelas (`sql/02_criar_usuario_leitura.sql`); `MYSQL_ALLOWED_TABLES=ecopontos,subprefeituras`.
- Relatórios fixos do MySQL trocados: Visão geral, Ecopontos por subprefeitura, Lista de ecopontos e Todos os ecopontos, com filtros de subprefeitura e de gesso.
- Limitação conhecida: a fonte é de maio de 2024 (126 unidades); uma publicação da Prefeitura de outubro de 2025 fala em 129.

## 2. Etapa 1 — Chat e histórico
| Teste | Resultado | Print |
|---|---|---|
| 5 perguntas na conversa 1 | | |
| Conversa 2 com novas perguntas | | |
| Voltar à conversa 1 e conferir histórico | | |
| Exportar histórico (JSON) | | |

## 3. Etapa 2 — RAG
Arquivos indexados: _mínimo 2_.
| # | Pergunta | Resposta da IA | Confere com o documento? | Observação |
|---|---|---|---|---|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |
| 4 | | | | |
| 5 | | | | |

## 4. Etapa 3 — MySQL (somente SELECT)
| # | Pergunta | SQL gerado | Resultado | Confere com o banco? |
|---|---|---|---|---|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |
| 4 | | | | |
| 5 | | | | |

## 5. Etapa 4 — SQLite (`dados_locais/historico.sqlite3`)
Prints das tabelas `conversas` e `mensagens` no SQLite Viewer: _inserir_.

1. **Finalidade de `conversas`:** guarda uma linha por conversa (`id` UUID, `titulo`, `criado_em`); é o "cabeçalho" que alimenta o seletor de conversas da barra lateral.
2. **Finalidade de `mensagens`:** guarda cada pergunta e resposta (`id`, `conversa_id`, `papel`, `conteudo`, `criado_em`), na ordem em que ocorreram.
3. **Relacionamento:** `mensagens.conversa_id` é chave estrangeira para `conversas.id` (uma conversa tem muitas mensagens — 1:N).
4. **`user` x `assistant`:** `user` é a pergunta digitada por quem usa o chat; `assistant` é a resposta gerada pela IA (também são os papéis usados na API da Groq).
5. **Nova conversa:** é inserida uma linha em `conversas` com título "Nova conversa" e data/hora; ainda sem mensagens. Na primeira pergunta, o título passa a ser os 55 primeiros caracteres dela.
6. **Persistência:** sim; o SQLite é um arquivo em disco, então as mensagens continuam lá ao fechar e reabrir a aplicação.
7. **SQLite x ChromaDB:** SQLite guarda dados estruturados e sequenciais (histórico, buscas por `id`/`conversa_id`); o ChromaDB guarda vetores (embeddings) dos trechos dos documentos e faz busca por similaridade semântica, que o SQLite não faz.

## 6. Etapa 5 — Dez perguntas do PI
Resposta esperada calculada a partir dos arquivos da base (fonte de maio de 2024). Preencha as duas últimas colunas após testar.

| # | Fonte | Pergunta | Resposta esperada | Resposta da IA | Avaliação |
|---|---|---|---|---|---|
| 1 | RAG | Qual é o horário de funcionamento dos ecopontos? | Seg a sáb, 6h às 22h; domingos e feriados, 6h às 18h | | |
| 2 | RAG | Quanto posso levar por descarga e o serviço é cobrado? | Até 1 m³ ou 20 sacos por descarga; gratuito | | |
| 3 | RAG | Quais tipos de resíduos os ecopontos aceitam? | Entulho de pequenas reformas, volumosos (sofás, colchões), podas domiciliares e recicláveis (papelão, plástico, vidro, metais); gesso só em algumas unidades | | |
| 4 | RAG | Qual é o endereço do Ecoponto Vigário Godói e ele recebe gesso? | Rua Vigário Godói, nº 480, Vila Zat, Pirituba/Jaraguá, CEP 02976-080; sim, recebe gesso | | |
| 5 | MySQL | Quantos ecopontos existem no total e quantos recebem gesso? | 126 no total; 40 recebem gesso | | |
| 6 | MySQL | Qual subprefeitura tem mais ecopontos e quantos? | Mooca, com 11 | | |
| 7 | MySQL | Quais ecopontos da subprefeitura de Santo Amaro recebem gesso? | Pedro Bueno, Vicente Rao e Vitor Manzini | | |
| 8 | MySQL | Algum ecoponto está fora de operação? | Sim: General Flores (Rua General Flores, nº 10, Bom Retiro), temporariamente | | |
| 9 | Ambos | Moro em Pinheiros e tenho 3 m³ de entulho de reforma. Onde posso levar e posso levar tudo de uma vez? | Ecopontos da Subprefeitura Pinheiros: Alto de Pinheiros, Pinheiros e Vila Madalena; não, o limite é 1 m³ (ou 20 sacos) por descarga. Não deve afirmar qual é o mais próximo | | |
| 10 | Sem resposta | Qual é o telefone direto do Ecoponto Bresser? | Não consta nos documentos nem no banco; deve dizer que não encontrou e sugerir a Central 156 | | |

Critério de avaliação: **correta**, **parcial** (faltou item ou detalhe) ou **incorreta/inventada**. Nas perguntas 5 a 8 e 9, conferir também o SQL mostrado em "SQL gerado pela IA".

## 7. Etapa 6 — Checklist final
- [ ] Streamlit inicia
- [ ] Nova conversa
- [ ] Mensagens no SQLite
- [ ] Histórico após reiniciar
- [ ] Upload e indexação
- [ ] Respostas baseadas nos documentos
- [ ] Consultas MySQL de leitura
- [ ] SQL gerado visível e conferido
- [ ] Interface adaptada ao PI
- [ ] Perguntas sem resposta tratadas

## 8. Dificuldades e soluções
| Dificuldade | Solução |
|---|---|
| | |
