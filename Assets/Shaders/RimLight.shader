Shader "Custom/RimLight"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
       [HDR] _RimColor("RIm Color", color) = (1,1,1,1)
        _RimPower("Rim Power", float) = 1
     
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert noambient
        #pragma target 3.0

        sampler2D _MainTex;
        

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        fixed4 _Color;  
        float _RimPower;
        fixed4 _RimColor;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Alpha = c.a;

            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = 1-rim;
            rim = pow(rim, _RimPower);

            o.Emission = rim * _RimColor.rgb;
        }

        ENDCG

      
    }
    FallBack "Diffuse"
}
