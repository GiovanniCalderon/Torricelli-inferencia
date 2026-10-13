"""
Verificación numérica de la actividad con datos sintéticos del vaciado de
tanques mediante la ley de Torricelli.

Calcula todas las cantidades que pide el enunciado. Es la base del
solucionario: NO debe distribuirse a los estudiantes junto con la actividad.

Datos: Cuadro 2 de la actividad (idénticos a los del artículo). Se generaron
con el modelo (2) para r_real = 0.035 m y se redondearon a dos decimales;
no contienen otro ruido. El script lo comprueba al final.

Uso:  python verificacion_actividad_A.py
Requiere: numpy.
"""
import numpy as np

# ---------------------------------------------------------------- datos
from pathlib import Path

Cd, R, g, r0, h0 = 0.61, 2.5, 9.81, 0.04, 10.0          # Cuadro 1
DATOS = (Path(__file__).resolve().parents[2]
         / "datos" / "sinteticos" / "datos_actividad_sintetica.csv")
t, h = np.loadtxt(DATOS, delimiter=",", skiprows=1, unpack=True)  # s, m
N = t.size


def beta_de(r):
    """Ec. (4): beta = Cd (r/R)^2 sqrt(2g)   [m^(1/2)/s] (notación del artículo)."""
    return Cd * (r / R) ** 2 * np.sqrt(2 * g)


def r_de(beta):
    """Inversa de (4): r = sqrt(beta R^2 / (Cd sqrt(2g)))   [m]."""
    return np.sqrt(beta * R ** 2 / (Cd * np.sqrt(2 * g)))


def h_modelo(tt, beta, raiz_h0):
    """Ec. (2), válida solo para 0 <= t <= 2 raiz_h0/beta; después h = 0."""
    y = np.clip(raiz_h0 - 0.5 * beta * tt, 0.0, None)
    return y ** 2


# ------------------------------------------- ítem 1: linealización
y = np.sqrt(h)

# ------------------------------------------- ítem 2: mínimos cuadrados
# Ecuaciones normales del ajuste y = a + m t
S_t, S_tt, S_y, S_ty = t.sum(), (t * t).sum(), y.sum(), (t * y).sum()
det = N * S_tt - S_t ** 2
m = (N * S_ty - S_t * S_y) / det
a = (S_y * S_tt - S_t * S_ty) / det
assert np.allclose([a, m], np.polyfit(t, y, 1)[::-1])     # control cruzado
beta = -2 * m                                  # ec. (3): pendiente = -beta/2
res = y - (a + m * t)
err_a = abs(a - np.sqrt(h0)) / np.sqrt(h0)
# Escala esperada de los residuos por el redondeo a 0.01 m:
# |dy| <= 0.005 / (2 sqrt(h))
cota_red = 0.005 / (2 * np.sqrt(h.min()))

# ------------------------------------------- ítem 3: radio efectivo
r_est = r_de(beta)
red_r = 1 - r_est / r0
red_A = 1 - (r_est / r0) ** 2

# ------------------------------------------- ítem 4: validación
h_fit = h_modelo(t, beta, np.sqrt(h0))         # con h0 del Cuadro 1
ecm = np.mean((h - h_fit) ** 2)
h_fit_a = h_modelo(t, beta, a)                 # con a^2 (comparación)
ecm_a = np.mean((h - h_fit_a) ** 2)
beta0 = beta_de(r0)
T_est, T_nom = 2 * np.sqrt(h0) / beta, 2 * np.sqrt(h0) / beta0
T_90 = 2 * np.sqrt(h0) / beta_de(0.9 * r_est)      # radio 10 % menor


# RK4 para la EDO (1), detenido antes de h = 0 (allí sqrt(h) no es Lipschitz)
def rk4(f, h_ini, dt, t_fin):
    ts, hs = [0.0], [h_ini]
    while ts[-1] < t_fin - 1e-12:
        tk, hk = ts[-1], hs[-1]
        k1 = f(hk)
        k2 = f(hk + 0.5 * dt * k1)
        k3 = f(hk + 0.5 * dt * k2)
        k4 = f(hk + dt * k3)
        ts.append(tk + dt)
        hs.append(hk + dt * (k1 + 2 * k2 + 2 * k3 + k4) / 6)
    return np.array(ts), np.array(hs)


k = beta                                       # ec. (1): dh/dt = -beta sqrt(h)
f = lambda hh: -k * np.sqrt(max(hh, 0.0))
t_rk, h_rk = rk4(f, h0, 60.0, 3600.0)
err_rk = np.max(np.abs(h_rk - h_modelo(t_rk, beta, np.sqrt(h0))))

# ------------------------------------------- ítem 5: inferencia
t_2m = 2 * (np.sqrt(h0) - np.sqrt(2.0)) / beta     # tiempo para h = 2 m
# Sensibilidad a Cd con los mismos datos: r ∝ Cd^(-1/2)
r_cd = {e: r_de(beta) * np.sqrt(Cd / (Cd * (1 + e))) for e in (-0.05, 0.05)}

# ------------------------------------------- control de los datos
r_real = 0.035
h_gen = np.round(h_modelo(t, beta_de(r_real), np.sqrt(h0)), 2)
datos_ok = np.array_equal(h_gen, h)
dif_beta = abs(beta - beta_de(r_real)) / beta_de(r_real)

if __name__ == "__main__":
    print("Ítem 2  a = %.5f m^(1/2)   m = %.5e m^(1/2)/s" % (a, m))
    print("        error relativo de a frente a sqrt(h0): %.4f %%" % (100 * err_a))
    print("        beta = %.5e m^(1/2)/s" % beta)
    print("        residuos: max |res| = %.2e   (cota por redondeo ~ %.1e)"
          % (np.abs(res).max(), cota_red))
    print("Ítem 3  r_est = %.5f m   (r0 = %.3f m)" % (r_est, r0))
    print("        reducción de radio %.2f %%, de área %.2f %%"
          % (100 * red_r, 100 * red_A))
    print("Ítem 4  ECM (h0 del cuadro) = %.3e m^2   RMSE = %.4f m"
          % (ecm, np.sqrt(ecm)))
    print("        ECM (a^2)           = %.3e m^2" % ecm_a)
    print("        RK4 (dt = 60 s) vs solución exacta: max error %.2e m" % err_rk)
    print("        T_vaciado estimado = %.0f s (%.2f h); nominal = %.0f s (%.2f h)"
          % (T_est, T_est / 3600, T_nom, T_nom / 3600))
    print("        con radio 10 %% menor: %.0f s (+%.1f %%)"
          % (T_90, 100 * (T_90 / T_est - 1)))
    print("Ítem 5  t(h = 2 m) = %.0f s (%.2f h) -> %s el requisito de 2 h"
          % (t_2m, t_2m / 3600, "cumple" if t_2m <= 7200 else "NO cumple"))
    for e, rr in r_cd.items():
        print("        Cd %+d %%  ->  r_est = %.5f m (%+.2f %%)"
              % (100 * e, rr, 100 * (rr / r_est - 1)))
    print("Control datos generados con r_real = 0.035 m y redondeo: %s" % datos_ok)
    for ti, hc, hr in zip(t, h_gen, h):
        if hc != hr:
            print("        t = %4.0f s: modelo redondeado %.2f m, cuadro %.2f m"
                  % (ti, hc, hr))
    print("        |beta_est - beta_real| / beta_real = %.3f %%" % (100 * dif_beta))
