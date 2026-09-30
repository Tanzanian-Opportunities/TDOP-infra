# Dev helper: smoke-check that the local backend and frontend respond.
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/api/v1/public/health" -ErrorAction Stop
    Write-Host "Backend Status: $($response.StatusCode)"
} catch {
    Write-Host "Backend Error: $($_.Exception.Message)"
}
try {
    $response2 = Invoke-WebRequest -Uri "http://localhost:3000" -ErrorAction Stop
    Write-Host "Frontend Status: $($response2.StatusCode)"
} catch {
    Write-Host "Frontend Error: $($_.Exception.Message)"
}
