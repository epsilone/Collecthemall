package com.funcom.project.manager.implementation.ghost 
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.implementation.console.enum.ELogType;
	import com.funcom.project.manager.implementation.console.Logger;
	import com.funcom.project.manager.implementation.ghost.enum.EFoodType;
	import com.funcom.project.manager.implementation.ghost.enum.EGhostType;
	import com.funcom.project.manager.implementation.ghost.struct.GhostData;
	import com.funcom.project.utils.flash.VectorUtil;
	import flash.utils.Dictionary;
	
	public final class GhostManager extends AbstractManager implements IGhostManager 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const NUM_GHOSTS_PER_SESSION:uint = 6;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _ghostData:Dictionary = new Dictionary();
		private var _sessionGhosts:Vector.<GhostData> = new Vector.<GhostData>();
		private var _ghostsCaught:Vector.<GhostData> = new Vector.<GhostData>();
		private var _inSession:Boolean = false;

		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function GhostManager() 
		{
		}
		
		override public function initialize():void 
		{
			super.initialize();
			var hitpoints:Dictionary = new Dictionary();
			hitpoints[EGhostType.CRAZY_FACE] = 10;
			hitpoints[EGhostType.CAT] = 16;
			
			const numGhostTypes:uint = EGhostType.constants.length;
			
			for (var index:uint = 0; index < numGhostTypes; index++)
			{
				var type:EGhostType = EGhostType.constants[index];
				_ghostData[type] = new GhostData(hitpoints[type] as uint, "Ghost", type, EFoodType.WATER_MELON);
			}
			
			onInitialized();
		}
		
		override public function activate():void 
		{
			super.activate();
			
			onActivated();
		}
		

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		public final function catchGhost(aGhostType:EGhostType):void
		{
			if (!_inSession)
			{
				Logger.log(ELogType.CRITICAL, "GhostManager", "catchGhost", "Attempted to catch a ghost when there is no active session.");
				return;
			}
			
			_ghostsCaught.push(_ghostData[aGhostType]);
		}
		
		public final function getAvailableGhosts():Vector.<GhostData>
		{
			return _sessionGhosts.slice();
		}
		
		public final function getGhostsCaughtInSession():Vector.<GhostData>
		{
			return _ghostsCaught.slice();
		}
		
		public final function getGhostDataForType(aGhostType:EGhostType):GhostData
		{
			return _ghostData[aGhostType] as GhostData;
		}
		
		public final function startSession():void
		{
			_inSession = true;
			_sessionGhosts = new Vector.<GhostData>();
			_ghostsCaught = new Vector.<GhostData>();
			
			// Randomly pull NUM_GHOSTS_PER_SESSION
			var ghosts:Vector.<*> = VectorUtil.fromDictionary(_ghostData);
			ghosts = ghosts.sort(function(a:*, b:*):int {
				return (Math.random() < 0.5 ? -1 : 1);
			});
			
			// Just pull the first NUM_GHOSTS_PER_SESSION and use those.
			for (var i:uint = 0; i < NUM_GHOSTS_PER_SESSION; i++)
			{
				var index:int = Math.random() * ghosts.length;
				_sessionGhosts.push(ghosts[index]);
			}
		}
		
		public final function endSession():void
		{
			_inSession = false;
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}
