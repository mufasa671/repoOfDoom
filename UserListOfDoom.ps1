Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#Gets list of local users that are not built in accounts
$user = Get-LocalUser * | select name | where {$_.name -NotLike "Administrator" -and $_.name -NotLike "DefaultAccount" -and $_.name -NotLike "Guest" -and $_.name -NotLike "SysAdmin" -and $_.name -NotLike "WDAGUtilityAccount"}

#Rewrites the list to all lowercase
$userLower = ($user.Name).ToLower()

#Not fully working, but intent is to check for multiple users on one laptop
if($userLower.Count -gt 1){
    Write-Host "Which user would you like to modify?:"
    $user.Name -join "`n"
    $userInput = Read-Host
    $userLower = $userInput
}

#Variable for use in if statement below
$userListOfDoom = New-Object System.Collections.Generic.List[string]

#Set Firstname Lastname to first initial lastname in '-', ' ', or camelCase (i.e. 'John-Smith', 'John Smith', or 'JohnSmith' becomes 'jsmith')
if($userLower | Select-String ' '){
    $userListOfDoom = $userLower -split ' '
    $newUserName = ((($userListOfDoom)[0])[0] + ($userListOfDoom)[1]).ToLower()
    Rename-LocalUser -Name $userLower -NewName $newUserName
}elseif($userLower | Select-String '-'){
    $userListOfDoom = $userLower -split '-'
    $newUserName = ((($userListOfDoom)[0])[0] + ($userListOfDoom)[1]).ToLower()
    Rename-LocalUser -Name $userLower -NewName $newUserName
}elseif($userLower | Select-String '_'){
    $userListOfDoom = $userLower -split '_'
    $newUserName = ((($userListOfDoom)[0])[0] + ($userListOfDoom)[1]).ToLower()
    Rename-LocalUser -Name $userLower -NewName $newUserName
}else{
    Write-Host "Username:" $user.Name
    Write-Host "Is username camelcased?: [Y]es or [N]o"
    $camelCaseInput = Read-Host
    if($camelCaseInput = "y"){
        $tmp = $user | ForEach-Object {$_ -csplit '(?=[A-Z])' -ne '' -join ' '}
        $userListOfDoom = $tmp -split ' '
        $newUserName = ((($userListOfDoom)[0])[0] + ($userListOfDoom)[1]).ToLower()
        Rename-LocalUser -Name $userLower -NewName $newUserName
    }else{
        'Exception not handled.'
    }
}