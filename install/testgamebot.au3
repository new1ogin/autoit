HotKeySet('{Esc}','_Exit')
func _exit()
	Exit
EndFunc


sleep(3000)
while 1
	send('{Enter}')
	sleep(500)
	send('{right down}')
		sleep(500)
	send('{up}')
	sleep(500)
	send('{up}')
		sleep(500)
	send('{up}')
	sleep(500)
	send('{up}')
		sleep(500)
	send('{up}')
	sleep(500)
	send('{up}')
		sleep(500)
	send('{up}')
	sleep(500)
	send('{up}')
	send('{right up}')
WEnd
