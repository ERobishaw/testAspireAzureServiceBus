# Test script for the Azure Service Bus Queue endpoint
# Usage: .\test-queue.ps1 -Port 5000
# If port is not provided, it will try to use port 5000

param(
    [int]$Port = 5000
)

$apiUrl = "http://localhost:$Port/test-queue"

Write-Host "Testing Azure Service Bus Queue endpoint..." -ForegroundColor Cyan
Write-Host "API URL: $apiUrl" -ForegroundColor Cyan
Write-Host ""

try {
    # Send a test message
    $response = Invoke-RestMethod -Uri $apiUrl -Method Post -ErrorAction Stop
    
    Write-Host "Response Status: 200 OK" -ForegroundColor Green
    Write-Host "Response Body:" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
    Write-Host ""
    Write-Host "✅ Test PASSED - Message sent successfully!" -ForegroundColor Green
    exit 0
}
catch {
    Write-Host "Response Status: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
    Write-Host "Error Details:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "❌ Test FAILED" -ForegroundColor Red
    exit 1
}
