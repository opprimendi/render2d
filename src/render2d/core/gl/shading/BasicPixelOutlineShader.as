package render2d.core.gl.shading 
{
	public class BasicPixelOutlineShader extends AssemblerShader
	{
		public function BasicPixelOutlineShader() 
		{
			vertexData = 
																					//Matrix3D cameraTransform = vc0;
																					//Matrix3D meshTransform = vc2;
									ShaderStd.SET_MESH_VERTEX_DATA 					//Vec2[] meshVertexData = mesh.vertexData;
									
									//float xnew = p.x * c - p.y * s;```````````````````
									//float ynew = p.x * s + p.y * c;
									
								+	"mov	vt2 		va0					    \n" //Vec2[] meshVertexData = mesh.vertexData;
								+	"mul	vt2.x		vt2.x		vc3.x		\n" //meshVertexData.multipy(meshTransform.scale);
								+	"mul	vt2.y		vt2.y		vc3.y		\n" //meshVertexData.multipy(meshTransform.scale);
								+	"sub	vt0.x		vt2.x		vt2.y		\n" //meshVertexData.multipy(meshTransform.scale);
								
								
								+	"mov	vt2 		va0					\n" //Vec2[] meshVertexData = mesh.vertexData;
								+	"mul	vt2.x		vt2.x		vc3.y		\n" //meshVertexData.multipy(meshTransform.scale);
								+	"mul	vt2.y		vt2.y		vc3.x		\n" //meshVertexData.multipy(meshTransform.scale);
								+	"add	vt0.y		vt2.x		vt2.y		\n" //meshVertexData.multipy(meshTransform.scale);
									
								+	"mul	vt0.xy		vt0.xy		vc2.zw		\n" //meshVertexData.multipy(meshTransform.scale);
								+	"sub	vt0.xy		vt0.xy		vc0.xy		\n" //meshVertexData.sub(cameraTransform.position);
								+	"add	vt0.xy		vt0.xy		vc2.xy		\n" //meshVertexData.add(meshTransform.position);
								+	"mov	vt1.xy		vc0.zw					\n" //Vec2 cameraScale = cameraTransform.scale;
								+	"abs	vt1.y		vt1.y					\n"	//cameraScale.y = Math.abs(cameraScale.y);
								+	"mul	vt0.xy		vt0.xy		vt1.xy		\n" //meshVertexData.multipy(cameraScale);
								+	ShaderStd.CREEN_SPACE_RATIO						//meshVertexData.multipy(cameraTransform.screenSpaceRatio);
								+	"mov	v0, 		va1						\n" //copy uvData to v1
								+	"mov	op,			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			
										
										"mov	ft1	v0					\n" //vr buffer
									+	"mov	ft3	v0					\n" //position buffer
										 
									+	"tex	ft0	v0	fs0"				//main texture sample	
									+	"	<ignoresampler>				\n"
										 
									+	"add	ft3.x	ft1.x	fc1.x	\n" //left border position
									+	"tex	ft2		ft3		fs0"		//sample left border texture
									+	"	<ignoresampler>			\n"
										
									+	"sub	ft3.x	ft1.x	fc1.x	\n" //right border position
									+	"tex	ft4		ft3		fs0"		//sample right border texture
									+		" <ignoresampler>			\n"
									+	"add	ft2		ft4		ft2		\n" //combine border with main texture
									
									+	"mov 	ft3		ft1 			\n" //reset position register, set x to default value
									
									+	"sub	ft3.y	ft1.y	fc1.y	\n" //up border position
									+	"tex	ft4		ft3		fs0"		//sample up border texture
									+		" <ignoresampler>			\n"	
									+	"add	ft2		ft4		ft2		\n" //combine border with main texture
									
									+	"add	ft3.y	ft1.y	fc1.y	\n" //down border position
									+	"tex	ft4		ft3		fs0"		//sample up down texture
									+		" <ignoresampler>			\n"	
									+	"add	ft2		ft4		ft2		\n" //combine border with main texture
									
									+	"sat	ft2.w	ft2.w			\n" //Math.max(Math.min(alpha, 1), 0); because wee need alpha tob be <=1
									
									+	"sub	ft2.w	ft2.w	ft0.w	\n" //cut mask and get only border
									
									+	"mul	ft2.xyz	fc2.xyz	ft2.wwww \n"//colorize
									
									+	"add	ft0		ft2		ft0	\n" //add outline to result pixel
									
									+	"mov oc, ft0"
		}
	}
}