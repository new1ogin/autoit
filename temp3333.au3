$objWMIService = ObjGet("winmgmts:\\.\root\cimv2")
$objClass = $objWMIService.ExecQuery("Select * from Win32_NetworkAdapter")

For $obj in $objClass
    MsgBox(0, '', 'Device: ' & $obj.Name & @CRLF & 'Name: ' & $obj.NetConnectionID)
Next