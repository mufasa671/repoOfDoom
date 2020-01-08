<#
.SYNOPSIS
    Computer renaming script.
.DESCRIPTION
    Renames standard computers to follow naming standard.
    ASUS 14/15 inch:  FW-ASUS14-DEVICEID
    Dell Inspiron 15: FW-DellI15-DEVICEID
.NOTES
    Name: ComputerNameOfDoom.ps1
    Author: Freightwaves Devops
.LINK
    #NEED FREIGHTWAVES GIT REPO HERE.
.EXAMPLE
    ComputerNameOfDoom.ps1
#>

#
# Retreives Manufacturer and Model number from registry
#
$compInfo = Get-CimInstance -ClassName Win32_ComputerSystem
$brand = $compInfo.Manufacturer.Substring(0,4)
$model = $compInfo.Model

if($brand -eq 'Dell'){
    $size = '-I15'
}else{
    if($model.Substring(0,2) -eq 'X4'){
        $size = 14
    }elseif($model.Substring(0,2) -eq 'X5'){
        $size = 15
    }else{
        Write-Host "Exception not handled."
        Pause
        exit
    }
}

#
# Pulls first 8 characters from DeviceID from registry
#
$machinekey = Get-ItemProperty HKLM:SOFTWARE\Microsoft\SQMClient | Select -ExpandProperty MachineID
$devid = $machinekey.substring(1,8)

#
# Sets name of the computer with above parameters
#
$newcompname = "FW-"+$brand+$size+"-"+$devid
Rename-Computer $newcompname