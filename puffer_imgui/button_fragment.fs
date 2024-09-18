#version 330 core

out vec4 FragColor;
uniform vec4 backg_color;

void main() {
	FragColor = backg_color;
}