﻿// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'



// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Fisheye Center" {

	Properties{
		_Tess("Tessellation", Range(1,32)) = 4
		_MainTex("Base (RGB)", 2D) = "white" {}
		_DispTex("Disp Texture", 2D) = "black" {}
		_NormalMap("Normalmap", 2D) = "bump" {}
		_Displacement("Displacement", Range(0, 1.0)) = 0.3
		_Color("Color", color) = (1,1,1,0)
		_SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
		_DistortionFactor("Distortion Factor", Range(0.0, 5.0)) = 2.0
		_DistortionRadius("Distortion Radius", Range(0.0, 500.0)) = 150.0
		_AlphaTest("Alpha Test", Range(0.0, 1.0)) = 1.0
		_FocusPointX("X Point", Range(-100.0, 500.0)) = 0.0
		_FocusPointY("Y Point", Range(-100.0, 500.0)) = 0.0

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
						float _DistortionFactor;
						float _DistortionRadius;
						float _AlphaTest;
						float _FocusPointX;
						float _FocusPointY;



						//, out Input o
						void disp(inout appdata v)
						{
							//UNITY_INITIALIZE_OUTPUT(Input, o);
							float bbLength = 15;
							float bbHight = 8;
							float bbDepth = 20;
							//float minX = -5;
							//float minY = -3;
							//float minZ = -5;
							float minX = -10;
							float minY = -4;
							float minZ = -9;


							//Get the center of the object
							float4 objectOrigin = unity_ObjectToWorld[3];


						   float4 versch = float4(minX, minY, minZ,0);

						   //Position of vertex in real world coordinates

						   float4 wpos = mul(unity_ObjectToWorld, v.vertex);
						   //float4 wpos = mul(v.vertex, unity_ObjectToWorld);

						   //float3 wpos = mul(unity_ObjectToWorld, v.vertex);

						   //float check = _WorldSpaceCameraPos.x;

						   float4 uPos = float4(_WorldSpaceCameraPos.xyz, 1.0);

						   //float3 uPos = _WorldSpaceCameraPos.xyz;
						   float distortion = _DistortionFactor;
						   float radius = _DistortionRadius;

						   //Camera forward vector, two options: float3 viewDir = UNITY_MATRIX_IT_MV[2].xyz;
						   //or float3 forward = mul((float3x3)unity_CameraToWorld, float3(0,0,1));

						   //float3 viewDir = UNITY_MATRIX_IT_MV[2].xyz;
						   float k0 = exp(distortion);
						   k0 = k0 / (k0 - 1) * radius;
						   float k1 = distortion / radius;


						   //Transformation of User position, vertex position and view ray into the bounding box space

						   float4 bboxUser = uPos - versch;

						   //bboxUser = mul(bboxUser, bbMatrix2);


						   float4 bboxPos = wpos - versch;

						   //bboxPos = mul(bboxPos, bbMatrix2);



						   //float3 bboxRay = viewDir - versch;
						   //bboxRay = mul(bboxRay, bbMatrix2).xyz;


						   //normalisieren in die Bounding Box
						   //float4 bboxUser = mul(uPos, unity_WorldToObject);
						   //float4 bboxPos = mul(wpos, unity_WorldToObject);
						   //float3 bboxRay = mul(viewDir, unity_WorldToObject);

						   /*float3 floorNormal = (0, 1, 0);

						   float rdotn = dot(bboxRay, floorNormal);
						   if (rdotn > 0.000000001f) {

							   float lambda = dot(floorNormal, -bboxUser.xyz) / rdotn;

							   float3 intersection = bboxUser + lambda * bboxRay;



						   }*/

						   float2 focus = bboxUser.xz;
						   float2 d = bboxPos.xz - focus;
						   float2 fisheyePos = bboxPos.xz;

						   //In case y and z are switched
						   //float2 d = bboxPos.xy - focus;
						   //float2 fisheyePos = bboxPos.xy;

						   float dd = dot(d, d);
						   //dd = sqrt(dd);



							if ((dd != 0.0) && (dd < radius)) {

								//float k = k0 * (1.0 - exp(-dd * k1)) / dd * 0.75 + 0.25;
								float k = k0 * (1.0 - exp(-dd * k1)) / dd * 0.75 + 0.25;

								fisheyePos = focus + d * k.xx;

							}


							//v.vertex.xz = mul(float4(fisheyePos.x, 0.0, fisheyePos.y, 1.0), unity_ObjectToWorld).xz;
							//v.vertex.xz = mul(float4(fisheyePos.x, 0.0, fisheyePos.y, 1.0), invbbMatrix2).xz;

							 v.vertex.xz = fisheyePos.xy;



							 v.vertex.x = v.vertex.x + versch.x;
							 v.vertex.y = wpos.y;
							 v.vertex.z = v.vertex.z + versch.z;

							 //v.vertex = wpos;
							 //o.hack = float4(1,0,0,1);
							 v.vertex = mul(unity_WorldToObject, v.vertex);
							 v.vertex.z += _Displacement;

					}

					sampler2D _MainTex;
					sampler2D _NormalMap;
					fixed4 _Color;

					void surf(Input IN, inout SurfaceOutput o) {


						half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
						//c.a = 0;
						float3 pos = _WorldSpaceCameraPos;
						//Calculation of view Direction
						float3 viewDir = mul((float3x3)unity_CameraToWorld, float3(0, 0, 1));
						o.Albedo = c.rgb;
						//o.Albedo = float4(c.r, c.g, c.b, 0.0);
						//o.Alpha = _AlphaTest;
						float test = 2.6 % 1.3;
						/*if (test == 0) {
							o.Albedo = float4(1,0,0,1);

						}*/

						//o.Albedo = float4(IN.worldPos.x, IN.worldPos.y, IN.worldPos.z, 1);
						//o.Albedo = float4(0, IN.worldPos.x/25, 0, 1);

						//o.Albedo = float4(viewDir.x,0,0, 1.0);
						o.Specular = 0.2;
						o.Gloss = 1.0;
						o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
					}
					ENDCG
		}
			FallBack "Diffuse"
}