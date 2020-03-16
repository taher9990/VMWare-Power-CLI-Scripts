Param($days, $ref)
 
$date=get-date -hour 0 -minute 0 -second 0
$vms= get-vm | Where-Object {$_.powerstate -like "*on"} | sort-object
 
$vms | Where-object {((Get-Stat -Entity (Get-VM $_) -Stat mem.usage.average -Start $date.AddDays(-"$days")`
 -Finish $date.AddDays(-1) | where-object {$_.Instance -eq ""}).value|measure-object -average).average -lt $ref}