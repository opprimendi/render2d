package render2d.core.gl.shading 
{
	public class SimpleDynamicTextShader extends AssemblerShader
	{
		public function SimpleDynamicTextShader() 
		{
			vertexData = 															
																					
							
																					//Transform representation
																					//Transform{position(x, y), scale(x, y)} 1 register(xyzw)
																					//Rotation{rotatioX(cosX, sinX), notUsed, notUsed) 1 register (xyzw)
																					//VertexData(x, y) - each vertex is pair of registers x, y
																					//UvData(x, y) - pair of uv x, y
																					//
																					//vc0 - camera x, y, scaleX, scaleY
																					//vc1 - camera additional params (w - screenSpaceRatio)
																					//vc2 - container(batchedLayer) x, y, scaleX, scaleY
																					//vc3 - container(batchedLayer) cos(rotationX), sin(rotationX), notUsed, notUsed
																					//pair of registers vc3+1-vc3+2 is mesh transform data
																					//
																					//va0 - mesh vertices, va1 - mesh uvs, va2 - mesh index list
																					//mesh alias of va0
																					//camera alias of vc0-vc1
																					//meshIndex alias for va2
																					//
																					//Transform cameraTransform = vc0;
																					//Transform meshTransform = vc2 - container vc2+~ mesh transform;
								//				Define mesh data					//
									ShaderStd.SET_MESH_VERTEX_DATA 					//VertexData meshVertexData = mesh;
								+	"mov	vt2 		vc[va2.x]				\n" //Transform meshTransform = vc[meshIndex];
								
								//				Add local and global mesh transform to mesh vertices
								
								+	"abs	vt2.w		vt2.w					\n" //meshVertexData.multipy(meshTransform.scale); 					//scale mesh vertices by mesh local scale
								+	"mul	vt0.y		vt0.y		vt2.w		\n" //meshVertexData.multipy(meshTransform.scale); 					//scale mesh vertices by mesh local scale
								+	"add	vt0.xy		vt0.xy		vt2.xy		\n" //meshVertexData.add(meshTransform.position);					//add global mesh psotion to mesh vertices
								+	"mul	vt0.xy		vt0.xy		vc2.zw		\n" //add container scale
								+	"add	vt0.xy		vt0.xy		vc2.xy		\n" //add container position
								
								+	ShaderStd.CREEN_SPACE_RATIO 					//meshVertexData.multipy(cameraTransform.screenSpaceRatio);		//apply screen space ration to mesh vertices(1 pixel in backbufer is have different size bacause it based on backbufer w, h. In backbuffer coordinates is -1 - 1 not the w, h passed in configure back buffer
								+	"mov	v0, 		va1						\n" //copy uvData to v1
								+	"mov	op,			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			//anisotropic2x			
										
										"tex ft0, v0, fs0 <ignoresampler>\n"//<2d,repeat,anisotropic4x,miplinear> \n" //Pixel pixel = texture.getPixelAt(fs0, TextureFillModel.WRAP, TextureSampler.LINEAR, MipMapSampler.LINEAR, -0.5
									//+	"add ft0, v0, ft0 \n"
									//+	"div ft0, v0, ft0 \n"
									+	"sub ft0.xyz ft0.xyz fc0.www \n"
									+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									+	"add ft0.xyz ft0.xyz fc0.xyz \n"
									
									+	"mov oc, ft0"
		}
	}
}