package c3d 
{
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	[SWF(backgroundColor = "#000000", frameRate = "60")]
	/**
	 * ...
	 * @author Alanmars
	 */
	public class BasicView extends Sprite
	{
		[Embed(source = "../embeds/floor_diffuse.jpg")]
		public static var s_floorDiffuse : Class;
		
		private var m_view : View3D;
		private var m_plane : Mesh;
		
		public function BasicView() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			m_view = new View3D();
			addChild(m_view);
			
			m_view.camera.z = -600;
			m_view.camera.y = 500;
			m_view.camera.lookAt(new Vector3D());
			
			m_plane = new Mesh(new PlaneGeometry(700, 700), new TextureMaterial(Cast.bitmapTexture(s_floorDiffuse)));
			m_view.scene.addChild(m_plane);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		
		private function onEnterFrame(event : Event) : void
		{
			m_plane.rotationY += 1;
			m_view.render();
		}
		
		private function onResize(event : Event = null) : void
		{
			m_view.width = stage.stageWidth;
			m_view.height = stage.stageHeight;
		}
	}

}