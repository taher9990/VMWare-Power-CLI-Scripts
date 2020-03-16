
$vms = Get-VM

$start = (Get-Date).AddMonths(-1)

Get-VIEvent -Entity $vms -Start $start -MaxSamples ([int]::MaxValue) |

where{$_ -is [VMware.Vim.VmCreatedEvent]} | %{

    $obj = [ordered]@{

        Name = $_.Vm.Name

        Created = $_.CreatedTime

        CreatedBy = $_.UserName

        IPAddress = $vm.Guest.IPAddress -join '|'

    }

    New-Object psobject -Property $obj

}