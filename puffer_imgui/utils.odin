//+private

package puffer_imgui

import gl   "vendor:OpenGL"


xy_to_clipspace :: proc(pos_x, pos_y, width, height : f32) -> (f32, f32) 
{
    return (-1 + (pos_x / (width / 2.0))), (1 - (pos_y / (height / 2.0)))
}

is_within_bounds :: proc(point_pos_x, point_pos_y, rect_pos_x, rect_pos_y, rect_width, rect_height : f32) -> bool
{
    result := false
    if point_pos_x >= rect_pos_x && point_pos_x <= rect_pos_x + rect_width 
    {
        if point_pos_y >= rect_pos_y && point_pos_y <= rect_pos_y + rect_height
        {
            result = true
        }
    } 

    return result
}

update_color :: proc(program : u32, var_name : cstring, color_ptr : [4]f32) {
    gl.Uniform4f(gl.GetUniformLocation(program, var_name), color_ptr.r, color_ptr.g, color_ptr.b, color_ptr.a)
}