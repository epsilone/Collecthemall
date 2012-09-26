/**
* @author #AuthorName#
* @compagny Funcom
*/
package com.funcom.project.manager.implementation.template#PackageName#
{
	import com.funcom.project.manager.AbstractManager;
	import com.funcom.project.manager.IAbstractManager;
	
	public class #ManagerName# extends AbstractManager implements I#ManagerName#
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/

		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function #ManagerName#(aBlocker:SingletonBlocker) 
		{
			if (aBlocker == null) 
			{
				throw new Error("Error: Instantiation failed: "); //TODO
				return;
			}
			
			_instance = this;
		}
		
		static public function getInstance():IAbstractManager
		{
			if (_instance == null)
			{
				_instance = new #ManagerName#(new SingletonBlocker());
			}
			
			return _instance as IAbstractManager;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
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

internal class SingletonBlocker { }