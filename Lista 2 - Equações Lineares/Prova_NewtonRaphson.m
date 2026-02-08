function Prova_NewtonRaphson()
  clc;
  disp("--- Método de Newton-Raphson (Completo e Modularizado) ---");

  % =========================================================
  % 1. CONFIGURAÇÃO DA QUESTÃO (Edite aqui na Prova)
  % =========================================================
  x0 = [1.0; 1.0];   % Chute Inicial
  tol = 1e-5;        % Tolerância
  maxIter = 100;     % Máximo de iterações

  % =========================================================
  % 2. CHAMADA DO MÉTODO NUMÉRICO
  % =========================================================
  [xFinal, historico, iterFinal] = newtonRaphson(x0, tol, maxIter, @SistemaEquacoes, @MatrizJacobiana);

  % =========================================================
  % 3. EXIBIÇÃO DOS RESULTADOS
  % =========================================================
  printf("\n✅ Convergiu em %d iterações.\n", iterFinal);
  disp("Raízes encontradas (Vetor X Final):");
  for i = 1:length(xFinal)
      printf("x%d = %.6f\n", i, xFinal(i));
  end

  % Prova Real
  F_final = SistemaEquacoes(xFinal);
  disp("\nProva Real (F(x) deve ser próximo de 0):");
  disp(F_final);

  % =========================================================
  % 4. CHAMADA DOS GRÁFICOS (Funções Separadas)
  % =========================================================
  plotarConvergenciaX(historico);               % Gera Figure 1
  plotarConvergenciaF(historico, @SistemaEquacoes); % Gera Figure 2
end


% =========================================================
% ⚠️ ZONA DE EDIÇÃO DA PROVA: AS EQUAÇÕES MATEMÁTICAS ⚠️
% =========================================================

function F = SistemaEquacoes(x)
  % Escreva aqui suas funções igualadas a ZERO.
  F = [ 2*x(1) - 4*x(1)*x(2) + 2*x(2)^2;
        3*x(2)^2 + 6*x(1) - x(1)^2 - 4*x(1)*x(2) - 5 ];
end

function J = MatrizJacobiana(x)
  % Escreva a Matriz das Derivadas Parciais
  J = [ 2 - 4*x(2),               -4*x(1) + 4*x(2);
        6 - 2*x(1) - 4*x(2),      6*x(2) - 4*x(1) ];
end


% =========================================================
% 🛠️ FERRAMENTAS GENÉRICAS (NÃO MEXA AQUI)
% =========================================================

function [xFinal, historico, iter] = newtonRaphson(x0, tol, maxIter, f_handle, j_handle)
  numVars = length(x0);
  historico = zeros(maxIter + 1, numVars);
  historico(1, :) = x0';

  for k = 1:maxIter
    F = f_handle(x0);
    J = j_handle(x0);

    if abs(det(J)) < 1e-10
       error('Matriz Jacobiana Singular (Det=0). Tente outro chute inicial.');
    end

    deltaX = inv(J) * F;
    x1 = x0 - deltaX;

    historico(k + 1, :) = x1';

    if max(abs(x1 - x0)) <= tol
       iter = k;
       xFinal = x1;
       historico = historico(1:(k+1), :);
       return;
    endif

    x0 = x1;
  endfor

  iter = maxIter;
  xFinal = x0;
  disp('Aviso: Máximo de iterações atingido.');
end

% --- FUNÇÃO GRÁFICA 1: CONVERGÊNCIA DAS RAÍZES (X) ---
function plotarConvergenciaX(historicoRaizes)
    figure(1); % Abre a Janela 1

    [iteracoes, numVars] = size(historicoRaizes);
    z = 0:(iteracoes - 1);

    hold on;
    cores = lines(numVars);
    for v = 1:numVars
        plot(z, historicoRaizes(:, v), '-o', 'Color', cores(v,:), 'LineWidth', 1.5, 'MarkerFaceColor', cores(v,:));
    end

    title('Figure 1: Convergência das Raízes (x1, x2...)');
    xlabel('Iterações'); ylabel('Valor da Variável');
    grid on; hold off;

    legendas = cell(1, numVars);
    for v = 1:numVars, legendas{v} = sprintf('x%d', v); end
    legend(legendas, 'Location', 'best');
end

% --- FUNÇÃO GRÁFICA 2: CONVERGÊNCIA DO ERRO (F(x)) ---
function plotarConvergenciaF(historicoRaizes, f_handle)
    figure(2); % Abre a Janela 2

    [iteracoes, numVars] = size(historicoRaizes);
    z = 0:(iteracoes - 1);

    % Calcula o valor de F para cada ponto
    historicoF = zeros(iteracoes, numVars);
    for i = 1:iteracoes
        historicoF(i, :) = f_handle(historicoRaizes(i, :)')';
    end

    hold on;
    cores = lines(numVars);
    for v = 1:numVars
        plot(z, historicoF(:, v), '--', 'Color', cores(v,:), 'LineWidth', 1.5);
    end

    title('Figure 2: Convergência das Funções (Erro -> 0)');
    xlabel('Iterações'); ylabel('Valor de F(x)');
    grid on; hold off;

    legendas = cell(1, numVars);
    for v = 1:numVars, legendas{v} = sprintf('f%d(x)', v); end
    legend(legendas, 'Location', 'best');
end
