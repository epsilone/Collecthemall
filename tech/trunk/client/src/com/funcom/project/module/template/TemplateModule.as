/**
* @author #AuthorName#
* @compagny Funcom
*/
package #PackageName#
{
	import com.funcom.project.manager.implementation.module.struct.AbstractModule;
	
	public class #ModuleName# extends AbstractModule
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		//Manager
		
		//Reference holder
		
		//Managemnet
		
		//Visual
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function #ModuleName#()
		{
			
		}
		
		override public function destroy():void 
		{
			//Release visual reference
			//!...
			
			//Reset value of management var
			//!...
			
			super.destroy();
			
			//Release Reference holder
			//!...
			
			//Release manager reference
			//!...
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
			
			//Add your own initialization step
			//!_initStepController.addStep();
		}
		
		override protected function getvisualDefinition():void 
		{
			//Get your visual definition
			//!_avatarPicture = _loaderManager.getSymbol(_moduleDefinition.assetFilePath, "AvatarPicture_HudModule") as MovieClip;
			
			super.getvisualDefinition();
		}
		
		override protected function render():void 
		{
			//Position all your screen element correctly
			
			super.render();
		}
		
		override protected function addVisualOnStage():void 
		{
			//Add child all your visual element
			//!addChild(_avatarPicture);
			
			super.addVisualOnStage();
		}
		
		override protected function registerEventListener():void 
		{
			//Register your module specific event
			//!Listener.add(MouseEvent.CLICK, _friendbar["WorldBtn"] as IEventDispatcher, onWorldButtonClicked);
			
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			//Unregister your module specific event
			//!Listener.remove(MouseEvent.CLICK, _friendbar["WorldBtn"] as IEventDispatcher, onWorldButtonClicked);
			
			super.unregisterEventListener();
		}
		
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}