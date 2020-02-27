// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Tessellation Sample" {
	
	Properties{
		_Tess("Tessellation", Range(1,32)) = 4
		_MainTex("Base (RGB)", 2D) = "white" {}
		_DispTex("Disp Texture", 2D) = "black" {}
		_NormalMap("Normalmap", 2D) = "bump" {}
		_Displacement("Displacement", Range(0, 1.0)) = 0.3
		_Color("Color", color) = (1,1,1,0)
		_SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
		_ScaleValue("Scale Value", Range(0.0,0.8)) = 0.4
		_DistortionFactor("DistortionFactor", Range(0.0, 5.0)) = 1.0
		_RightBorder("Right Border", Float) = 0.0
		_LeftBorder("Left Border", Float) = 0.0
		_BottomBorder("Bottom Border", Float) = 0.0
		_TopBorder("Top Border", Float) = 0.0
		_FocusPointX("X Focus Point", Float) = 0.0
		_FocusPointY("Y Focus Point", Float) = 0.0

	}
		SubShader{

			Tags { "RenderType" = "Opaque" "DisableBatching" = "True" }
			//Tags { "RenderType" = "Opaque" }
			LOD 300

			CGPROGRAM
			#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessDistance nolightmap
			#pragma target 5.0
			#include "Tessellation.cginc"
			

			struct appdata {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

		

			

			float _Tess;

			//Calculates the amount of tessellation dependant on the distance between the object and the camera
			float4 tessDistance(appdata v0, appdata v1, appdata v2) {
				float minDist = 10.0;
				float maxDist = 25.0;
				return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
			}

			sampler2D _DispTex;
			float _Displacement;
			float _ScaleValue;
			float _DistortionFactor;
			float _RightBorder;
			float _LeftBorder;
			float _TopBorder;
			float _BottomBorder;
			float _FocusPointX;
			float _FocusPointY;

			void disp(inout appdata v)
			{
				

				//This is supposed to return the center coordinate of the object
				float4 objectCenter = unity_ObjectToWorld[3];
				
			

				
					

					//float3 centerVector = objectCenter - v.vertex;
					
					
					

		
					//Distance between vertex and Main Camera
					//float dist = distance(objectCenter, _WorldSpaceCameraPos);


					//float d = tex2Dlod(_DispTex, float4(v.texcoord.xy, 0, 0)).r * _Displacement / 50;



					//Fisheye Effect part

					//Position of vertex in real world coordinates
					float3 wpos = mul(unity_ObjectToWorld, v.vertex);
					
					float focusXObject = mul(unity_WorldToObject, _FocusPointX);
					float focusYObject = mul(unity_WorldToObject, _FocusPointY);
					float rightObject = mul(unity_WorldToObject, _RightBorder);
					float leftObject = mul(unity_WorldToObject, _LeftBorder);
					float topObject = mul(unity_WorldToObject, _TopBorder);
					float bottomObject = mul(unity_WorldToObject, _BottomBorder);
					


					//float DNormX = distance(_WorldSpaceCameraPos.x, v.vertex.x);


					/*float DMaxX = min(distance(_WorldSpaceCameraPos.x, 1.57), distance(_WorldSpaceCameraPos.x, -1.57));
					float DMaxY = min(distance(_WorldSpaceCameraPos.y, -1.05), distance(_WorldSpaceCameraPos.y, 1.05));*/

					//Implementation with Look-At Point as Focus
					float DMaxX = max(distance(_WorldSpaceCameraPos.x, _RightBorder), distance(_WorldSpaceCameraPos.x, _LeftBorder));
					float DMaxY = max(distance(_WorldSpaceCameraPos.y, _BottomBorder), distance(_WorldSpaceCameraPos.y, _TopBorder));

					//float DMaxX = distance(_FocusPointX, _RightBorder);
					//float DMaxY = distance(_FocusPointY, _RightBorder);

					//Implementierung im Object Space
					//float DMaxX = min(distance(focusXObject, rightObject), distance(focusXObject, leftObject));
					//float DMaxY = min(distance(focusYObject, topObject), distance(focusYObject, bottomObject));

					//float DMaxX = max(distance(wpos.x, 1.57), distance(wpos.x, -1.57));
					//float DMaxY = max(distance(wpos.y, -1.05), distance(wpos.y, 1.05));




					//DNormx & DNormY
					float DNormX = distance(_FocusPointX, wpos.x);
					float DNormY = distance(_FocusPointY, wpos.y);



					//Implementierung im Object Space
					//float DNormX = distance(focusXObject, v.vertex.x);
					//float DNormY = distance(focusYObject, v.vertex.y);

					//float DNormZ = distance(_WorldSpaceCameraPos.z, wpos.z);

					//Dnormx/Dmaxx
					float normDistX = DNormX / DMaxX;
					float normDistY = DNormY / DMaxY;
					//float normDistZ = DNormZ / DMaxZ;

					//G(x)
					float gOfXX = ((_DistortionFactor + 1) * normDistX) / ((_DistortionFactor * normDistX) + 1);
					float gOfXY = ((_DistortionFactor + 1) * normDistY) / ((_DistortionFactor * normDistY) + 1);
					//float gOfXZ = ((_DistortionFactor + 1) * normDistZ) / ((_DistortionFactor * normDistZ) + 1);

			
					//x Calculation
					v.vertex.x = gOfXX * DMaxX + _FocusPointX;
					//float intermediateX = gOfXX * DMaxX + _FocusPointX;
					

					//y Calculation 
					v.vertex.y = gOfXY * DMaxY + _FocusPointY;
					//float intermediateY = gOfXY * DMaxY + _FocusPointY;

					//Implementierung im Object Space
					//x Calculation
					//v.vertex.x = gOfXX * DMaxX + focusXObject;


					//y Calculation 
					//v.vertex.y = gOfXY * DMaxY + focusYObject;
					
					//float objPosX = mul(unity_WorldToObject, intermediateX);
					//float objPosY = mul(unity_WorldToObject, intermediateY);
		
					
					v.vertex = mul(unity_WorldToObject, v.vertex);	
				
					
					
					//v.vertex.x = objPosX;
					//v.vertex.y = objPosY;

				
				
			}

			struct Input {
				float2 uv_MainTex;
			};

			sampler2D _MainTex;
			sampler2D _NormalMap;
			fixed4 _Color;

			void surf(Input IN, inout SurfaceOutput o) {
				half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				//c.a = 0;

				o.Albedo = c.rgb;
				
				o.Specular = 0.2;
				o.Gloss = 1.0;
				o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
			}
			ENDCG
		}
			FallBack "Diffuse"
}