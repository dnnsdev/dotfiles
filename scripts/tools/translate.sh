#!/bin/bash

# Usage: ./translate.sh "text" "target"
# Example: ./translate.sh "Hello i suck" "gr"
# Or when in path: translate "Hello i suck" "gr"

# Check if jq is available
# Since this is a prerequisite for parsing JSON responses
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed" >&2
    exit 1
fi

# Check if curl is available
# Since this is a prerequisite for making HTTP requests
if ! command -v curl &> /dev/null; then
    echo "curl is required but not installed" >&2
    exit 1
fi

# Check if text is provided
if [ -z "$1" ]; then
    echo "Hey stupid. Please provide text to translate" >&2
    echo "Usage: $0 \"text\" [target_language]" >&2
    exit 1
fi

text="$1"
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