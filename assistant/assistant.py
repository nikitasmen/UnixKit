import whisper
import sounddevice as sd

# Settings
duration = 10  # seconds to record
sample_rate = 16000  # Whisper expects 16000 Hz

# Record audio from microphone
print("Recording...")
audio = sd.rec(
    int(duration * sample_rate),
    samplerate=sample_rate,
    channels=1,
    dtype='float32'
)
sd.wait()
print("Recording complete.")

# Convert to mono and flatten
audio = audio.flatten()

# Load model
model = whisper.load_model(
    "base"  # "turbo" only available via API or OpenAI's hosted solution
)

# Pad or trim audio
audio = whisper.pad_or_trim(audio)

# Convert to log-Mel spectrogram
mel = whisper.log_mel_spectrogram(audio).to(model.device)

# Detect language
_, probs = model.detect_language(mel)
language = max(probs, key=probs.get)
print(f"Detected language: {language}")

# Decode the audio
options = whisper.DecodingOptions()
result = whisper.decode(model, mel, options)

# Output result
print("Transcription:", result.text)
