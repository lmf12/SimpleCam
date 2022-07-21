precision highp float;

uniform sampler2D inputImageTexture;
varying vec2 textureCoordinate;

uniform float time;

const float PI = 3.1415926;

void main (void) {
    float duration = 0.7;
    
    float currentTime = mod(time, duration);
    
    vec4 whiteMask = vec4(1.0, 1.0, 1.0, 1.0);
    float amplitude = abs(sin(currentTime * (PI / duration)));
    
    vec4 mask = texture2D(inputImageTexture, textureCoordinate);
    
    gl_FragColor = mask * (1.0 - amplitude) + whiteMask * amplitude;
}
