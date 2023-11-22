import numpy as np
from matplotlib import pyplot as plt


max_iterations = 100 #max_iterations = 11 for Bifurcation diagram #2

p_m = np.zeros((2000, max_iterations))
r_m = np.zeros((2000, max_iterations))

def sc_plot(x):
    red = 0.0
    blue = 1.0
    incr = 1/(x - 1)
    for i in range(x):
#         print(red, blue)
        ax.scatter(r_m[:, i], p_m[:, i], s=1, c=[[red, 0.0, blue]])
        red += incr
        blue -= incr

for j in range(1, 1000):
    for r in range(2000, 4000):
        m = 0
        population = j/1000
        while m < max_iterations:
            population = r/1000*(population - population**2)
            p_m[r - 2000, m] = population
            r_m[r - 2000, m] = r/1000
            m += 1
    
    color = 'white'
    fig, ax = plt.subplots(facecolor=color)
    ax.set_facecolor(color)
    fig.set_size_inches(60, 30)
    ax.set_ylim([0, 1])
    ax.set_xlim([2, 4])
    ax.yaxis.label.set_color(color)
    ax.xaxis.label.set_color(color)
    ax.tick_params(labelcolor=color)
    sc_plot(max_iterations)
    plt.savefig('C:\\Users\\ksn\\bd3/{:04d}.png'.format(j))
    plt.clf()
    plt.close('all')
    p_m = np.zeros((2000, max_iterations))
    r_m = np.zeros((2000, max_iterations))
