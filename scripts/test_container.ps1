$count = 0
do {
    $count++
    Write-Output "Starting container [Attempt: $count]"
} until ((Invoke-WebRequest -Uri http://localhost:8000).statuscode == '200' || $count > 3)
