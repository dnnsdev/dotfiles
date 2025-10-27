#!/bin/bash

# Usage: ./translate.sh "text" "target"
# Example: ./translate.sh "Hello i suck" "gr"
# Or when in path: translate "Hello i suck" "gr"

text="${1:-''}"
targetLanguage="${2:-nl}"
libreTranslateHost="http://192.168.1.170:5000"

curl -s -X POST "${libreTranslateHost}/translate" \
     -H "Content-Type: application/json" \
     --data '{
        "q": "'"${text}"'",
        "source": "auto",
        "target": "'"${targetLanguage}"'",
        "format": "text",
        "alternatives": 0,
        "api_key": ""
     }' | jq -r '.translatedText'