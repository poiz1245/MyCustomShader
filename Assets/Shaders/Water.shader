Shader "Custom/Water"
{
    Properties
    {
        _Cube ("Cube Map", cube) = ""{}
        _BumpMap ("Normal Map", 2D) = "white" {}
        _BumpPower ("Bump Power", float) = 1
        _TimeCount1 ("TimeCount1", float) = 1
        _TimeCount2 ("TimeCount2", float) = 1
        _WaveHeight ("_WaveHeight", float) = 1
        _WaveTime ("_WaveTime", float) = 1

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        LOD 200


        CGPROGRAM
        #pragma surface surf Standard alpha:blend vertex:vert addshadow

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _BumpMap;
        samplerCUBE _Cube;

        float _BumpPower;
        float _TimeCount1, _TimeCount2;
        float _WaveHeight, _WaveTime;

        

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldRefl;
            float3 viewDir;

            INTERNAL_DATA
        };


        void vert(inout appdata_full v)
        {
            v.vertex.z += cos(abs(v.texcoord.x * 2 - 1) * _WaveHeight + _Time.y * _WaveTime);
            v.vertex.z += cos(abs(v.texcoord.y * 2 - 1) * _WaveHeight + _Time.y * _WaveTime);
        }


        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

            //Normal Wave
            float3 n1 = UnpackNormal(tex2D(_BumpMap,IN.uv_BumpMap + (_Time.y*_TimeCount1)));
            float3 n2 = UnpackNormal(tex2D(_BumpMap,IN.uv_BumpMap - (_Time.y*_TimeCount2)));
            o.Normal = (n1+n2) * 0.5;
            o.Normal *= float3(0.5, 0.5, 1);

            //Rim
            float rim = saturate(dot(o.Normal, IN.viewDir));
            float rim1 = pow(1-rim, 100);
            float rim2 = pow(1-rim, 2);

            float4 ref = texCUBE(_Cube, WorldReflectionVector(IN, o.Normal));

            o.Emission = ref + rim1;
            o.Alpha = rim2;
        }

        float4 Lightingwater(SurfaceOutput s, float3 lightDir, float3 viewDir, float atten)
        {
            //Specular
            float3 H = normalize(lightDir + viewDir);
            float spec = saturate(dot(s.Normal, H));
            spec = pow (spec, 1050)*10;

            float4 final;
            final.rgb = spec * _LightColor0;
            final.a = s.Alpha +spec;    
            return final;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
