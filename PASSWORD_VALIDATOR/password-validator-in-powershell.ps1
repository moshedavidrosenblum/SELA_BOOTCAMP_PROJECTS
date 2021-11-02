$user_pass = $args[0] # Get comand line argument ("user password")

if ($user_pass.length -lt 10) {
    Write-Host "The password must contain at least  10 charcters" -ForegroundColor Red
    exit 1;
}
elseif($user_pass -match ".*\d+.*" -eq $false) 
{
    Write-Host "Password must contain digits" -ForegroundColor Red
    exit 1;
}
elseif ($user_pass -cmatch "[A-Z]" -eq $false) 
{
    Write-Host "Password most contain Upper case" -ForegroundColor Red
    exit 1; 
}
elseif ($user_pass -cmatch "[a-z]" -eq $false)
{
    Write-Host "Password most contain Lower case" -ForegroundColor Red
    exit 1;
}

else{
    Write-Host "Very good paasword" -ForegroundColor Green
    exit 0;
}







