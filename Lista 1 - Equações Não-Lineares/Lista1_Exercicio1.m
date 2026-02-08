function Lista1_Exercicio1
  clc; clear; close all;

  f = @(x) x.^3 + 2.*x.^2 - 2;

  xl = 0.0;
  xu = 1.0;
  tol = 1e-5;
  max_iter = 1000;

  [xr, iter, histXr] = metodoBissecao(f, xl, xu, tol, max_iter);

    printf('Raiz encontrada: %.6f\n', xr);
    printf('Iterações: %d\n', iter);
    printf('f(raiz): %.6e\n', f(xr));

    plotaConvergencia(histXr, tol);
    plotaAnimacao(f, xl, xu, histXr);
endfunction

function [xr, iteracoes, histXr] = metodoBissecao(f, xl, xu, tol, max_iter)

    xr = NaN;
    iteracoes = 0;
    histXr = [];

    if f(xl) * f(xu) > 0
        printf('f(%.2f) e f(%.2f) tem o mesmo sinal\n', xl, xu);
        return;
    end

    xrAnt = inf;

    for i = 1:max_iter
        xrNovo = (xl + xu) / 2;

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

        if f(xl) * f(xrNovo) < 0
            xu = xrNovo;
        elseif f(xl) * f(xrNovo) > 0
            xl = xrNovo;
        else
            xr = xrNovo;
            iteracoes = i;
            return;
        endif

        xrAnt = xrNovo;
    endfor
    xr = xrNovo;
    iteracoes = max_iter;
endfunction

function plotaAnimacao(f, xl_ini, xu_ini, histXr)
    figure(1);

    x_plot = linspace(xl_ini - 0.5, xu_ini + 0.5, 100);

    for i = 1:length(histXr)
        xr_atual = histXr(i);

        clf;

        plot(x_plot, f(x_plot), 'b-', 'LineWidth', 2);
        hold on;

        plot([min(x_plot), max(x_plot)], [0, 0], 'k--');

        plot(xr_atual, f(xr_atual), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

        title(sprintf('Animação Bissecção - Iteração: %d | Raiz: %.6f', i, xr_atual));
        xlabel('x'); ylabel('f(x)');
        grid on;

        pause(0.2);
    endfor
endfunction

function plotaConvergencia(histXr, tol)

    if length(histXr) > 1

        erros = abs(diff(histXr));
        erros = [abs(histXr(1) - histXr(2)*2), erros];
        erros = abs(diff([0, histXr]));
        erros(1) = max(erros);

    else
        erros = [0];
    endif

    figure(2);
    plot(1:length(histXr), erros, 'r-o', 'LineWidth', 2);

    title(sprintf('Convergência do Erro (Tol: %g)', tol));
    xlabel('Iterações');
    ylabel('Erro Absoluto');
    grid on;
endfunction
