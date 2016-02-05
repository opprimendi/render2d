package render2d.core.geometries 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import render2d.utils.FastMath;
	
	use namespace transform_inner;
	
	public class Transform 
	{
		transform_inner var transformMatrix:Matrix;
		
		transform_inner var _isMarkAsChanged:Boolean = false;
		
		transform_inner var _rotation:Number = 0;
		transform_inner var _rotationRadians:Number = 0;
		transform_inner var _rotationSine:Number = 0;
		transform_inner var _rotationCosine:Number = 1;
		
		transform_inner var _scaleX:Number = 1;
		transform_inner var _scaleY:Number = 1;
		
		transform_inner var _x:Number = 0;
		transform_inner var _y:Number = 0;
		
		public function Transform() 
		{
			transformMatrix = new Matrix();
		}
		
		public function get isMarkAsChanged():Boolean
		{
			return _isMarkAsChanged;
		}
		
		[Inline]
		public final function transformPoint(pointToTransform:Point):void
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
			
			pointToTransform.setTo(
									px * transformMatrix.a + py * transformMatrix.c + _x, 
									px * transformMatrix.b + py * transformMatrix.d + _y);
		}
		
		[Inline]
		public final function softConcat(transform:Transform):void
		{
			transformMatrix.concat(transform.transformMatrix);
			
			_x = transformMatrix.tx;
			_y = transformMatrix.ty;
		}
		
		public function concat(transform:Transform, isSoftConcat:Boolean = false):void 
		{
			softConcat(transform);
			
			if (isSoftConcat == false)
			{
				recauclateTransform();
				_isMarkAsChanged = true;
			}
		}
		
		[Inline]
		public final function softCopyFrom(transform:Transform):void
		{
			transformMatrix.copyFrom(transform.transformMatrix);
			
			_x = transform._x;
			_y = transform._y;
		}
		
		public function copyFrom(transform:Transform, softCopy:Boolean = false):void 
		{
			softCopyFrom(transform);
			
			if (softCopy == false)
			{
				_rotation = transform._rotation;
				_rotationRadians = transform._rotationRadians;
				_rotationSine = transform._rotationSine;
				_rotationCosine = transform._rotationCosine;
				
				_scaleX = transform._scaleX;
				_scaleY = transform._scaleY;
			
				_isMarkAsChanged = true;
			}
		}
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		private function calculateRotationAdditionalValues():void
		{
			_rotationRadians = FastMath.convertToRadian(_rotation);
			_rotationSine = Math.sin(_rotationRadians);
			_rotationCosine = Math.cos(_rotationRadians);
		}
		
		public function set rotation(value:Number):void 
		{
			if (value == _rotation) 
				return;
				
			_rotation = value;
			calculateRotationAdditionalValues();
			
			transformMatrix.a = _rotationCosine * _scaleX;
			transformMatrix.b = _rotationSine * _scaleX;
			transformMatrix.c = -_rotationSine * _scaleY;
			transformMatrix.d = _rotationCosine * _scaleY;
			
			markAsChanged();
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			if (value == _x) 
				return;
				
			_x = value;
			transformMatrix.tx = _x
			markAsChanged ();
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			if (value == _y) 
				return;
				
			_y = value;
			transformMatrix.ty = _y
			markAsChanged ();
		}
		
		public function get scaleX():Number 
		{
			return scaleX;
		}
		
		[Inline]
		public final function calculateScaleX():Number
		{
			if (transformMatrix.b == 0) 
				return transformMatrix.a;
			else 
				return Math.sqrt(transformMatrix.a * transformMatrix.a + transformMatrix.b * transformMatrix.b);
		}
		
		public function set scaleX (value:Number):void 
		{
			if (value == _scaleX)
				return;
				
			_scaleX = value;
			
			if (transformMatrix.c == 0) {
				
				if (value != transformMatrix.a)
					markAsChanged();
					
				transformMatrix.a = value;
			} 
			else
			{
				var a:Number = _rotationCosine * value;
				var b:Number = _rotationSine * value;
				
				if (transformMatrix.a != a || transformMatrix.b != b) 
					markAsChanged();
					
				transformMatrix.a = a;
				transformMatrix.b = b;
			}
		}
		
		public function get scaleY():Number
		{
			return _scaleY;	
		}
		
		[Inline]
		public final function calculateScaleY():Number
		{
			if (transformMatrix.c == 0)
				return transformMatrix.d;
			else 
				return Math.sqrt(transformMatrix.c * transformMatrix.c + transformMatrix.d * transformMatrix.d);
		}
		
		public function set scaleY (value:Number):void 
		{
			if (value == _scaleY)
				return;
				
			_scaleY = value;
			
			if (transformMatrix.c == 0) 
			{
				if (value != transformMatrix.d)
					markAsChanged ();
					
				transformMatrix.d = value;
			} 
			else 
			{
				var c:Number = -_rotationSine * value;
				var d:Number = _rotationCosine * value;
				
				if (transformMatrix.d != d || transformMatrix.c != c) 
					markAsChanged();
					
				transformMatrix.c = c;
				transformMatrix.d = d;
			}
		}
		
		private function markAsChanged(value:Boolean = true):void 
		{
			_isMarkAsChanged = value;
		}
		
		[Inline]
		public final function recauclateTransform():void
		{
			_scaleX = calculateScaleX();
			_scaleY = calculateScaleY();
			
			_x = transformMatrix.tx;
			_y = transformMatrix.ty;
			
			calculateRotationAdditionalValues();
		}
		
		public function identity():void 
		{
			transformMatrix.identity();
			
			_rotation = 0;
			_rotationRadians = 0;
			_rotationSine = 0;
			_rotationCosine = 1;
			 
			_scaleX = 1;
			_scaleY = 1;
			  
			_x = 0;
			_y = 0;
		}
		
		public function toString():String
		{
			return "[Transform(a=" + transformMatrix.a.toFixed(6) + ", b=" + transformMatrix.b.toFixed(6) + ", c=" + transformMatrix.c.toFixed(6) 
							+", d=" + transformMatrix.d.toFixed(6) + ", tx=" + transformMatrix.tx.toFixed(6) + ", ty=" + transformMatrix.ty.toFixed(6) + ")]";
		}
	}
}