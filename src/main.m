%% PDS - Script de Execução Total
% Descrição: Roda todas as etapas do projeto em sequência sem interrupções.

clc; clear; close all;
tempo_inicio = tic;

fprintf('======================================================\n');
fprintf('      INICIANDO EXECUÇÃO AUTOMÁTICA DO PROJETO        \n');
fprintf('======================================================\n');

%% ETAPA 1: ANÁLISE E DIAGNÓSTICO
fprintf('\n>>> [1/4] Executando Análise Temporal e Espectral...\n');
try
    run('parte1_analise.m');
    fprintf('    [OK] Gráficos de diagnóstico gerados.\n');
catch ME
    fprintf('    [ERRO] Falha na Parte 1: %s\n', ME.message);
    return;
end

%% ETAPA 2: GERAÇÃO DO GRÁFICO DE PLANEJAMENTO (OVERLAY)
fprintf('\n>>> [2/4] Gerando Máscara de Projeto (Overlay)...\n');
try
    run('gerar_grafico_overlay.m');
    fprintf('    [OK] Gráfico de planejamento salvo.\n');
catch ME
    fprintf('    [ERRO] Falha no Overlay: %s\n', ME.message);
    return;
end

%% ETAPA 3: CÁLCULO DO FILTRO
fprintf('\n>>> [3/4] Calculando Coeficientes do Filtro (Kaiser)...\n');
try
    run('parte2_projeto.m');
    fprintf('    [OK] Coeficientes salvos em .mat.\n');
    close(gcf); % Fecha a janela do FVTool para não travar
catch ME
    fprintf('    [ERRO] Falha na Parte 2: %s\n', ME.message);
    return;
end

%% ETAPA 4: APLICAÇÃO E VALIDAÇÃO
fprintf('\n>>> [4/4] Filtrando Áudio e Gerando Comparativos...\n');
try
    run('parte3_aplicacao.m');
    fprintf('    [OK] Áudio filtrado e gráficos finais gerados.\n');
catch ME
    fprintf('    [ERRO] Falha na Parte 3: %s\n', ME.message);
    return;
end

%% FINALIZAÇÃO
tempo_total = toc(tempo_inicio);
fprintf('======================================================\n');
fprintf('      PIPELINE CONCLUÍDO COM SUCESSO!                 \n');
fprintf('======================================================\n');
fprintf('Tempo Total de Execução: %.2f segundos\n', tempo_total);
fprintf('Todos os resultados estão na pasta: ../results/\n');
fprintf('O áudio limpo está em: ../assets/processed/nasa_limpo.wav\n');