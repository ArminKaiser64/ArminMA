// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'



// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "TestShader" {

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
							
							v.vertex.x += _Displacement;

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