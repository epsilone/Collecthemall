package com.funcom.project.manager.implementation.layer 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.layer.enum.ELayerDefinition;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class LayerManager extends AbstractManager implements ILayerManager 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _stageReference:Stage;
		private var _layerList:Vector.<LayerObject>;
		private var _layerMainContainer:Sprite;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function LayerManager() 
		{
			
		}
		
		override public function activate():void 
		{
			super.activate();
			
			onActivated();
		}
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		override protected function init():void 
		{
			_layerList = new Vector.<LayerObject>();
			
			super.init();
		}
		
		public function registerStage(aStage:Stage):void
		{
			if (_stageReference != null)
			{
				Logger.log(ELogType.WARNING, "LayerManager", "registerStage", "The stage should not be register more than once.");
				return;
			}
			
			_stageReference = aStage;
			_layerMainContainer = new Sprite();
			_stageReference.addChildAt(_layerMainContainer, 0);
		}
		
		public function addLayer(aLayerDefinition:ELayerDefinition):void
		{
			var layer:LayerObject = findLayerObjectById(aLayerDefinition.id);
			if (layer != null)
			{
				Logger.log(ELogType.WARNING, "LayerManager", "addLayer", "Layer with name " + aLayerDefinition.name + " has already been added.");
				return;
			}
			
			var layerSprite:Sprite = new Sprite();
			_layerList.push(new LayerObject(aLayerDefinition.id, layerSprite));
			
			if (!aLayerDefinition.isInteractive)
			{
				layerSprite.mouseEnabled = false;
				layerSprite.mouseChildren = false;
			}
			
			_layerMainContainer.addChild(layerSprite);
			Logger.log(ELogType.INFO, "LayerManager", "addLayer", "Layer with name " + aLayerDefinition.name + " added.");
		}
		
		public function addLayerList(aLayerDefinitionList:Array):void 
		{
			for each (var layerDefinition:ELayerDefinition in aLayerDefinitionList) 
			{
				addLayer(layerDefinition);
			}
		}
		
		public function removeLayer(aLayerDefinition:ELayerDefinition):void
		{
			var layer:LayerObject = findLayerObjectById(aLayerDefinition.id);
			if (layer != null)
			{
				var index:int = _layerList.indexOf(layer);
				_layerMainContainer.removeChild(layer.layerReference);
				_layerList.splice(index, 1);
			}
		}
		
		public function removeLayerList(aLayerDefinitionList:Array):void 
		{
			for each (var layerDefinition:ELayerDefinition in aLayerDefinitionList) 
			{
				removeLayer(layerDefinition);
			}
		}
		
		public function getLayer(aLayerDefinition:ELayerDefinition):DisplayObjectContainer
		{
			var layer:LayerObject = findLayerObjectById(aLayerDefinition.id);
			if (layer != null)
			{
				return layer.layerReference;
			}
			
			return null;
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function findLayerObjectById(aLayerId:int):LayerObject
		{
			for each (var layer:LayerObject in _layerList)
			{
				if (layer.id == aLayerId)
				{
					return layer;
				}
			}
			
			return null;
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get stageReference():Stage 
		{
			return _stageReference;
		}
	}
}
import flash.display.DisplayObjectContainer;

class LayerObject
{
	private var _id:int;
	private var _layerReference:DisplayObjectContainer;
	
	public function LayerObject(aId:int, aLayer:DisplayObjectContainer)
	{
		_id = aId;
		_layerReference = aLayer;
	}
	
	public function get id():int 
	{
		return _id;
	}
	
	public function get layerReference():DisplayObjectContainer 
	{
		return _layerReference;
	}
}