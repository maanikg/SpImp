import speech_recognition as sr
from textblob import TextBlob
import textstat

# Initialize recognizer
r = sr.Recognizer()

# Load audio file
with sr.AudioFile("audio.wav") as source:
    audio = r.record(source)

# Transcribe audio
result = r.recognize_google(audio)

# Analyze sentiment
tb = TextBlob(result)
polarity = tb.sentiment.polarity
subjectivity = tb.sentiment.subjectivity

# Check for formality
formality_score = formality_score = textstat.flesch_kincaid_grade(result)


# Give feedback based on sentiment and formality
print(result)

if polarity > 0.5:
    print("The text has a positive sentiment. It has a polarity score of: {:.2f}".format(polarity))
elif polarity < -0.5:
    print("The text has a negative sentiment. It has a polarity score of: {:.2f}".format(polarity))
else:
    print("The text has a neutral sentiment. It has a polarity score of: {:.2f}".format(polarity))

# Check formality
formality_score = textstat.flesch_kincaid_grade(result)

if formality_score > 12:
    print("The text is too formal. It has a formality score of: {:.2f}".format(formality_score))
elif formality_score < 8:
    print("The text is too informal. It has a formality score of: {:.2f}".format(formality_score))
else:
    print("The text has an appropriate level of formality. It has a formality score of: {:.2f}".format(formality_score))