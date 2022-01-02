Shader "RIOT/Fur/FurShaderEdit (Low)"
{
	Properties
	{
		[Header(Textures)]
		_MainTex ("Fur Texture (RGB)", 2D) = "white" {}

		_SkinTex ("Skin Texture (RGB)", 2D) = "white" {}

		_NoiseMap("Noise Map (Gray) ", 2D) = "white" {}
		_HeightMap("Height Map (Gray) ", 2D) = "white" {}
		_Blend("Texture Blend", Range(0,1)) = 0.0

		[Header(Fur Color Properties)]
		_FurColor("Fur Color", Color) = (1, 1, 1, 1)
		_Brightness("Fur Brightness", Range(0, 1)) = 0.25
		_HeightMapBrightness("Height Map Brightness", Range(0, 1)) = 0.25
		_FurTransparency("Fur Transparency", Range(0, 1.0)) = 1.0

		[Header(Skin Color Properties)]
		[Toggle]_EnableSkin("Enable Skin Layer", Float) = 0
		_SkinColor("Skin Color", Color) = (1, 1, 1, 1)
		_SkinBrightness("Skin Brightness", Range(0, 1)) = 0.25
		_SkinTransparency("Skin Transparency", Range(0, 1.0)) = 1.0

		[Header(Fur Properties)]
		_FurLength("Fur Length", Range(0, 1.0)) = 0.25
		_FurStiff("Fur Stiffness", Range(0, 1.0)) = 0.1
		_Gravity("Gravity Direction", Vector) = (0.0, 0.0, 0.0, 0.0)

		[Header(Depth Shadow Properties)]
		[Enum(None,0, Normal, 1, Invert, 2)] _Shadows("Depth Shadows", Float) = 0
		_ShadowStrength("Depth Shadow Strength", Range(0.0, 1.0)) = .5

		[Header(Randomized Wind Properties)]
		_WindSpeed("Wind Speed", Range(0, 1.0)) = 0.0
		_WindStrength("Wind Strength", Range(0, 1)) = 0.0

		[Header(Velocity Properties)]
		[Toggle] _CullVelocity("Cull Velocity Angle", Float) = 0
		_CullAngle("Cull Angle", Range(-1.0, 1.0)) = 0.0

		[HideInInspector] _Velocity("Velocity", Vector) = (0.0, 0.0, 0.0, 0.0)

			[Header(Rim Lightning)]
			[Toggle]_LightMode("Toggle", Float) = 0.0
			_Color1("Rim Color A", Color) = (1.0, 0.5, 0.5, 1.0)
			_Color2("Rim Color B", Color) = (0.5, 0.5, 1.0, 1.0)
			_Rim("Rim", Float) = 1.0
			_Shift("Shift", Float) = 1.0
			_angularPow("Normal Angle", Range(-2.0, 2.0)) = 0.0

	}

	Category {

		ZWrite on
		Cull Back
		Tags {"Queue" = "Transparent" "RenderType"="Transparent" "LightMode" = "ForwardBase" "DisableBatching" = "True"}
		Blend SrcAlpha OneMinusSrcAlpha


		SubShader {
			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.0
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.0526315789473684
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.1052631578947368
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.1578947368421053
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.2105263157894737
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.2631578947368421
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.3157894736842105
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.3684210526315789
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.4210526315789474
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.4736842105263158
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.5263157894736842
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.5789473684210526
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.6315789473684211
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.6842105263157895
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG
			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.7368421052631579
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG

			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.7894736842105263
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG

			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.8421052631578947
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG

			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.8947368421052632
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG

			}

			Pass
			{
			    CGPROGRAM

			    #define _FURLAYER 0.9473684210526316
			    #pragma vertex vert
			    #pragma fragment frag
			    #pragma multi_compile_fog
			    #include "FurHelper.cginc"

			    ENDCG

			}




		}
	}
}
