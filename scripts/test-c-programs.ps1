$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
$gcc = Get-Command gcc -ErrorAction SilentlyContinue
$script:useAndroid = $false
$script:androidPrograms = @{}
$script:androidDevice = $null
$script:adb = $null
$script:clang = $null
$script:androidSysroot = $null

if (-not $gcc) {
    $sdk = $env:ANDROID_HOME
    if (-not $sdk) {
        $sdk = $env:ANDROID_SDK_ROOT
    }
    $ndkRoot = if ($sdk) { Join-Path $sdk 'ndk' } else { $null }
    $ndk = if ($ndkRoot -and (Test-Path $ndkRoot)) {
        Get-ChildItem $ndkRoot -Directory | Sort-Object Name -Descending | Select-Object -First 1
    } else {
        $null
    }
    if ($ndk) {
        $toolchain = Join-Path $ndk.FullName 'toolchains/llvm/prebuilt/windows-x86_64'
        $script:clang = Join-Path $toolchain 'bin/clang.exe'
        $script:androidSysroot = Join-Path $toolchain 'sysroot'
        $script:adb = Join-Path $sdk 'platform-tools/adb.exe'
        if ((Test-Path $script:clang) -and (Test-Path $script:adb)) {
            $deviceLines = & $script:adb devices
            $deviceLine = $deviceLines | Where-Object { $_ -match '^emulator-\d+\s+device$' } | Select-Object -First 1
            if ($deviceLine -match '^(\S+)\s+device$') {
                $script:androidDevice = $Matches[1]
                $script:useAndroid = $true
            }
        }
    }
    if (-not $script:useAndroid) {
        throw 'Install GCC, or set ANDROID_HOME and start an Android emulator, then run this script again.'
    }
    Write-Host "Using Android NDK on $script:androidDevice"
} else {
    Write-Host "Using GCC at $($gcc.Source)"
}

$buildDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ('project1-c-tests-' + [guid]::NewGuid())
New-Item -ItemType Directory -Path $buildDirectory | Out-Null

function Invoke-Program {
    param(
        [string] $Program,
        [string] $InputText
    )

    if ($script:useAndroid) {
        $remoteProgram = $script:androidPrograms[$Program]
        $inputPath = Join-Path $buildDirectory "$Program.in"
        [System.IO.File]::WriteAllText($inputPath, $InputText, [System.Text.Encoding]::ASCII)
        & $script:adb -s $script:androidDevice push $inputPath "$remoteProgram.in" | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "Could not copy test input to the Android emulator: $Program"
        }

        $output = & $script:adb -s $script:androidDevice shell "sh -c '$remoteProgram < $remoteProgram.in'" 2>&1
        $exitCode = $LASTEXITCODE
        return [pscustomobject] @{
            ExitCode = $exitCode
            Output = $output -join "`n"
            Error = ''
        }
    }

    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = $Program
    $startInfo.UseShellExecute = $false
    $startInfo.CreateNoWindow = $true
    $startInfo.RedirectStandardInput = $true
    $startInfo.RedirectStandardOutput = $true
    $startInfo.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    [void] $process.Start()
    $stdoutTask = $process.StandardOutput.ReadToEndAsync()
    $stderrTask = $process.StandardError.ReadToEndAsync()
    $process.StandardInput.Write($InputText)
    $process.StandardInput.Close()

    if (-not $process.WaitForExit(5000)) {
        $process.Kill()
        throw "Program timed out: $Program"
    }

    [pscustomobject] @{
        ExitCode = $process.ExitCode
        Output = $stdoutTask.GetAwaiter().GetResult()
        Error = $stderrTask.GetAwaiter().GetResult()
    }
}

function Assert-Output {
    param(
        [string] $Name,
        [string] $Output,
        [string[]] $Patterns
    )

    foreach ($pattern in $Patterns) {
        if ($Output -notmatch $pattern) {
            throw "$Name failed. Expected output to match: $pattern`n$Output"
        }
    }
    Write-Host "PASS $Name"
}

