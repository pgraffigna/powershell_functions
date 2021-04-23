# Script para activar/desactivar el modo oscuro en equipos con Windows10 (sin activar!!!)
# Como Administrador primero cargar los modulos con 
# Import-Module .\dark_theme_win10.ps1

# Panel de ayuda
function Panel {

	Write-Output ''
	Write-Host "1. Para habilitar el modo oscuro usar el comando Dark_Mode_ON" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "2. Para deshabilitar el modo oscuro usar el comando Dark_Mode_OFF" -ForegroundColor "yellow"
}

# Funcion para habilitar el Dark Mode
function Dark_Mode_ON {
	Write-Output ''
	Write-Host "[!!]Activando Dark Mode" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "[!!]Editando items en HKEY_CURRENT_USER para habilitar Dark Mode" -ForegroundColor "yellow"
	Set-Itemproperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -value 0

	Write-Output ''
	Write-Host "[!!]Agregando y editando items en HKEY_LOCAL_MACHINE para habilitar Dark Mode" -ForegroundColor "yellow"
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes" -Name 'Personalize'
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name 'AppsUseLightTheme' -PropertyType 'DWORD' -Value 0

	Write-Host "[!!]Activado" -ForegroundColor "green"
}

# Funcion para deshabilitar el Dark Mode
function Dark_Mode_OFF {
	Write-Output ''
        Write-Host "Desactivando Dark Mode" -ForegroundColor "yellow"
        Write-Output ''
        Write-Host "[!!]Editando items en HKEY_CURRENT_USER para deshabilitar Dark Mode" -ForegroundColor "yellow"
        Set-Itemproperty -path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -value 1

	Write-Host "[!!]Desactivado" -ForegroundColor "red"
}

