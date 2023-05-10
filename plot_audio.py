import wave
import matplotlib.pyplot as plt
import numpy as np

obj = wave.open("song.wav","rb")

sampleFreq = obj.getframerate()
nSamples = obj.getnframes()
signalWave = obj.readframes(-1)

obj.close()

time = nSamples/sampleFreq
print(time)

#cause frame is type bytes you can create a numpy array out of it easily

signalArray = np.frombuffer(signalWave,dtype = np.int32)
times = np.linspace(0,time,num = nSamples)

#Stuff for the graph
plt.figure(figsize=(15,5))
plt.plot(times, signalArray)
plt.title("Audio Signal")
plt.ylabel("Signal wave")
plt.xlabel("Time (Hz)")
plt.xlim(0, time)
plt.show()