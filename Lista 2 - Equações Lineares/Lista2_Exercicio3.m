function Lista2_Exercicio3()
  clc;
  x0 = [1; 1];
  tolerancia = 1e-5;
  maxIter = 1000;

  [x1, valRaizes, iterFinal] = newtonRaphson(x0, tolerancia, maxIter);

  printf("iterações: %d\n", iterFinal);
  printf("raiz x1: %.6f\n", x1(1));
  printf("raiz x2: %.6f\n", x1(2));
  fFinal = funcoesF(x1);
  printf("f1: %.6f\n", fFinal(1));
  printf("f2: %.6f\n", fFinal(2));

  plotarGraficoConvergencia(valRaizes);
end


function [xFinal, historico, k] = newtonRaphson(x0, tolerancia, maxIter)
  historico = zeros(maxIter + 1, length(x0));
  historico(1, :) = x0';

  for k = 1:maxIter
    f = funcoesF(x0);
    j = funcoesJ(x0);

    deltaX = inv(j) * f;
    x1 = x0 - deltaX;
    historico(k + 1, :) = x1';

    if max(abs(x1 - x0)) <= tolerancia
      break;
    endif
    x0 = x1;
  endfor
  xFinal = x0;
  historico = historico(1:(k+1), :);
end

function plotarGraficoConvergencia(valRaizes)
  iteracoes = size(valRaizes, 1);

  z = 0:(iteracoes - 1);
  historicoF = zeros(iteracoes, 2);

  for i = 1:iteracoes
    historicoF(i, :) = funcoesF(valRaizes(i, :)')';
  end

  figure;

  subplot(2, 1, 1);
  hold on;

  plot(z, valRaizes(:, 1), '-or', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
  plot(z, valRaizes(:, 2), '-ob', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
  title('Gráfico de convergência de x1 e x2');
  xlabel('iteração (k)');
  ylabel('valor da raiz');
  legend('raiz x1', 'raiz x2');
  grid on;
  hold off;

  subplot(2, 1, 2);
  hold on;
  plot(z, historicoF(:, 1), '-or', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
  plot(z, historicoF(:, 2), '-ob', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
  title('Gráfico de convergência das funções');
  xlabel('iteração (k)');
  ylabel('valor de f(x)');
  legend('f1(x,y)', 'f2(x,y)');
  grid on;
  hold off;
end

function F = funcoesF(x)
  F = [2*x(1) - 4*x(1)*x(2) + 2*x(2)^2;
       3*x(2)^2 + 6*x(1) - x(1)^2 - 4*x(1)*x(2) - 5];
end

function J = funcoesJ(x)
  J = [2 - 4*x(2),          -4*x(1) + 4*x(2);
       6 - 2*x(1) - 4*x(2), -4*x(1) + 6*x(2)];
end
