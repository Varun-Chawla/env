Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# # Create/Edit the PowerShell profile using the following command
# if (!(Test-Path -Path $PROFILE)){ New-Item -Path $PROFILE -ItemType File } ; ise $PROFILE

# # Add the following line in the profile to load the posh-git profile
# . "D:\GitHub\env\windows\poshgitprofile.ps1"

# Load posh-git module from current directory
Import-Module 'C:\Program Files (x86)\Poshgit\posh-git'

# Background colors
$baseBackgroundColor = "DarkBlue"
$GitPromptSettings.AfterBackgroundColor = $baseBackgroundColor
$GitPromptSettings.AfterStashBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BeforeBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BeforeIndexBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BeforeStashBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchAheadStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchBehindAndAheadStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchBehindStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.BranchIdenticalStatusToBackgroundColor = $baseBackgroundColor
$GitPromptSettings.DelimBackgroundColor = $baseBackgroundColor
$GitPromptSettings.IndexBackgroundColor = $baseBackgroundColor
$GitPromptSettings.LocalDefaultStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.LocalStagedStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.LocalWorkingStatusBackgroundColor = $baseBackgroundColor
$GitPromptSettings.StashBackgroundColor = $baseBackgroundColor
$GitPromptSettings.WorkingBackgroundColor = $baseBackgroundColor

# Foreground colors
$GitPromptSettings.AfterForegroundColor = "Blue"
$GitPromptSettings.BeforeForegroundColor = "Blue"
$GitPromptSettings.BranchForegroundColor = "Blue"
$GitPromptSettings.BranchIdenticalStatusToForegroundColor = "White"
$GitPromptSettings.DefaultForegroundColor = "Gray"
$GitPromptSettings.DelimForegroundColor = "Blue"
$GitPromptSettings.IndexForegroundColor = "Green"
$GitPromptSettings.WorkingForegroundColor = "Yellow"

# Prompt shape
$GitPromptSettings.AfterText = " "
$GitPromptSettings.BeforeText = "  "
$GitPromptSettings.BranchAheadStatusSymbol = ""
$GitPromptSettings.BranchBehindStatusSymbol = ""
$GitPromptSettings.BranchBehindAndAheadStatusSymbol = ""
$GitPromptSettings.BranchIdenticalStatusToSymbol = ""
$GitPromptSettings.DelimText = " ॥"
$GitPromptSettings.LocalStagedStatusSymbol = ""
$GitPromptSettings.LocalWorkingStatusSymbol = ""
$GitPromptSettings.ShowStatusWhenZero = $false

# Update the PowerShell prompt
set-content Function:prompt {
  $title = (get-location).Path.replace($home, "~")
  $idx = $title.IndexOf("::")
  if ($idx -gt -1) { $title = $title.Substring($idx + 2) }

  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

  $windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $windowsPrincipal = new-object 'System.Security.Principal.WindowsPrincipal' $windowsIdentity

  if ($windowsPrincipal.IsInRole("Administrators") -eq 1) {
    Write-Host "* " -NoNewline -ForegroundColor Red
  }

  Write-Host $title -NoNewline -ForegroundColor Blue

  if ($LASTEXITCODE -ne 0) {
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host "  $LASTEXITCODE " -NoNewLine -BackgroundColor DarkRed -ForegroundColor Yellow
  }

  if ($PromptEnvironment -ne $null) {
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-Host $PromptEnvironment -NoNewLine -BackgroundColor DarkMagenta -ForegroundColor White
  }

  if (Get-GitStatus -ne $null) {
    Write-Host " : " -NoNewline -ForegroundColor DarkGray
    Write-VcsStatus
  }

  Write-Host " : " -NoNewline -ForegroundColor DarkGray
  Write-Host (Get-Date -Format G) -ForegroundColor DarkMagenta

  $global:LASTEXITCODE = 0
  $host.UI.RawUI.WindowTitle = $title
  return "> "
}

# Load the Get-ChildItemColor to add color to ls/dir
Import-Module "D:\Repos\Get-ChildItemColor\Get-ChildItemColor.psm1"
Set-Alias ls Get-ChildItemColor -option AllScope -Force
Set-Alias dir Get-ChildItemColor -option AllScope -Force

Pop-Location

Start-SshAgent -Quiet
