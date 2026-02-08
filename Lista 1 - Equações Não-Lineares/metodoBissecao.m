function metodoBissecao
    clc; clear; close all;

    % 1. Configuração do Problema
    f = @(x) x.^3 + 2.*x.^2 - 2; % Coloque a função do exercício aqui
    xl = 0.0;
    xu = 1.0;
    tol = 1e-5;
    max_iter = 1000;

    % 2. Chama o Método Numérico (BISSECÇÃO)
    [xr, iter, histXr] = calculaMetodoBissecao(f, xl, xu, tol, max_iter);

    % 3. Saída no Terminal (Requisito: 5 casas decimais, sem tolerância)
    printf('Raiz convergida: %.5f\n', xr);
    printf('Iterações: %d\n', iter);
    printf('f(raiz): %.5f\n', f(xr));

    % 4. Gera os Gráficos Solicitados (Mesmo padrão do professor)
    plotaConvergenciaFx(histXr, f);       % Figure 1
    plotaConvergenciaX(histXr);           % Figure 2
    plotaAnimacaoCorrigida(f, xl, xu, histXr); % Figure 3
endfunction

% --- MÉTODO NUMÉRICO (BISSECÇÃO) ---
function [xr, iteracoes, histXr] = calculaMetodoBissecao(f, xl, xu, tol, max_iter)
    xr = NaN;
    iteracoes = 0;
    histXr = [];

    % Validação de Bolzano
    if f(xl) * f(xu) > 0
        printf('Erro: Intervalo inválido (sinais iguais).\n');
        return;
    end

    xrAnt = inf;

    for i = 1:max_iter
        xrNovo = (xl + xu) / 2;
        histXr = [histXr, xrNovo];

        % Cálculo do erro
        if i > 1
            erro = abs(xrNovo - xrAnt);
        else
            erro = abs(xrNovo - xl);
        end

        % Critério de Parada
        if erro <= tol
            xr = xrNovo;
            iteracoes = i;
            return;
        end

        % Decisão do Intervalo
        if f(xl) * f(xrNovo) < 0
            xu = xrNovo; % Raiz está na esquerda
        elseif f(xl) * f(xrNovo) > 0
            xl = xrNovo; % Raiz está na direita
        else
            xr = xrNovo; % Achou exato (sorte)
            iteracoes = i;
            return;
        endif
        xrAnt = xrNovo;
    endfor
    xr = xrNovo;
    iteracoes = max_iter;
endfunction

% --- GRÁFICO 1: CONVERGÊNCIA DE F(X) ---
function plotaConvergenciaFx(histXr, f)
    figure(1);

    valores_fx = arrayfun(f, histXr);

    plot(1:length(histXr), valores_fx, 'r-o', 'LineWidth', 2);

    title('Gráfico de convergência de f(x)');
    xlabel('Iterações');
    ylabel('f(x)'); % Requisito do professor
    grid on;
endfunction

% --- GRÁFICO 2: CONVERGÊNCIA DE X ---
function plotaConvergenciaX(histXr)
    figure(2);

    plot(1:length(histXr), histXr, 'b-o', 'LineWidth', 2);

    title('Gráfico de convergência de x');
    xlabel('Iterações');
    ylabel('Valor de x (Raiz)');
    grid on;
endfunction

% --- GRÁFICO 3: ANIMAÇÃO ---
function plotaAnimacaoCorrigida(f, xl_ini, xu_ini, histXr)
    figure(3);
    x_plot = linspace(xl_ini - 0.5, xu_ini + 0.5, 100);

    for i = 1:length(histXr)
        xr_atual = histXr(i);

        clf;

        p1 = plot(x_plot, f(x_plot), 'm-', 'LineWidth', 2);
        hold on;
        p2 = plot(xr_atual, f(xr_atual), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

        title(sprintf('Iterações: %d | Raiz: %.5f', i, xr_atual));
        xlabel('x');
        ylabel('f(x)');
        legend([p1, p2], {'f(x)', 'Posição estimada da raiz de f(x)'}, 'Location', 'northeast');

        grid on;
        pause(0.2);
    end
endfunction
