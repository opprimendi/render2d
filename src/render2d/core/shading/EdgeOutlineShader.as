package render2d.core.shading 
{
	public class EdgeOutlineShader extends AssemblerShader
	{
		/**
		 * Вообще рендерить едж аутлайн в 1 пасс нереально. Но теоретически можно юзать что то типа:
		 * Брать пиксель аутлайн, аутлайн не увиличивает размер объекта а наоборот уменьшает, т.е так мы создаем 
		 * место для рендера аутлайна. Аутлайн рендерим в пиксель шейдере и получаем примерно или же желаемый результат
		 * 
		 * Не возможно ап скейлить в пикслеь шейдере т.к зона рендера ограничена. Можно апскейлить сразу вертекс буфер на величину аутлайна, а в 
		 * пиксель шейдере даунскейлить исходное изображение а аутлайн же рисовать в 1:1
		 * 
		 */
		public function EdgeOutlineShader() 
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
			
										"mov ft0 v0 \n"
									+	"div ft0.xy ft0.xy fc1.xy \n"
									
									+	"tex ft1 ft0 fs0 <ignoresampler> \n"
									
									+	"tex ft2 v0 fs0 <ignoresampler> \n"
									
									//+	"mul ft1.xyz ft1.xyz fc2.wwww \n"
									//+	"add ft1 ft1 ft2 \n"
									
									+	"mov oc, ft1"
		}
	}
}