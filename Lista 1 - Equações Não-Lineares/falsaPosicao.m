function Lista1_falsaPosicao
    clc; clear; close all;

    % 1. Configuração do Problema
    f = @(x) x.^3 + 2.*x.^2 - 2; % Coloque a função do exercício aqui
    xl = 0.0;
    xu = 1.0;
    tol = 1e-5;
    max_iter = 1000;

    % 2. Chama o Método Numérico
    [xr, iter, histXr] = metodoFalsaPosicao(f, xl, xu, tol, max_iter);

    % 3. Saída no Terminal (Requisito: 5 casas decimais, sem tolerância)
    printf('Raiz convergida: %.5f\n', xr);
    printf('Iterações: %d\n', iter);
    printf('f(raiz): %.5f\n', f(xr));

    % 4. Gera os Gráficos Solicitados
    % Gráfico 1: Convergência de f(x) (Esquerda)
    plotaConvergenciaFx(histXr, f);

    % Gráfico 2: Convergência de x (Não tinha antes)
    plotaConvergenciaX(histXr);

    % Gráfico 3: Animação (Direita)
    plotaAnimacaoCorrigida(f, xl, xu, histXr);
endfunction

% --- MÉTODO NUMÉRICO (FALSA POSIÇÃO) ---
function [xr, iteracoes, histXr] = metodoFalsaPosicao(f, xl, xu, tol, max_iter)
    xr = NaN;
    iteracoes = 0;
    histXr = [];
    f_xl = f(xl);
    f_xu = f(xu);

    if f_xl * f_xu > 0
        printf('Erro: Intervalo inválido.\n');
        return;
    end

    xrAnt = inf;

    for i = 1:max_iter
        % Fórmula da Falsa Posição
        xrNovo = xu - (f_xu * (xl - xu)) / (f_xl - f_xu);

        histXr = [histXr, xrNovo];

        if i > 1
            erro = abs(xrNovo - xrAnt);
        else
            erro = abs(xrNovo - xl);
        end

        if erro <= tol
            xr = xrNovo;
            iteracoes = i;
            return;
        end

        f_xr = f(xrNovo);

        if f_xl * f_xr < 0
            xu = xrNovo;
            f_xu = f_xr;
        elseif f_xl * f_xr > 0
            xl = xrNovo;
            f_xl = f_xr;
        else
            xr = xrNovo;
            iteracoes = i;
            return;
        end
        xrAnt = xrNovo;
    end
    xr = xrNovo;
    iteracoes = max_iter;
endfunction

% --- GRÁFICO 1: CONVERGÊNCIA DE F(X) ---
function plotaConvergenciaFx(histXr, f)
    figure(1);

    % Calcula f(x) para todo o histórico
    valores_fx = arrayfun(f, histXr);

    % Requisito: Eixo Y deve ser "f(x)", título corrigido
    plot(1:length(histXr), valores_fx, 'r-o', 'LineWidth', 2);

    title('Gráfico de convergência de f(x)');
    xlabel('Iterações');
    ylabel('f(x)'); % Requisito: Eixo Y correto
    grid on;
endfunction

% --- GRÁFICO 2: CONVERGÊNCIA DE X ---
function plotaConvergenciaX(histXr)
    figure(2);

    % Requisito: Mostrar o valor de X se estabilizando
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
        % Desenha a função (Curva magenta)
        p1 = plot(x_plot, f(x_plot), 'm-', 'LineWidth', 2);
        hold on;

        % Desenha o eixo zero (Tracejado preto)
        plot([min(x_plot), max(x_plot)], [0, 0], 'k--');

        % Desenha a bolinha (Raiz atual)
        p2 = plot(xr_atual, f(xr_atual), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

        % Requisito: Título com iterações e raiz com 5 casas
        title(sprintf('Iterações: %d | Raiz: %.5f', i, xr_atual));

        % Requisito: Rótulo "x" simples
        xlabel('x');
        ylabel('f(x)');

        % Requisito: Legendas exatas "f(x)" e "Posição estimada..."
        legend([p1, p2], {'f(x)', 'Posição estimada da raiz de f(x)'}, 'Location', 'northeast');

        grid on;
        pause(0.2);
    end
endfunction
