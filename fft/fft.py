import math
import matplotlib.pyplot as plt
import numpy  as np

def permute(x: list):
    padding = int(math.log2(len(x)))
    output = x.copy()

    for index, data in enumerate(x):
        bit_reversed_index = int(format(index, 'b').zfill(padding)[::-1], 2)
        output[bit_reversed_index] = data
 
    return output



def danielson_lanczos(x, w, N):
    M = 1
    while N > M:
        Istep = M * 2
        Mstep = N // 2 // M
        for m in range(0, M):
            
            for i in range(m, N, Istep):
                j = i + M
                Temp = w[m*Mstep] * x[j]
                x[j] = x[i] - Temp
                x[i] = x[i] + Temp
            # end for
        # end for
        M = Istep
    # while loop

srate  = 64 # hz
time   = np.arange(0,1.,1/srate)  # time vector in seconds
pnts   = len(time) # number of time points
signal = 2.5 * np.sin( 2*np.pi*2*time ) + 1.5 * np.sin( 2*np.pi*3*time ) + 0.4 * np.sin( 2*np.pi*7*time )

data = []

for r in signal:
    data.append(complex(r, 0))

N = len(signal)
w = [complex(math.cos((2*k*np.pi)/N), math.sin((2*k*np.pi)/N)) for k in range(N//2)]

data = permute(data) # bit order reversal

danielson_lanczos(data, w, N) # butterfly fft

pnts = N // 2

# extract amplitudes
ampls = np.abs(data)/N
ampls[range(1,len(ampls))] = 2*ampls[range(1,len(ampls))]
hz = np.linspace(0,pnts,num=math.floor(pnts)+1)

fig, ax = plt.subplots(1,2)
ax[0].stem(hz,ampls[range(0,len(hz))])

# plt.step([_ for _ in range(0, N)], [y.real/pnts for y in data])
# plt.stem([_ for _ in range(0, N)], [y.imag/pnts for y in data])
#plt.show()

## first, the forward Fourier transform

pnts = N
# prepare the Fourier transform
fourTime = np.array(np.arange(0,pnts))/pnts
fCoefs   = np.zeros(len(signal),dtype=complex)

for fi in range(0,pnts):
    
    # create complex sine wave
    csw = np.exp( -1j*2*np.pi*fi*fourTime )
    
    # compute dot product between sine wave and signal
    fCoefs[fi] = np.sum( np.multiply(signal,csw) )

# extract amplitudes
ampls = np.abs(fCoefs) / pnts
ampls[range(2,len(ampls))] = 2*ampls[range(2,len(ampls))]

# compute frequencies vector
hz = np.linspace(0,srate/2,num=math.floor(pnts/2)+1)

ax[1].stem(hz,ampls[range(0,len(hz))])
#fig.xlim([0,16])
plt.show()
# the inverse Fourier transform

# initialize time-domain reconstruction
reconSignal = np.zeros(len(signal));

for fi in range(0,pnts):
    
    # create coefficient-modulated complex sine wave
    csw = fCoefs[fi] * np.exp( 1j*2*np.pi*fi*fourTime )
    
    # sum them together
    reconSignal = reconSignal + csw


# divide by N
reconSignal = reconSignal/pnts

plt.plot(time,signal,label='original')
plt.plot(time,np.real(reconSignal),'r.',label='reconstructed')
plt.legend()
plt.show() 