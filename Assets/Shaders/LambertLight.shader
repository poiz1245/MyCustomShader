Shader "Custom/Lambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
     
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert

        #pragma target 3.0

        sampler2D _MainTex;
        

        struct Input
        {
            float2 uv_MainTex;
        };


        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        float4 LightingGetOut(SurfaceOutput s, float3 LightDir, float atten)
        {
            float NdotL = dot(s.Normal, LightDir) * 0.5 + 0.5;
            NdotL = pow(NdotL,3);

            float4 finalColor;
            finalColor.rgb = s.Albedo * NdotL * _LightColor0.rgb * atten;
            finalColor.a = s.Alpha;


            return finalColor;
        }

        ENDCG

      
    }
    FallBack "Diffuse"
}
