%% Fig4_Fig5_resultados.m
% -------------------------------------------------------------------------
% Resultados de las Secs. 3.1 a 3.8 del articulo y Figuras 4 y 5.
%
%   Sec. 3.1  Datos sinteticos (Tabla II): redondeo a dos decimales de la
%             solucion exacta (4) con beta_real, y perturbacion de redondeo
%   Sec. 3.2  Solucion nominal y errores relativos, ec. (8)
%   Sec. 3.3  Estimacion de beta: linealizacion, ec. (9), y ajuste no
%             lineal directo con h0 fijo, ec. (10)  -> Tabla V
%   Sec. 3.5  Radio efectivo, ec. (11), y reducciones de radio y area
%   Sec. 3.7  Tiempo total de vaciado, ec. (5)
%   Sec. 3.8  Errores de la solucion ajustada y clasificacion (Tabla IV)
%
% Datos: la Tabla II se genera en este script. Si se ejecuta desde la carpeta
% codigo/matlab del repositorio, ademas se comprueba que coincide con
% datos/sinteticos/datos_actividad_sintetica.csv.
%
% Salidas: resultados en consola, Fig4_nominal.pdf y Fig5_ajuste.pdf
% Requisitos: MATLAB R2020a o posterior (exportgraphics) y Optimization
%             Toolbox (lsqcurvefit) para el ajuste no lineal.
%
% Articulo: G. Calderon y J. C. Carrillo Escobar, "Modelacion e inferencia
% de parametros mediante la ley de Torricelli", Rev. Mex. Fis. E (2026).
% -------------------------------------------------------------------------

clear; close all; clc

%% Parametros (Tabla I)
R     = 2.5;       % radio del tanque [m]
Cd    = 0.61;      % coeficiente de descarga [-]
g     = 9.81;      % aceleracion de la gravedad [m/s^2]
h0    = 10.0;      % altura inicial [m]
r0    = 0.040;     % radio nominal del orificio [m]
rReal = 0.035;     % radio efectivo usado para construir el escenario [m]

A     = pi*R^2;
beta  = @(rad) Cd*(pi*rad.^2)/A*sqrt(2*g);          % ec. (2)
radio = @(b) sqrt(b*R^2/(Cd*sqrt(2*g)));            % ec. (11)
hsol  = @(b, tt) (sqrt(h0) - b/2*tt).^2;            % ec. (4)

beta0    = beta(r0);
betaReal = beta(rReal);

%% ===================== Sec. 3.1: datos sinteticos ======================
t       = (0:300:3600)';                % instantes de medicion [s]
hExacta = hsol(betaReal, t);            % ec. (4) con beta_real, sin redondeo

% Tabla II: redondeo a dos cifras decimales (resolucion de 0.01 m)
h = round(hExacta, 2);

