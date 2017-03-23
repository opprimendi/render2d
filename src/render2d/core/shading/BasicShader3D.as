package render2d.core.shading 
{
	public class BasicShader3D extends AssemblerShader
	{
		public function BasicShader3D() 
		{
			vertexData = 
																					//Matrix3D cameraTransform = vc0;
																					//Matrix3D meshTransform = vc2;
									ShaderStd.SET_MESH_VERTEX_DATA 					//Vec2[] meshVertexData = mesh.vertexData;
									
									//float xnew = p.x * c - p.y * s;```````````````````
									//float ynew = p.x * s + p.y * c;
									
								//+	"mov	vt2 		va0					    \n" //Vec2[] meshVertexData = mesh.vertexData;
								//+	"mul	vt2.x		vt2.x		vc3.x		\n" //meshVertexData.multipy(meshTransform.scale);
								//+	"mul	vt2.y		vt2.y		vc3.y		\n" //meshVertexData.multipy(meshTransform.scale);
								//+	"sub	vt0.x		vt2.x		vt2.y		\n" //meshVertexData.multipy(meshTransform.scale);
								
								
								//+	"mov	vt2 		va0					\n" //Vec2[] meshVertexData = mesh.vertexData;
								//+	"mul	vt2.x		vt2.x		vc3.y		\n" //meshVertexData.multipy(meshTransform.scale);
								//+	"mul	vt2.y		vt2.y		vc3.x		\n" //meshVertexData.multipy(meshTransform.scale);
								//+	"add	vt0.y		vt2.x		vt2.y		\n" //meshVertexData.multipy(meshTransform.scale);
									
								//+	"mul	vt0.xy		vt0.xy		vc2.zw		\n" //meshVertexData.multipy(meshTransform.scale);
								//+	"sub	vt0.xy		vt0.xy		vc0.xy		\n" //meshVertexData.sub(cameraTransform.position);
								//+	"add	vt0.xy		vt0.xy		vc2.xy		\n" //meshVertexData.add(meshTransform.position);
								//+	"mov	vt1.xy		vc0.zw					\n" //Vec2 cameraScale = cameraTransform.scale;
								//+	"abs	vt1.y		vt1.y					\n"	//cameraScale.y = Math.abs(cameraScale.y);
								//+	"mul	vt0.xy		vt0.xy		vt1.xy		\n" //meshVertexData.multipy(cameraScale);
								
								+	"m44	vt0			vt0			vc0			\n"
								
								//+	ShaderStd.CREEN_SPACE_RATIO						//meshVertexData.multipy(cameraTransform.screenSpaceRatio);
								
								+	"mov	v0, 		vt0						\n" //copy uvData to v1
								+	"mov	v2, 		va1						\n" //copy uvData to v1
								
								+	"mov	v1			va0 \n"
								
								+	"mov	op,			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			"mov ft0 fc1 \n"
									+ "div ft1.z v1.z fc2.z \n"
									
									+ "mov ft3 ft0 \n"
									+ "mul ft3 ft0.xyz ft1.zzz \n"
									
									//+ "nrm ft3.xyz ft3.zzz \n"
									
									+ "mul ft4 ft0 ft3 \n"
									
									
									
									+ "mov ft4.w fc2.x \n"
									
									+ "add oc ft0 ft4";
		}
	}
}