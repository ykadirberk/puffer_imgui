// DEFAULT WINDOW OPTIONS

package window

DEFAULT_MAJOR_OPENGL_VERSION :: 3
DEFAULT_MINOR_OPENGL_VERSION :: 3
DEFAULT_WINDOW_WIDTH         :: 640
DEFAULT_WINDOW_HEIGHT        :: 480
DEFAULT_WINDOW_NAME          :: "WINDOW"

WindowOptions :: struct {
    major_opengl_version    : int,
    minor_opengl_version    : int,
    window_width            : i32,
    window_height           : i32,
    window_name             : string
}

get_default_window_options :: proc() -> WindowOptions {
    return { 
        DEFAULT_MAJOR_OPENGL_VERSION, 
        DEFAULT_MINOR_OPENGL_VERSION, 
        DEFAULT_WINDOW_WIDTH, 
        DEFAULT_WINDOW_HEIGHT, 
        DEFAULT_WINDOW_NAME 
    }
}