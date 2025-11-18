function Lista1_Exercicio8()
  clc;

  xl = 0.0;
  xu = 5.0;
  tolerancia = 1e-5;
  iteracoesMax = 1000;

  [xr, iteracoesTotais, vetorFXr, vetorXr] = metodoFalsaPosicao(xl, xu, tolerancia, iteracoesMax);

  fxrFinal = funcao(xr);

  fprintf('raiz de f(x) = 16x*sin(x/10) - 37/2\n');
  fprintf('raiz convergida: %0.5f\n', xr);
  fprintf('f(x) final: %0.5f\n', fxrFinal);
  fprintf('iteracoes: %d\n', iteracoesTotais);

  plotaGraficoFx(vetorFXr, iteracoesTotais);
  plotaGraficoX(vetorXr, iteracoesTotais);
  plotaGraficoAnimado(xl, xu, vetorXr, iteracoesTotais);

end

function [xr, iteracoesTotais, vetorFXr, vetorXr] = metodoFalsaPosicao(xl, xu, tolerancia, iteracoesMax)
  iteracoesTotais = 0;
  erroAbsoluto = inf;
  xrAnterior = inf;
  vetorFXr = [];
  vetorXr = [];

  f_xl = funcao(xl);
  f_xu = funcao(xu);

  xr = xl;

  for i = 1:iteracoesMax
      xrNovo = xu - (f_xu * (xl - xu))/(f_xl - f_xu);
      iteracoesTotais = iteracoesTotais + 1;

      if (xrAnterior != inf)
           erroAbsoluto = abs(xrNovo - xrAnterior);
      end

      if(erroAbsoluto <= tolerancia)
          xr = xrNovo;
          vetorFXr = [vetorFXr; funcao(xrNovo)];
          vetorXr = [vetorXr; xrNovo];
          break;
      end

      f_xr = funcao(xrNovo);
      vetorFXr = [vetorFXr; f_xr];
      vetorXr = [vetorXr; xrNovo];
      valorMultiplicacao = f_xl * f_xr;

      if (valorMultiplicacao > 0)
          xl = xrNovo;
          f_xl = f_xr;
      elseif (valorMultiplicacao < 0)
          xu = xrNovo;
          f_xu = f_xr;
      end
      xrAnterior = xrNovo;

  end

  if iteracoesTotais == iteracoesMax
      xr = xrNovo;
  end
end

function plotaGraficoFx(vetorFXr, iteracoesTotais)
figure(1);
clf;

iteracoes = 1:iteracoesTotais;
plot(iteracoes, vetorFXr, 'm-o', 'linewidth', 2, 'markersize', 3);
hold on;
plot([1 iteracoesTotais], [0 0], 'k--', 'linewidth', 1);

title('grafico de convergencia de f(x)');
xlabel('numero de iteracoes');
ylabel('f(x)');
legend({'f(x)'}, 'location', 'northEast');
grid on;
hold off;

end

function plotaGraficoX(vetorXr, iteracoesTotais)
figure(2);
clf;
iteracoes = 1:iteracoesTotais;
plot(iteracoes, vetorXr, 'b-o', 'linewidth', 2, 'markersize', 3);
hold on;

xr_final = vetorXr(end);
plot([1 iteracoesTotais], [xr_final xr_final], 'g--', 'linewidth', 1);
title('grafico de convergencia de x');
xlabel('numero de iteracoes');
ylabel('x (posicao da raiz)');
legend({'xr calculado', sprintf('valor final (%.5f)', xr_final)}, 'location', 'southEast');
grid on;
hold off;
end

function plotaGraficoAnimado(xlInicial, xuInicial, vetorXr, iteracoesTotais)
figure(3);
clf;
plotagemX = xlInicial : 0.01 : xuInicial;
plotagemY = fIntervalo(plotagemX);
xrAtual = vetorXr(end);

for i = 1:length(vetorXr)
    xr_atual = vetorXr(i);
    yr_atual = funcao(xr_atual);
    hold('on');

    plot(plotagemX, plotagemY, 'm-', 'linewidth', 2);
    plot([xlInicial xuInicial], [0 0], 'k--');
    fponto = plot(xr_atual, yr_atual, 'r*', 'markersize', 10, 'markerfacecolor', 'b');
    fproj = plot(xr_atual, 0, 'g*', 'markersize', 8, 'markerfacecolor', 'b');
    title(sprintf('visualizacao da raiz - iteracoes: %d', i));

    xlabel('x');
    ylabel('f(x)');
    legend([fponto, fproj], {'f(x)', 'posicao estimada da raiz de f(x)'}, 'location', 'northWest');
    grid on;
    pause(0.1);
    hold('off');
    clf;

end

figure(3);

plot(plotagemX, plotagemY, 'm-', 'linewidth', 2);
hold on;
plot([xlInicial xuInicial], [0 0], 'k--');
plot(xrAtual, 0, 'b*', 'markersize', 10, 'markerfacecolor', 'r');
title(sprintf('raiz final convergida: %.5f - iteracoes: %d', xrAtual, iteracoesTotais));
xlabel('x');
ylabel('f(x)');
legend({'f(x)', 'eixo da raiz', 'posicao estimada da raiz de f(x)'}, 'location', 'northWest');
grid on;
hold off;

end

function Y = fIntervalo(X)
  Y = zeros(size(X));
  for cont = 1:length(X)
      Y(cont) = funcao(X(cont));
  end
end

function f = funcao(x)
  f = 16*x*sin(x/10) - 37/2;
end
