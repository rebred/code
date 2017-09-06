Red/System [
	Title:   "Red/System OpenGL info"
	Purpose: "Prints some informations about supported OpenGL"
	Author:  "Oldes"
	File: 	 %gl-info.reds
	Rights:  "Copyright (C) 2017 David 'Oldes' Oliva. All rights reserved."
	License: "BSD-3 - https://github.com/red/red/blob/master/BSD-3-License.txt"
]

#include %common.reds

;some functions used in this example are defined as ARB extensions
#include %../extensions/gl-ARB.reds ;(Extensions officially approved by the OpenGL Architecture Review Board)
;to use these functions, you must manually load them.. see bellow in code.

GL-init

major: 0
minor: 0
rev:   0
glfwGetVersion :major :minor :rev

print-line ["GLFW version: " major #"." minor #"." rev " reported: " glfwGetVersionString]

glfwWindowHint GLFW_SAMPLES 4 ;4x antialiasing
glfwWindowHint GLFW_CONTEXT_VERSION_MAJOR 3 ;We want OpenGL 3.3
glfwWindowHint GLFW_CONTEXT_VERSION_MINOR 3 ;
glfwWindowHint GLFW_OPENGL_FORWARD_COMPAT GL_TRUE ;To make MacOS happy; should not be needed
glfwWindowHint GLFW_OPENGL_PROFILE GLFW_OPENGL_CORE_PROFILE ;We don't want the old OpenGL 

GL-window "GL info" 800 600

glfwMakeContextCurrent window

;@@ must manually load used GL extension functions here as Red compiler is not able to do it automatically yet!
glGetStringi:               as glGetStringi!               glfwGetProcAddress "glGetStringi"
glGetIntegeri_v:            as glGetIntegeri_v!            glfwGetProcAddress "glGetIntegeri_v"

print-line ["GL version: " as c-string! glGetString GL_VERSION]

max-texture-size: 0
max-texture-units: 0
glGetIntegerv GL_MAX_TEXTURE_SIZE :max-texture-size
glGetIntegerv GL_MAX_TEXTURE_UNITS :max-texture-units

print-line ["Maximum texture size: " max-texture-size " units: " max-texture-units]

n: 0

glGetIntegerv GL_MAX_VERTEX_ATTRIBS :n
print-line ["Maximum number of vertex attributes: " n]

glGetIntegerv GL_MAX_VERTEX_UNIFORM_COMPONENTS :n
print-line ["Maximum number of uniform vertex vectors: " n]

glGetIntegerv GL_MAX_FRAGMENT_UNIFORM_COMPONENTS :n
print-line ["Maximum number of uniform fragment vectors: " n]

glGetIntegerv GL_MAX_VARYING_FLOATS :n
print-line ["Maximum number of varying vectors: " n]

glGetIntegerv GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS :n
print-line ["Maximum number of texture units usable in a vertex shader: " n]

glGetIntegerv GL_MAX_TEXTURE_IMAGE_UNITS :n
print-line ["Maximum number of texture units usable in a fragment shader: " n]


num-extensions: 0
glGetIntegerv GL_NUM_EXTENSIONS :num-extensions
print-line ["Supported extensions: " num-extensions]
i: 0 
iSize: 0
while [i < num-extensions][
	i: i + 1
	print-line [#" " i ":^-" as c-string! glGetStringi GL_EXTENSIONS i - 1]
]

monitor-info: func[
	monitor [GLFWmonitor!]
	/local currentMode mode x y n modes i p gamma
][
	print-line [" Name: " glfwGetMonitorName monitor]
	x: 0 y: 0
	glfwGetMonitorPos monitor :x :y
	print-line [" glfwGetMonitorPos: " x #"x" y]
	glfwGetMonitorPhysicalSize monitor :x :y
	print-line [" glfwGetMonitorPhysicalSize: " x #"x" y]
	
	n: 0
	modes: glfwGetVideoModes monitor :n
	currentMode: glfwGetVideoMode monitor
	print-line ["Supported video modes: " n]
	p: as byte-ptr! modes
	i: 0
	while [i < n][
		mode: as GLFWvidmode! p
		i: i + 1
		
		print [
			#" " i ":^-" mode/width #"x" mode/height ", " mode/refreshRate " Hz, "
			mode/redBits #"." mode/greenBits #"." mode/blueBits " RGBbits"
		]
		either all [
			mode/width       = currentMode/width
			mode/height      = currentMode/height
			mode/redBits     = currentMode/redBits
			mode/greenBits   = currentMode/greenBits
			mode/blueBits    = currentMode/blueBits
			mode/refreshRate = currentMode/refreshRate
		][ print " current^/" ][ print lf ]
		p: p + size? GLFWvidmode!
	]
]

monitors: glfwGetMonitors :n
print-line ["Number of monitors: " n]

i: 0
while [i < n][
	i: i + 1
	print-line ["Monitor " i #":" ]
	monitor-info as GLFWmonitor! monitors/i
]

;no main loop in this example

GL-close