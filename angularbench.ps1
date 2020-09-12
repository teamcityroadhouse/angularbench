# choco install -y nodejs
# npm install -g @angular/cli
$ng = 'ng'
if($env:OS -eq "Windows_NT"){$ng = "ng.cmd"}
$ErrorActionPreference = "Stop"
if (Test-Path /tmp/_benchmark){
    cd /
    Remove-Item -Recurse /tmp/_benchmark
}
For ($i=0; $i -lt 3; $i++) {
New-Item -ItemType Directory ("/tmp/_benchmark/"+$i) | Out-Null
cd ("/tmp/_benchmark/"+$i)
(ng --version|select-string -Context 2 -Pattern "Angular CLI: ").ToString().Trim();if($LastExitCode -ne 0){throw}
Write-Host("Yarn: "+(yarn --version)) ;if($LastExitCode -ne 0){throw}
Write-Host("Ran: "+(Get-Date).ToString("yyyy-MM-dd"))
$stopwatch = New-Object -TypeName System.Diagnostics.Stopwatch


$stopwatch.Restart()
if((Start-Process -Wait -PassThru -RedirectStandardOutput /tmp/outnull $ng "new benchmarkapp --routing --style=css --skipGit --skipInstall").ExitCode -ne 0){throw}
$stopwatch.Stop()
Write-Host("ng new:        "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")


cd benchmarkapp


$stopwatch.Restart()
if((Start-Process -Wait -PassThru -RedirectStandardOutput /tmp/outnull -RedirectStandardError /tmp/errornull yarn "install --no-progress").ExitCode -ne 0){throw}
$stopwatch.Stop()
Write-Host("yarn install:  "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")


$stopwatch.Restart()
if((Start-Process -Wait -PassThru -RedirectStandardOutput /tmp/outnull $ng "test --watch=false --no-progress --browsers=ChromeHeadless").ExitCode -ne 0){throw}
$stopwatch.Stop()
Write-Host("ng test:       "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")


$stopwatch.Restart()
if((Start-Process -Wait -PassThru -RedirectStandardOutput /tmp/outnull $ng "build").ExitCode -ne 0){throw}
$stopwatch.Stop()
Write-Host("ng build:      "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")


$stopwatch.Restart()
if((Start-Process -Wait -PassThru -RedirectStandardOutput /tmp/outnull $ng "build --prod").ExitCode -ne 0){throw}
$stopwatch.Stop()
Write-Host("ng build prod: "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")


$stopwatch.Restart()
if((Start-Process -Wait -PassThru -RedirectStandardOutput /tmp/outnull $ng "build --prod --aot").ExitCode -ne 0){throw}
$stopwatch.Stop()
Write-Host("ng build aot:  "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")


<#
$stopwatch.Restart()
cd /tmp
Remove-Item -Recurse /tmp/_benchmark
$stopwatch.Stop()
Write-Host("delete:        "+($stopwatch.ElapsedMilliseconds/1000).ToString("#.#")+" sec")
#>


}
