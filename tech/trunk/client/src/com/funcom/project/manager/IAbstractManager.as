/**
* @author Keven Poulin
*/
package com.funcom.project.manager
{
	import com.funcom.project.manager.enum.EManagerState;
	public interface IAbstractManager
	{
		function get state():EManagerState;
		function initialize():void;
		function activate():void;
	}
}