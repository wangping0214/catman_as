package c3d 
{
	import away3d.animators.data.Skeleton;
	import away3d.animators.SkeletonAnimationSet;
	import away3d.animators.SkeletonAnimator;
	import away3d.animators.SkeletonAnimationState;
	import away3d.animators.transitions.CrossfadeStateTransition;
	import away3d.cameras.Camera3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.DitheredShadowMapMethod;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.FresnelSpecularMethod;
	import away3d.materials.methods.RimLightMethod;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import away3d.library.AssetLibrary;
	import away3d.loaders.parsers.AWD2Parser;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Alanmars
	 */
	public class BasicAnimator extends Sprite
	{
		private var m_modelTexture : BitmapTexture;
		private const DEMO_COLOR : Array = [0xffffff, 0x99AAff, 0x222233]; 
		
		// engine variables
		private var m_scene : Scene3D;
		private var m_camera : Camera3D;
		private var m_view : View3D;
		private var m_awayStats : AwayStats;
		
		// animation variables
		private var m_skeleton : Skeleton;
		private var m_animationSet : SkeletonAnimationSet;
		private var m_animator : SkeletonAnimator;
		private var m_breatheState : SkeletonAnimationState;
		private var m_walkState : SkeletonAnimationState;
		private var m_runState : SkeletonAnimationState;
		private var m_crossfadeTransition : CrossfadeStateTransition;
		private var m_isRunning : Boolean;
		private var m_isMoving : Boolean;
		private var m_movementDirection : Number;
		private var m_currentAnim : String;
		private var m_currentRotationInc : Number = 0;
		
		// animation constants
		private const ANIM_BREATHE : String = "Breathe";
		private const ANIM_WALK : String = "Walk";
		private const ANIM_RUN : String = "Run";
		private const XFADE_TIME : Number = 0.5;
		private const ROTATION_SPEED : Number = 18;
		private const RUN_SPEED : Number = 2;
		private const WALK_SPEED : Number = 1;
		private const BREATHE_SPEED : Number = 1;
		private const SHIFT_FACTOR : Number = 40;
		
		// light objects
		private var m_sunLight : DirectionalLight;
		private var m_skyLight : PointLight;
		private var m_lightPicker : StaticLightPicker;
		
		// scene objects
		private var m_text : TextField;
		private var m_hero : Mesh;
		private var m_floor : Mesh;
		
		private var m_hoverController : HoverController;
		private var m_prevMouseX : Number;
		private var m_prevMouseY : Number;
		
		private var m_meshUrl : String = "MaxAWDWorkflow.awd";
		private var m_textureUrl : String = "onkba_N.jpg";
		private var m_floorDiffuseUrl : String = "floor_diffuse.jpg";
		private var m_floorSpecularUrl : String = "floor_specular.jpg";
		private var m_floorNormalUrl : String = "floor_normal.jpg";
		private var m_skyPosXUrl : String = "sky_posX.jpg";
		private var m_skyNegXUrl : String = "sky_negX.jpg";
		private var m_skyPosYUrl : String = "sky_posY.jpg";
		private var m_skyNegYUrl : String = "sky_negY.jpg";
		private var m_skyPosZUrl : String = "sky_posZ.jpg";
		private var m_skyNegZUrl : String = "sky_negZ.jpg";
		private var m_assetsThatAreloaded : Number = 0;
		private var m_assetsToLoaded : int = 11;
		
		public function BasicAnimator() 
		{
			initEngine();
			initText();
			initLights();
			initLoading();
		}
		
		/*
		 * Initialize the engine
		 */
		private function initEngine() : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			m_scene = new Scene3D();
			
			m_camera = new Camera3D();
			m_camera.lens.far = 50000;
			m_camera.lens.near = 20;
			
			m_view = new View3D();
			m_view.backgroundColor = DEMO_COLOR[2];
			m_view.scene = m_scene;
			m_view.camera = m_camera;
			
			m_hoverController = new HoverController(m_camera);
			m_hoverController.distance = 2000;
			m_hoverController.tiltAngle = 15;
			m_hoverController.panAngle = 360;
			m_hoverController.minTiltAngle = 0;
			m_hoverController.maxTiltAngle = 60;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			addChild(m_view);
			
			m_awayStats = new AwayStats(m_view);
			addChild(m_awayStats);
		}
		
		/*
		 * Create an instruction overlay 
		 */
		private function initText() : void
		{
			m_text = new TextField();
			m_text.defaultTextFormat = new TextFormat("Verdana", 11, 0xFFFFFF);
			m_text.width = 240;
			m_text.height = 100;
			m_text.selectable = false;
			m_text.mouseEnabled = false;
			m_text.text = "Cursor keys / WSAD - move\n";
			m_text.appendText("SHIFT - hold down to run\n");
			m_text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0)];
			addChild(m_text);
		}
		
		/*
		 * Initialize the lights
		 */
		private function initLights() : void
		{
			// create a light for shadows that mimics the sun's position in the skybox
			m_sunLight = new DirectionalLight( -1, -0.4, 1);
			m_sunLight.color = DEMO_COLOR[0];
			m_sunLight.castsShadows = true;
			m_sunLight.ambient = 1;
			m_sunLight.diffuse = 1;
			m_sunLight.specular = 1;
			m_scene.addChild(m_sunLight);
			
			// create a light for ambient effect that mimics the sky
			m_skyLight = new PointLight();
			m_skyLight.y = 500;
			m_skyLight.color = DEMO_COLOR[1];
			m_skyLight.diffuse = 1;
			m_skyLight.specular = 0.5;
			m_skyLight.radius = 2000;
			m_skyLight.fallOff = 2500;
			m_scene.addChild(m_skyLight);
			
			m_lightPicker = new StaticLightPicker([m_sunLight, m_skyLight]);
		}
		
		private function initLoading() : void
		{
			AssetLibrary.enableParser(AWD2Parser);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			AssetLibrary.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			AssetLibrary.load(new URLRequest(m_meshUrl));
			AssetLibrary.load(new URLRequest(m_textureUrl));
			AssetLibrary.load(new URLRequest(m_floorDiffuseUrl));
			AssetLibrary.load(new URLRequest(m_floorSpecularUrl));
			AssetLibrary.load(new URLRequest(m_floorNormalUrl));
			AssetLibrary.load(new URLRequest(m_skyPosXUrl));
			AssetLibrary.load(new URLRequest(m_skyNegXUrl));
			AssetLibrary.load(new URLRequest(m_skyPosYUrl));
			AssetLibrary.load(new URLRequest(m_skyNegYUrl));
			AssetLibrary.load(new URLRequest(m_skyPosZUrl));
			AssetLibrary.load(new URLRequest(m_skyNegZUrl));
		}
		
		private function onAssetComplete(event : AssetEvent) : void
		{
			trace("Loaded : " + event.asset.name);
		}
		
		private function onResourceComplete(event : LoaderEvent) : void
		{
			m_assetsThatAreloaded ++;
			if (m_assetsThatAreloaded == m_assetsToLoaded)
				setupScene();
		}
		
		private function onLoadError(event : LoaderEvent) : void
		{
			showError("Error loading: " + event.url);
		}
		
		private function showError(msg : String) : void
		{
			m_text.appendText(msg);
			trace("Error: " + msg);
		}
		
		private function setupScene() : void
		{
			m_skeleton = Skeleton(AssetLibrary.getAsset("Bone001"));
			m_breatheState = SkeletonAnimationState(AssetLibrary.getAsset("Breathe"));
			m_walkState = SkeletonAnimationState(AssetLibrary.getAsset("Walk"));
			m_runState = SkeletonAnimationState(AssetLibrary.getAsset("Run"));
			m_modelTexture = BitmapTexture(AssetLibrary.getAsset(m_textureUrl));
			m_hero = Mesh(AssetLibrary.getAsset("ONKBA-Corps-lnew"));
			
			var autoMap : Mapper = new Mapper(m_modelTexture.bitmapData);
			var specularMethod : FresnelSpecularMethod = new FresnelSpecularMethod();
			specularMethod.normalReflectance = 0.4;
			
			var material : TextureMaterial = new TextureMaterial(m_modelTexture);
			material.normalMap = new BitmapTexture(autoMap.bitdata[1]);
			material.specularMap = new BitmapTexture(autoMap.bitdata[2]);
			material.specularMethod = specularMethod;
			material.lightPicker = m_lightPicker;
			material.gloss = 40;
			material.specular = 0.5;
			material.ambientColor = 0xAAAAFF;
			material.ambient = 0.25;
			material.addMethod(new RimLightMethod(DEMO_COLOR[1], 0.4, 3, RimLightMethod.ADD));
			
			m_hero.scale(8);
			m_hero.material = material;
			m_hero.castsShadows = true;
			m_hero.z = 1000;
			m_scene.addChild(m_hero);
			
			
			
			var floorMaterial : TextureMaterial = new TextureMaterial(BitmapTexture(AssetLibrary.getAsset(m_floorDiffuseUrl)));
			floorMaterial.specularMap = BitmapTexture(AssetLibrary.getAsset(m_floorSpecularUrl));
			floorMaterial.normalMap = BitmapTexture(AssetLibrary.getAsset(m_floorNormalUrl));
			floorMaterial.lightPicker = m_lightPicker;
			floorMaterial.repeat = true;
			
			m_floor = new Mesh(new PlaneGeometry(50000, 50000));
			m_floor.material = floorMaterial;
			m_floor.geometry.scaleUV(50, 50);
			m_floor.y = -380;
			m_scene.addChild(m_floor);
			
			var skyPosXTex : BitmapTexture = BitmapTexture(AssetLibrary.getAsset(m_skyPosXUrl));
			var skyNegXTex : BitmapTexture = BitmapTexture(AssetLibrary.getAsset(m_skyNegXUrl));
			var skyPosYTex : BitmapTexture = BitmapTexture(AssetLibrary.getAsset(m_skyPosYUrl));
			var skyNegYTex : BitmapTexture = BitmapTexture(AssetLibrary.getAsset(m_skyNegYUrl));
			var skyPosZTex : BitmapTexture = BitmapTexture(AssetLibrary.getAsset(m_skyPosZUrl));
			var skyNegZTex : BitmapTexture = BitmapTexture(AssetLibrary.getAsset(m_skyNegZUrl));
			var skyTexture : BitmapCubeTexture = new BitmapCubeTexture(skyPosXTex.bitmapData, skyNegXTex.bitmapData, skyPosYTex.bitmapData, skyNegYTex.bitmapData, skyPosZTex.bitmapData, skyNegZTex.bitmapData);
			var sky : SkyBox = new SkyBox(skyTexture);
			m_scene.addChild(sky);
			
			m_animationSet = new SkeletonAnimationSet(3);
			m_animationSet.addState(m_breatheState.name, m_breatheState);
			m_animationSet.addState(m_walkState.name, m_walkState);
			m_animationSet.addState(m_runState.name, m_runState);
			m_animator = new SkeletonAnimator(m_animationSet, m_skeleton);
			m_animator.updateRootPosition = false;
			m_hero.animator = m_animator;
			m_crossfadeTransition = new CrossfadeStateTransition(XFADE_TIME);
			
			if (m_animationSet.hasState(ANIM_BREATHE) && m_animationSet.hasState(ANIM_WALK) && m_animationSet.hasState(ANIM_RUN))
			{
				m_hoverController.lookAtObject = m_hero;
				gotoPauseState();
				initListeners();
			}
			else
			{
				showError("Animation error");
			}
		}
		
		private function gotoPauseState() : void
		{
			m_isMoving = false;
			m_animator.playbackSpeed = BREATHE_SPEED;
			if (m_currentAnim == ANIM_BREATHE)
				return;
			m_currentAnim = ANIM_BREATHE;
			m_animator.play(m_currentAnim, m_crossfadeTransition);
		}
		
		private function onEnterFrame(event : Event) : void
		{
			updateMovement(m_movementDirection);
			m_skyLight.x = m_camera.x;
			m_skyLight.y = m_camera.y;
			m_skyLight.z = m_camera.z;
			m_view.render();
		}
		
		private function updateMovement(dir : Number) : void
		{
			if (!m_isMoving)
				return;
			m_animator.playbackSpeed = dir * (m_isRunning ? RUN_SPEED : WALK_SPEED);
			var anim : String = m_isRunning ? ANIM_RUN : ANIM_WALK;
			var rotationYRadians : Number = m_hero.rotationY * Math.PI / 180;
			var speed : Number = (m_isRunning ? RUN_SPEED * 2 : WALK_SPEED); 
			var xOffset : Number = -SHIFT_FACTOR * Math.sin(rotationYRadians) * speed;
			var zOffset : Number = -SHIFT_FACTOR * Math.cos(rotationYRadians) * speed;
			//trace("xoffset: " + xOffset);
			//trace("zoffset: " + zOffset);
			m_hero.x += xOffset * m_movementDirection;
			m_hero.z += zOffset * m_movementDirection;
			if (m_currentAnim == anim)
				return;
			m_currentAnim = anim;
			m_animator.play(m_currentAnim, m_crossfadeTransition);
		}
		
		private function onResize(event : Event = null) : void
		{
			m_view.width = stage.stageWidth;
			m_view.height = stage.stageHeight;
			m_awayStats.x = stage.stageWidth - m_awayStats.width;
		}
		
		private function initListeners() : void
		{
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onMouseDown(event : MouseEvent) : void
		{
			m_prevMouseX = event.stageX;
			m_prevMouseY = event.stageY;
		}
		
		private function onMouseMove(event : MouseEvent) : void
		{
			if (event.buttonDown)
			{
				m_hoverController.panAngle += (event.stageX - m_prevMouseX);
				m_hoverController.tiltAngle += (event.stageY - m_prevMouseY);
			}
			m_prevMouseX = event.stageX;
			m_prevMouseY = event.stageY;
		}
		
		private function onMouseWheel(event : MouseEvent) : void
		{
			m_hoverController.distance -= event.delta * 5;
			if (m_hoverController.distance < 100)
				m_hoverController.distance = 100;
			if (m_hoverController.distance > 3000)
				m_hoverController.distance = 3000;
		}
		
		private function onKeyDown(event : KeyboardEvent) : void
		{
			trace(event.keyCode);
			switch (event.keyCode)
			{
				case Keyboard.SHIFT:
					m_isRunning = true;
					if (m_isMoving)
						updateMovement(m_movementDirection);
					break;
				case Keyboard.UP:
				case Keyboard.W:
					m_isMoving = true;
					m_movementDirection = 1;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					m_isMoving = true;
					m_movementDirection = -1;
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
					if (m_hero)
						m_hero.rotationY -= ROTATION_SPEED;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					if (m_hero)
						m_hero.rotationY += ROTATION_SPEED;
					break;
			}
		}
		
		private function onKeyUp(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.SHIFT:
					m_isRunning = false;
					if (m_isMoving)
						updateMovement(m_movementDirection);
					break;
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					gotoPauseState();
					break;
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
					m_currentRotationInc = 0;
					break;
			}
		}
		
	}

}