function Build-Program {
    param(
        [string] $Name,
        [string] $Source
    )

    if ($script:useAndroid) {
        $executable = Join-Path $buildDirectory $Name
        & $script:clang --target=x86_64-linux-android24 "--sysroot=$script:androidSysroot" -std=c11 -Wall -Wextra -pedantic $Source -lm -o $executable
    } else {
        $executable = Join-Path $buildDirectory "$Name.exe"
        & $gcc.Source -std=c11 -Wall -Wextra -pedantic $Source -lm -o $executable
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Compilation failed: $Source"
    }

    if ($script:useAndroid) {
        $remoteProgram = "/data/local/tmp/project1-$Name"
        & $script:adb -s $script:androidDevice push $executable $remoteProgram | Out-Null
        if ($LASTEXITCODE -ne 0) {
            throw "Could not copy the program to the Android emulator: $Name"
        }
        & $script:adb -s $script:androidDevice shell chmod 700 $remoteProgram
        if ($LASTEXITCODE -ne 0) {
            throw "Could not set the program permissions on the Android emulator: $Name"
        }
        $script:androidPrograms[$Name] = $remoteProgram
        Write-Host "PASS compile $Name"
        return $Name
    }

    return $executable
}

try {
    $water = Build-Program 'water-quality' (Join-Path $projectRoot 'assignments/water-quality-monitoring-system/src/main.c')
    $waterCases = @(
        @{ Name = 'water index 100 is Good'; Input = "25`n0`n"; Patterns = @('Index:\s+100\.0', 'Status:\s+Good') },
        @{ Name = 'water index 80 is Good'; Input = "25`n40`n"; Patterns = @('Index:\s+80\.0', 'Status:\s+Good') },
        @{ Name = 'water index below 80 is Warning'; Input = "25`n40.2`n"; Patterns = @('Index:\s+79\.9', 'Status:\s+Warning') },
        @{ Name = 'water index 60 is Warning'; Input = "25`n80`n"; Patterns = @('Index:\s+60\.0', 'Status:\s+Warning') },
        @{ Name = 'water index below 60 is Critical'; Input = "25`n80.2`n"; Patterns = @('Index:\s+59\.9', 'Status:\s+Critical') }
    )
    foreach ($test in $waterCases) {
        $result = Invoke-Program $water $test.Input
        if ($result.ExitCode -ne 0) { throw "$($test.Name) returned $($result.ExitCode): $($result.Error)" }
        Assert-Output $test.Name $result.Output $test.Patterns
    }
    foreach ($test in @(
        @{ Name = 'water rejects text temperature'; Input = "warm`n10`n" },
        @{ Name = 'water rejects non-finite temperature'; Input = "nan`n10`n" },
        @{ Name = 'water rejects negative turbidity'; Input = "25`n-1`n" },
        @{ Name = 'water rejects non-finite turbidity'; Input = "25`nnan`n" }
    )) {
        $result = Invoke-Program $water $test.Input
        if ($result.ExitCode -eq 0) { throw "$($test.Name) should return an error." }
        Write-Host "PASS $($test.Name)"
    }

    $money = Build-Program 'mobile-money' (Join-Path $projectRoot 'assignments/mobile-money-transaction-system/src/main.c')
    $moneyInput = "1`n100`n2`n25`n2`n100`n1`n0`n1`n-5`n1`nnan`nabc`n3`n4`n5`n"
    $moneyResult = Invoke-Program $money $moneyInput
    if ($moneyResult.ExitCode -ne 0) { throw "Mobile money program returned $($moneyResult.ExitCode): $($moneyResult.Error)" }
    Assert-Output 'mobile money repeated transactions and invalid input' $moneyResult.Output @(
        'Deposit successful\. Balance: 100\.00',
        'Withdrawal successful\. Balance: 75\.00',
        'Insufficient balance',
        'Deposit rejected',
        'Invalid choice',
        'Current balance: 75\.00',
        'Successful deposits: 1',
        'Successful withdrawals: 1',
        'Goodbye\.'
    )
    $moneyDecimals = Invoke-Program $money "1`n10.50`n2`n4.25`n3`n4`n5`n"
    if ($moneyDecimals.ExitCode -ne 0) { throw "Decimal money inputs returned $($moneyDecimals.ExitCode): $($moneyDecimals.Error)" }
    Assert-Output 'mobile money decimal amounts' $moneyDecimals.Output @(
        'Deposit successful\. Balance: 10\.50',
        'Withdrawal successful\. Balance: 6\.25',
        'Current balance: 6\.25',
        'Successful deposits: 1',
        'Successful withdrawals: 1'
    )
    $moneyOverflow = Invoke-Program $money "1`n1e308`n1`n1e308`n4`n5`n"
    if ($moneyOverflow.ExitCode -ne 0) { throw "Large deposit inputs returned $($moneyOverflow.ExitCode): $($moneyOverflow.Error)" }
    Assert-Output 'mobile money rejects balance overflow' $moneyOverflow.Output @(
        'Deposit successful',
        'Deposit rejected\. Balance limit exceeded\.',
        'Successful deposits: 1'
    )

    $routes = Build-Program 'route-analysis' (Join-Path $projectRoot 'assignments/delivery-route-analysis/src/main.c')
    $routeResult = Invoke-Program $routes "6`n12`n25`n18`n40`n15`n30`n20`n"
    if ($routeResult.ExitCode -ne 0) { throw "Route analysis returned $($routeResult.ExitCode): $($routeResult.Error)" }
    Assert-Output 'route sample and recursive total' $routeResult.Output @(
        'Total distance: 140 km',
        'Average distance: 23\.33 km',
        'Longest route: 40 km',
        'Routes longer than 20 km: 3',
        'Recursive sum: 140 km'
    )

    $zeroRoutes = "100`n" + ("0`n" * 100) + "0`n"
    $zeroResult = Invoke-Program $routes $zeroRoutes
    if ($zeroResult.ExitCode -ne 0) { throw "100 zero routes returned $($zeroResult.ExitCode): $($zeroResult.Error)" }
    Assert-Output 'route maximum array size and zero distances' $zeroResult.Output @(
        'Total distance: 0 km',
        'Average distance: 0\.00 km',
        'Longest route: 0 km',
        'Recursive sum: 0 km'
    )
    $largeDistances = "100`n" + ("2147483647`n" * 100) + "0`n"
    $largeResult = Invoke-Program $routes $largeDistances
    if ($largeResult.ExitCode -ne 0) { throw "Large route values returned $($largeResult.ExitCode): $($largeResult.Error)" }
    Assert-Output 'route total beyond 32-bit range' $largeResult.Output @(
        'Total distance: 214748364700 km',
        'Average distance: 2147483647\.00 km',
        'Longest route: 2147483647 km',
        'Routes longer than 0 km: 100',
        'Recursive sum: 214748364700 km'
    )

    foreach ($test in @(
        @{ Name = 'routes rejects zero route count'; Input = "0`n" },
        @{ Name = 'routes rejects text route count'; Input = "many`n" },
        @{ Name = 'routes rejects a negative distance'; Input = "1`n-1`n" },
        @{ Name = 'routes rejects more than 100 routes'; Input = "101`n" }
    )) {
        $result = Invoke-Program $routes $test.Input
        if ($result.ExitCode -eq 0) { throw "$($test.Name) should return an error." }
        Write-Host "PASS $($test.Name)"
    }

    Write-Host 'All C program checks passed.'
}
finally {
    if ($script:useAndroid) {
        foreach ($remoteProgram in $script:androidPrograms.Values) {
            & $script:adb -s $script:androidDevice shell rm -f $remoteProgram "$remoteProgram.in" | Out-Null
        }
    }
    Remove-Item -LiteralPath $buildDirectory -Recurse -Force -ErrorAction SilentlyContinue
}
