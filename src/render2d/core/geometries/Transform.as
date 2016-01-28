package render2d.core.geometries 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import render2d.utils.FastMath;
	
	public class Transform 
	{
		public var x:Number = 0;
		public var y:Number = 0;
		
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		
		private var _rotation:Number = 0;
		private var rotationRad:Number = 0;
		private var rotationCos:Number = 1;
		private var rotationSin:Number = 0;
		
		public function Transform() 
		{
			identity();
		}
		
		public function get rotation():Number 
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void 
		{
			if (_rotation == value)
				return;
				
			_rotation = value;
			
			rotationRad = FastMath.convertToRadian(_rotation);
			rotationSin = Math.sin(rotationRad);
			rotationCos = Math.cos(rotationRad);
		}
		
		public function copyTransformFrom(transform:Transform):void 
		{
			x = transform.x;
			y = transform.y;
			
			scaleX = transform.scaleX;
			scaleY = transform.scaleY;
			
			rotation = transform.rotation;
		}
		
		public function copyTransformTo(constantsVector:Vector.<Number>, registerIndex:int):void 
		{
			constantsVector[registerIndex++] = x;
			constantsVector[registerIndex++] = y;
			
			constantsVector[registerIndex++] = scaleX;
			constantsVector[registerIndex++] = scaleY;
			
			constantsVector[registerIndex++] = rotationCos;
			constantsVector[registerIndex++] = rotationSin;
		}
		
		public function copyTo(transform:Transform):void
		{
			transform.copyFrom(this);
		}
		
		public function copyFrom(transform:Transform):void
		{
			x = transform.x;
			y = transform.y;
			
			scaleX = transform.scaleX;
			scaleY = transform.scaleY;
			
			rotation = transform.rotation;
		}
		
		public function concat(transform:Transform):void
		{
			/**
			 * свой поворот 90
			 * скейл контейнера 0.5 по Y
			 * =>
			 * скейл по игрик полностью перейдет в X
			 * 
			 * sin(90) - 1
			 * cos(90) ~ 0
			 * 
			 * mScaleX = 1
			 * mScaleY = 1
			 * 
			 * cScaleX = 1
			 * cScaleY = 0.5
			 * 
			 * sAngle = 90
			 * sin - 1
			 * cos - 0
			 * 
			 * mScaleX * cos + cScaleY * sin - 0.5
			 * mScaleX * sin + cScaleY * cos - 1
			 * 
			 * 
			 * mScaleX = 1
			 * mScaleY = 1
			 * 
			 * cScaleX = 1
			 * cScaleY = 0.5
			 * 
			 * sAngle = 0
			 * sin - 0
			 * cos - 1
			 * 
			 * mScaleX * cos + cScaleY * sin - 1
			 * mScaleX * sin + cScaleY * cos - 0.5
			 */
			
			scaleX *= transform.scaleX;
			scaleY *= transform.scaleY;
			
			//trace(scaleX, scaleY, rotationCos, rotationSin, _rotation);
				
			//if(scaleX != 1)
			//	var newScaleX:Number = scaleX * rotationCos + scaleY * rotationSin;
			
			//if(scaleY != 1)
			//	scaleY = scaleX * rotationSin + scaleY * rotationCos;
			
			//scaleX = newScaleX;
				
			var xnew:Number = x * transform.rotationCos - y * transform.rotationSin;
			var ynew:Number = x * transform.rotationSin + y * transform.rotationCos;
			
			x = xnew + transform.x;
			y = ynew + transform.y;
			
			rotation = rotation + transform.rotation;
		}
		
		public function transformPoint(pointToTransform:Point):void
		{

			/** a, b,
			 *  c, d,
			 *  tx, ty
			 * # transpose for standart matrix a, c, tx, b, d, ty => [scaleX, rotationX, tx] 
			 * 														 [rotationY, scaleY, ty] - транспозиция матрицы в стандартном виде
			 * newX = (px * scalex * cos(angle) - (py * scaley * sin(angle)) - текущая формула подсчета Х
			 * 
			 * => следовательно 
			 * 
			 * p (x, y) если п это Х, У
			 * transform(x, y, scaleX, scaleY, cosA, sinA) а трансформ представлен таким набором атриибутов
			 * [
			 *  	x, y, scaleX
			 * 		scaleY, cosA, sinA
			 * ]
			 * 
			 * dp3 и используется опкод dp3
			 * {
			 *  	x = p.x * a + p.y * c + p.z * tx - p.z можно просто отбросить т.к он будет либо 1 либо индексом
			 *  	y = p.x * b + p.y * d + p.z * ty
			 * }
			 * 
			 * ------------------------------------------
			 * 
			 * a = scaleX * rotationCos
			 * b = rotationSin * scaleY
			 * c = -rotationSin * scaleX
			 * d = rotationCos * scaleY
			 * 
			 * таким обрзаом испоьлзуя m3x2 или dp3 можно преобразуя трансформ в матцриу a,b,c,d
			 */
			
			var px:Number = pointToTransform.x;
			var py:Number = pointToTransform.y;
			
			
			
			var xnew:Number = px * rotationCos - py * rotationSin;
			var ynew:Number = px * rotationSin + py * rotationCos;
			xnew *= scaleX;
			ynew *= scaleY;
			//xnew = (pointToTransform.x * scaleX * rotationCos) + (pointToTransform.y * -rotationSin * scaleX);
			//ynew = (pointToTransform.x * rotationSin * scaleY) + (pointToTransform.y * rotationCos * scaleY);
			
			xnew += x;
			ynew += y;
			
			pointToTransform.setTo(xnew, ynew);
		}
		
		public function identity():void 
		{
			x = 0;
			y = 0;
			scaleX = 1;
			scaleY = 1;
			_rotation = 0;
			rotationRad = 0;
			rotationSin = 0;
			rotationCos = 1;
		}
		
		public function toString():String 
		{
			return "[Transform x=" + x + " y=" + y + " scaleX=" + scaleX + " scaleY=" + scaleY + " rotation=" + _rotation + 
						"]";
		}
	}
}