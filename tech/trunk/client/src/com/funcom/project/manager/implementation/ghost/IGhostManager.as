package com.funcom.project.manager.implementation.ghost 
{
	import com.funcom.project.manager.implementation.ghost.enum.EGhostType;
	import com.funcom.project.manager.implementation.ghost.struct.GhostData;
	
	public interface IGhostManager 
	{
		function catchGhost(aGhostType:EGhostType):void;
		function getAvailableGhosts():Vector.<GhostData>;
		function getGhostDataForType(aGhostType:EGhostType):GhostData;
		
		function startSession():void;
		function endSession():void;
		function getGhostsCaughtInSession():Vector.<GhostData>;
	}
}