fprintf('SEC. 3.1  Datos sinteticos (Tabla II)\n');
fprintf('%6s %10s %10s\n', 't (s)', 'exacta', 'Tabla II');
fprintf('%6d %10.4f %10.2f\n', [t, hExacta, h]');

% Comprobacion contra el archivo de datos del repositorio (si existe)
archivo = fullfile('..', '..', 'datos', 'sinteticos', 'datos_actividad_sintetica.csv');
if isfile(archivo)
    D = readmatrix(archivo);                      % columnas: t_s, h_m
    ok = isequal(D(:,1), t) && max(abs(D(:,2) - h)) < 1e-9;
    fprintf('Coincide con %s: %s\n', archivo, string(ok));
end

pert = 100*abs(h - hExacta)./hExacta;
fprintf('Perturbacion maxima respecto de la curva exacta: %.3f %%\n\n', max(pert));

% Tabla III: y = sqrt(h), mostrada con cuatro decimales.
% El ajuste usa sqrt(h) con precision completa; la diferencia en la
% pendiente respecto de usar los valores de cuatro decimales es < 1e-9.
y = sqrt(h);
fprintf('Tabla III, y = sqrt(h):\n'); fprintf('%.4f  ', y); fprintf('\n\n');

%% ===================== Sec. 3.2: solucion nominal ======================
hNom = hsol(beta0, t);
Enom = 100*abs(h - hNom)./h;                         % ec. (8) con h^ = h_nom
fprintf('SEC. 3.2  beta_0 = %.4e m^(1/2)/s\n', beta0);
fprintf('  E_max,nom = %.2f %% (%s)   E_med,nom = %.2f %% (%s)\n\n', ...
    max(Enom), clasificar(max(Enom)), mean(Enom), clasificar(mean(Enom)));

%% ===================== Sec. 3.3: estimacion de beta ====================
% (a) Linealizacion: pendiente por minimos cuadrados, ec. (9)
n     = numel(t);
m     = (n*sum(t.*y) - sum(t)*sum(y)) / (n*sum(t.^2) - sum(t)^2);
betaE = -2*m;

% (b) Ajuste no lineal directo, ec. (10), con h0 FIJO en su valor de la
%     Tabla I. Se estima p = beta*1e4 (p ~ 5) para evitar problemas de escala.
modelo = @(p, tt) (sqrt(h0) - (p*1e-4)/2*tt).^2;
optLM  = optimoptions('lsqcurvefit', 'Algorithm','levenberg-marquardt', ...
         'Display','off', 'FunctionTolerance',1e-14, ...
         'StepTolerance',1e-14, 'OptimalityTolerance',1e-14);
betaNL = lsqcurvefit(modelo, 5, t, h, [], [], optLM)*1e-4;

fprintf('SEC. 3.3\n');
fprintf('  pendiente m       = %.4e m^(1/2)/s\n', m);
fprintf('  beta_real         = %.4e\n', betaReal);
fprintf('  beta_est          = %.4e   (dif. con beta_real: %.3f %%)\n', ...
    betaE, 100*abs(betaReal - betaE)/betaReal);
fprintf('  beta_est^(nl)     = %.4e   (dif. con beta_est:  %.3f %%)\n\n', ...
    betaNL, 100*abs(betaNL - betaE)/betaE);

fprintf('TABLA V\n');
fprintf('  %-34s %12s %10s\n', 'Cantidad', 'beta', 'r (m)');
fprintf('  %-34s %12.4e %10.6f\n', 'beta_0 (nominal)',             beta0,    r0);
fprintf('  %-34s %12.4e %10.6f\n', 'beta_real (teorico)',          betaReal, rReal);
fprintf('  %-34s %12.4e %10.6f\n', 'beta_est (ajuste lineal)',     betaE,    radio(betaE));
fprintf('  %-34s %12.4e %10.6f\n\n', 'beta_est^(nl) (no lineal)',  betaNL,   radio(betaNL));

%% ===================== Sec. 3.5: radio efectivo ========================
rE = radio(betaE);
fprintf('SEC. 3.5\n');
fprintf('  r_est = %.6f m   (dif. con r_real: %.3f %%)\n', rE, 100*abs(rReal - rE)/rReal);
fprintf('  reduccion del radio = %.2f %%\n', 100*(r0 - rE)/r0);
fprintf('  reduccion del area  = %.2f %%\n', 100*(r0^2 - rE^2)/r0^2);
fprintf('  (r0/r_est)^2        = %.4f\n\n', (r0/rE)^2);

%% ===================== Sec. 3.7: tiempo de vaciado =====================
Test = 2*sqrt(h0)/betaE;                             % ec. (5)
Tnom = 2*sqrt(h0)/beta0;
fprintf('SEC. 3.7\n');
fprintf('  T_est = %.4e s = %.1f min = %.2f h\n', Test, Test/60, Test/3600);
fprintf('  T_nom = %.4e s = %.1f min = %.2f h\n', Tnom, Tnom/60, Tnom/3600);
fprintf('  T_est/T_nom = %.3f;  T_est/3600 s = %.2f;  h(3600 s) = %.2f m\n\n', ...
    Test/Tnom, Test/3600, h(end));

%% ===================== Sec. 3.8: ajuste del modelo =====================
hEst = hsol(betaE, t);
Eest = 100*abs(h - hEst)./h;                         % ec. (8) con h^ = h_est
fprintf('SEC. 3.8\n');
fprintf('  E_max,est = %.3f %% (%s)   E_med,est = %.4f %% (%s)\n', ...
    max(Eest), clasificar(max(Eest)), mean(Eest), clasificar(mean(Eest)));
fprintf('  reduccion del error medio = %.2f %%\n', 100*(mean(Enom) - mean(Eest))/mean(Enom));
fprintf('  residuo absoluto maximo   = %.4f m (resolucion de los datos: 0.01 m)\n', ...
    max(abs(h - hEst)));
fprintf('  perturbacion maxima de los datos (Sec. 3.1) = %.3f %%\n\n', max(pert));

%% ===================== Figuras 4 y 5 ===================================
tt = linspace(0, 3600, 400);                         % malla fina para curvas
estiloEjes = {'FontSize',11, 'TickLabelInterpreter','latex'};

% Figura 4: datos sinteticos y solucion nominal
figure('Units','centimeters', 'Position',[2 2 12 9], 'Renderer','painters');
hold on; box on; grid on
plot(t, h, 'ko', 'MarkerFaceColor','k', 'MarkerSize',5, ...
    'DisplayName','Datos sint\''eticos');
plot(tt, hsol(beta0, tt), 'r-', 'LineWidth',1.6, ...
    'DisplayName','Soluci\''on nominal');
xlabel('$t$ (s)', 'Interpreter','latex');
ylabel('$h(t)$ (m)', 'Interpreter','latex');
xlim([0 3700]); ylim([3 10.5]);
legend('Location','northeast', 'Interpreter','latex', 'Box','off');
set(gca, estiloEjes{:});
exportgraphics(gcf, 'Fig4_nominal.pdf', 'ContentType','vector');

% Figura 5: datos sinteticos, solucion nominal y solucion ajustada
figure('Units','centimeters', 'Position',[2 2 12 9], 'Renderer','painters');
hold on; box on; grid on
plot(t, h, 'ko', 'MarkerFaceColor','k', 'MarkerSize',5, ...
    'DisplayName','Datos sint\''eticos');
plot(tt, hsol(beta0, tt), 'r-', 'LineWidth',1.6, ...
    'DisplayName','Soluci\''on nominal');
plot(tt, hsol(betaE, tt), 'b-.', 'LineWidth',1.6, ...
    'DisplayName','Soluci\''on ajustada');
xlabel('$t$ (s)', 'Interpreter','latex');
ylabel('$h(t)$ (m)', 'Interpreter','latex');
xlim([0 3700]); ylim([3 10.5]);
legend('Location','northeast', 'Interpreter','latex', 'Box','off');
set(gca, estiloEjes{:});
exportgraphics(gcf, 'Fig5_ajuste.pdf', 'ContentType','vector');

%% ===================== Funcion local ===================================
function c = clasificar(E)
% Categoria de la Tabla IV para un error relativo E (en %).
    if E < 2
        c = 'excelente ajuste';
    elseif E < 5
        c = 'buen ajuste';
    elseif E < 10
        c = 'aceptable pero relevante';
    elseif E < 15
        c = 'error significativo';
    else
        c = 'error critico';
    end
end
