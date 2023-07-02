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

def radix_2_fft(x, w, N):
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

    # extract amplitudes
    ampls = np.abs(x)/N
    ampls[range(1,len(ampls))] = 2*ampls[range(1,len(ampls))]

    return ampls

def fft(signal, pnts):
    fourTime = np.array(np.arange(0,pnts))/pnts
    fCoefs   = np.zeros(len(signal),dtype=complex)

    for fi in range(0,pnts):
        
        # create complex sine wave
        csw = np.exp(-1j*2*np.pi*fi*fourTime)
        
        # compute dot product between sine wave and signal
        fCoefs[fi] = np.sum(np.multiply(signal,csw))

    # extract amplitudes
    ampls = np.abs(fCoefs) / pnts
    ampls[range(2,len(ampls))] = 2*ampls[range(2,len(ampls))]

    return ampls

srate  = 64 # hz
time   = np.arange(0,1.,1/srate)  # time vector in seconds
pnts   = len(time) # number of time points
signal = 2.5 * np.sin( 2*np.pi*2*time ) + 1.5 * np.sin( 2*np.pi*3*time ) + 0.4 * np.sin( 2*np.pi*7*time )
hz = np.linspace(0,srate//2,num=math.floor(pnts//2)+1)
fourTime = np.array(np.arange(0,pnts))/pnts

data = []
for r in signal:
    data.append(complex(r, 0))

w = [complex(math.cos((2*k*np.pi)/pnts), math.sin((2*k*np.pi)/pnts)) for k in range(pnts//2)]

data = permute(data) # bit order reversal
ampls_radix = radix_2_fft(data, w, pnts) # butterfly fft
ampls_fft = fft(signal, pnts)

plt.stem(hz, ampls_fft[range(0, len(hz))])
# fig, ax = plt.subplots(1,2)
# ax[0].stem(hz, ampls_radix[range(0,len(hz))])
# ax[1].stem(hz,ampls_fft[range(0,len(hz))])
plt.show()


# the inverse Fourier transform

# initialize time-domain reconstruction
reconSignal = np.zeros(len(signal));

csw = 0
for fi in range(0,pnts):
    
    # create coefficient-modulated complex sine wave
    csw += data[fi] * np.exp( 1j*2*np.pi*fi*fourTime )
    
    # sum them together
    reconSignal = reconSignal + csw


# divide by N
reconSignal = reconSignal/(pnts*32)
reconSignal = reconSignal[::-1]
reconSignal = np.insert(reconSignal, 0, reconSignal[-1])
reconSignal = np.delete(reconSignal, 64)

plt.plot(time,signal,label='original')
#plt.plot(time,np.real(reconSignal),'r.',label='reconstructed')
#plt.legend()
plt.show() 