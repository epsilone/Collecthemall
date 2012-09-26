/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.layer 
{
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	
	public interface ILayerManager extends IEventDispatcher
	{
		function registerStage(aStage:Stage):void;
		function addLayer(aLayerDefinition:ELayerDefinition):void;
		function addLayerList(aLayerDefinitionList:Array):void;
		function removeLayer(aLayerDefinition:ELayerDefinition):void;
		function removeLayerList(aLayerDefinitionList:Array):void;
		function getLayer(aLayerDefinition:ELayerDefinition):DisplayObjectContainer;
		function get stageReference():Stage;
	}
}