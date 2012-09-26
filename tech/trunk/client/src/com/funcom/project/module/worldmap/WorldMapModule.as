/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.module.worldmap
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	import com.funcom.project.manager.implementation.update.IUpdatable;
	import com.funcom.project.manager.implementation.update.IUpdateManager;
	import com.funcom.project.manager.ManagerA;
	import com.funcom.project.module.worldmap.struct.IslandObject;
	import com.funcom.project.utils.event.Listener;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class WorldMapModule extends AbstractModule implements IUpdatable
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const SCROLLING_ZONE_BUFFER:int = 75;
		private const SCROLLING_SPEED:Number = 15;
		private const NUMBER_OF_ISLAND:Number = 13;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		private var _updateManager:IUpdateManager;
		
		//Visual ref
		private var _worldMap:MovieClip;
		private var _islandList:Vector.<IslandObject>;
		
		//Management
		private var _scrollLeft:Boolean;
		private var _scrollRight:Boolean;
		private var _scrollTop:Boolean;
		private var _scrollDown:Boolean;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function WorldMapModule()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			for each (var island:IslandObject in _islandList) 
			{
				island.destroy();
			}
			_islandList.length = 0;
			_islandList = null;
			_worldMap = null;
			
			super.destroy();
			
			//Release manager reference
			_updateManager = null;
		}
		
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function populateInitStep():void 
		{
			super.populateInitStep();
		}
		
		override protected function getManagerDefinition():void 
		{
			_updateManager = ManagerA.getManager(EManagerDefinition.UPDATE_MANAGER) as IUpdateManager;
			
			super.getManagerDefinition();
		}
		
		override protected function initVar():void 
		{
			_islandList = new Vector.<IslandObject>();
			_scrollLeft = false;
			_scrollRight = false;
			_scrollTop = false;
			_scrollDown = false;
			
			super.initVar();
		}
		
		override protected function getvisualDefinition():void 
		{
			_worldMap = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "Map_WorldMapModule") as MovieClip;
			for (var i:int = 0; i < NUMBER_OF_ISLAND; i++) 
			{
				_islandList.push(new IslandObject((_worldMap["Island_" + i]) as MovieClip))
			}
			
			super.getvisualDefinition();
		}
		
		override protected function render():void 
		{
			_worldMap.x = 0;
			_worldMap.y = 0;
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			addChild(_worldMap);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			Listener.add(MouseEvent.MOUSE_MOVE , _layerManager.stageReference, onMouseMove);
			_updateManager.registerModule(this);
			
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			Listener.remove(MouseEvent.MOUSE_MOVE , _layerManager.stageReference, onMouseMove);
			_updateManager.unRegisterModule(this);
			
			super.unregisterEventListener();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		private function onMouseMove(aEvent:MouseEvent):void 
		{
			const stageWidth:int = _resolutionManager.stageWidth;
			const stageHeight:int = _resolutionManager.stageHeight;
			const mouseX:int = _layerManager.stageReference.mouseX;
			const mouseY:int = _layerManager.stageReference.mouseY;
			
			_scrollLeft = false;
			_scrollRight = false;
			_scrollTop = false;
			_scrollDown = false;
			
			if (mouseX < SCROLLING_ZONE_BUFFER)
			{
				_scrollLeft = true;
			}
			
			if (mouseY < SCROLLING_ZONE_BUFFER)
			{
				_scrollTop = true;
			}
			
			if (mouseX > (stageWidth - SCROLLING_ZONE_BUFFER))
			{
				_scrollRight = true;
			}
			
			if (mouseY > (stageHeight - SCROLLING_ZONE_BUFFER))
			{
				_scrollDown = true;
			}
		}
		
		public function update(aDeltaFrame:uint, aDeltaTime:uint):void 
		{
			var newX:Number = _worldMap.x;
			var newY:Number = _worldMap.y;
			
			if (_scrollLeft)
			{
				newX += SCROLLING_SPEED;
			}
			
			if (_scrollRight)
			{
				newX -= SCROLLING_SPEED;
			}
			
			if (_scrollTop)
			{
				newY += SCROLLING_SPEED;
			}
			
			if (_scrollDown)
			{
				newY -= SCROLLING_SPEED;
			}
			
			moveMapTo(newX, newY);
		}
		
		public function moveMapTo(aX:Number, aY:Number):void 
		{
			const stageWidth:int = _resolutionManager.stageWidth;
			const stageHeight:int = _resolutionManager.stageHeight;
			
			//X
			if (aX > 0)
			{
				aX = 0;
			}
			else if ((aX + _worldMap.width) < stageWidth)
			{
				aX = -(_worldMap.width - stageWidth); 
			}
			
			//Y
			if (aY > 0)
			{
				aY = 0;
			}
			else if ((aY + _worldMap.height) < stageHeight)
			{
				aY = -(_worldMap.height - stageHeight); 
			}
			
			_worldMap.x = aX;
			_worldMap.y = aY;
		}
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}