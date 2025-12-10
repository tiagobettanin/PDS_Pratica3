% Descrição: Calcula os coeficientes do filtro FIR Notch com Janela de Kaiser.

%% 1. Configuração Inicial
arquivo_audio = '../assets/processed/nasa_cut.wav'; 
dir_saida = '../results/';
arquivo_coefs = '../assets/processed/coeficientes_filtro.mat';

try
    [~, FS] = audioread(arquivo_audio);
    fprintf('Taxa de Amostragem detectada: %d Hz\n', FS);
catch
    error('Erro: Áudio não encontrado. Verifique a pasta assets/processed.');
end

%% 2. Definição das Especificações
% Objetivo: Matar o tom de 3205 Hz com margem de segurança

% Frequências de Borda (Hz)
Fpass1 = 3000;  % Fim da voz
Fstop1 = 3150;  % Início do corte
Fstop2 = 3260;  % Fim do corte
Fpass2 = 3400;  % Retomada do sinal (agudos)

A = [1 0 1]; 

DEV = [0.01 0.01 0.01]; 

F = [Fpass1 Fstop1 Fstop2 Fpass2];

fprintf('\n--- PROJETO DO FILTRO ---\n');
fprintf('Tipo: FIR Notch (Rejeita-Faixa)\n');
fprintf('Zona Morta: %d Hz até %d Hz\n', Fstop1, Fstop2);

%% 3. Cálculo dos Coeficientes (Algoritmo de Kaiser)
% kaiserord estima a ordem necessária para cumprir suas especificações
[N, Wn, BTA, FILTYPE] = kaiserord(F, A, DEV, FS);

% Ajuste de paridade: Filtros Notch/Band-stop FIR precisam de ordem PAR
if rem(N, 2) == 1
    N = N + 1;
end

B = fir1(N, Wn, FILTYPE, kaiser(N+1, BTA), 'noscale');
A_filt = 1;

fprintf('Ordem calculada (N): %d\n', N);
fprintf('Beta de Kaiser: %.2f\n', BTA);

%% 4. Visualização e Validação (FVTool)
fprintf('Abrindo FVTool para validação...\n');

h_filt = dfilt.dffir(B);
fvtool(h_filt, 'Fs', FS, 'Color', 'white'); 

%% 5. Salvar Coeficientes para a Parte 3
save(arquivo_coefs, 'B', 'A_filt', 'FS', 'N');
fprintf('Sucesso! Coeficientes salvos em: %s\n', arquivo_coefs);
fprintf('Agora você pode rodar a parte3_aplicacao.m\n');