package com.funcom.project.manager.implementation.ghost.struct 
{
	import com.funcom.project.manager.implementation.ghost.enum.EFoodType;
	import com.funcom.project.manager.implementation.ghost.enum.EGhostType;
	
	/**
	 * @author Kevin Fields
	 */
	public final class GhostData 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _hitPoints:uint;
		private var _name:String;
		private var _type:EGhostType;
		private var _favouriteFood:EFoodType;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/		
		public function GhostData(aHitPoints:uint, aName:String, aType:EGhostType, aFavouriteFood:EFoodType) 
		{
			_hitPoints = aHitPoints;
			_name = aName;
			_type = aType;
			_favouriteFood = aFavouriteFood;
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public final function get hitPoints():uint 
		{
			return _hitPoints;
		}
		
		public final function get name():String 
		{
			return _name;
		}
		
		public final function get type():EGhostType 
		{
			return _type;
		}
		
		public final function get favouriteFood():EFoodType 
		{
			return _favouriteFood;
		}
	}
}