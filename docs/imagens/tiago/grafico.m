clc; clear; close all;

%% 1. Configurações e Parâmetros
arquivo_audio = '../../../assets/processed/nasa_cut.wav'; 
dir_saida = './';

if ~exist(dir_saida, 'dir')
    mkdir(dir_saida);
    fprintf('Pasta de resultados criada: %s\n', dir_saida);
end

try
    [Y, FS] = audioread(arquivo_audio);
    if size(Y, 2) > 1, Y = mean(Y, 2); end 
catch
    error('Erro: Arquivo "nasa_cut.wav" não encontrado em assets/processed/.');
end

% --- SEUS PARÂMETROS DE PROJETO (Do readmeTiago.md) ---
Fr_alvo = 3205; % Frequência do Ruído (Bipe)
Fp1 = 3000;     % Fim da Passagem 1 (Voz)
Fr1 = 3150;     % Início do Corte (Stopband)
Fr2 = 3260;     % Fim do Corte (Stopband)
Fp2 = 3400;     % Início da Passagem 2 (Agudos)

%% 2. Cálculo da FFT (Base de Dados Real)
N = length(Y);
f = FS * (0:(N/2)) / N;
Y_fft = fft(Y);
P2 = abs(Y_fft/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

%% 3. Construção do Gráfico Overlay
fig_overlay = figure('Name', 'Planejamento do Filtro', 'Color', 'w', 'Position', [100 100 1200 600]);
hold on; grid on;

plot(f, P1, 'Color', [0 0.4470 0.7410], 'LineWidth', 0.8); 

ylabel('|H(f)| - Magnitude', 'FontSize', 11, 'FontWeight', 'bold');
xlabel('Frequência (Hz)', 'FontSize', 11, 'FontWeight', 'bold');
title('Planejamento do Filtro: Espectro Real vs. Especificações', 'FontSize', 14);
set(gca, 'XColor', 'k', 'YColor', 'k', 'Layer', 'top'); 

xlim([0 5000]); 
ymax = max(P1(f > 100 & f < 3000)) * 1.1; 
ylim([0 ymax]);

fill([0 Fp1 Fp1 0], [0 0 ymax ymax], [0.85 1 0.85], 'EdgeColor', 'none', 'FaceAlpha', 0.4);
text(1000, ymax*0.9, 'Banda de Passagem 1 (Voz)', 'Color', [0 0.4 0], 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

fill([Fr1 Fr2 Fr2 Fr1], [0 0 ymax ymax], [1 0.85 0.85], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
text((Fr1+Fr2)/2, ymax*0.6, 'FILTRO NOTCH', 'Color', [0.8 0 0], 'FontWeight', 'bold', 'Rotation', 90, 'HorizontalAlignment', 'center');

fill([Fp2 5000 5000 Fp2], [0 0 ymax ymax], [0.85 1 0.85], 'EdgeColor', 'none', 'FaceAlpha', 0.4);
text(4200, ymax*0.9, 'Banda de Passagem 2 (Agudos)', 'Color', [0 0.4 0], 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

xline(Fp1, '--', 'Color', [0 0.5 0], 'LineWidth', 1.5);
text(Fp1, ymax*0.02, sprintf(' Fp1: %d Hz', Fp1), 'Rotation', 90, 'FontSize', 9, 'Color', [0 0.5 0]);

idx_ruido = find(f >= Fr_alvo, 1);
pico_altura = P1(idx_ruido);
text(Fr_alvo, pico_altura + (ymax*0.05), '\downarrow Ruído (3205 Hz)', 'Color', 'k', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');

xline(Fr1, ':', 'Color', 'r', 'LineWidth', 1.2);
xline(Fr2, ':', 'Color', 'r', 'LineWidth', 1.2);

%% 4. Salvamento Automático Profissional
nome_arquivo = fullfile(dir_saida, 'grafico2_especificacoes.png');

fprintf('Salvando gráfico em alta resolução...\n');
exportgraphics(fig_overlay, nome_arquivo, 'BackgroundColor', 'white', 'Resolution', 300);

fprintf('SUCESSO! Gráfico salvo em: %s\n', nome_arquivo);