precision highp float;

uniform sampler2D inputImageTexture;
uniform sampler2D hairMask;
varying vec2 textureCoordinate;

void main (void) {
    vec4 color = texture2D(hairMask, textureCoordinate);
    gl_FragColor = vec4(color.g, color.g, color.g, 1.0);
}
