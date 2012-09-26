/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.update 
{
	public interface IUpdatable
	{
		function update(aDeltaFrame:uint, aDeltaTime:uint):void;
	}
}
