/**
* @author Keven Poulin
*/
package com.funcom.project.manager.implementation.loader
{
	import com.funcom.project.manager.implementation.loader.enum.EFileType;
	import com.funcom.project.manager.implementation.loader.struct.LoadGroup;
	import com.funcom.project.manager.implementation.loader.struct.LoadPacket;
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	public interface ILoaderManager extends IEventDispatcher
	{
		function load(filePath:String, fileType:EFileType, callback:Function = null, applicationDomain:ApplicationDomain = null, loaderPriority:int = 1, avoidCaching:Boolean = false):LoadPacket;
		function loadGroup(loadgroup:LoadGroup):void;
		function hasFile(filePath:String):Boolean;
		function getPacket(filePath:String):LoadPacket;
		function getSWFStage(filePath:String):MovieClip;
		function getSymbol(filePath:String, symbolLinkage:String):*;
		function getXML(filePath:String):XML;
	}
}