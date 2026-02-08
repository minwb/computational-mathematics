function testeCodigoMetodoFechado
  clc; clear; close all;

  % declarar a função
  f = @(x) x.^3 + 2.*x.^2 - 2);

  % declarar as variáveis
  xl = 0.0;
  xu = 1.0;
  tol = 1e-5;
  iteracoesMax = 1000;

  % chamar o metodo (fp ou bisseção)
  [xr, iteracoesTotais, histXr] = metodoBissecaoFp(f, xl, xu, iteracoesMax, tol)

  % impressao no terminal
  printf('Raiz convergida: %.5f\n', xr);
  printf('Iteracoes: %d\n', iteracoesTotais);
  printf('f(raiz): %.5f\n', f(xr));

  % plotagem de gráficos
  plotaConvergenciaFx(histXr, f);
  plotaConvergenciaX(histXr);
  plotaGraficoAnimado(f, xl, xu, histXr);
endfunction

function [xr, iteracoes, histXr] = metodoBissecao(f, xl, xu, tol, max_iter)
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
        % --- A GRANDE MUDANÇA ESTÁ AQUI ---
        % Fórmula da Bissecção (Média Simples)
        xrNovo = (xl + xu) / 2;
        % ----------------------------------

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
        end
        xrAnt = xrNovo;
    end
    xr = xrNovo;
    iteracoes = max_iter;
endfunction
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

function plotaConvergenciaFxBissecao(histXr, f)
  figure(1);

    valores_fx = arrayfun(f, histXr);

    plot(1:length(histXr), valores_fx, 'r-o', 'LineWidth', 2);

    title('Gráfico de convergência de f(x)');
    xlabel('Iterações');
    ylabel('f(x)'); % Requisito do professor
    grid on;
end function
function plotaConvergenciaFxFP(histXr, f)
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


function plotaConvergenciaXBissecao(histXr)
    figure(2);

    plot(1:length(histXr), histXr, 'b-o', 'LineWidth', 2);

    title('Gráfico de convergência de x');
    xlabel('Iterações');
    ylabel('Valor de x (Raiz)');
    grid on;
endfunction
function plotaConvergenciaXFP(histXr)
    figure(2);

    % Requisito: Mostrar o valor de X se estabilizando
    plot(1:length(histXr), histXr, 'b-o', 'LineWidth', 2);

    title('Gráfico de convergência de x');
    xlabel('Iterações');
    ylabel('Valor de x (Raiz)');
    grid on;
endfunction

function plotaAnimacaoBissecao(f, xl_ini, xu_ini, histXr)
    figure(3);
    x_plot = linspace(xl_ini - 0.5, xu_ini + 0.5, 100);

    for i = 1:length(histXr)
        xr_atual = histXr(i);

        clf;
        % Desenha a função
        p1 = plot(x_plot, f(x_plot), 'm-', 'LineWidth', 2);
        hold on;

        % Desenha o eixo zero
        plot([min(x_plot), max(x_plot)], [0, 0], 'k--');

        % Desenha a bolinha
        p2 = plot(xr_atual, f(xr_atual), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

        % Título e Legendas conforme pedido
        title(sprintf('Bissecção - Iterações: %d | Raiz: %.5f', i, xr_atual));
        xlabel('x');
        ylabel('f(x)');
        legend([p1, p2], {'f(x)', 'Posição estimada da raiz de f(x)'}, 'Location', 'northeast');

        grid on;
        pause(0.2);
    end
endfunction
function plotaAnimacaoFP(f, xl_ini, xu_ini, histXr)
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

