"""
Figuras esquemáticas originales para la actividad de vaciado de tanques
(ley de Torricelli). Reemplazan las fotografías de terceros usadas en
versiones anteriores, por lo que pueden publicarse con licencia abierta.

  F1_tanque_esquema.(pdf|png):  tanque cilíndrico vertical con orificio
                                lateral al fondo; define h(t), R, A_w y A_h.
  F2_orificio_efectivo.(pdf|png): orificio nominal frente a orificio con
                                incrustaciones, y círculo de área
                                equivalente que define el radio efectivo r.

Reproducible: no usa datos externos; la forma irregular de la
incrustación se genera con una semilla fija.

Uso:  python figuras_esquematicas.py   (escribe en ../figuras/)
Requiere: numpy, matplotlib (probado con matplotlib 3.11).
"""
from pathlib import Path

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse, Polygon, Circle, FancyArrowPatch

OUT = Path(__file__).resolve().parents[2] / "figuras"
OUT.mkdir(parents=True, exist_ok=True)

plt.rcParams.update({
    "font.family": "serif",
    "font.serif": ["TeX Gyre Termes", "Liberation Serif", "DejaVu Serif"],
    "mathtext.fontset": "stix",
    "font.size": 12,
})

AGUA = "#cfe6f5"      # relleno del agua
AGUA_SUP = "#9fcbe8"  # superficie libre
TRAZO = "#2b2b2b"
COTA = "#1f4e79"
DEPOSITO = "#c8a26b"  # incrustación
EFECTIVA = "#3a86c8"  # área efectiva (círculo equivalente)


def cota_vertical(ax, x, y0, y1, texto, dx=0.12):
    """Flecha de cota vertical con etiqueta a la derecha."""
    ax.add_patch(FancyArrowPatch((x, y0), (x, y1), arrowstyle="<->",
                                 mutation_scale=12, color=COTA, lw=1.1))
    ax.text(x + dx, 0.5 * (y0 + y1), texto, color=COTA,
            va="center", ha="left")


# ----------------------------------------------------------------------
# F1. Tanque cilíndrico
# ----------------------------------------------------------------------
def figura_tanque():
    fig, ax = plt.subplots(figsize=(5.2, 5.4))
    R, e = 1.6, 0.35          # semieje horizontal y vertical de las elipses
    yb, yt, yh = 0.0, 4.0, 2.7  # fondo, tapa, nivel del agua

    # Agua: cuerpo + superficie libre
    ax.add_patch(Polygon([(-R, yb - 0.02), (-R, yh), (R, yh), (R, yb - 0.02)],
                         closed=True, color=AGUA, lw=0))
    th = np.linspace(np.pi, 2 * np.pi, 100)
    ax.fill_between(R * np.cos(th), yb + e * np.sin(th), yb,
                    color=AGUA, lw=0)
    ax.add_patch(Ellipse((0, yh), 2 * R, 2 * e, fc=AGUA_SUP,
                         ec=COTA, lw=0.8))

    # Paredes, tapa y fondo
    ax.plot([-R, -R], [yb, yt], color=TRAZO, lw=1.4)
    ax.plot([R, R], [yb, yt], color=TRAZO, lw=1.4)
    ax.add_patch(Ellipse((0, yt), 2 * R, 2 * e, fc="none",
                         ec=TRAZO, lw=1.4))
    t_front = np.linspace(np.pi, 2 * np.pi, 100)
    t_back = np.linspace(0, np.pi, 100)
    ax.plot(R * np.cos(t_front), yb + e * np.sin(t_front),
            color=TRAZO, lw=1.4)
    ax.plot(R * np.cos(t_back), yb + e * np.sin(t_back),
            color=TRAZO, lw=0.9, ls=(0, (4, 3)))

    # Orificio lateral al fondo y chorro parabólico
    yo = yb + 0.14                      # centro del orificio (casi al fondo)
    ax.add_patch(Ellipse((R, yo), 0.07, 0.20, fc="white",
                         ec=TRAZO, lw=1.1, zorder=5))
    xj = np.linspace(R + 0.03, R + 1.35, 80)
    s = (xj - xj[0]) / (xj[-1] - xj[0])
    yj = yo - 1.25 * s ** 2             # trayectoria parabólica
    ancho = 0.075 * (1 - 0.45 * s)      # el chorro se adelgaza
    ax.fill_between(xj, yj - ancho, yj + ancho, color="#6fb0dc", lw=0)

    # Eje
    ax.plot([0, 0], [yb - e, yt + 0.6], color="0.45", lw=0.8,
            ls=(0, (6, 3)))

    # Nivel de referencia: centro del orificio
    ax.plot([-R - 0.5, R], [yo, yo], color=COTA, lw=0.7, ls=(0, (3, 2)))
    ax.plot([-R - 0.5, -R], [yh, yh], color=COTA, lw=0.7)

    # Cotas y rótulos
    ax.add_patch(FancyArrowPatch((-R - 0.35, yo), (-R - 0.35, yh),
                                 arrowstyle="<->", mutation_scale=12,
                                 color=COTA, lw=1.1))
    ax.text(-R - 0.47, 0.5 * (yo + yh), r"$h(t)$", color=COTA,
            va="center", ha="right")
    ax.annotate("", xy=(R, yh), xytext=(0, yh),
                arrowprops=dict(arrowstyle="->", color=COTA, lw=1.1))
    ax.text(0.5 * R, yh + 0.08, r"$R$", color=COTA, ha="center",
            va="bottom")
    ax.annotate(r"$A_w=\pi R^2$", xy=(-0.45 * R, yh + 0.05),
                xytext=(-R - 0.6, yh + 1.15),
                arrowprops=dict(arrowstyle="->", color=TRAZO, lw=0.8),
                ha="center")
    ax.annotate(r"$A_h=\pi r^2$", xy=(R + 0.02, yo + 0.08),
                xytext=(R + 1.0, yo + 1.0),
                arrowprops=dict(arrowstyle="->", color=TRAZO, lw=0.8),
                ha="center")
    ax.text(R + 1.4, yo - 0.85, "chorro de salida", fontsize=10,
            color="0.3", ha="left")

    ax.set_xlim(-R - 1.7, R + 3.0)
    ax.set_ylim(yb - e - 1.2, yt + 0.8)
    ax.set_aspect("equal")
    ax.axis("off")
    return fig


