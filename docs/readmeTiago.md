# Relatório: Análise e Projeto de Filtragem (Parte 1)


### 2.2 Pré-Processamento
Para viabilizar a análise computacional e focar em trechos de interesse (fala + ruído):
1.  **Recorte Temporal:** Utilizando o software *Audacity*, foi extraído um trecho de aproximadamente **1:30 min** (entre os minutos 07:00 e 09:00 do original).
2.  **Conversão:** O áudio foi convertido para canal mono no MATLAB para simplificar a análise espectral (média dos canais estéreo).
3.  **Padronização:** A taxa de amostragem nativa do arquivo foi preservada ($F_s = 44100 \text{ Hz}$), respeitando o padrão de áudio digital (Qualidade de CD) e garantindo a fidelidade na análise espectral.

---

## 3. Análise e Diagnóstico do Sinal

A análise foi conduzida em dois domínios para identificar a natureza da contaminação do sinal.

### 3.1 Análise no Domínio do Tempo
Observou-se visualmente a forma de onda. Mesmo nos momentos de silêncio (pausa na fala dos astronautas), a amplitude do sinal não é zero, indicando um *noise floor* (piso de ruído) elevado, característico de gravações em fita magnética e transmissão via rádio.

### 3.2 Análise no Domínio da Frequência (FFT)
Foi aplicada a Transformada Rápida de Fourier (FFT) para visualizar a distribuição de energia do sinal.

**Observações Fundamentais:**
1.  **Sinal de Voz:** A maior parte da energia da voz humana concentrou-se abaixo de **3000 Hz** (região azul densa no gráfico).
2.  **Identificação do Ruído:** Ao inspecionar a banda acima da voz (High Frequency), foi detectado um **pico tonal isolado** (Narrowband noise). Diferente de um chiado (que seria espalhado), este ruído se comporta como uma "agulha" no espectro.

#### Evidência 1: Log de Diagnóstico Automático
*Abaixo apresenta-se a saída do console do MATLAB durante a execução do script de análise:*

```text
Carregando arquivo: ../assets/processed/nasa_cut.wav ...
Aviso: Áudio estéreo convertido para mono.
Áudio carregado com sucesso!
Duração Total: 89.47 segundos
Amostras: 3945710

[ANÁLISE TEMPORAL]
Observe a figura 1. Identifique visualmente onde há fala e onde há silêncio.

[ANÁLISE ESPECTRAL]
Observe a figura 2. O código abaixo tenta identificar picos automaticamente...

--- DIAGNÓSTICO AUTOMÁTICO ---
Pico de maior energia detectado em: 400.56 Hz
-> PICO NA FAIXA DE VOZ OU INCERTO.
   Verifique visualmente o gráfico para decidir.
------------------------------
````

#### Evidência 2: Espectrograma e Cursor de Dados

*A captura de tela abaixo demonstra a identificação precisa da frequência do ruído utilizando a ferramenta Data Cursor do MATLAB:*

![Ímagem do Gráfico 2 com as infos do pico isolado](./imagens/tiago/fRuido.png).

> **Análise da Imagem:** O cursor aponta para um pico de magnitude elevada em **3205.72 Hz**. Note que esta frequência está isolada e acima do limite típico da voz (linha tracejada vermelha), confirmando ser um ruído de interferência ou tom de transmissão.

-----

## 4\. Decisões de Projeto

Com base no diagnóstico acima, as seguintes decisões de engenharia foram tomadas para a **Parte 2 (Projeto do Filtro)**:

### 4.1 Escolha da Topologia: Filtro Rejeita-Faixa (Notch)

Inicialmente, considerou-se um filtro Passa-Baixa (Low-Pass). No entanto, essa abordagem foi descartada.

  * **Justificativa:** Um filtro Passa-Baixa cortando em 3000 Hz eliminaria o ruído, mas também eliminaria os harmônicos superiores da voz e a "ambiência" da gravação, deixando o som abafado.
  * **Decisão:** Como o ruído é um tom puro em **3205 Hz**, a melhor estratégia é um filtro **Notch (Rejeita-Faixa)**. Ele atua "cirurgicamente", removendo apenas a frequência do bipe e preservando as frequências vizinhas (acima e abaixo).

### 4.2 Especificações Numéricas Definidas

Para configurar o algoritmo de projeto (Janelamento de Kaiser ou Parks-McClellan), definiram-se as seguintes bandas:

  * **Frequência de Amostragem ($F_s$):** 44100 Hz
  * **Frequência do Ruído ($F_{c}$):** $\approx 3205$ Hz
  * **Banda de Passagem 1 ($F_{pass1}$):** $0 - 3000$ Hz (Preserva a voz)
  * **Banda de Rejeição ($F_{stop}$):** $3150 - 3260$ Hz (Zona morta ao redor do ruído)
  * **Banda de Passagem 2 ($F_{pass2}$):** $> 3400$ Hz (Preserva o "ar" da gravação)

![Ímagem do Gráfico 2 com as especificacoes](./imagens/tiago/grafico2_especificacoes.png).

### 4.3 Tipo de Filtro: FIR (Resposta ao Impulso Finita)

Optou-se por um filtro FIR projetado pelo método da janela (Window Method).

  * **Motivo:** Filtros FIR possuem **fase linear**. Em processamento de áudio, isso é crucial para garantir que todas as frequências sofram o mesmo atraso temporal, evitando distorção de fase na voz filtrada.

-----

## 5\. Conclusão da Fase 1

A etapa de análise foi concluída com sucesso. A utilização de um sinal real permitiu exercitar a identificação visual de artefatos no espectro. O ruído alvo foi isolado com precisão em **3205.72 Hz**, permitindo a especificação de um filtro seletivo que promete alta eficácia na remoção do ruído com mínima degradação do sinal de voz histórico.

```
```