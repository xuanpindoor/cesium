/**
 * Clip a fragment by an array of clipping planes.
 *
 * @name czm_discardIfClipped
 * @glslFunction
 *
 * @param {vec4[]} clippingPlanes The array of planes used to clip, defined in eyespace.
 * @param {int} clippingPlanesLength The number of planes in the array of clipping planes.
 * @param {bool} inclusive
 * @returns {float} The distance away from a clipped fragment, in eyespace
 */
float czm_discardIfClipped (vec4[czm_maxClippingPlanes] clippingPlanes, int clippingPlanesLength, bool inclusive)
{
    if (clippingPlanesLength > 0)
    {
        bool clipped = inclusive;
        vec4 position = czm_windowToEyeCoordinates(gl_FragCoord);
        vec3 clipNormal = vec3(0.0);
        vec3 clipPosition = vec3(0.0);
        float clipAmount = 0.0;

        for (int i = 0; i < czm_maxClippingPlanes; ++i)
        {
            if (i == clippingPlanesLength)
            {
                break;
            }

            clipNormal = clippingPlanes[i].xyz;
            clipPosition = -clippingPlanes[i].w * clipNormal;

            float amount = dot(clipNormal, (position.xyz - clipPosition));
            if (amount > clipAmount) {
                clipAmount = amount;
            }

            if (inclusive) {
                clipped = clipped && (amount <= 0.0);
            } else {
                clipped = clipped || (amount <= 0.0);
            }
        }

        if (clipped)
        {
            discard;
        }

        return clipAmount;
    }

    return 0.0;
}
