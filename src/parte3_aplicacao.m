
% Descrição: Aplica o filtro FIR projetado, gera áudio limpo e gráficos comparativos.

%% 1. Configurações e Carregamento
arquivo_audio = '../assets/processed/nasa_cut.wav'; 
arquivo_coefs = '../assets/processed/coeficientes_filtro.mat';
dir_saida = '../results/';

% Carregar Áudio Original
try
    [Y, FS] = audioread(arquivo_audio);
    if size(Y, 2) > 1, Y = mean(Y, 2); end
    fprintf('Áudio original carregado.\n');
catch
    error('Erro: Áudio não encontrado.');
end

% Carregar Coeficientes do Filtro (Parte 2)
try
    load(arquivo_coefs); 
    fprintf('Filtro carregado (Ordem %d).\n', N);
catch
    error('Erro: Execute a parte2_projeto.m primeiro para gerar os coeficientes.');
end

%% 2. Filtragem (Zero-Phase)
fprintf('Aplicando filtro...\n');
Y_filtrado = filtfilt(B, A_filt, Y);

Y_filtrado = Y_filtrado / max(abs(Y_filtrado));

% Salvar o áudio limpo
audiowrite('../assets/processed/nasa_limpo.wav', Y_filtrado, FS);
fprintf('Áudio limpo salvo em: ../assets/processed/nasa_limpo.wav\n');

%% 3. Comparação no Tempo 
trecho_zoom = (30*FS) : (30.05*FS); 
t_zoom = (0:length(trecho_zoom)-1)/FS;

fig_tempo = figure('Name', 'Comparacao Tempo', 'Color', 'w', 'Position', [100 100 1000 400]);
plot(t_zoom, Y(trecho_zoom), 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on;
plot(t_zoom, Y_filtrado(trecho_zoom), 'b', 'LineWidth', 1.5);
legend('Original (Ruidoso)', 'Filtrado (Limpo)');
title('Comparação no Domínio do Tempo (Zoom de 50ms)');
xlabel('Tempo (s)'); ylabel('Amplitude');
grid on; axis tight;
set(gca, 'XColor', 'k', 'YColor', 'k');

% Salvar
exportgraphics(fig_tempo, fullfile(dir_saida, 'grafico_4_tempo_comparacao.png'), 'Resolution', 300);

%% 4. Comparação na Frequência
fprintf('Calculando espectros comparativos...\n');

N_fft = length(Y);
f = FS * (0:(N_fft/2)) / N_fft;

% FFT Original
Y_fft = fft(Y);
P1_orig = abs(Y_fft/N_fft);
P1_orig = P1_orig(1:N_fft/2+1);
P1_orig(2:end-1) = 2*P1_orig(2:end-1);

% FFT Filtrada
Y_fil = fft(Y_filtrado);
P1_filt = abs(Y_fil/N_fft);
P1_filt = P1_filt(1:N_fft/2+1);
P1_filt(2:end-1) = 2*P1_filt(2:end-1);

fig_freq = figure('Name', 'Comparacao Frequencia', 'Color', 'w', 'Position', [100 500 1000 400]);
plot(f, P1_orig, 'Color', [0.8 0.4 0.4], 'LineWidth', 0.5); hold on; 
plot(f, P1_filt, 'Color', [0 0.5 0], 'LineWidth', 1.2);       

xlim([0 5000]);
legend('Espectro Original (Com Ruído)', 'Espectro Filtrado (Sem Ruído)');
title('Prova da Remoção do Ruído (Domínio da Frequência)');
xlabel('Frequência (Hz)'); ylabel('Magnitude');
grid on;
set(gca, 'XColor', 'k', 'YColor', 'k');

xline(3205, '--k', 'Alvo Removido');

exportgraphics(fig_freq, fullfile(dir_saida, 'grafico_5_espectro_comparacao.png'), 'Resolution', 300);

fprintf('Gráficos comparativos salvos em "results/".\n');
fprintf('---------------------------------------------------\n');
fprintf('PROJETO CONCLUÍDO! \nEscute o arquivo "nasa_limpo.wav" para verificar o resultado.\n');

% Tocar o áudio automaticamente (os primeiros 10s)
sound(Y_filtrado(1:10*FS), FS);