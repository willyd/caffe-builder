Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

wget https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-win.zip ninja-win.zip
Unzip ninja-win.zip $pwd