# ----------------------------------------------------------------------
# F2. Orificio nominal frente a orificio con incrustaciones
# ----------------------------------------------------------------------
def borde_irregular(r_medio, rng, n_modos=7, amplitud=0.10, n=720):
    """Contorno polar rho(theta) suave y cerrado (serie de Fourier corta)."""
    th = np.linspace(0, 2 * np.pi, n, endpoint=False)
    rho = np.ones_like(th)
    for k in range(2, n_modos + 2):
        a = amplitud * rng.uniform(0.3, 1.0) / k ** 0.6
        rho += a * np.cos(k * th + rng.uniform(0, 2 * np.pi))
    return th, r_medio * rho


def area_polar(th, rho):
    """Área encerrada por rho(theta): (1/2)∫ rho^2 dtheta (regla del trapecio periódica)."""
    return 0.5 * np.sum(rho ** 2) * (th[1] - th[0])


def figura_orificio():
    rng = np.random.default_rng(20261012)   # semilla fija
    r0, pared = 1.0, 0.07
    th, rho = borde_irregular(0.82 * r0, rng, n_modos=45, amplitud=0.045)
    r_ef = np.sqrt(area_polar(th, rho) / np.pi)   # radio del círculo equivalente
    assert rho.max() < r0, "la incrustación no puede exceder el orificio"

    fig, axs = plt.subplots(1, 2, figsize=(8.4, 4.3))
    for ax in axs:
        ax.add_patch(Circle((0, 0), r0 + pared, fc="0.82", ec=TRAZO, lw=1.2))
        ax.set_xlim(-1.4, 1.4)
        ax.set_ylim(-1.45, 1.4)
        ax.set_aspect("equal")
        ax.axis("off")

    # (a) nominal
    a = axs[0]
    a.add_patch(Circle((0, 0), r0, fc=AGUA, ec=TRAZO, lw=1.2))
    a.annotate("", xy=(r0 * np.cos(0.6), r0 * np.sin(0.6)), xytext=(0, 0),
               arrowprops=dict(arrowstyle="->", color=COTA, lw=1.2))
    a.text(0.42, 0.12, r"$r_0$", color=COTA, fontsize=13)
    a.set_title("(a) Orificio nominal", fontsize=12, pad=4)

    # (b) con incrustaciones
    b = axs[1]
    b.add_patch(Circle((0, 0), r0, fc=DEPOSITO, ec=TRAZO, lw=1.2,
                       hatch="....", alpha=0.95))
    xy = np.column_stack([rho * np.cos(th), rho * np.sin(th)])
    b.add_patch(Polygon(xy, closed=True, fc=AGUA, ec="none"))
    # Área efectiva: círculo equivalente resaltado (relleno translúcido)
    b.add_patch(Circle((0, 0), r_ef, fc=EFECTIVA, ec="none", alpha=0.45))
    b.add_patch(Polygon(xy, closed=True, fc="none", ec=TRAZO, lw=0.9))
    b.add_patch(Circle((0, 0), r_ef, fc="none", ec=COTA, lw=2.0,
                       ls=(0, (6, 3))))
    b.annotate("", xy=(r_ef * np.cos(2.3), r_ef * np.sin(2.3)), xytext=(0, 0),
               arrowprops=dict(arrowstyle="->", color=COTA, lw=1.2))
    b.text(-0.36, 0.06, r"$r$", color=COTA, fontsize=14, fontweight="bold")
    b.annotate("incrustación", xy=(0.93 * np.cos(-0.7), 0.93 * np.sin(-0.7)),
               xytext=(0.95, -1.32), fontsize=10, ha="center",
               arrowprops=dict(arrowstyle="->", color=TRAZO, lw=0.8))
    b.set_title("(b) Orificio con incrustaciones", fontsize=12, pad=4)
    b.text(0, 1.17, r"$\pi r^2=$ área libre de paso", ha="center",
           fontsize=11, color=COTA)

    fig.tight_layout()
    return fig, r_ef / r0


if __name__ == "__main__":
    f1 = figura_tanque()
    f2, ratio = figura_orificio()
    for fig, nombre in [(f1, "F1_tanque_esquema"), (f2, "F2_orificio_efectivo")]:
        fig.savefig(OUT / f"{nombre}.pdf", bbox_inches="tight")
        fig.savefig(OUT / f"{nombre}.png", dpi=300, bbox_inches="tight")
    print(f"r/r0 del esquema (solo ilustrativo): {ratio:.3f}")
