package window

import glfw     "vendor:glfw"
import gl       "vendor:OpenGL"
import strings  "core:strings"
import fmt      "core:fmt"

@(private)
glfw_window : glfw.WindowHandle

WindowInitError :: enum {
	NONE,
    COULD_NOT_CREATE_WINDOW,
}

// this function frees itself automatically
@(deferred_none=free)
init :: proc(window_options : WindowOptions) -> WindowInitError
{
    glfw.Init()

    glfw.WindowHint_int(glfw.CONTEXT_VERSION_MAJOR, auto_cast window_options.major_opengl_version)
    glfw.WindowHint_int(glfw.CONTEXT_VERSION_MINOR, auto_cast window_options.minor_opengl_version)
    glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

    if glfw_window != nil 
    {
        glfw.DestroyWindow(glfw_window)
        glfw_window = nil
    }

    glfw_window = glfw.CreateWindow(window_options.window_width, window_options.window_height, strings.clone_to_cstring(window_options.window_name), nil, nil)
    if glfw_window == nil {
        return WindowInitError.COULD_NOT_CREATE_WINDOW
    }

    glfw.MakeContextCurrent(glfw_window)
    glfw.SwapInterval(1)

    // Load OpenGL 3.3 function pointers.
    gl.load_up_to(window_options.major_opengl_version, window_options.minor_opengl_version, glfw.gl_set_proc_address)

    framebuffer_width, framebuffer_height := glfw.GetFramebufferSize(glfw_window)
    gl.Viewport(0, 0, framebuffer_width, framebuffer_height)

    // Key press / Window-resize behaviour
    glfw.SetKeyCallback(glfw_window, callback_key)
    glfw.SetWindowRefreshCallback(glfw_window, window_refresh)

    gl.PixelStorei(gl.UNPACK_ALIGNMENT, 1)

    gl.Enable(gl.BLEND)
    gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

    return WindowInitError.NONE
}


@(private)
free :: proc() 
{
    glfw.DestroyWindow(glfw_window)
    glfw.Terminate()
}

should_close :: proc() -> bool 
{
    return auto_cast glfw.WindowShouldClose(glfw_window)
}

poll_events :: proc() 
{
    glfw.PollEvents()
}

swap_buffers :: proc() 
{
    glfw.SwapBuffers(glfw_window)
}

get_mouse_position :: proc() -> (f32, f32) 
{
    posx, posy := glfw.GetCursorPos(glfw_window)
    return auto_cast posx, auto_cast posy
}

get_window_resolution :: proc() -> (f32, f32) 
{
    w,h := glfw.GetWindowSize(glfw_window)
    return auto_cast w, auto_cast h
}

get_mouse_buttons_state :: proc() -> (bool, bool)
{
    left_button, right_button : bool
    if glfw.PRESS == glfw.GetMouseButton(glfw_window, glfw.MOUSE_BUTTON_LEFT)
    {
        left_button = true
    }

    if glfw.PRESS == glfw.GetMouseButton(glfw_window, glfw.MOUSE_BUTTON_RIGHT)
    {
        right_button = true
    }

    return left_button, right_button
}
