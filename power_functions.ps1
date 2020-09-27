## Ejecutar Powershell como Administrador y correr "Set-ExecutionPolicy RemoteSigned" para poder usar el script

# Panel de ayuda
function helpPanel {

	Write-Output ''
	Write-Host "1. Para cambiar el nombre al equipo usar el comando renameComputer" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "2. Para crer usuarios usar el comando createUsers" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "3. Para desactivar Windows Defender usar el comando disableDefender" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "4. Para actualizar Windows via Windows Update usar el comando windowsUpdates" -ForegroundColor "yellow"
	Write-Output ''
	Write-Host "5. Para habilitar escritorio remoto usar el comando remoteDesktop" -ForegroundColor "yellow"
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

# Desactivar Defender
function disableDefender {

	Write-Output ''
	Write-Host "[!!] Esta función desactiva el Windows Defender solo ejecutarla en entornos controlados" -ForegroundColor "yellow"
	Try {

	$defenderOptions = Get-MpComputerStatus

	if([string]::IsNullOrEmpty($defenderOptions)) {
	Write-host "No se ha encontrado el Windows Defender corriendo en el equipo:" $env:computername -foregroundcolor "green"
	}

	else {
	Write-host '[!!] Windows Defender se encuentra activo en el equipo:' $env:computername -foregroundcolor "yellow"
	Write-Host ''
	Write-host '	Se encuentra Windows Defender habilitado?' $defenderOptions.AntivirusEnabled
	Write-host '	Se encuentra el servicio de Windows Defender habilitado?' $defenderOptions.AMServiceEnabled
	Write-host '	Se encuentra el Antispware de Windows Defender habilitado?' $defenderOptions.AntispywareEnabled
	Write-host '	Se encuentra el componente OnAccessProtection en Windows Defender habilitado?' $defenderOptions.OnAccessProtectionEnabled
	Write-host '	Se encuentra el componente RealTimeProtection en Windows Defender habilitado?' $defenderOptions.RealTimeProtectionEnabled
	Write-Output ''
	
	Write-Host "[!!] Desinstalando Windows-Defender..." -ForegroundColor "yellow"

	Uninstall-WindowsFeature -Name Windows-Defender

	Write-Output ''
	Write-Host "[**] Windows Defender ha sido desinstalado, se va a reiniciar el equipo" -ForegroundColor "green"
	Write-Output ''

	Start-Sleep -Seconds 5
	Restart-Computer
	Start-Sleep -Seconds 10
	}
	}
	Catch {}
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
