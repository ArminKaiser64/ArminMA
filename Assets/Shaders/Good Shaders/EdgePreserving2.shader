


Shader "EdgePreserving2" {

	Properties{
		_Tess("Tessellation", Range(1,32)) = 4
		_MainTex("Base (RGB)", 2D) = "white" {}
		_DispTex("Disp Texture", 2D) = "black" {}
		_NormalMap("Normalmap", 2D) = "bump" {}
		_Displacement("Displacement", Range(0, 100.0)) = 0.3
		_Displacement2("Displacement2", Range(0, 100.0)) = 0.3
		_Displacement3("Displacement3", Range(0, 100.0)) = 0.3
		_Color("Color", color) = (1,1,1,0)
		_SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
		_Push("Push", Range(0.0,20.0)) = 5.0
		_CameraX("Camera X", Range(0.0,1.0)) = 0.0
		_CameraY("Camera Y", Range(0.0,1.0)) = 0.0
		_CameraZ("Camera Z", Range(0.0,1.0)) = 0.0

	}
		SubShader{

			Tags { "Queue" = "Transparent" "RenderType" = "Transparent"  }
			//Tags { "RenderType" = "Opaque" }
			//If you put ZWrite Off, it will enable transparancy features
			//ZWrite Off
			//Cull Off
			LOD 300

			CGPROGRAM
			// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members hack)
						//#pragma exclude_renderers d3d11
						#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessDistance nolightmap
						#pragma target 5.0
						#include "Tessellation.cginc"


						struct appdata {
							float4 vertex : POSITION;
							float4 tangent : TANGENT;
							float3 normal : NORMAL;
							float2 texcoord : TEXCOORD0;


						};


						struct Input {
							float2 uv_MainTex;
							float4 hack;
							float3 worldPos;

						};




						float _Tess;

						//Calculates the amount of tessellation dependant on the distance between the object and the camera
						float4 tessDistance(appdata v0, appdata v1, appdata v2) {
							float minDist = 10.0;
							float maxDist = 25.0;
							//return	(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
							return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);

						}

						sampler2D _DispTex;
						float _Displacement;
						float _Displacement2;
						float _Displacement3;
						float _FocusPointX;
						float _FocusPointY;
						float _Push;
						float _CameraX;
						float _CameraY;
						float _CameraZ;



						//, out Input o
						void disp(inout appdata v)
						{

							//float4 test = float4(_CameraX, _CameraY, _CameraZ, 1.0);
							//float3 uPos = float3(_WorldSpaceCameraPos);
							//float4 test = float4(_WorldSpaceCameraPos.xyz, 1.0);

							//float4 test = float4(_Displacement2, _Displacement3, _Displacement, 1.0);
							float4 test = float4(_WorldSpaceCameraPos.x, _WorldSpaceCameraPos.y, _WorldSpaceCameraPos.z, 1.0);
							float4 wPos = mul(unity_ObjectToWorld, v.vertex);


							float4 newPos = wPos;
							//float dist = distance(uPos, newPos);
							float dist = distance(test, newPos);

							float distX = distance(test.x, newPos.x);
							float distZ = distance(test.z, newPos.z);
							float distY = distance(test.y, newPos.y);

							float amount = _Push - dist;
							float amountX = _Push - distX;
							float amountZ = _Push - distZ;
							float amountY = _Push - distY;
							//float4 dirVector = float4(wPos - uPos);
							float4 dirVector = float4(wPos - test);




							dirVector = dirVector / length(dirVector);
							//float3 dirVector = v.vertex.xyz - mul(unity_WorldToObject, uPos);
							float3 viewDir = mul((float3x3)unity_CameraToWorld, float3(0, 0, 1));


							if (dist < _Push)
							{
								//newPos.xz = newPos.xz + (amount * dirVector.xz);
								//newPos = newPos + (amount * dirVector);

							}

							//In this part, the distance of the x- and z-Coordinate between the user and the vertex are looked at independentely

							if (distX < _Push)
							{
								
								newPos.x = newPos.x + (amountX * dirVector.x);

							}
							if (distZ < _Push)
							{
					
								newPos.z = newPos.z + (amountZ * dirVector.z);
							}

							/*if (distY < _Push)
							{
								//newPos.xz = newPos.xz + (amount * dirVector.xz);
								//newPos = newPos + (amount * dirVector);
								newPos.y = newPos.y + (amountY * dirVector.y);
							}*/
							//newPos = newPos + dirVector * _Push;
							//newPos = wPos + (_Push * dirVector);
							//v.vertex = mul(unity_ObjectToWorld, v.vertex);

							v.vertex.xyz = newPos;

							v.vertex = mul(unity_WorldToObject, v.vertex);

						}

					 sampler2D _MainTex;
					 sampler2D _NormalMap;
					 fixed4 _Color;

					 void surf(Input IN, inout SurfaceOutput o) {
						 /*float3 uPos = _WorldSpaceCameraPos;
						 float3 wPos = IN.worldPos;

						 //float3 camDirection = normalize(wPos - uPos);
						 float3 newPos = wPos;
						 float dist = distance(uPos, newPos);
						 float amount = _Push - dist;
						 //float3 dirVector = mul(uPos, newPos);
						 float3 dirVector = float3(wPos - uPos);
						 dirVector = dirVector / length(dirVector);*/

						 half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
						 //c.a = 0;
						 float3 pos = _WorldSpaceCameraPos;
						 //Calculation of view Direction
						 //float3 viewDir = mul((float3x3)unity_CameraToWorld, float3(0, 0, 1));
						 o.Albedo = c.rgb;
						 //o.Albedo = float4(c.r, c.g, c.b, 0.0);





						 float4 uPos = float4(_WorldSpaceCameraPos.xyz, 1.0);
						 float4 wPos = float4(IN.worldPos.xyz,1.0);
						 //o.Albedo = float4(uPos.x, 0.0, 0.0, 1.0);
						 float dist = distance(uPos, wPos);
						 float4 kamera = float4(_WorldSpaceCameraPos.xyz, 1.0);
						 //o.Albedo = float4(_WorldSpaceCameraPos.x, 0, 0, 1.0);
						 /*if (length(dirVector) > 1)
						 {
							 o.Albedo = float4(1.0, 0.0, 0.0, 1.0);
							 //o.Albedo = float4(1.0, 0.0, 0.0, 1.0);
						 }*/
						 if (dist < _Push)
						 {
							 //o.Albedo = float4(1.0, 0.0, 0.0, 1.0);
						 }
						 o.Specular = 0.2;
						 o.Gloss = 1.0;
						 o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
					 }
					 ENDCG
		}
			FallBack "Diffuse"
}