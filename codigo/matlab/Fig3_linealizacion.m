%% Fig3_linealizacion.m
% -------------------------------------------------------------------------
% Figura 3 del articulo (Sec. 2.3): forma linealizada de la solucion,
%
%       y(t) = sqrt(h0) - (beta/2) t,                       ec. (7)
%
% para tres condiciones iniciales h0 = 10, 8 y 6 m y dos valores de beta:
%   beta_real = beta(r_real), r_real = 0.035 m  -> linea continua
%   beta_0    = beta(r0),     r0     = 0.040 m  -> linea discontinua
% con beta(r) = Cd*pi*r^2/A*sqrt(2g), ec. (2), y los parametros de la Tabla I.
%
% Salida : Fig3_linealizacion.pdf (vectorial)
% Requisitos: MATLAB R2020a o posterior (exportgraphics). Sin toolboxes.
%
% Articulo: G. Calderon y J. C. Carrillo Escobar, "Modelacion e inferencia
% de parametros mediante la ley de Torricelli", Rev. Mex. Fis. E (2026).
% -------------------------------------------------------------------------

clear; close all; clc

%% Parametros (Tabla I)
R     = 2.5;       % radio del tanque [m]
Cd    = 0.61;      % coeficiente de descarga [-]
g     = 9.81;      % aceleracion de la gravedad [m/s^2]
r0    = 0.040;     % radio nominal (de diseno) del orificio [m]
rReal = 0.035;     % radio efectivo usado para construir el escenario [m]

A    = pi*R^2;                                 % seccion del tanque [m^2]
beta = @(rad) Cd*(pi*rad.^2)/A*sqrt(2*g);      % ec. (2) [m^(1/2)/s]

beta0    = beta(r0);
betaReal = beta(rReal);

%% Verificacion contra el texto
fprintf('beta_0    = %.4e m^(1/2)/s   (texto: 6.9170e-04)\n', beta0);
fprintf('beta_real = %.4e m^(1/2)/s   (texto: 5.2958e-04)\n', betaReal);

%% Curvas
% y(t) es una recta: bastan sus dos extremos. Con pocos puntos el
% renderizador 'painters' dibuja correctamente las lineas discontinuas.
t   = [0 3600];                    % intervalo de la Tabla II [s]
h0s = [10 8 6];                    % condiciones iniciales [m]
C   = [0.00 0.45 0.74;             % azul
       0.85 0.33 0.10;             % naranja
       0.47 0.67 0.19];            % verde

figure('Units','centimeters', 'Position',[2 2 12 9], 'Renderer','painters');
hold on; box on; grid on
for k = 1:numel(h0s)
    yReal = sqrt(h0s(k)) - betaReal/2*t;       % ec. (7) con beta_real
    yNom  = sqrt(h0s(k)) - beta0/2*t;          % ec. (7) con beta_0
    plot(t, yReal, 'LineStyle','-',  'Color',C(k,:), 'LineWidth',1.8, ...
        'DisplayName', sprintf('$h_0 = %d$ m, $\\beta_{\\mathrm{real}}$', h0s(k)));
    plot(t, yNom,  'LineStyle','--', 'Color',C(k,:), 'LineWidth',1.4, ...
        'HandleVisibility','off');
end
% Entrada de leyenda comun para las lineas discontinuas
plot(nan, nan, 'LineStyle','--', 'Color','k', 'LineWidth',1.4, ...
    'DisplayName', 'misma $h_0$, $\beta_0$ (nominal)');

xlabel('$t$ (s)', 'Interpreter','latex');
ylabel('$y=\sqrt{h}$ (m$^{1/2}$)', 'Interpreter','latex');
xlim([0 3600]);
% 'northeast': esa zona queda libre y la leyenda no tapa las rectas
legend('Location','northeast', 'Interpreter','latex', 'Box','off');
set(gca, 'FontSize',11, 'TickLabelInterpreter','latex');

%% Exportar
exportgraphics(gcf, 'Fig3_linealizacion.pdf', 'ContentType','vector');
