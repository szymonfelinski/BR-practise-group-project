(*
steruje zmianami osi zadanymi w ManualControl.AxisControl.axis1-6
 zwraca 1 gdy siê wykona
 docelowo bêdzie u¿ywane w g³ównym stanie "READY"
 *)
FUNCTION AxisControl : BOOL 
	VAR_INPUT
		axis1:UDINT;
		axis2:UDINT;
		axis3:UDINT;
		axis4:UDINT;
		axis5:UDINT;
		axis6:UDINT;
	END_VAR
	
	VAR
		AxisControlState : AxisControlStateType;
	END_VAR