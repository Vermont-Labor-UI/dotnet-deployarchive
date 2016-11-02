$build = (Get-Content .\build.json | Out-String | ConvertFrom-Json)
if ($build.deploys)
{
    $build.deploys | ForEach {
      Add-Type -Assembly System.IO.Compression.FileSystem
      $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
      $sourcedir = $env:BUILD_ARTIFACTSTAGINGDIRECTORY + "\" + $_.name
      $zipfilename = $env:BUILD_ARTIFACTSTAGINGDIRECTORY + "\" + $_.name + ".zip"
      Remove-Item $zipfilename
      [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcedir, $zipfilename, $compressionLevel, $false)
        if ($LASTEXITCODE -eq 1)
        {
            Write-Host "Error build project $_"
            exit 1
        }
    }
}
