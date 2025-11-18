function Lista3_Exercicio11()
    A = [-1,  1, -3;
          3, -2,  8;
          2, -2,  5];
    b = [-4;
         14;
          7];

    Aa = [A b];

    x = gaussJordan(Aa);

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
        end
        printf("= %.2f\n", b(i));
    end

    disp("é");

    for i = 1:length(x)
        printf("x%d = %.6f\n", i, x(i));
    end
endfunction

function Aa = pivotamentoParcial(Aa, iter)
    n = size(Aa, 1);
    [~, pos] = max(abs(Aa(iter:n, iter)));
    pos_real = pos + iter - 1;

    if pos_real ~= iter
        Aa([iter, pos_real], :) = Aa([pos_real, iter], :);
    endif
endfunction

function x = gaussJordan(Aa)
    [n, ~] = size(Aa);

    for iter = 1 : n
        Aa = pivotamentoParcial(Aa, iter);

        % normalização
        pivo = Aa(iter, iter);
        Aa(iter, :) = Aa(iter, :) / pivo;

        for linha = 1 : n
            if linha ~= iter
                fator = Aa(linha, iter);
                Aa(linha, :) = Aa(linha, :) - fator * Aa(iter, :);
            endif
        endfor
    endfor
    x = Aa(:, end);
endfunction
