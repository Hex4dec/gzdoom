
#include "layout_frag_scene.glsl"
#include "material.glsl"

void main()
{
#ifdef NO_CLIPDISTANCE_SUPPORT
	if (ClipDistanceA.x < 0 || ClipDistanceA.y < 0 || ClipDistanceA.z < 0 || ClipDistanceA.w < 0 || ClipDistanceB.x < 0) discard;
#endif

	Material material = CreateMaterial();
	vec4 frag = material.Base;

#ifndef NO_ALPHATEST
	if (frag.a <= uAlphaThreshold) discard;
#endif

	float gray = grayscale(frag);
	vec4 cm = (uObjectColor + gray * (uAddColor - uObjectColor)) * 2;
	frag = vec4(clamp(cm.rgb, 0.0, 1.0), frag.a);

	frag = frag * ProcessLight(material, vColor);
	frag.rgb = frag.rgb + uFogColor.rgb;

	FragColor = frag;
#ifdef GBUFFER_PASS
	FragFog = vec4(AmbientOcclusionColor(), 1.0);
	FragNormal = vec4(vEyeNormal.xyz * 0.5 + 0.5, 1.0);
#endif
}
