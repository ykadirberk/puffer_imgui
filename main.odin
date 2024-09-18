package main

import window   "window"
import fmt      "core:fmt"
import gl       "vendor:OpenGL"
import imgui    "puffer_imgui"

main :: proc () 
{
    options := window.get_default_window_options()
    options.window_name = "DEMO"
    window.init(options)

    imgui.init()

    counter := 0

    for false == window.should_close() 
    {
        window.poll_events()
        
        window_w,           window_h            := window.get_window_resolution()
        button_left,        button_right        := window.get_mouse_buttons_state()
        cursor_position_x,  cursor_position_y   := window.get_mouse_position()

        gl.ClearColor(0.1, 0.2, 0.3, 1)
        gl.Clear(gl.COLOR_BUFFER_BIT)
        
        imgui.start_frame(auto_cast window_w,
                          auto_cast window_h,
                          auto_cast cursor_position_x,
                          auto_cast cursor_position_y,
                          button_left,
                          button_right
        )
        
        is_hit := imgui.button_standalone(100,50,200,50)

        if true == is_hit
        {
            counter += 1
            fmt.println("I HIT!", counter)
        }

        window.swap_buffers()
    }

    fmt.println("EXITING...")
}