function metodoGaussGenerico
    clc;

    N = 10;
    A = randi(N, N, N); % randi(VALOR_MAXIMO, LINHAS, COLUNAS)
    b = randi(N, N, 1);

    Aa = [A b];
    x = eliminacaoGaussiana(Aa);

    disp("A solução para o sistema");

    [linhas, colunas] = size(A);

    for i = 1:linhas
      printf("%.2fx1 ", A(i, 1));
      for j = 2:colunas
        valor = A(i, j);
        if valor >= 0
          printf("+ %.2fx%d ", valor, j);
        else
          printf("- %.2fx%d ", abs(valor), j);
        end
      endfor
      printf("= %.2f\n", b(i));
    endfor

  disp("é");

  for i = 1:length(x)
      printf("x%d = %.6f\n", i, x(i));
  end

  b_calculado = A * x;
  erro = max(abs(b_calculado - b));
  printf("prova: %.10f\n", erro);
endfunction

function Aa = pivotamentoParcial(Aa, iter)
    n = size(Aa, 1);

    [~, pos] = max(abs(Aa(iter:n, iter)));
    pos_real = pos + iter - 1;

    if pos_real ~= iter
        Aa([iter, pos_real], :) = Aa([pos_real, iter], :);
    endif
endfunction

function x = eliminacaoGaussiana(Aa)
    [n, ~] = size(Aa);

    % eliminação progressiva
    for iter = 1 : n-1
        Aa = pivotamentoParcial(Aa, iter);
        for linha = iter+1 : n
            pivo = Aa(iter, iter);

            elemento_abaixo = Aa(linha, iter);
            fator = elemento_abaixo / pivo;
            Aa(linha, :) = Aa(linha, :) - fator * Aa(iter, :);
        endfor
    endfor

    % substituição regressiva
    x = zeros(n, 1);

    x(n) = Aa(n, end) / Aa(n, n);
    for i = n-1 : -1 : 1
        termos = Aa(i, i+1:n) * x(i+1:n);
        x(i) = (Aa(i, end) - termos) / Aa(i, i);
    endfor
endfunction

