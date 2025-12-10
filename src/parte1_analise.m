%% 1. Configuração e Carregamento
arquivo_audio = '../assets/processed/nasa_cut.wav'; 
dir_saida = '../results/';

if ~exist(dir_saida, 'dir')
    mkdir(dir_saida);
end

fprintf('Carregando arquivo: %s ...\n', arquivo_audio);

try
    [Y, FS] = audioread(arquivo_audio);
catch
    error('Erro: Arquivo não encontrado.');
end

if size(Y, 2) > 1
    Y = mean(Y, 2);
end

N = length(Y);
duracao = N / FS;
t = (0:N-1) / FS;

fprintf('Duração Total: %.2f segundos\n', duracao);

%% 2. Análise Temporal (Gráfico 1)
fig1 = figure('Name', 'Analise Temporal', 'Color', 'w'); 
plot(t, Y, 'b');
grid on;
title(['Sinal no Tempo - Duração: ' num2str(duracao, '%.1f') 's'], 'Interpreter', 'none');
xlabel('Tempo (s)');
ylabel('Amplitude');
axis tight;
set(gca, 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', 'GridAlpha', 0.3);

% Salvar Gráfico 1
nome_arquivo_fig1 = fullfile(dir_saida, 'grafico_1_tempo.png');
exportgraphics(fig1, nome_arquivo_fig1, 'BackgroundColor', 'white', 'Resolution', 300);

fprintf('\n[ANÁLISE TEMPORAL]\n');
fprintf('Gráfico salvo em: %s (Tema Claro Forçado)\n', nome_arquivo_fig1);

%% 3. Análise Espectral (Gráfico 2)
f = FS * (0:(N/2)) / N;
Y_fft = fft(Y);
P2 = abs(Y_fft/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

fig2 = figure('Name', 'Analise Espectral', 'Color', 'w');
plot(f, P1, 'b', 'LineWidth', 1.0);
grid on;
title('Espectro de Frequência (FFT)');
xlabel('Frequência (Hz)');
ylabel('|H(f)|');
xlim([0 5000]); 
xline(3000, '--r', 'Limite Típico Voz');

set(gca, 'XColor', 'k', 'YColor', 'k', 'GridColor', 'k', 'GridAlpha', 0.3);

% Salvar Gráfico 2
nome_arquivo_fig2 = fullfile(dir_saida, 'grafico_2_espectro.png');
exportgraphics(fig2, nome_arquivo_fig2, 'BackgroundColor', 'white', 'Resolution', 300);

fprintf('\n[ANÁLISE ESPECTRAL]\n');
fprintf('Gráfico salvo em: %s (Tema Claro Forçado)\n', nome_arquivo_fig2);

%% 4. Diagnóstico Automático
fprintf('\n--- DIAGNÓSTICO AUTOMÁTICO ---\n');
f_ignorar_voz = f > 300; 
[pico_mag, indice] = max(P1(f_ignorar_voz));
freq_pico = f(find(f_ignorar_voz, 1) + indice - 1);

fprintf('Pico de maior energia detectado em: %.2f Hz\n', freq_pico);

if freq_pico > 2300 && freq_pico < 2700
    fprintf('-> PARECE SER O "QUINDAR TONE" (Bipe da NASA).\n');
elseif freq_pico > 3150 && freq_pico < 3300
    fprintf('-> ALERTA: Ruído Tonal Detectado (Bipe/Interferência) em %.0f Hz.\n', freq_pico);
    fprintf('   Recomendação: Filtro Notch.\n');
elseif freq_pico > 3500
    fprintf('-> PARECE SER CHIADO/RUÍDO DE ALTA FREQUÊNCIA.\n');
else
    fprintf('-> INCERTO. Verifique visualmente.\n');
end
fprintf('------------------------------\n');