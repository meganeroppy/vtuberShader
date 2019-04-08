Shader "RM/Clay" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
        _AOTexture ("AO Texture (A)", 2D) = "white" {}
        _Specul("Specular Texture (A)", 2D) = "white" {}
        
		_Glossiness ("Smoothness", Range(0,0.5)) = 0.5

		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
        _RimPower ("Rim Power", Range(-0.5,1)) = 0.0
		
	}
	SubShader {
		Tags { "RenderType"="Opaque" }

		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _AOTexture;
        sampler2D _Specul;
		float4 _RimColor;
      	float _RimPower;
      	

		struct Input {
			float2 uv_MainTex;
			float2 uv_AOTexture;
			float2 uv_BumpMap;
            float2 uv_Specul;
			float3 viewDir;
			
            
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 s = tex2D (_Specul, IN.uv_Specul) * _Color;
			fixed4 ao = tex2D (_AOTexture, IN.uv_AOTexture);
			
			o.Albedo = c.rgb;
			o.Albedo *= ao.a;
			
			o.Normal = UnpackNormal (tex2D (_BumpMap,  IN.uv_BumpMap));
		
			
           	 half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));

		
			o.Smoothness = _Glossiness*s.a;
			
			
			
			o.Alpha = c.a;
			
            
            o.Albedo +=  _RimColor.rgb*o.Smoothness* pow (rim, _RimPower)*ao.a;
            o.Albedo +=  _RimColor.rgb* pow (rim, _RimPower)*ao.a;

		}
		ENDCG
	} 
	FallBack "Diffuse"
}
