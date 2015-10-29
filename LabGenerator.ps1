Import-module Hyper-V
 
$LABVMs =@("Client01";"Client02";"Client03";"Client04")
$VMTemplate = "D:\Virtualization\TEMPLATE\Windows10.vhdx"
$LabPath = "D:\Virtualization\LAB"
$Switch = "Internal"
$Memsize = 1024MB
  
 Foreach ($LABVM in $LABVMs) {
  
    $VHD = Get-VHD -Path "$LabPath\$LABVM\$LABVM.vhdx" -ErrorAction SilentlyContinue
    Write-Host "Creating VHD for VM $LABVM..." -NoNewline
    If ($VHD -eq $null) {
        New-VHD -ParentPath $VMTemplate -Path "$LabPath\$LABVM\$LABVM.vhdx" -Differencing | Out-Null
        Write-Host -ForegroundColor Green " - Done."
    } else {
        Write-Host -ForegroundColor Gray " - Already Created"
    }
     
    $VM = Get-VM -Name $LABVM -ErrorAction SilentlyContinue
  
        Write-Host "Creating VM $LABVM..." -NoNewline
        If ($VM.Name -ne $LABVM) {
            New-VM -VHDPath "$LabPath\$LABVM\$LABVM.vhdx" -VMName $LABVM -MemoryStartupBytes $Memsize -SwitchName $Switch | Out-Null
            Write-Host -ForegroundColor Green " - Done."
        } else {
            Write-Host -ForegroundColor Gray " - Already Created"
        }
     
    Write-Host "Starting VM $LABVM..." -NoNewline
    If ($VM.State -ne "Running") {
        Start-VM -Name $LABVM
        Write-Host -ForegroundColor Green " - Done."
    } else {
        Write-Host -ForegroundColor Gray " - Already Running"
    }
 }