%% MonteCarlo_TablaVI_Fig6.m
% -------------------------------------------------------------------------
% Sec. 3.9 del articulo: incertidumbre del radio estimado mediante
% simulacion Monte Carlo.
%
%   Parte A  Tabla VI: media, desviacion estandar e IC95 % de r_est para
%            linealizacion y ajuste no lineal (h0 fijo), con ruido de 1 y 2 %.
%   Parte B  Figura 6: distribuciones de r_est para sigma = 2 %.
%   Parte C  Verificacion citada en la Sec. 3.9.2: con h0 libre tambien en el
%            ajuste no lineal, las dispersiones de ambos metodos son comparables.
%
% Modelo de ruido (Sec. 3.9.1), multiplicativo, sobre la solucion exacta (4)
% evaluada con beta_real y SIN redondeo:
%       h_i^(k) = h(t_i) (1 + sigma xi_i^(k)),   xi_i^(k) ~ N(0,1).
%
% Salidas: resultados en consola, TablaVI_montecarlo.csv y Fig6_montecarlo.pdf
% Requisitos: MATLAB R2020a o posterior y Optimization Toolbox (lsqcurvefit).
% Semilla fija: rng(2026). Tiempo de ejecucion: unos minutos.
%
% Articulo: G. Calderon y J. C. Carrillo Escobar, "Modelacion e inferencia
% de parametros mediante la ley de Torricelli", Rev. Mex. Fis. E (2026).
% -------------------------------------------------------------------------

clear; close all; clc

%% Parametros (Tabla I) y escenario exacto
R     = 2.5;  Cd = 0.61;  g = 9.81;  h0 = 10.0;
r0    = 0.040;  rReal = 0.035;
A     = pi*R^2;
beta  = @(rad) Cd*(pi*rad.^2)/A*sqrt(2*g);          % ec. (2)
radio = @(b) sqrt(b*R^2/(Cd*sqrt(2*g)));            % ec. (11)
bReal = beta(rReal);

t  = (0:300:3600)';                                 % instantes de la Tabla II
hx = (sqrt(h0) - bReal/2*t).^2;                     % ec. (4), sin redondeo

%% Configuracion
N      = 3000;                                      % replicas por nivel
sigmas = [0.01 0.02];                               % ruido relativo
nS     = numel(sigmas);

% Ajuste no lineal, ec. (10), con h0 fijo; se estima p = beta*1e4
modelo = @(p, tt) (sqrt(h0) - (p*1e-4)/2*tt).^2;
optLM  = optimoptions('lsqcurvefit', 'Algorithm','levenberg-marquardt', ...
         'Display','off', 'FunctionTolerance',1e-14, ...
         'StepTolerance',1e-14, 'OptimalityTolerance',1e-14);

%% ===================== Parte A: Tabla VI ===============================
rng(2026);                                          % semilla fija
rL = zeros(N, nS);                                  % linealizacion
rM = zeros(N, nS);                                  % no lineal, h0 fijo
H  = cell(1, nS);                                   % replicas (se reusan en C)

for is = 1:nS
    s = sigmas(is);
    H{is} = zeros(numel(t), N);
    for k = 1:N
        hk = hx.*(1 + s*randn(size(t)));            % replica ruidosa
        H{is}(:,k) = hk;
        c        = polyfit(t, sqrt(hk), 1);         % linealizacion
        rL(k,is) = radio(-2*c(1));
        p        = lsqcurvefit(modelo, 5, t, hk, [], [], optLM);
        rM(k,is) = radio(p*1e-4);
    end
end

fprintf('PARTE A: Tabla VI (N = %d, semilla 2026)\n', N);
fprintf('%-6s %-10s %10s %10s %24s %10s\n', 'sigma', 'metodo', 'media', 'sd', 'IC95 %', '|media-r|/EEM');
filas  = {};
metodo = {'Lineal', 'No lineal'};
for is = 1:nS
    for j = 1:2
        if j == 1, x = rL(:,is); else, x = rM(:,is); end
        q   = prctile(x, [2.5 97.5]);
        eem = std(x)/sqrt(N);                       % error estandar de la media
        fprintf('%-6s %-10s %10.6f %10.6f   [%.5f, %.5f] %10.2f\n', ...
            sprintf('%g%%', 100*sigmas(is)), metodo{j}, mean(x), std(x), ...
            q(1), q(2), abs(mean(x) - rReal)/eem);
        filas(end+1,:) = {100*sigmas(is), metodo{j}, mean(x), std(x), q(1), q(2)}; %#ok<SAGROW>
    end
    fprintf('       razon s_lin/s_nl = %.2f\n', std(rL(:,is))/std(rM(:,is)));
end
fprintf('(Esperado con semilla 2026: 1%% lineal 0.035002 +- 0.000223 [0.03457, 0.03543])\n\n');

% Filas listas para LaTeX
fprintf('Filas LaTeX de la Tabla VI:\n');
for f = 1:size(filas,1)
    fprintf('%g & %s & $%.6f \\pm %.6f$ & $[%.5f,\\ %.5f]$ \\\\\n', filas{f,:});
end
fprintf('\n');

T6 = cell2table(filas, 'VariableNames', ...
     {'sigma_pct','metodo','r_media','r_sd','IC95_inf','IC95_sup'});
writetable(T6, 'TablaVI_montecarlo.csv');

%% ===================== Parte B: Figura 6 ===============================
is    = 2;                                          % sigma = 2 %
edges = linspace(0.0335, 0.0365, 61);

figure('Units','centimeters', 'Position',[2 2 12 9], 'Renderer','painters');
hold on; box on
histogram(rL(:,is), edges, 'Normalization','pdf', 'FaceAlpha',0.5, ...
    'DisplayName','Linealizaci\''on');
histogram(rM(:,is), edges, 'Normalization','pdf', 'FaceAlpha',0.5, ...
    'DisplayName','No lineal');
xline(rReal, 'k-',  'LineWidth',1.4, 'DisplayName','$r_{\mathrm{real}} = 0.035$ m');
xline(r0,    'k--', 'LineWidth',1.4, 'DisplayName','$r_0 = 0.040$ m');
xlim([0.0335 0.0405]);
xlabel('$r_{\mathrm{est}}$ (m)', 'Interpreter','latex');
ylabel('Densidad (m$^{-1}$)', 'Interpreter','latex');
legend('Location','northeast', 'Interpreter','latex', 'Box','off');
set(gca, 'FontSize',11, 'TickLabelInterpreter','latex');
exportgraphics(gcf, 'Fig6_montecarlo.pdf', 'ContentType','vector');

%% ===================== Parte C: h0 libre ===============================
% Mismas replicas de la Parte A. El ajuste no lineal estima ahora dos
% parametros, beta y sqrt(h0), igual que la regresion lineal.
modelo2 = @(p, tt) (p(2) - (p(1)*1e-4)/2*tt).^2;
fprintf('PARTE C: ajuste no lineal con h0 libre\n');
for is = 1:nS
    rLib = zeros(N,1);
    for k = 1:N
        p       = lsqcurvefit(modelo2, [5 sqrt(h0)], t, H{is}(:,k), [], [], optLM);
        rLib(k) = radio(p(1)*1e-4);
    end
    fprintf('  sigma = %g %%:  s_lin/s_nl(h0 fijo) = %.2f   s_lin/s_nl(h0 libre) = %.2f\n', ...
        100*sigmas(is), std(rL(:,is))/std(rM(:,is)), std(rL(:,is))/std(rLib));
end
