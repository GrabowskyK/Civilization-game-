shader_type canvas_item;

varying flat vec2 vertexPos[2];
uniform vec2 globalMousePosition;

void vertex() {
	vertexPos[0] = (MODEL_MATRIX * vec4(VERTEX,0.0,1.0)).xy;
	// Place fragment code here.
}
void fragment() {
	float isWithinY = step(vertexPos[0].y, globalMousePosition.y) * step(globalMousePosition.y, vertexPos[0].y + 64.);
	float isWithinX = step(vertexPos[0].x, globalMousePosition.x) * step(globalMousePosition.x, vertexPos[0].x + 64.);
	float isWithin = isWithinY * isWithinX;
	vec4 textureColor = texture(TEXTURE, UV);
	COLOR = mix(textureColor, vec4(1.0,1.0,1.0,1.0), 0.5* isWithin); 
}