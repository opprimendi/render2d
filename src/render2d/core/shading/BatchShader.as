package render2d.core.shading 
{
	public class BatchShader extends AssemblerShader
	{
		public function BatchShader() 
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
									"mov	vt0 		va0						\n" //VertexData meshVertexData = mesh;
								+	"mov	vt2 		vc[va2.x]				\n" //Transform meshTransform = vc[meshIndex];
								+	"mov	vt4 		vc[va2.x+1]				\n" //Rotation meshRotation = vc[meshIndex+1];
								//				Rotation
								//				float xnew = p.x * cos - p.y * sin;
								//				float ynew = p.x * sin + p.y * cos;
								+	"mov	vt3 		va0					    \n" //VertexData meshVertexData2 = mesh;
								+	"mul	vt3.x		vt3.x		vt4.x		\n" //meshVertexData2.x *= meshRotation.rotatioX.x;
								+	"mul	vt3.y		vt3.y		vt4.y		\n" //meshVertexData2.y *= meshRotation.rotatioX.y;
								+	"sub	vt0.x		vt3.x		vt3.y		\n" //meshVertexData.x = meshVertexData2.x - meshVertexData2.y;
								
								
								+	"mov	vt3 		va0						\n" //meshVertexData2 = mesh;
								+	"mul	vt3.x		vt3.x		vt4.y		\n" //meshVertexData2.x *= meshRotation.rotatioX.y;
								+	"mul	vt3.y		vt3.y		vt4.x		\n" //meshVertexData2.y *= meshRotation.rotatioX.x;
								+	"add	vt0.y		vt3.x		vt3.y		\n" //meshVertexData.x = meshVertexData2.x + meshVertexData2.y;
								
								
								//				Add local and global mesh transform to mesh vertices
								//+	"mov	vt2 		vc4						\n" //Vec2[] meshVertexData = mesh.vertexData;
								+	"mul	vt0.xy		vt0.xy		vt2.zw		\n" //meshVertexData.multipy(meshTransform.scale); 					//scale mesh vertices by mesh local scale
								+	"sub	vt0.xy		vt0.xy		vc0.xy		\n" //meshVertexData.sub(cameraTransform.position); 				//apply camera position to mesh vertices
								+	"add	vt0.xy		vt0.xy		vt2.xy		\n" //meshVertexData.add(meshTransform.position);					//add global mesh psotion to mesh vertices
								+	"mov	vt1.xy		vc0.zw					\n" //Scale cameraScale = cameraTransform.scale;
								+	"abs	vt1.y		vt1.y					\n"	//cameraScale.y = Math.abs(cameraScale.y);						//because camera behing scene :E by default
								+	"mul	vt0.xy		vt0.xy		vt1.xy		\n" //meshVertexData.multipy(cameraScale);							//apply camera scale(zoom) to mesh vertices
								+	"mul	vt0.xy		vt0.xy		vc1.w		\n" //meshVertexData.multipy(cameraTransform.screenSpaceRatio);		//apply screen space ration to mesh vertices(1 pixel in backbufer is have different size bacause it based on backbufer w, h. In backbuffer coordinates is -1 - 1 not the w, h passed in configure back buffer
								//+	"mul	vt0.x		vt0.x		vc1.z		\n" //meshVertexData.multipy(cameraTransform.screenSpaceRatio);     //mb screen space ration should be raplaced with camera W, H and cauculated as aspect ration
								+	"mov	v0, 		va1						\n" //copy uvData to v1
								+	"mov	op,			vt0						  ";//copy meshVertexData to output
								
			fragmentData = 			//anisotropic2x												 		//pixel(Vec2 position, TextureFillModel fillMode, TextureSampler sampler, MipMapSampler mipSampler, Number bias)
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