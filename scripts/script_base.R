# SCRIPT - Organização de Projetos em R | Tutorial no Youtube
# Pacotes: {fs}, {usethis} e {here}

# Instalação dos pacotes (Instalar apenas uma vez)
install.packages(c("usethis", "fs", "here"))

# Carregar Pacotes (sempre)
library(usethis)
library(fs)
library(here)

# ======================================================================
# MÓDULO 1: {usethis}
# Criação e configuração de projeto
# ======================================================================

# 1. Crie o projeto (escolha um local)
usethis::create_project("tutorial_rladies")

# 2. Note que o working directory mudou
getwd()

# 2.1 Verifique se está em um projeto
usethis::proj_get()

# Configurações adicionais
usethis::use_readme_md()
usethis::use_git()
usethis::use_github()

# .gitignore personalizado
usethis::use_git_ignore(c(
  "*.log",
  "*.tmp",
  ".Rhistory",
  ".RData"))

# ======================================================================
# MÓDULO 2: {here}
# ======================================================================

here()  # Onde estou?

# Construção de caminhos
here("data")
here("data", "raw")
here("data", "raw", "vendas.csv")

# Caminho para script
here("scripts", "01-importar.R")

# Verificar existência
file.exists(here("README.md"))
file.exists(here("data", "dados.csv"))

# ======================================================================
# MÓDULO 3: {fs}
# PRÁTICA 2
# ======================================================================

library(fs)
library(here)

# IMPORTANTE: Criar diretórios antes de criar arquivos
dir_create(here("scripts"))
dir_create(here("data"))
dir_create(here("data", "raw"))
dir_create(here("data", "clean"))
dir_create(here("outputs"))
dir_create(here("relatorios"))

# 1°) CRIAR ARQUIVOS

scripts <- c(
  "01-importar.R",
  "02-limpar.R",
  "03-analisar.R",
  "04-visualizar.R",
  "05-funcoes.R",
  "06-modelos.R")

file_create(here("scripts", scripts))

# Dados fictícios
file_create(here("data", "raw", "vendas_2024.csv"))
file_create(here("data", "raw", "clientes.xlsx"))
file_create(here("data", "raw", "produtos.txt"))

# Sem here()
file_create("data/raw/vendas_2024.csv")

# ======================================================================
# 2° LISTAR ARQUIVOS
# ======================================================================

dir_ls(here())                         # Todos os arquivos
dir_ls(here("scripts"), glob = "*.R")  # Apenas .R
dir_ls(here("data"), recurse = TRUE)   # Recursivo
dir_ls(here(), type = "directory")     # Apenas diretórios

# ======================================================================
# 3° INFORMAÇÕES DOS ARQUIVOS
# ======================================================================

file_info(here("scripts", "01-importar.R"))
file_size(here("README.md"))
file_exists(here("data", "raw", "vendas_2024.csv"))

dir_tree(here())          # função para projetos!!
dir_tree(here("data"))

# ======================================================================
# 4° COPIAR ARQUIVOS
# ======================================================================

# Arquivos
file_copy(
  path = here("data", "raw", "vendas_2024.csv"),
  new_path = here("data", "raw", "vendas_backup.csv"))

# Para pastas
dir_copy(
  path = here("data", "raw"),
  new_path = here("data", "raw_backup"))

# As funções copy não sobreescrevem os arquivos precisa usar o argumento overwrite = TRUE

# ======================================================================
# 5° MOVER, RENOMEAR, EXTENSÕES
# ======================================================================

# Copia arquivo
# Mantem o original
# Pode renomear, mudando nome

file_copy(
  path = here("data", "raw", "vendas_2024.csv"),
  new_path = here("data", "clean", "vendas_processadas.csv"))

# Move
# Não mantém o original
# Pode renomear
# Recorte e cole

file_move(
  path = here("scripts", "01-importar.R"),
  new_path = here("scripts", "01-importar-dados-vendas.R"))

# Extensões

arquivos <- dir_ls(here("data", "raw"))
path_ext(arquivos)

# Modificar a extensão do arquivo

path_ext_set("dados.xlsx", "csv")
path_file(here("data", "raw", "vendas_2024.csv"))

# ======================================================================
# 6° TEMPORÁRIOS E LIMPEZA
# ======================================================================

temp_file <- file_temp(ext = ".rds") # gera um caminho temporário
saveRDS(mtcars, temp_file)           # cria o arquivo nesse caminho
file_exists(temp_file)

path_temp()

# Deleção de arquivos

file_delete(here("data", "raw", "vendas_backup.csv")) # deleção de arquivos
dir_delete(here("data", "raw_backup")) # deleção de pastas

dir_tree(here())

# ======================================================================
# PRÁTICA 4 — Funções Avançadas
# ======================================================================

# LINKS SIMBÓLICOS, PERMISSÕES, BUSCA E MANIPULAÇÃO DE CAMINHOS

# Criar um link simbólico que aponta para o arquivo processado
# Isso permite referenciar o arquivo sem duplicar conteúdo.

link_create(
  path = here("data", "clean", "vendas_processadas.csv"),
  new_path = here("outputs", "dados_link.csv"))

# Verificar para onde o link simbólico aponta
link_path(here("outputs", "dados_link.csv"))

# Verificar as permissões do arquivo README.md
# Útil quando scripts precisam garantir permissão de leitura/escrita.
file_info(here("README.md"))$permissions

# BUSCA RECURSIVA DE ARQUIVOS

# Listar todos os arquivos que contenham "vendas" no nome (regex)
dir_ls(here(), recurse = TRUE, regexp = "vendas")

# Listar somente arquivos (exclui diretórios)
dir_ls(here(), recurse = TRUE, type = "file")

# TAMANHO DE ARQUIVOS E INSPEÇÃO

# Listar todos os arquivos dentro de data/ recursivamente
files <- dir_ls(here("data"), recurse = TRUE, type = "file")

# Obter o tamanho de cada arquivo
sizes <- file_size(files)
sizes

# Nomear os tamanhos usando somente os nomes dos arquivos
names(sizes) <- basename(files)
names(sizes)

# Ordenar do maior para o menor
sort(sizes, decreasing = TRUE)

# # METADADOS DE ARQUIVOS

# Obter informações de modificação e acesso de um script específico
info <- file_info(here("scripts", "01-gerar-dados.R"))

# Última modificação
info$modification_time

# Último acesso
info$access_time

# MANIPULAÇÃO DE CAMINHOS: ABSOLUTO, RELATIVO, NORMALIZAÇÃO

# Converter caminho para absoluto
caminho_abs <- path_abs(here("data", "raw"))

# Converter caminho absoluto para relativo ao projeto
path_rel(caminho_abs, start = here())

# Normalizar caminho removendo redundâncias (./, ../, etc.)
path_norm("./data/../data/./raw")

# Expandir o atalho ~ para o caminho real no sistema
path_expand("~/Documents")

# Obter o diretório HOME do usuário
path_home()

# Montar caminhos de forma segura concatenando partes
path(here("data"), "raw", "arquivo.csv")

# Prática 5

# Abra o README.md e preecnha com o conteúdo dos slides
