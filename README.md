# 🎬 MovieShelf

Aplicativo iOS desenvolvido com **UIKit** e **arquitetura VIPER**.  
Permite buscar filmes na API do **The Movie Database (TMDb)**, visualizar detalhes e salvar favoritos localmente.

---

## 📱 Funcionalidades

- **Busca de filmes** pelo nome.  
- **Listagem** com título, poster e nota.  
- **Detalhes completos** do filme (título, sinopse, data, nota, orçamento, receita).  
- **Favoritar** filmes e gerenciar a lista de favoritos.  
- **Armazenamento local** usando **SwiftData**.  
- Interface construída em **UIKit**.  
- **GCD (Grand Central Dispatch)** para tarefas assíncronas de rede e imagens.

---

## 🏗️ Arquitetura

O projeto segue o padrão **VIPER**:
**Camadas do projeto:**

App/ # Inicialização e injeção de dependências.  
Common/ # Utilitários.  
Core/ # Entities e Protocols.  
Infra/ # Networking e Persistense.  
Modules/ # Módulos VIPER (Search, MovieList, MovieDetail, FavoritesList).  
MovieShelfTests/ # Testes unitários e mocks.

---

## ⚙️ Instalação e Execução

1. Clone o repositório:
   -> git clone https://github.com/thalitaauad/MovieShelf.git

2. Abra o projeto:
  -> cd MovieShelf
  -> open MovieShelf.xcodeproj

4. Adicione sua API Key do TMDb no arquivo: **Infra/Networking/TMDbAPIClient.swift**
  -> Substitua o valor da variável apiKey

5. Execute o projeto

---

## 🧪 Testes Unitários

Os testes estão organizados por módulo dentro de MovieShelfTests.
Incluem:

-> Mocks para API e armazenamento local.
-> Testes de Presenter e Interactor.
-> Execute os testes com ⌘ + U no Xcode.

