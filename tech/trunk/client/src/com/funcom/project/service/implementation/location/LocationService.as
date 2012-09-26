/**
 * @author Atila
 * @compagny Funcom
 */
package com.funcom.project.service.implementation.location 
{
	import com.funcom.project.service.AbstractService;
	import com.funcom.project.service.implementation.time.struct.Location;
	import flash.utils.Dictionary;
	
	public class LocationService extends AbstractService implements ILocationService 
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Reference holder
		private var _locationList:Dictionary;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function LocationService() 
		{
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_locationList = new Dictionary();
		}
		
		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/
		
		public function loadLocation():void
		{
			var xmlData:XML = loaderManager.getXML(""); 
			
			var locationNodes:XMLList = xmlData.location;
			var locationNodesCount:int = locationNodes.length();
			var location:Location;
			
			for (var i:int = 0; i < locationNodesCount; i++)
            {
                location = getLocationFromXmlData(locationNodes[i]);

                if (location != null)
                {
                    addLocation(location);
                }
            }
			
			//Tells ServiceA that the service is ready
			onInitialized();
		}
		
		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		private function getLocationFromXmlData(xmlNode:XML):Location
		{
			if (xmlNode.@id == null)
			{
				return null;
			}
			
			var location:Location = new Location();
			var i:uint;
			
			location.id = Number(xmlNode.@id);
			location.name = xmlNode.name;
			
			location.description = xmlNode.description;
			
			location.filePath = xmlNode.filePath;
			
			return location;
		}
		
		private function addLocation(location:Location):void
		{
			_locationList[location.id] = location;
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
		public function get locationById(id:int):Location 
		{
			if (id in _locationList)
			{
				return _locationList[id];
			}
			return null;
		}
		
	}

}