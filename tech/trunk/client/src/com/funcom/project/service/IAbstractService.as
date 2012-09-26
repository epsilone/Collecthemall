package com.funcom.project.service 
{
	import com.funcom.project.service.enum.EServiceState;
	
	public interface IAbstractService 
	{
		function get state():EServiceState;
		function initialize():void;
	}
}