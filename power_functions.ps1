# Ejecutar Powershell como Administrador y correr "Set-ExecutionPolicy RemoteSigned" para poder usar el script
# Como Administrador primero cargar los modulos con
# Import-Module .\dark_theme_win10.ps1

# Panel de ayuda
function Panel {

	Write-Output ''
	Write-Host "1. Para cambiar el nombre al equipo usar el comando renameComputer" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "2. Para crer usuarios usar el comando createUsers" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "3. Para actualizar Windows via Windows Update usar el comando windowsUpdates" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "4. Para habilitar escritorio remoto usar el comando remoteDesktop" -ForegroundColor "yellow"
	Write-Output ''
}

# Funcion para el cambio de nombre del equipo
function renameComputer {

	Write-Output ''
	Write-Host "[**] Cambiando el nombre del equipo [**]" -Foreground "green"
	Write-Output ''

	Rename-Computer -NewName "NOMBRE-PC" 

}

# Creacion de usuarios 
function createUsers {

        Write-Output ''
        Write-Host "[**] Creando usuario nuevo"  -ForegroundColor "green"
        Write-Output ''

	Write-Host "[!!] Ingresar nuevo password" -ForegroundColor "yellow"
	$Password = Read-Host -AsSecureString
	New-LocalUser "pgraffigna" -Password $Password -FullName "pablo graffigna" -Description "Usuario de prueba"
	Add-LocalGroupMember -Group "Administrators" -Member "pgraffigna"
	

        Write-Output ''
        Write-Host "[!!] Todos los usuarios han sido creados" -ForegroundColor "green"
        Write-Output ''
}

# Buscar Actualizaciones 
function windowsUpdates {
	
	Write-Output ''
	Write-Host "[!!] Instalando los paquetes necesarios para poder buscar actualizaciones de Windows" -ForegroundColor "yellow"
	Write-Output ''

	Install-PackageProvider -Name NuGet -Force
	Install-module -Name PSWindowsUpdate -Confirm:$False -force -SkipPublisherCheck	
	Import-module -Name PSWindowsUpdate

	Write-Output ''
	Write-Host "[!!] Buscando actualizaciones" -ForegroundColor "yellow"
	Get-WindowsUpdate
	Write-Output ''

	Write-Output ''
	Write-Host "[!!] Instalando actualizaciones" -Foreground "yellow"
	Install-WindowsUpdate -AcceptAll
	Write-Output ''

	Write-Host "[**] Actualizaciones instaladas con exito" -ForegroundColor "green"
}

# Activar el acceso remoto 
function remoteDesktop {
	
	Write-Output ''
	Write-Host "[!!] Activando acceso remoto y creando regla en el Firewall" -ForegroundColor "yellow"
	Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
	Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
	netsh advfirewall firewall add rule name="Acceso Remoto" dir=in protocol=TCP localport=3389 action=allow
	Write-Output ''
}
