$Path = Get-Item '.\src'
$Timeout = 1000

function Invoke-SomeAction
{
  param
  (
    [Parameter(Mandatory)]
    [System.IO.WaitForChangedResult]
    $ChangeInformation
  )
  
  Write-Warning 'Change detected:'
  Write-Host -ForegroundColor DarkYellow "$($ChangeInformation.ChangeType) $($ChangeInformation.Name)"
  .\build.ps1
}

try
{
  Write-Warning "FileSystemWatcher is monitoring $Path"
  
  $watcher = New-Object System.IO.FileSystemWatcher $Path
  $watcher.IncludeSubdirectories = $true

  do
  {
    $result = $watcher.WaitForChanged("All", $Timeout)
    if ($result.TimedOut) { continue }
    
    Invoke-SomeAction -Change $result
  } while ($true)
}
finally
{
  $watcher.Dispose()
  Write-Warning 'FileSystemWatcher removed.'
}
