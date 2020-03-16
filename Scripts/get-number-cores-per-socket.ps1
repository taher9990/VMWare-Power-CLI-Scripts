$result = @()

$vms = Get-view  -ViewType VirtualMachine

foreach ($vm in $vms) {

$obj = new-object psobject

$obj | Add-Member -MemberType NoteProperty -Name ServerName -Value $vm.Name

$obj | Add-Member -MemberType NoteProperty -Name CPUs -Value $vm.config.hardware.NumCPU

$obj | Add-Member -MemberType NoteProperty -Name Sockets -Value ($vm.config.hardware.NumCPU/$vm.config.hardware.NumCoresPerSocket)

$obj | Add-Member -MemberType NoteProperty -Name CPUPersocket -Value $vm.config.hardware.NumCoresPerSocket

$result += $obj

}

$result | Out-File C:\cpuresult.txt