# SCRIPT - Organização de Projetos em R | Tutorial no Youtube
# Pacotes: {fs}, {usethis} e {here}

# Instalação dos pacotes (Instalar apenas uma vez) ------------------------

install.packages(c("usethis", "fs", "here"))

# Carregar Pacotes (sempre) -----------------------------------------------

library(usethis)
library(fs)
library(here)


# Módulo 1: {usethis} ----------------------------------------------------

# Prática 1: Criação e configuração de projeto ----------------------------

# 1. Crie o projeto (escolha um local) - Mostrar onde definir o local

usethis::create_project("tutorial_rladies")

# 2. Note que o working directory mudou
getwd()

# 2.1. Veja que está em um projeto
usethis::proj_get()

# Configurações adicionais -------------------------------------

# 3. Adicionar README
usethis::use_readme_md()

# 3.1. Inicializar Git 
usethis::use_git()

# 3.2. Inicializar GitHub
usethis::use_github()

# 3.3. Criar .gitignore personalizado
usethis::use_git_ignore(c(
  "*.log",
  "*.tmp",
  ".Rhistory",
  ".RData"))

# Módulo 2 - {here} -------------------------------------------------------

library(here)

# 1. Onde estou?
here()

# 2. Construir caminhos
here("data")
here("data", "raw")
here("data", "raw", "vendas.csv")

# 3. Caminho para script
here("scripts", "01-importar.R")

# 4. Verificar existência
file.exists(here("README.md"))
file.exists(here("data", "dados.csv"))


# Módulo 3: {fs} ----------------------------------------------------------

# PRÁTICA 2 ---------------------------------------------------------------

# 1°) CRIAR ARQUIVOS

library(fs)
library(here)

# Scripts numerados
scripts <- c(
  "01-importar.R", "02-limpar.R",
  "03-analisar.R", "04-visualizar.R")
file_create(here("scripts", scripts))

# Dados fictícios
file_create(here("data", "raw", "vendas_2024.csv"))
file_create(here("data", "raw", "clientes.xlsx"))
file_create(here("data", "raw", "produtos.txt"))


# 2° LISTAR ARQUIVOS

# Todos os arquivos
dir_ls(here())

# Apenas .R
dir_ls(here("scripts"), glob = "*.R")

# Recursivo
dir_ls(here("data"), recurse = TRUE)

# Apenas diretórios
dir_ls(here(), type = "directory")

# 3° INFORMAÇÕES DOS ARQUIVOS

# Detalhes
file_info(here("scripts", "01-importar.R"))

# Tamanho
file_size(here("README.md"))

# Existe?
file_exists(here("data", "raw", "vendas_2024.csv"))

# Visualizar árvore
dir_tree(here())
dir_tree(here("data"))

# 4° COPIAR ARQUIVOS

# Copiar arquivo
file_copy(
  path = here("data", "raw", "vendas_2024.csv"),
  new_path = here("data", "raw", "vendas_backup.csv"))

# Copiar diretório
dir_copy(
  path = here("data", "raw"),
  new_path = here("data", "raw_backup"))


# 5° MOVER/RENOMEAR E EXTENSÕES

# Simular processamento: raw → clean
file_copy(
  path = here("data", "raw", "vendas_2024.csv"),
  new_path = here("data", "clean", "vendas_processadas.csv"))

# Renomear script
file_move(
  path = here("scripts", "01-importar.R"),
  new_path = here("scripts", "01-importar-dados-vendas.R"))

# Ver extensões
arquivos <- dir_ls(here("data", "raw"))
path_ext(arquivos)

# Mudar extensão
path_ext_set("dados.xlsx", "csv")

# Apenas nome do arquivo
path_file(here("data", "raw", "vendas_2024.csv"))


# 6° TEMPORÁRIOS E LIMPEZA

# Arquivo temporário
temp_file <- file_temp(ext = ".rds")
print(temp_file)

# Testar salvamento
saveRDS(mtcars, temp_file)
file_exists(temp_file)

# Diretório temporário
path_temp()

# Deletar backup
file_delete(here("data", "raw", "vendas_backup.csv"))
dir_delete(here("data", "raw_backup"))

# Verificação final
dir_tree(here())



# PRÁTICA 4 ---------------------------------------------------------------

# Indo além: mais funções

# 1° LINKS SIMBÓLICOS E PERMISSÕES

# Criar link para dados grandes
link_create(
  path = here("data", "clean", "vendas_processadas.csv"),
  new_path = here("outputs", "dados_link"))

# Ver para onde aponta
link_path(here("outputs", "dados_link"))

# Ver permissões
file_info(here("README.md"))$permissions

# 2° BUSCA E COMPARAÇÃO

# Buscar padrão específico
dir_ls(here(), recurse = TRUE, regexp = "vendas")

# Buscar por tipo
dir_ls(here(), recurse = TRUE, type = "file")

# Comparar tamanhos
files <- dir_ls(here("data"), recurse = TRUE, type = "file")
sizes <- file_size(files)
names(sizes) <- basename(files)
sort(sizes, decreasing = TRUE)

# Metadados - última modificação
info <- file_info(here("scripts", "01-gerar-dados.R"))
info$modification_time
info$access_time

# 3° CONVERSÃO E UTILITÁRIOS

# Absoluto para relativo
caminho_abs <- path_abs(here("data", "raw"))
path_rel(caminho_abs, start = here())

# Normalizar caminho
path_norm("./data/../data/./raw")

# Expandir ~
path_expand("~/Documents")

# Home directory
path_home()

# Juntar caminhos
path(here("data"), "raw", "arquivo.csv")

# Abra o README.md e adicione: --------------------------------------------

# Copiar dos slides
