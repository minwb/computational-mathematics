function metodoBissecao
    clc; clear; close all;

    f = @(x) x.^3 + 2.*x.^2 - 2; 
    xl = 0.0;
    xu = 1.0;
    tol = 1e-5;
    max_iter = 1000;

    [xr, iter, histXr] = calculaMetodoBissecao(f, xl, xu, tol, max_iter);

    printf('Raiz convergida: %.5f\n', xr);
    printf('Iterações: %d\n', iter);
    printf('f(raiz): %.5f\n', f(xr));

    plotaConvergenciaFx(histXr, f);      
    plotaConvergenciaX(histXr);         
    plotaAnimacaoCorrigida(f, xl, xu, histXr); 
endfunction

function [xr, iteracoes, histXr] = calculaMetodoBissecao(f, xl, xu, tol, max_iter)
    xr = NaN;
    iteracoes = 0;
    histXr = [];

    if f(xl) * f(xu) > 0
        printf('Erro: Intervalo inválido (sinais iguais).\n');
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

function plotaConvergenciaFx(histXr, f)
    figure(1);

    valores_fx = arrayfun(f, histXr);

    plot(1:length(histXr), valores_fx, 'r-o', 'LineWidth', 2);

    title('Gráfico de convergência de f(x)');
    xlabel('Iterações');
    ylabel('f(x)'); 
    grid on;
endfunction

function plotaConvergenciaX(histXr)
    figure(2);

    plot(1:length(histXr), histXr, 'b-o', 'LineWidth', 2);

    title('Gráfico de convergência de x');
    xlabel('Iterações');
    ylabel('Valor de x (Raiz)');
    grid on;
endfunction

function plotaAnimacaoCorrigida(f, xl_ini, xu_ini, histXr)
    figure(3);
    x_plot = linspace(xl_ini - 0.5, xu_ini + 0.5, 100);

    for i = 1:length(histXr)
        xr_atual = histXr(i);

        clf;

        p1 = plot(x_plot, f(x_plot), 'm-', 'LineWidth', 2);
        hold on;
        p2 = plot(xr_atual, f(xr_atual), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

        title(sprintf('Iteracoes: %d | Raiz: %.5f', i, xr_atual));
        xlabel('x');
        ylabel('f(x)');
        legend([p1, p2], {'f(x)', 'Posição estimada da raiz de f(x)'}, 'Location', 'northeast');

        grid on;
        pause(0.2);
    end
endfunction
