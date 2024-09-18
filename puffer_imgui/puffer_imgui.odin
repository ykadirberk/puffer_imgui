package puffer_imgui

import gl   "vendor:OpenGL"
import fmt  "core:fmt"

@(deferred_none=free)
init :: proc ()
{
    program_ok      : bool
    vertex_shader   := string(#load("button_vertex.vs"  ))
    fragment_shader := string(#load("button_fragment.fs"))

    button_shader, program_ok = gl.load_shaders_source(vertex_shader, fragment_shader);

    if !program_ok {
        fmt.println("ERROR: Failed to load and compile shaders.")
    }

    gl.GenVertexArrays(1, &button_vao)
    gl.BindVertexArray(button_vao)

    gl.GenBuffers(1, &button_vbo)
    gl.BindBuffer(gl.ARRAY_BUFFER, button_vbo)
    
    gl.BufferData(gl.ARRAY_BUFFER,      
                  size_of(f32) * 2*6,  
                  nil,                 
                  gl.DYNAMIC_DRAW)     

    gl.VertexAttribPointer(0, 2, gl.FLOAT, gl.FALSE, 2 * size_of(f32), 0 * size_of(f32))
    gl.EnableVertexAttribArray(0)
}

@(private)
free :: proc() 
{

}


start_frame :: proc(frambuffer_width, framebuffer_height, mouse_pos_x, mouse_pos_y : int, left_button_down, right_button_down : bool) 
{
    current_buffer_width        = frambuffer_width
    current_buffer_height       = framebuffer_height

    current_mouse_pos_x         = mouse_pos_x
    current_mouse_pos_y         = mouse_pos_y

    previous_left_button_down   = current_left_button_down
    previous_right_button_down  = current_right_button_down

    current_left_button_down    = left_button_down
    current_right_button_down   = right_button_down
}

button_standalone :: proc(pos_x, pos_y, width, height : int) -> bool
{
    gl.BindVertexArray(button_vao)

    top_left_x, top_left_y          := xy_to_clipspace(auto_cast pos_x,             auto_cast pos_y,            auto_cast current_buffer_width, auto_cast current_buffer_height)
    top_right_x, top_right_y        := xy_to_clipspace(auto_cast (pos_x + width),   auto_cast pos_y,            auto_cast current_buffer_width, auto_cast current_buffer_height)
    bottom_left_x, bottom_left_y    := xy_to_clipspace(auto_cast pos_x,             auto_cast (pos_y + height), auto_cast current_buffer_width, auto_cast current_buffer_height)
    bottom_right_x, bottom_right_y  := xy_to_clipspace(auto_cast (pos_x + width),   auto_cast (pos_y + height), auto_cast current_buffer_width, auto_cast current_buffer_height)

    vertices : [2 * 6] f32 = {
        bottom_left_x,      bottom_left_y, 
        top_left_x,         top_left_y,
        top_right_x,        top_right_y,
        top_right_x,        top_right_y,
        bottom_right_x,     bottom_right_y,
        bottom_left_x,      bottom_left_y
    }

    gl.BufferSubData(gl.ARRAY_BUFFER,               
                     0,                             
                     size_of(vertices),   
                     &vertices)           

    gl.UseProgram(button_shader)

    hit_button : bool = false

    if true == is_within_bounds(auto_cast current_mouse_pos_x, 
                                auto_cast current_mouse_pos_y,
                                auto_cast pos_x,
                                auto_cast pos_y,
                                auto_cast width,
                                auto_cast height)
    {
        color_ptr := [4]f32{0.75, 0.15, 0.45, 1.0}
        update_color(button_shader, "backg_color", color_ptr)
        if false == current_left_button_down && true == previous_left_button_down 
        {
            hit_button = true
        }
    }
    else 
    {
        color_ptr := [4]f32{0.65, 0.05, 0.35, 1.0}
        update_color(button_shader, "backg_color", color_ptr)
    }

    gl.DrawArrays(gl.TRIANGLES, 0, 6)

    return hit_button
}

