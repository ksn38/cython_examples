import Julia_c_im
from matplotlib.colors import LinearSegmentedColormap
import matplotlib.pyplot as plt


colors = [
    
    (0.83529411764705885, 0.24313725490196078 , 0.30980392156862746),
    (0.95686274509803926, 0.42745098039215684 , 0.2627450980392157 ),
    (0.99215686274509807, 0.68235294117647061 , 0.38039215686274508),
    (0.99607843137254903, 0.8784313725490196  , 0.54509803921568623),
    (1.0                , 1.0                 , 0.74901960784313726),
    (0.90196078431372551, 0.96078431372549022 , 0.59607843137254901),
    (0.6705882352941176 , 0.8666666666666667  , 0.64313725490196083),
    (0.4                , 0.76078431372549016 , 0.6470588235294118 ),
    (0.19607843137254902, 0.53333333333333333 , 0.74117647058823533),
    (0.36862745098039218, 0.30980392156862746 , 0.63529411764705879),
    (0.61960784313725492, 0.003921568627450980, 0.25882352941176473)
]

my_cmap = LinearSegmentedColormap.from_list('my_cmap', colors, N=1000)

def plot1(i, real, img, my_cmap):
    jl = Julia_c_im.calc_julia((real + img), 1.4)

    fig, ax = plt.subplots()
    fig.set_size_inches(12.90, 27.96)
    fig.patch.set_visible(False)
    ax.axis('off')
    fig.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=0, hspace=0)
        
    ax.imshow(jl, cmap=my_cmap)

    plt.savefig('F:\\Temp\\tmp/{:04d}.png'.format(i))
    plt.clf()
    
plot1(0, -0.1, -0.649j, my_cmap)
