$Bzip2Path = Resolve-Path -Path ".\bzip2\bzip2.exe"
$CompressDir = Resolve-Path -Path ".\compress"
$CurrentLocation = Get-Location

if (-Not (Test-Path -Path $CompressDir)) {
  "No compress directory"
  exit
}

if (-Not (Test-Path -Path $Bzip2Path)) {
  "bzip2.exe not found"
  exit
}

Write-Host "Compressing files..."

Set-Location $CompressDir

$FilePathList = Get-ChildItem -Recurse -File -Exclude *.bz2 | % { $_.FullName }
$InputList = $FilePathList | Resolve-Path -Relative

$FilePathList = $FilePathList -Replace "\\", "/"
$FilePathList = $FilePathList  -Replace " ", "` "
$InputCount = $InputList.Count

foreach ($file in $FilePathList) {
  Invoke-Expression '& $Bzip2Path -z $file'
}

Write-Host "$InputCount files compressed"

$OutputList = Get-ChildItem -Recurse -File -Filter *.bz2 | % { $_.FullName } | Resolve-Path -Relative

Set-Location $CurrentLocation

($OutputList -Replace "^.\\", "") -Replace "\\", "/" | Out-File -FilePath ".\output.txt"
($InputList -Replace "^.\\", "") -Replace "\\", "/" | Out-File -FilePath ".\input.txt"