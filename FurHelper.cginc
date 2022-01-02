// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct appdata members custom_uv)
#pragma exclude_renderers d3d11
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#include "UnityCG.cginc"
#include "UnityLightingCommon.cginc"


struct appdata
{
	float4 vertex	: POSITION;
	float2 uv		: TEXCOORD0;
	float4 normal	: NORMAL;
	float4 color	: COLOR;
};

struct v2f
{
	float4 vertex        : SV_POSITION;
	float2 uv		     : TEXCOORD0;
	float2 uv2			 : TEXCOORD2;
	float2 uv3			 : TEXCOORD3;
	float4 normal        : TEXCOORD1;
	float4 color		 : COLOR;
	UNITY_FOG_COORDS(3)
};

struct f2g
{
	float4 color : SV_TARGET;
};


sampler2D _MainTex;
sampler2D _SkinTex;
sampler2D _NoiseMap;
sampler2D _HeightMap;

float4 _NoiseMap_ST;
float4 _HeightMap_ST;
float4 _MainTex_ST;
float4 _SkinTex_ST;

float4 _FurColor;
float4 _SkinColor;
float _FurTransparency;
float _SkinTransparency;
float _Brightness;
float _SkinBrightness;
float _HeightMapBrightness;

float4 _Gravity;
float4 _Velocity;

float _WindStrength;
float _WindSpeed;

float _FurLength;
float _FurStiff;
float _EnableSkin;

float _Shadows;
float _InvertShadows;
float _ShadowStrength;

float _CullVelocity;
float _CullAngle;

float4    _Color;
float4    _Color1;
float4    _Color2;
float     _Rim;
float     _Shift;

float _LightMode;
half _angularPow;
half _Blend;

v2f vert(appdata v)
{
	v2f o;
	//OUTPUT TEXTURE COORDINATES
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	o.uv2 = TRANSFORM_TEX(v.uv, _NoiseMap);
	o.uv3 = TRANSFORM_TEX(v.uv, _HeightMap);

	float furlength = _FURLAYER * _FurLength;
	//WIND
	float3 wind = float3(0, 0, 0);
	wind.x = _WindStrength * sin(_Time.y * (10 * _WindSpeed) * 0.25 + v.vertex.x);
	wind.y = _WindStrength * cos(_Time.y * (10 * _WindSpeed) * 0.25 + v.vertex.y);
	wind.z = _WindStrength * sin(_Time.y * (10 * _WindSpeed) * 0.45 + v.vertex.z);

	//GRAVITY - Add gravity to wind direction and subtract velocity
	_Gravity = mul(unity_WorldToObject, _Gravity);

	//float4 _Gravity = float4(0,0,0,0);
	//_Gravity = tex2Dlod(_MainTex, float4(v.uv.xy, 0, 0));

	float3 totaldisplacement = wind + _Gravity.xyz - _Velocity.xyz;

	//FURLENGTH, WEIGHT, AND SPACING BETWEEN LAYERS - Displacement
	float4 disNormal = v.normal;
	float displacementFactor = pow(furlength, (5 * (1 - _FurStiff)));
	disNormal.xyz += totaldisplacement * displacementFactor;
	float4 displacement = normalize(disNormal) * furlength * 0.25;

	//SET VERTEX POSITION BY ADDING DISPLACEMENT POSITION
	//OUTPUT VERTEX VIEWPORT POSITION
	float4 wpos = float4(v.vertex.xyz + displacement.xyz, 1.0);
	o.vertex = UnityObjectToClipPos(wpos);



//	o.normal = lerp(mul(UNITY_MATRIX_IT_MV, v.normal), mul(unity_WorldToObject, v.normal), _angularPow);
//	o.normal = lerp(mul(UNITY_MATRIX_IT_MV, v.normal), 100, _angularPow);

	if (_LightMode < 1.0)
	{
		o.normal = mul(unity_ObjectToWorld, v.normal);
	}
	else
	{
		o.normal = lerp(mul(UNITY_MATRIX_IT_MV, v.normal), 100, _angularPow);
	}

	//LIGHTING - Provided by Unity's shader tutorials (http://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html)
	float3 worldNormal = mul(v.normal, unity_WorldToObject); //This Caused errors for PS4 : UnityObjectToWorldNormal(v.normal); 
//	float dotNormal = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
	float dotNormal = 1;
	o.color = dotNormal * _LightColor0;
	//o.color.rgb += ShadeSH9(half4(worldNormal, 1));
	o.color.rgb += 1;

	//o.normal = mul((float3x3)UNITY_MATRIX_IT_MV, i.normal);
	//o.color = i.color * _Color;



	//FOG
	UNITY_TRANSFER_FOG(o, o.vertex);

	return o;
}

