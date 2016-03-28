$Texto = FileRead('E:\test\chkparser321.ini')
global $binarySignature, $schet=0
$pos=1
for $i=1 to 70

$array = StringRegExp ( $Texto, '\H* \H* (\H*)'&@CR, 2 ,$pos)
$pos=@extended
if not @error then 
   
;~    ConsoleWrite( $array[1] & @CRLF )

   $binarySignature=Binary( $array[1])
   $schet=$schet+1
;~    ConsoleWrite($schet & '   ' &$binarySignature& @CRLF )
      ConsoleWrite($binarySignature& @CRLF )
   
EndIf


Next