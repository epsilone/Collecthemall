/**
* @author Keven Poulin
* @compagny Epix Studio
*/
package com.funcom.project.manager.implementation.transition.struct
{
	import com.funcom.project.manager.enum.EManagerDefinition;
	import com.funcom.project.manager.implementation.resolution.event.ResolutionManagerEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ProcessingTransition extends AbstractTransition
	{
		/************************************************************************************************************
		* Static/Constant variables																					*
		************************************************************************************************************/
		private const BLOCKER_ALPHA:Number = 0.6;
		private const SCREEN_MARGIN:int = 50;
		
		/************************************************************************************************************
		* Member Variables																							*
		************************************************************************************************************/
		private var _blocker:Sprite;
		private var _processingAnimation:MovieClip;
		
		/************************************************************************************************************
		* Constructor / Init / Dispose																				*	
		************************************************************************************************************/
		public function ProcessingTransition()
		{
			
		}
		
		override public function init():void 
		{
			//here
			
			super.init();
			
			createBlocker();
			createProcessingAnimation();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			//here
		}

		/************************************************************************************************************
		* Public Methods																							*
		************************************************************************************************************/

		/************************************************************************************************************
		* Private Methods																							*
		************************************************************************************************************/
		override protected function open():void 
		{
			super.open();
			
			render(_resolutionManager.stageWidth, _resolutionManager.stageHeight);
			
			_transitionContainer.addChild(_blocker);
			_transitionContainer.addChild(_processingAnimation);
			
			onOpened();
		}
		
		override protected function close():void 
		{
			super.close();
			
			_transitionContainer.removeChild(_blocker);
			_transitionContainer.removeChild(_processingAnimation);
			
			onClosed();
		}
		
		override protected function registerEventListener():void 
		{
			super.registerEventListener();
		}
		
		override protected function unregisterEventListener():void 
		{
			super.unregisterEventListener();
		}
		
		override protected function render(aStageWidth:int, aStageHeight:int):void 
		{
			super.render(aStageWidth, aStageHeight);
			
			_blocker.x = 0;
			_blocker.y = 0;
			_blocker.width = aStageWidth;
			_blocker.height = aStageHeight;
			
			_processingAnimation.x = aStageWidth * 0.5;//aStageWidth - SCREEN_MARGIN;
			_processingAnimation.y = aStageHeight * 0.5;//aStageHeight - SCREEN_MARGIN;
		}
		
		private function createBlocker():void
		{
			_blocker = new Sprite();
			_blocker.graphics.beginFill(0x000000);
			_blocker.graphics.drawRect(0,0,_resolutionManager.stageWidth,_resolutionManager.stageHeight);
			_blocker.graphics.endFill();
			_blocker.alpha = BLOCKER_ALPHA;
		}
		
		private function createProcessingAnimation():void
		{
			var filePath:String = EManagerDefinition.TRANSITION_MANAGER.assetFilePath;
			_processingAnimation = _loaderManager.getSymbol(filePath, "Processing_TransitionManager");
		}
		/************************************************************************************************************
		* Handler Methods																							*
		************************************************************************************************************/
		
		/************************************************************************************************************
		* Getter/Setter Methods																						*
		************************************************************************************************************/
	}
}