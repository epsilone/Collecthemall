/**
* @author Keven Poulin
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.update 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.layer.ILayerManager;
	import com.funcom.project.manager.ManagerA;
	import flash.display.Stage;
	import flash.utils.getTimer;
	
	public class UpdateManager extends AbstractManager implements IUpdateManager
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Reference
		private var _updateList:Vector.<IUpdatable>;
		
		//General Management
		private var _updateLen:int;
		private var _isActive:Boolean;
		private var _listValid:Boolean;
		
		//Time/Frame Management
		private var _targetFrameMs:Number;
		private var _lastFrame:uint;
		private var _currentFrame:uint;
		private var _startTime:int;
		private var _lastTime:uint;
		private var _totalFrameCount:uint;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function UpdateManager() 
		{
		}
		
		override public function activate():void
		{
			super.activate();
			
			//Get the _targetFrameMs base on the framerate of the stage
			var layerManager:ILayerManager = ManagerA.getManager(EManagerDefinition.LAYER_MANAGER) as ILayerManager;
			_targetFrameMs = 1000 / (layerManager.stageReference as Stage).frameRate;
			_targetFrameMs = int(_targetFrameMs*1000)/1000
			
			onActivated();
		}

		public function destroy():void
		{
			_listValid = false;
			purge();
			_listValid = true;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public function start():void
		{
			_startTime = getTimer();
			_isActive = true;
		}
		
		public function update():void
		{
			if (_isActive && _listValid)
			{
				var currentTick:int = getTimer();
				var totalFrame:uint = ((currentTick - _startTime) / _targetFrameMs) | 0;
				var deltaFrame:uint = totalFrame - _lastFrame;
				var deltaTime:uint = currentTick - _lastTime;
				
				if (deltaFrame > 0)
				{
					_lastFrame = totalFrame;
					_lastTime = currentTick;
					_totalFrameCount++;
					_currentFrame++;
				}
				
				_updateLen = _updateList.length -1;
				for (_updateLen; _updateLen >= 0; _updateLen--)
				{
					_updateList[_updateLen].update(deltaFrame, deltaTime);
				}
			}
		}
		
		public function registerModule(aModule:IUpdatable):void
		{
			if (aModule && (aModule is IUpdatable))
			{
				if (_updateList.indexOf(aModule, 0) == -1)
				{
					_updateList.push(aModule);
				}
			}
		}
		
		public function unRegisterModule(aModule:IUpdatable):void
		{
			_listValid = false;
			
			var len:uint = _updateList.length;
			
			for (var i:uint = 0; i < len; i++)
			{
				if (_updateList[i] == aModule)
				{
					_updateList.splice(i, 1);
					break;
				}
			}
			
			_listValid = true;
		}
		
		public function isModuleRegistered(aModule:IUpdatable):Boolean
		{
			var len:uint = _updateList.length;
			
			for (var i:uint = 0; i < len; i++)
			{
				if (_updateList[i] == aModule)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function purge():void
		{
			_listValid = false;
			_updateList = new Vector.<IUpdatable>();
			_listValid = true;
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function init():void 
		{
			_updateList = new Vector.<IUpdatable>();
			_updateLen = 0;
			_startTime = 0;
			_lastTime == 0;
			_lastFrame = 0;
			_currentFrame = 0;
			_totalFrameCount = 0;
			_isActive = false;
			_listValid = true;
			
			super.init();
		}
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}