function Lista4_Exercicio2()
    clc; clear; close all;

    x0 = [-0.5; 0.5; 0.5];
    optimum = [1; 1; 1];
    lim = 1000;
    tol = 1e-3;

    func_obj = @(x) 100*(x(2) - x(1)^2)^2 + (x(1) - 1)^2 + ...
                    100*(x(2) - x(3)^2)^2 + (x(3) - 1)^2;

    grad_obj = @(x) [ ...
        -400*x(1)*(x(2) - x(1)^2) + 2*(x(1) - 1);
        200*(x(2) - x(1)^2) + 200*(x(2) - x(3)^2);
        -400*x(3)*(x(2) - x(3)^2) + 2*(x(3) - 1)
    ];

    H_obj = @(x) [ ...
        (-400*x(2) + 1200*x(1)^2 + 2),  (-400*x(1)),       0;
        (-400*x(1)),                    400,               (-400*x(3));
        0,                              (-400*x(3)),       (-400*x(2) + 1200*x(3)^2 + 2)
    ];


    alpha_grad = 0.0015;
    [dataX_GD, dataF_GD] = numericMethod(x0, func_obj, grad_obj, [], alpha_grad, lim, tol, 'gradient');
    printaResultados('Gradiente Descendente', dataX_GD, dataF_GD, optimum);

    alpha_newton = 1.0;
    [dataX_N, dataF_N] = numericMethod(x0, func_obj, grad_obj, H_obj, alpha_newton, lim, tol, 'newton');
    printaResultados('Método de Newton', dataX_N, dataF_N, optimum);

    plotaGraficoConvergencia(dataF_GD, dataF_N);

    animaTrajetoria3D(dataX_GD, dataX_N, optimum);

end

function [dataX, dataF] = numericMethod(x0, func, grad, H, alpha, lim, tol, method)
    dim = length(x0);
    dataX = zeros(lim + 1, dim);
    dataF = zeros(lim + 1, 1);

    x = x0;
    dataX(1, :) = x;
    dataF(1) = func(x);

    for i = 1 : lim
        g = grad(x);

        if strcmp(method, 'gradient')
            delta = -alpha * g;
        elseif strcmp(method, 'newton')
            H_val = H(x);
            if rcond(H_val) < 1e-15
                 delta = -alpha * g;
            else
                 delta = -alpha * (H_val \ g);
            end
        end

        x_new = x + delta;

        dataX(i + 1, :) = x_new;
        dataF(i + 1) = func(x_new);

        if norm(x_new - x) <= tol
            dataX = dataX(1:i+1, :);
            dataF = dataF(1:i+1);
            return;
        end

        x = x_new;
    end
end

function printaResultados(name, dataX, dataF, optimum)
    final_x = dataX(end, :)';
    final_f = dataF(end);
    iters = length(dataF) - 1;
    dist_opt = norm(final_x - optimum);

    printf('\n%s\n', name);
    printf('x final: [%.6f  %.6f  %.6f]\n', final_x(1), final_x(2), final_x(3));
    printf('f(x): %.6f\n', final_f);
    printf('distância euclidiana: %.6f\n', dist_opt);
    printf('iterações:cc %d\n', iters);
end

function plotaGraficoConvergencia(dataF_GD, dataF_N)
    figure;
    semilogy(0:length(dataF_GD)-1, dataF_GD, '-r', 'LineWidth', 2, 'DisplayName', 'Gradiente');
    hold on;
    semilogy(0:length(dataF_N)-1, dataF_N, '-b', 'LineWidth', 2, 'DisplayName', 'Newton');
    grid on;
    xlabel('Iterações');
    ylabel('Valor de f(x) (log scale)');
    title('Gráfico de Convergência');
    legend show;
end

function animaTrajetoria3D(dataX_GD, dataX_N, optimum)
    figure;

    plot3(optimum(1), optimum(2), optimum(3), 'go', 'MarkerSize', 15, 'MarkerFaceColor', 'g', 'DisplayName', 'Ponto de Mínimo');

    hold on; grid on;
    xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
    title('Caminho da Otimização no Espaço 3D');
    view(45, 30);

    plot3(dataX_GD(:,1), dataX_GD(:,2), dataX_GD(:,3), '--r', 'LineWidth', 1, 'DisplayName', 'Trajetória Gradiente');
    plot3(dataX_N(:,1), dataX_N(:,2), dataX_N(:,3), '--b', 'LineWidth', 1, 'DisplayName', 'Trajetória Newton');
    legend show;

    hGD = plot3(dataX_GD(1,1), dataX_GD(1,2), dataX_GD(1,3), 'or', 'MarkerFaceColor', 'r', 'DisplayName', 'Atual Gradiente');

    hN = plot3(dataX_N(1,1), dataX_N(1,2), dataX_N(1,3), 'ob', 'MarkerFaceColor', 'b', 'DisplayName', 'Atual Newton');

    max_iter = max(size(dataX_GD, 1), size(dataX_N, 1));
    for k = 1:max_iter
        if k <= size(dataX_GD, 1)
            set(hGD, 'XData', dataX_GD(k,1), 'YData', dataX_GD(k,2), 'ZData', dataX_GD(k,3));
        end

        if k <= size(dataX_N, 1)
            set(hN, 'XData', dataX_N(k,1), 'YData', dataX_N(k,2), 'ZData', dataX_N(k,3));
        end

        title(sprintf('iteração: %d', k-1));
        drawnow;
        pause(0.05);
    end
end
