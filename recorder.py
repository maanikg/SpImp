import wave
from dataclasses import dataclass, asdict

import pyaudio


@dataclass
class StreamParams:
    format: int = pyaudio.paInt16
    channels: int = 1
    rate: int = 44100
    frames_per_buffer: int = 1024
    input: bool = True
    output: bool = False

    def to_dict(self) -> dict:
        return asdict(self)


class Recorder:
    """Recorder uses the blocking I/O facility from pyaudio to record sound
    from mic.

    Attributes:
        - stream_params: StreamParams object with values for pyaudio Stream
            object
    """
    def __init__(self, stream_params: StreamParams) -> None:
        self.stream_params = stream_params
        self._pyaudio = None
        self._stream = None
        self._wav_file = None
        self.stopped = False # added variable to keep track of recording state

    def record(self, save_path: str) -> None:
        """Record sound from mic until user stops recording.

        :param save_path: Where to store recording
        """
        print("Start recording...")
        self._create_recording_resources(save_path)
        self._write_wav_file_reading_from_stream()
        self._close_recording_resources()
        print("\nStopped recording")

    def _create_recording_resources(self, save_path: str) -> None:
        self._pyaudio = pyaudio.PyAudio()
        self._stream = self._pyaudio.open(**self.stream_params.to_dict())
        self._create_wav_file(save_path)

    def _create_wav_file(self, save_path: str):
        self._wav_file = wave.open(save_path, "wb")
        self._wav_file.setnchannels(self.stream_params.channels)
        self._wav_file.setsampwidth(self._pyaudio.get_sample_size(self.stream_params.format))
        self._wav_file.setframerate(self.stream_params.rate)

    def _write_wav_file_reading_from_stream(self) -> None:
        while not self.stopped: # loop until recording is stopped
            try:
                audio_data = self._stream.read(self.stream_params.frames_per_buffer)
                self._wav_file.writeframes(audio_data)
            except KeyboardInterrupt: # catch Ctrl+C to stop recording
                self.stopped = True

    def _close_recording_resources(self) -> None:
        self._wav_file.close()
        self._stream.close()
        self._pyaudio.terminate()


if __name__ == "__main__":
    stream_params = StreamParams()
    recorder = Recorder(stream_params)
    recorder.record("audio.wav")
