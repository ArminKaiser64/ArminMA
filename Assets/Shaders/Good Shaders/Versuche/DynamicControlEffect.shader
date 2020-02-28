// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'



// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "Dynamic Control Shader" {

	Properties{
		_Tess("Tessellation", Range(1,32)) = 4
		_MainTex("Base (RGB)", 2D) = "white" {}
		_DitherPattern("Dithering Pattern", 2D) = "white" {}
		_Displacement("Displacement", Range(0, 100.0)) = 0.3
		_Color("Color", color) = (1,1,1,0)
		_SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
		_DistortionFactor("Distortion Factor", Range(0.0, 5.0)) = 2.0
		_DistortionRadius("Distortion Radius", Range(0.0, 500.0)) = 150.0
		_Transparency("Transparency", Range(0.0, 1.0)) = 1.0
		_Back("Back", Float) = 0.0
		_Front("Front", Float) = 0.0
		_Right("Right", Float) = 0.0
		_Left("Left", Float) = 0.0
		_MiddleX("X Middle", Float) = 0.0
		_MiddleY("Y Middle", Float) = 0.0
		_MiddleZ("Z Middle", Float) = 0.0
		_BackMiddleX("Back X Middle", Float) = 0.0
		_BackMiddleY("Back Y Middle", Float) = 0.0
		_BackMiddleZ("Back Z Middle", Float) = 0.0
		_FrontMiddleX("Front X Middle", Float) = 0.0
		_FrontMiddleY("Front Y Middle", Float) = 0.0
		_FrontMiddleZ("Front Z Middle", Float) = 0.0
		_RightMiddleX("Right X Middle", Float) = 0.0
		_RightMiddleY("Right Y Middle", Float) = 0.0
		_RightMiddleZ("Right Z Middle", Float) = 0.0
		_LeftMiddleX("Left X Middle", Float) = 0.0
		_LeftMiddleY("Left Y Middle", Float) = 0.0
		_LeftMiddleZ("Left Z Middle", Float) = 0.0
		_BackNormalX("Back Normal X", Float) = 0.0
		_BackNormalY("Back Normal Y", Float) = 0.0
		_BackNormalZ("Back Normal Z", Float) = 0.0
		_FrontNormalX("Front Normal X", Float) = 0.0
		_FrontNormalY("Front Normal Y", Float) = 0.0
		_FrontNormalZ("Front Normal Z", Float) = 0.0
		_RightNormalX("Right Normal X", Float) = 0.0
		_RightNormalY("Right Normal Y", Float) = 0.0
		_RightNormalZ("Right Normal Z", Float) = 0.0
		_LeftNormalX("Left Normal X", Float) = 0.0
		_LeftNormalY("Left Normal Y", Float) = 0.0
		_LeftNormalZ("Left Normal Z", Float) = 0.0
		_Factor("Reduktionsfaktor", Float) = 0.0
		_RotationFactor("Rotation Factor", Float) = 0.0
		_Versuch("Versuch", Range(0.0, 50.0)) = 0
		_Color1("Dither Color 1", Color) = (0, 0, 0, 1)
		_Color2("Dither Color 2", Color) = (1, 1, 1, 1)





	}
		SubShader{

			Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "DisableBatching" = "true"  }
			//Tags { "RenderType" = "Opaque" }
			//If you put ZWrite Off, it will enable transparancy features
			//ZWrite Off
			Cull Off
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
							float4 vertex : POSITION;
							float2 texcoord : TEXCOORD0;
							float4 screenPos;
							float4 screenPosition : TEXCOORD1;
						};




						float _Tess;

						//Calculates the amount of tessellation dependant on the distance between the object and the camera
						float4 tessDistance(appdata v0, appdata v1, appdata v2) {
							float minDist = 10.0;
							float maxDist = 25.0;
							//return	(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
							return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);

						}

						sampler2D _DitherPattern;
						float4 _Color1;
						float4 _Color2;

						float _Displacement;
						float _DistortionFactor;
						float _DistortionRadius;
						float _Back;
						float _Front;
						float _Right;
						float _Left;
						float _MiddleX;
						float _MiddleY;
						float _MiddleZ;
						float _BackMiddleX;
						float _BackMiddleY;
						float _BackMiddleZ;
						float _FrontMiddleX;
						float _FrontMiddleY;
						float _FrontMiddleZ;
						float _RightMiddleX;
						float _RightMiddleY;
						float _RightMiddleZ;
						float _LeftMiddleX;
						float _LeftMiddleY;
						float _LeftMiddleZ;
						float _BackNormalX;
						float _BackNormalY;
						float _BackNormalZ;
						float _FrontNormalX;
						float _FrontNormalY;
						float _FrontNormalZ;
						float _RightNormalX;
						float _RightNormalY;
						float _RightNormalZ;
						float _LeftNormalX;
						float _LeftNormalY;
						float _LeftNormalZ;
						float _Factor;
						float _RotationFactor;
						half _Transparency;
						float _Versuch;
						float4 _DitherPattern_TexelSize;

						//, out Input o
						void disp(inout appdata v)
						{
							//UNITY_INITIALIZE_OUTPUT(Input, o);

					

								//define the initial position of the vertex when the program is launched
								float3 initPos = v.vertex;
								
							


					
							//Get the center of the object
							float4 objectCenter2 = unity_ObjectToWorld[3];
							float4 objectCenter = float4(_MiddleX, _MiddleY, _MiddleZ, 1.0);

							objectCenter = mul(unity_WorldToObject, objectCenter);

							//neighbors
							float4 backCenter = float4(_BackMiddleX, _BackMiddleY, _BackMiddleZ, 1.0);
							backCenter = mul(unity_WorldToObject, backCenter);
							float4 frontCenter = float4(_FrontMiddleX, _FrontMiddleY, _FrontMiddleZ, 1.0);
							frontCenter = mul(unity_WorldToObject, frontCenter);
							float4 rightCenter = float4(_RightMiddleX, _RightMiddleY, _RightMiddleZ, 1.0);
							rightCenter = mul(unity_WorldToObject, rightCenter);
							float4 leftCenter = float4(_LeftMiddleX, _LeftMiddleY, _LeftMiddleZ, 1.0);
							leftCenter = mul(unity_WorldToObject, leftCenter);
							//

							//
							//normals of the different sites, calculated during runtime via script
							float4 backNormal = float4(_BackNormalX, _BackNormalY, _BackNormalZ, 1.0);
							float4 frontNormal = float4(_FrontNormalX, _FrontNormalY, _FrontNormalZ, 1.0);
							float4 rightNormal = float4(_RightNormalX, _RightNormalY, _RightNormalZ, 1.0);
							float4 leftNormal = float4(_LeftNormalX, _LeftNormalY, _LeftNormalZ, 1.0);
							//

							//With those variables, the vertices that lie on the site of the room clostest to the appropriate neighbour are calculated. With those, we know which vertices to distort in order to close the gap between two neighboring rooms.
							float backdist2 = distance(backCenter.xyz, objectCenter2.xyz);
							float backdist3 = distance(v.vertex.xyz, backCenter);

							float frontdist2 = distance(frontCenter.xyz, objectCenter2.xyz);
							float frontdist3 = distance(v.vertex.xyz, frontCenter);

							float rightdist2 = distance(rightCenter.xyz, objectCenter2.xyz);
							float rightdist3 = distance(v.vertex.xyz, rightCenter);

							float leftdist2 = distance(leftCenter.xyz, objectCenter2.xyz);
							float leftdist3 = distance(v.vertex.xyz, leftCenter);


							//

						float4 centerVector = objectCenter - v.vertex;

						float4 centerVector2 = (v.vertex - objectCenter) * _Factor;
						centerVector2 = normalize(centerVector2);

						//necessary, because the y and z axis in the unity scene are reversed in respect to the shader
						float4  backNormal2 = float4(backNormal.x, backNormal.z, backNormal.y, backNormal.w);
						float4  frontNormal2 = float4(frontNormal.x, frontNormal.z, frontNormal.y, frontNormal.w);
						float4  rightNormal2 = float4(rightNormal.x, rightNormal.z, rightNormal.y, rightNormal.w);
						float4  leftNormal2 = float4(leftNormal.x, leftNormal.z, leftNormal.y, leftNormal.w);


						/*float backDot = dot(centerVector2, backNormal2);
						float frontDot = dot(centerVector2, frontNormal2);
						float rightDot = dot(centerVector2, rightNormal2);
						float leftDot = dot(centerVector2, leftNormal2);*/


						//float4 objectCenterNew = float4(_CenterX, _CenterY, _CenterZ, 1.0);

						//float4 backCenterVector = backCenter - v.vertex;
						//float4 backVertex = (v.vertex.xyz + backCenterVector.xyz, 1.0);


						float4 backVertex = backCenter;
						float4 frontVertex = frontCenter;
						float4 rightVertex = rightCenter;
						float4 leftVertex = leftCenter;

						v.vertex.xyz += centerVector.xyz;

						//Position of vertex in real world coordinates

						 float4 wpos = mul(unity_ObjectToWorld, v.vertex);
						 //
						 float4 backwpos = mul(unity_ObjectToWorld, backCenter);
						 float4 frontwpos = mul(unity_ObjectToWorld, frontCenter);
						 float4 rightwpos = mul(unity_ObjectToWorld, rightCenter);
						 float4 leftwpos = mul(unity_ObjectToWorld, leftCenter);

						 //
						float4 uPos = float4(_WorldSpaceCameraPos.xyz, 1.0);

						//direction vector to figure out where the user is relative to the vertex position (or in this case the center of the room)
						float3 direction = wpos - uPos;
						//use distance as indicator, how big the gap between the two neighboring rooms is
						//float dist = distance(uPos, wpos);

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

						float4 bboxUser = uPos;


						float4 bboxPos = wpos;

						//
						float4 backPos = backwpos;
						float4 frontPos = frontwpos;
						float4 rightPos = rightwpos;
						float4 leftPos = leftwpos;
						//

						float2 focus = bboxUser.xz;
						float2 d = bboxPos.xz - focus;

						//
						float2 backd = backPos.xz - focus;
						float2 frontd = frontPos.xz - focus;
						float2 rightd = rightPos.xz - focus;
						float2 leftd = leftPos.xz - focus;
						//

						float2 fisheyePos = bboxPos.xz;

						//
						float2 backFisheyePos = backPos.xz;
						float2 frontFisheyePos = frontPos.xz;
						float2 rightFisheyePos = rightPos.xz;
						float2 leftFisheyePos = leftPos.xz;
						//

						float dd = dot(d, d);

						//
						float backdd = dot(backd, backd);
						float frontdd = dot(frontd, frontd);
						float rightdd = dot(rightd, rightd);
						float leftdd = dot(leftd, leftd);
						//

						//calculation of the center of the neighboring room (if it exists) to calculate the distance between the two centers and the center of the neighbor and the vertex

						if ((backdd != 0.0) && (backdd < radius)) {
							float backk = k0 * (1.0 - exp(-backdd * k1)) / backdd * 0.75 + 0.25;
							backFisheyePos = focus + backd + backk.xx;
						}
						if ((frontdd != 0.0) && (frontdd < radius)) {
							float frontk = k0 * (1.0 - exp(-frontdd * k1)) / frontdd * 0.75 + 0.25;
							frontFisheyePos = focus + frontd + frontk.xx;
						}
						if ((rightdd != 0.0) && (rightdd < radius)) {
							float rightk = k0 * (1.0 - exp(-rightdd * k1)) / rightdd * 0.75 + 0.25;
							rightFisheyePos = focus + rightd + rightk.xx;
						}
						if ((leftdd != 0.0) && (leftdd < radius)) {
							float leftk = k0 * (1.0 - exp(-leftdd * k1)) / leftdd * 0.75 + 0.25;
							leftFisheyePos = focus + leftd + leftk.xx;
						}



						 if ((dd != 0.0) && (dd < radius)) {

							 float k = k0 * (1.0 - exp(-dd * k1)) / dd * 0.75 + 0.25;

							 fisheyePos = focus + d * k.xx;

						 }


						  v.vertex.xz = fisheyePos.xy;

						  backVertex.xz = backFisheyePos.xy;
						  frontVertex.xz = frontFisheyePos.xy;
						  rightVertex.xz = rightFisheyePos.xy;
						  leftVertex.xz = leftFisheyePos.xy;

						  v.vertex.x = v.vertex.x;
						  v.vertex.y = wpos.y;
						  v.vertex.z = v.vertex.z;



						  //
						  backVertex.x = backVertex.x;
						  backVertex.y = backwpos.y;
						  backVertex.z = backVertex.z;

						  frontVertex.x = frontVertex.x;
						  frontVertex.y = frontwpos.y;
						  frontVertex.z = frontVertex.z;

						  rightVertex.x = rightVertex.x;
						  rightVertex.y = rightwpos.y;
						  rightVertex.z = rightVertex.z;

						  leftVertex.x = leftVertex.x;
						  leftVertex.y = leftwpos.y;
						  leftVertex.z = leftVertex.z;
						  //

						  float backdist = distance(v.vertex, backVertex);
						  float frontdist = distance(v.vertex, frontVertex);
						  float rightdist = distance(v.vertex, rightVertex);
						  float leftdist = distance(v.vertex, leftVertex);

						  v.vertex = mul(unity_WorldToObject, v.vertex);
						  float4 mitte = float4(v.vertex.xyz, 1.0);
						  v.vertex.xyz -= centerVector.xyz;



						  /*
						  backVertex = mul(unity_WorldToObject, backVertex);
						  frontVertex = mul(unity_WorldToObject, frontVertex);
						  rightVertex = mul(unity_WorldToObject, rightVertex);
						  leftVertex = mul(unity_WorldToObject, leftVertex);


						  float backdist = distance(v.vertex, backVertex);
						  float frontdist = distance(v.vertex, frontVertex);
						  float rightdist = distance(v.vertex, rightVertex);
						  float leftdist = distance(v.vertex, leftVertex);
						  */

						  float4 distor = mul(unity_ObjectToWorld, v.vertex);
						  //float4 versuch = v.vertex;
						  centerVector.xyz = v.vertex.xyz - mitte.xyz;



						  //The Factor indicates that a rotation has taken place (within the scene). It adjustes the centerVector so that the correct vertices are being changed for the room enhancement.
						  centerVector *= _Factor;
						  centerVector2 = (normalize(centerVector));

						  float backDot = dot(centerVector2, backNormal2);
						  float frontDot = dot(centerVector2, frontNormal2);
						  float rightDot = dot(centerVector2, rightNormal2);
						  float leftDot = dot(centerVector2, leftNormal2);


						  


						//When the control Distortion is being triggered, gaps between the rooms are being created. For that reason, the below correction is being used to enhance the width of the rooms which have a neighbor
						//The direction of the neighbor, wether or not the user is within distortion range and wether or not the vertex is being called for the enhancement are checked in the if-Statement
							  //if (_Back == 1.0 && (dd != 0.0) && (dd <= radius) && centerVector.y <= 0.0) {
							  //if (_Back == 1.0 && (dd != 0.0) && (dd <= radius) && backdist3 < backdist2) {
							if (_Back == 1.0 && (dd != 0.0) && (dd <= radius) && initPos.y < 0) {
							 


								  //versuch.z += (1 - dd / radius) * (backdist / 3);

								  distor.xz += (((1 - dd / radius) * backNormal.xz) * (backdist / 2)) / _Displacement;

							  }


							  //if (_Front == 1.0 && (dd != 0.0) && (dd <= radius) && centerVector.y >= 0.0) {
							  //if (_Front == 1.0 && (dd != 0.0) && (dd <= radius) && frontdist3 < frontdist2) {
							  if (_Front == 1.0 && (dd != 0.0) && (dd <= radius) && initPos.y > 0) {
								  



								  //versuch.z -= (1 - dd / radius) * (frontdist / 3);

								  distor.xz += (((1 - dd / radius) * frontNormal.xz) * (frontdist / 2)) / _Displacement;
							  }

							  //if ((dd != 0.0) && (dd <= radius) && centerVector.x >= 0.0) {
							  //if (_Right == 1.0 && (dd != 0.0) && (dd <= radius) && rightdist3 < rightdist2) {
							  if (_Right == 1.0 && (dd != 0.0) && (dd <= radius) && initPos.x > 0) {
								  

								  //versuch.x -= (1 - dd / radius) * (rightdist/2);

								  distor.xz += (((1 - dd / radius) * rightNormal.xz) * (rightdist / 2)) / _Displacement;

							  }
							  //if (_Left == 1.0 && (dd != 0.0) && (dd <= radius) && centerVector.x <= 0.0) {
							  //if (_Left == 1.0 && (dd != 0.0) && (dd <= radius) && leftdist3 < leftdist2) {
							  if (_Left == 1.0 && (dd != 0.0) && (dd <= radius) && initPos.x < 0) {
								  

								  //versuch.x += (1 - dd / radius) * (leftdist / 2);

								  distor.xz += (((1 - dd / radius) * leftNormal.xz) * (leftdist / 2)) / _Displacement;

							  }
							  

								  v.vertex = mul(unity_WorldToObject, distor);



						}

								sampler2D _MainTex;
								sampler2D _NormalMap;
								fixed4 _Color;

								void surf(Input IN, inout SurfaceOutput o) {

									//
									float texColor = tex2D(_DitherPattern, IN.texcoord).r;
									//
									half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

									float3 Userpos = _WorldSpaceCameraPos;
									float3 pos = IN.worldPos;
									float dist = distance(pos, Userpos);
									//Calculation of view Direction
									float3 viewDir = mul((float3x3)unity_CameraToWorld, float3(0, 0, 1));
									o.Albedo = c.rgb;


									float3 objectCenterTest = unity_ObjectToWorld[3].xyz;
									float3 localPos = mul(unity_ObjectToWorld, IN.vertex.xyz) - objectCenterTest;

									


									

									float4x4 thresholdMatrix =
									{ 1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
									  13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
									   4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
									  16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
									};
									float4x4 _RowAccess = { 1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1 };
									//float2 poss = IN.worldPos.xz / IN.worldPos.z;
									float2 poss = IN.screenPos.xz / IN.screenPos.z;
									
									float2 test = IN.texcoord;
									//float test = IN.vertex.x;

									//
									float2 screenPos = IN.screenPosition.xy / IN.screenPosition.w;
									float2 ditherCoordinate = screenPos * _ScreenParams.xy * _DitherPattern_TexelSize.xy;
									float ditherValue = tex2D(_DitherPattern, ditherCoordinate).r;
									//	
									
									//clip(_Transparency - thresholdMatrix[fmod(poss.x, 4)] * _RowAccess[fmod(poss.y, 4)]);
									//clip(_Transparency - thresholdMatrix[fmod(poss.x, 4)] * _RowAccess[fmod(poss.y, 4)]);
									//clip((dist - _Versuch) * (-1));
									//float4 centerVectorTest = objectCenterTest - IN.vertex;

									o.Specular = 0.2;
									o.Gloss = 1.0;
									o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
									//
									float ditheredValue = step(ditherValue, texColor);
									float4 col = lerp(_Color1, _Color2, ditheredValue);
									o.Albedo = col;
									//
								}
								ENDCG
		}
			FallBack "Diffuse"
}