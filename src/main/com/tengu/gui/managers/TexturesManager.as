package com.tengu.gui.managers
{
	import com.tengu.core.funcs.parseBoolean;
	import com.tengu.gui.api.ITexturesManager;
	import com.tengu.gui.enum.FillType;
	import com.tengu.gui.fills.BitmapFill;
	import com.tengu.gui.fills.ColorFloodFill;
	import com.tengu.gui.fills.Scale3BitmapFill;
	import com.tengu.gui.fills.Scale9BitmapFill;
	import com.tengu.gui.fills.ShapeFill;
	import com.tengu.gui.resources.text.StyleProtocol;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
	import ru.mail.minigames.zygote.logger.LoggerFactory;
	
	public class TexturesManager implements ITexturesManager
	{
		private static const colorValues:Vector.<uint> 	= new <uint>[0x000000, 0xff0f6411, 0xff516b51, 0xff036603, 0xff343834, 0xff00a700, 0xffffffff, 0xfffefefe, 0xff121403];
		private static const colors:Vector.<uint> 		= new <uint>[	0,0,0,0,0,0,3,5,5,3,2,0,0,0,0,
			0,0,0,0,0,0,3,5,5,3,3,0,0,0,0,
			0,0,0,0,3,5,5,5,5,5,5,3,3,0,0,
			0,0,0,3,5,5,5,5,8,5,5,5,5,3,2,
			0,0,0,3,5,5,7,2,2,8,8,5,5,3,3,
			0,0,3,5,5,7,7,7,2,7,7,7,3,3,3,
			0,0,3,5,5,7,8,2,2,6,7,7,3,3,3,
			3,5,5,5,5,7,4,4,3,2,2,2,3,3,3,
			0,0,3,5,5,7,8,2,2,6,7,7,3,3,3,
			0,0,3,5,5,7,7,7,2,7,7,7,3,3,3,
			0,0,0,3,5,5,7,2,2,8,8,5,5,3,3,
			0,0,0,0,3,5,5,5,8,5,5,5,5,1,2,
			0,0,0,0,0,3,5,5,5,5,5,3,3,0,0,
			0,0,0,0,0,0,3,5,5,3,3,0,0,0,0,
			0,0,0,0,0,0,3,5,5,3,2,0,0,0,0];

		private static const INVALID_TEXTURE:BitmapFill = function ():BitmapFill
		{
			var bitmap:BitmapData = new BitmapData(4, 4, false);
			var rect:Rectangle = new Rectangle(0, 0, 2, 2);
			bitmap.fillRect(rect, 0x000000);
			rect.x = 2;
			rect.y = 2;
			bitmap.fillRect(rect, 0x000000);
			rect.y = 0;
			bitmap.fillRect(rect, 0xFF0000);
			rect.x = 0;
			rect.y = 2;
			bitmap.fillRect(rect, 0xFF0000);
			return new BitmapFill(bitmap, false);
		}();
		
		private static const INVALID_ICON:BitmapData = function():BitmapData
		{
			var result:BitmapData = new BitmapData(15, 15, true, 0x00000000);
			var xCoord:uint = 0;
			var yCoord:uint = 0;
			
			for each (var code:uint in colors)
			{
				result.setPixel32(xCoord, yCoord, colorValues[code]);
				yCoord = (yCoord + 1) % 15;
				if (yCoord == 0)
				{
					xCoord++;
				}
			}
			return result;
		}();

		private static const matrix:Matrix = new Matrix();
		
		private var assetDomain:ApplicationDomain = null;
		private var textures:Object = {};
		private var scale:Number = 1;

		public function set library(value:ApplicationDomain):void 
		{
			assetDomain = value;
		}
		
		public function set scaleFactor (value:Number):void
		{
			scale = value;
		}
		
		public function TexturesManager()
		{
			//Empty
		}
		
		private function getScaledBitmap(bitmapData:BitmapData):BitmapData
		{
			if (scale == 1)
			{
				return bitmapData;
			}
			var newWidth:int = Math.round(bitmapData.width * scale);
			var newHeight:int = Math.round(bitmapData.height * scale);
			var result:BitmapData = new BitmapData(Math.max(newWidth, 1), Math.max(newHeight, 1), true, 0x00FFFFFF);
			matrix.identity();
			matrix.scale(scale, scale);
			result.draw(bitmapData, matrix, null, null, null, true);
			bitmapData.dispose();
			return result;
		}
		
		private function makeAsset (className:String):*
		{
			if (!assetDomain.hasDefinition(className))
			{
				return null;
			}
			var assetClass:Class = assetDomain.getDefinition(className) as Class;
			return new assetClass();
		}
		
		private function getLoadedTexture (name:String):BitmapData
		{
			return makeAsset(name) as BitmapData;
		}

		public function configure (config:XML):void
		{
			var name:String = null;
			var nodesList:XMLList = config.children();
			
			for each (var node:XML in nodesList)
			{
				name = String(node.@[StyleProtocol.NAME]);
				switch ( String(node.name()) )
				{
					case FillType.BITMAP_FILL:
					{
						registerBitmap(	name, 
										parseBoolean(String(node.@["stretch"])), 
										parseBoolean(String(node.@["repeat"])));
						break;
					}
					case FillType.SCALE3_BITMAP_FILL:
					{
						registerScale3Bitmap(	name, 
												parseInt(String(node.@["stretch_start"])),
												parseInt(String(node.@["stretch_size"])),
												String(node.@["direction"]));
						break;
					}
					case FillType.SCALE9_BITMAP_FILL:
					{
						registerScale9Bitmap(	name,
												new Rectangle(	parseInt(String(node.@["left"])),
																parseInt(String(node.@["top"])),
																parseInt(String(node.@["width"])),
																parseInt(String(node.@["height"])) ));
						break;
					}
					case FillType.COLOR_FLOOD_FILL:
					{
						registerFloodFillTexture(	name, 
													parseInt(String(node.@["color"])),
													parseFloat(String(node.@["alpha"])) );
						break;
					}
					case FillType.BORDER_FILL:
					{
						//TODO
						break;
					}
					case FillType.GRADIENT_FILL:
					{
						//TODO
						break;
					}
				}
			}
		}
				
		public function registerScale9Bitmap(name:String, scaleGrid:Rectangle):void
		{
			var bitmapData:BitmapData = getLoadedTexture(name);
			var scaledData:BitmapData = null;
//			trace(name);
			if (bitmapData == null)
			{
				textures[name] = INVALID_TEXTURE;
			}
			else
			{
				textures[name] = new Scale9BitmapFill(bitmapData, scaleGrid);
//				scaledData = getScaledBitmap(bitmapData);
//				scaleGrid.x = Math.max(scaleGrid.x * scale, 1);
//				scaleGrid.y = Math.max(scaleGrid.y * scale, 1);
//				scaleGrid.width = Math.max(scaleGrid.width * scale, 1);
//				scaleGrid.height = Math.max(scaleGrid.height * scale, 1);
//				textures[name] = new Scale9BitmapFill(scaledData, scaleGrid);
			}
		}
		
		public function registerScale3Bitmap(name:String, stretchStart:uint = 1, stretchSize:uint = 1, direction:String = "horizontal"):void
		{
			var bitmapData:BitmapData = getLoadedTexture(name);
			var scaledData:BitmapData = null;
			if (bitmapData == null)
			{
				textures[name] = INVALID_TEXTURE;
			}
			else
			{
				scaledData = getScaledBitmap(bitmapData);
				textures[name] = new Scale3BitmapFill(	scaledData, 
														Math.max(stretchStart * scale, 1), 
														Math.max(stretchSize * scale, 1), direction);
			}
		}
		
		public function registerBitmap(name:String, stretch:Boolean=true, isRepeat:Boolean=false):void
		{
			var bitmapData:BitmapData = getLoadedTexture(name);
			var scaledData:BitmapData = null;
			if (bitmapData == null)
			{
				textures[name] = INVALID_TEXTURE;
			}
			else
			{
				scaledData = getScaledBitmap(bitmapData);
				textures[name] = new BitmapFill(scaledData, stretch, isRepeat);
			}
		}
		
		public function registerFloodFillTexture(name:String, color:uint, alpha:Number=1):void
		{
			textures[name] = new ColorFloodFill(color, alpha);
		}
		
		public function getTexture(name:String):ShapeFill
		{
			if (textures[name] == null)
			{
				LoggerFactory.get(this).e("Texture not registered: ", name);
				return INVALID_TEXTURE;
			}
			return textures[name];
		}
		
		public function getIcon(name:String, scaled:Boolean = true):BitmapData
		{
			if (name == null)
			{
				return null;
			}
			if (!assetDomain.hasDefinition(name))
			{
				return INVALID_ICON;
			}
			var bitmap:BitmapData = makeAsset(name) as BitmapData;
			
			if (scaled)
			{
				return getScaledBitmap(bitmap);
			}
			else
			{
				return bitmap;
			}
		}
	}
}