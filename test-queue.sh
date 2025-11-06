#!/bin/bash

# Test script for the Azure Service Bus Queue endpoint
# Usage: ./test-queue.sh [port]
# If port is not provided, it will try to use port 5000

PORT=${1:-5000}
API_URL="http://localhost:${PORT}/test-queue"

echo "Testing Azure Service Bus Queue endpoint..."
echo "API URL: $API_URL"
echo ""

# Send a test message
RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X POST "$API_URL")
HTTP_STATUS=$(echo "$RESPONSE" | grep -o "HTTP_STATUS:[0-9]*" | cut -d: -f2)
BODY=$(echo "$RESPONSE" | sed '/HTTP_STATUS:/d')

echo "Response Status: $HTTP_STATUS"
echo "Response Body:"
echo "$BODY" | jq . 2>/dev/null || echo "$BODY"
echo ""

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Test PASSED - Message sent successfully!"
    exit 0
else
    echo "❌ Test FAILED - Unexpected status code: $HTTP_STATUS"
    exit 1
fi
