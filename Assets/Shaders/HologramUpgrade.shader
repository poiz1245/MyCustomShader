Shader "Custom/HologramUpgrade"
{
    Properties
    {
       [HDR] _RimColor("RIm Color", color) = (1,1,1,1) //Bloom이 이쁘게 먹음
        _RimPower("Rim Power", float) = 1
        _BumpMap("NormalMap", 2D) = "bump"{}
        _LineTime("Line Time", float) = 1
        _LineCount("Line Count", float) = 1
        _LineThickness("Line Thickness",float) = 1

        _LineTex("Albedo (RGB)", 2D) = "White"{}
        _LineTIme2("Sub Line Time", float) = 1

        _Blinking("Blinking", float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert alpha:blend noambient  
        #pragma target 3.0

        sampler2D _LineTex;
        sampler2D _BumpMap;
        sampler2D _AlphaTex;
        

        struct Input
        {
            float2 uv_LineTex;
            float2 uv_AlphaTex;
            float2 uv_BumpMap;

            float3 viewDir;
            float3 worldPos;
            float3 secWorldPos;

        };

        fixed4 _RimColor;

        float _RimPower, _RimBold;
        float _LineTime, _LineCount, _LineThickness;
        float _LineTime2, _Blinking;

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

            //Gradiation
            float3 secWorldPos = pow( (IN.worldPos.y * 0.5 + 0.5) , 4 );
            
            //Rim Light
            float rim = dot(normalize(o.Normal), normalize(IN.viewDir));
            rim = pow(1-rim, _RimPower);

            //Hologram
            float holo = pow(frac(IN.worldPos.y * _LineCount + _Time.y * _LineTime), _LineThickness);
            float holo2 = tex2D(_LineTex, (IN.uv_LineTex + _Time.y * _LineTime2));

            o.Emission = _RimColor.rgb;

            o.Alpha = (rim + holo + holo2) * abs(sin(_Time.y * _Blinking)) * secWorldPos;  //림과 홀로그램 먼저 같이 적용된 후에 깜빡여야 하므로 림과 홀로를 먼저 더함
        }
        ENDCG   
    }
}
