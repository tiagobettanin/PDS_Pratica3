# PDS - Atividade Prática 3: Projeto de Filtros Digitais

Este repositório contém os códigos, dados e resultados da **Atividade Prática 3** da disciplina de **Processamento Digital de Sinais (PDS)** da UTFPR-AP.

**Objetivo:** Projetar e aplicar filtros digitais (FIR/IIR) para remoção de ruído em sinais de áudio reais, analisando o impacto no domínio do tempo e da frequência.

-----

## 🔊 Fonte de Dados (Dataset)

Para esta prática, optou-se pela utilização de áudio histórico real contendo ruídos característicos de transmissão, dispensando a adição artificial de ruído.

  * **Fonte Original:** [Apollo 11 Onboard Audio - Archive.org](https://archive.org/details/Apollo11Audio/Apollo11OnboardAudioHighlightClip2.mp3) (O arquivo original não foi disponibilizado no repositório devido ao seu tamanho; apenas o áudio recortado foi incluído).
  * **Arquivo Base:** `Apollo11OnboardAudioHighlightClip2.mp3`
  * **Processamento Inicial:**
      * **Software Utilizado:** Audacity.
      * **Procedimento:** Recorte manual de trecho com fala contínua e ruído de fundo.
      * **Intervalo:** Aproximadamente dos minutos **07:00 ao 09:00** do áudio original.
      * **Duração Final:** \~1 minuto e 30 segundos.

-----

## ✅ Divisão de Tarefas (Roadmap)

O desenvolvimento está dividido em 3 partes:

### Parte 1: Análise do Áudio Ruidoso

  - [x] Carregar o áudio recortado (`.wav` ou `.mp3`) no MATLAB.
  - [x] Reproduzir e descrever o conteúdo audível (Voz vs. Ruído).
  - [x] **Gráfico 1:** Plotar o sinal no Domínio do Tempo ($t$).
  - [x] **Gráfico 2:** Calcular e plotar o Espectro de Frequência (FFT).
  - [x] Identificar a faixa de frequência onde o ruído está concentrado (Diagnóstico).
  - [x] Definir especificações ($F_p$, $F_r$, Ripple)

### Parte 2: Projeto do Filtro Digital

  - [ ] Escolher a topologia: **FIR** (Janelamento) ou **IIR** (Butterworth/Chebyshev).
  - [ ] Calcular a ordem ($N$) e os coeficientes do filtro no MATLAB.
  - [ ] **Gráfico 3:** Plotar a resposta em frequência e ao impulso (`fvtool`).
  - [ ] Justificar a escolha do tipo de filtro.

### Parte 3: Aplicação e Avaliação

  - [ ] Aplicar o filtro ao sinal original (utilizando `filtfilt` para fase zero).
  - [ ] Reproduzir o áudio resultante e comparar auditivamente.
  - [ ] **Gráfico 4:** Plotar sinais no tempo sobrepostos (Original vs. Filtrado).
  - [ ] **Gráfico 5:** Plotar espectros sobrepostos (Original vs. Filtrado).
  - [ ] Redigir conclusões sobre a eficácia e possíveis distorções na voz.

-----

## 📝 Relatório

O relatório final (PDF) contendo os gráficos e as justificativas técnicas será depositado na pasta `docs/`.

-----

## 🗂️ Estrutura de Pastas

A organização atual do projeto encontra-se da seguinte forma:

```text
.
├── assets/
│   └── processed/
│       └── nasa_cut.wav                      # Áudio cortado (~1m30s) utilizado na análise
├── docs/
│   ├── imagens/
│   │   └── tiago/                            # Recursos visuais e scripts de plotagem
│   │       ├── fRuido.png                    # Captura manual do pico de ruído
│   │       ├── grafico.m                     # Script auxiliar de gráfico
│   │       └── grafico2_especificacoes.png   # Captura das especificaceos do grafico de ruído
│   ├── Atividade_Prática_3___PDS.pdf         # Roteiro do projeto
│   ├── Aula_PROJETO_filtros.pdf              # Material de aula
│   └── readmeTiago.md                        # Notas de desenvolvimento
├── results/                                  
│   ├── grafico_1_tempo.png                   # Gráfico 1 (Sinal no tempo)
│   └── grafico_2_espectro.png                # Gráfico 2 (Gráfico do Espectro)
├── src/                                      
│   └── parte1_analise.m                      # Script: Análise e Diagnóstico (Parte 1)
└── README.MD                                 # Documentação do projeto (este arquivo)

