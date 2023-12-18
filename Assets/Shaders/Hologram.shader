Shader "Custom/Hologram"
{
    Properties
    {
       [HDR] _RimColor("RIm Color", color) = (1,1,1,1)
        _RimPower("Rim Power", float) = 1
        _BumpMap("NormalMap", 2D) = "bump"{}
        _LineTime("Line Time", float) = 1
        _LineCount("Line Count", float) = 1
        _LineThickness("Line Thickness",float) = 1
        _Blinking("Blinking", float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert alpha:blend noambient  
        #pragma target 3.0

        sampler2D _BumpMap;
        

        struct Input
        {
            float2 uv_BumpMap;
            float3 viewDir;
            float3 worldPos;
        };

        fixed4 _RimColor;

        float _RimPower;
        float _LineTime, _LineCount, _LineThickness;
        float _Blinking;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

            //Rim Light
            float rim = dot(normalize(o.Normal), normalize(IN.viewDir));
            rim = pow(1-rim, _RimPower);

            //Hologram
            float holo = pow(frac(IN.worldPos.y * _LineCount + _Time.y * _LineTime), _LineThickness);

            o.Emission = _RimColor.rgb;

            o.Alpha = (rim + holo) * abs(sin(_Time.y * _Blinking));
        }
        ENDCG   
    }
}
