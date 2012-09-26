/**
 * @author Keven Poulin
 * @compagny Funcom
 */
package com.funcom.project.manager.implementation.loader.enum 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	public class EFileType 
	{
		private static var id:int = 1;
		
		public static const AUTO_FILE:EFileType 	= new EFileType(id++, "EFileType::AUTO_FILE", [], ELoaderType.URL_LOADER);
		public static const SWF_FILE:EFileType 		= new EFileType(id++, "EFileType::SWF_FILE", ["swf"], ELoaderType.LOADER);
		public static const XML_FILE:EFileType 		= new EFileType(id++, "EFileType::XML_FILE", ["xml"], ELoaderType.URL_LOADER);
		public static const ZLIB_XML_FILE:EFileType = new EFileType(id++, "EFileType::ZLIB_XML_FILE", ["zlib"], ELoaderType.URL_LOADER);
		public static const IMG_FILE:EFileType 		= new EFileType(id++, "EFileType::IMG_FILE", ["png","jpg","gif"],  ELoaderType.LOADER);
		public static const TXT_FILE:EFileType 		= new EFileType(id++, "EFileType::TXT_FILE", ["txt"], ELoaderType.URL_LOADER);
		public static const MP3_FILE:EFileType 		= new EFileType(id++, "EFileType::MP3_FILE", ["mp3"], ELoaderType.SOUND_LOADER);
		public static const WAV_FILE:EFileType 		= new EFileType(id++, "EFileType::WAV_FILE", ["wav"], ELoaderType.SOUND_LOADER);
		public static const BINARY_FILE:EFileType 	= new EFileType(id++, "EFileType::BINARY_FILE", ["bin"], ELoaderType.URL_LOADER);
		public static const CSS_FILE:EFileType 		= new EFileType(id++, "EFileType::CSS_FILE", ["css"], ELoaderType.URL_LOADER);
		
		public static const UNKNOWN_FILE:EFileType 	= new EFileType(id++, "EFileType::UNKNOWN_FILE", [],  ELoaderType.URL_LOADER);
		
		private static var m_referenceList:Array;/*com.funcom.social.service.loader.enum.EFileType*/
		private var m_id:int;
		private var m_type:String;
		private var m_extensionList:Array;
		private var m_loaderType:String;
		
		public function EFileType(id:int, type:String, extension:Array, loaderType:String) 
		{
			m_id = id;
			m_type = type;
			m_extensionList = extension;
			m_loaderType = loaderType;
			
			if (!m_referenceList)
			{
				m_referenceList = new Array();
			}
			
			m_referenceList.push(this);
		}
		
		public static function getFileTypeById(id:int):EFileType
		{
			for each (var fileType:EFileType in m_referenceList) 
			{
				if (fileType.id == id)
				{
					return fileType;
				}
			}
			
			return null;
		}
		
		public static function getFileTypeByType(type:String):EFileType
		{
			for each (var fileType:EFileType in m_referenceList) 
			{
				if (fileType.type == type)
				{
					return fileType;
				}
			}
			
			return null;
		}
		
		public static function getFileTypeByFilePath(filePath:String):EFileType
		{
			var index:int = filePath.lastIndexOf(".");
			var extension:String;
			
			//Return if no extension found
			if (index == -1) 
			{
				return UNKNOWN_FILE;
			}
			
			//Get the extension equivalent
			extension = filePath.substr(index + 1, filePath.length);
			
			for each (var fileType:EFileType in m_referenceList) 
			{
				for each (var ext:String in fileType.extensionList) 
				{
					if (ext.toUpperCase() == extension.toUpperCase())
					{
						return fileType;
					}
					
				}
			}
			
			//No extension ound
			return UNKNOWN_FILE;
		}
		
		public static function getList():Array
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject(m_referenceList);
			byteArray.position = 0;
			return byteArray.readObject() as Array;
		}
		
		public function get id():int 
		{
			return m_id;
		}
		
		public function get type():String 
		{
			return m_type;
		}
		
		public function get loaderType():String 
		{
			return m_loaderType;
		}
		
		public function get extensionList():Array 
		{
			return m_extensionList;
		}
	}
}