float4 frag(v2f i) : SV_Target
{
	//Rim Color
	float rim = _Shift - pow(saturate(1.0f - normalize(i.normal).z), _Rim);



	//VELOCITY CULLING
	if (_CullVelocity)
	{
		float4 normal = mul(unity_WorldToObject, i.normal);
		if (dot(normalize(normal), normalize(-_Velocity)) > _CullAngle) discard;
	}

	//SKIN LAYER
	if (_FURLAYER == 0.0 && _EnableSkin)
	{
		//Skin Color
		float4 skinColor = tex2D(_SkinTex, i.uv) ;
		float4 colorChange = i.color * _SkinColor;


		skinColor *= colorChange;

		//Skin Brightness
		if (_LightMode < 1.0)
		{
			skinColor.rgb *= (5 * _SkinBrightness);
		}
		else
		{
			skinColor.rgb *= tex2D(_SkinTex, i.uv) * lerp(_Color1, _Color2, rim) * (5 * _Brightness);
		}




		//Skin Transparency
		skinColor.a = 1.0;
		skinColor.a *= max(_SkinTransparency, _SkinTransparency * _FURLAYER);

		//Skin Fog
		UNITY_APPLY_FOG(i.fogCoord, skinColor);
		return skinColor;

	}
	//FUR LAYER
	else
	{
		//Fur Color
		float4 furColor = tex2D(_MainTex, i.uv);
		float4 colorChange = i.color * _FurColor;
		furColor *= colorChange;

		//Depth Shadows - This darkens lower layers of the fur shader to give apperance of shadows underneath
		//Normal shadows
		if (_Shadows == 1)
		{
			float shadow = pow(_FURLAYER, (2 * _ShadowStrength));
			furColor.rgb = furColor.rgb * shadow;
		}
		//Invert shadows
		else if (_Shadows == 2)
		{
			float shadow = pow(_FURLAYER, 2 - (2 * _ShadowStrength));
			furColor.rgb = furColor.rgb * (1 - shadow);
		}

		//Height map
		//float2 height = tex2D(_HeightMap, i.uv2) * tex2D(_HeightMap2, i.uv);
		float2 height = tex2D(_NoiseMap, i.uv2) - tex2D(_HeightMap, i.uv3)*_Blend;
		float hmBright = (2 * _HeightMapBrightness);
		height.xy *= hmBright;

		//Discard pixels if heightmap is black 
		if (height.x <= 0.0 || height.y < _FURLAYER) discard;

		//Fur transparency, lower layers are more visable
		furColor.a = 1.0 - _FURLAYER;

		//Fur brightness

		if (_LightMode < 1.0)
		{
			furColor.rgb *= (5 * _Brightness);
		}
		else
		{
			furColor.rgb *= tex2D(_MainTex, i.uv) * lerp(_Color1, _Color2, rim) * (5 * _Brightness);
		}


		//User set fur transparency
		furColor.a *= max(_FurTransparency, _FurTransparency * _FURLAYER);

		//Fur Fog
		UNITY_APPLY_FOG(i.fogCoord, furColor);

		return furColor;
	}
}
