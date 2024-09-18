//+private

package puffer_imgui

import gl   "vendor:OpenGL"


xy_to_clipspace :: proc(source_position : Point, reference_size : Size) -> Point 
{
    return {-1 + (source_position.x / (reference_size.x / 2.0)), 1 - (source_position.y / (reference_size.y / 2.0))}
}

is_within_bounds :: proc(point : Point, bounds_rect : Rect) -> bool
{
    result := false
    if point.x >= bounds_rect.x && point.x <= bounds_rect.x + bounds_rect.z
    {
        if point.y >= bounds_rect.y && point.y <= bounds_rect.y + bounds_rect.w
        {
            result = true
        }
    } 

    return result
}

update_color :: proc(program : u32, var_name : cstring, color_ptr : [4]f32) 
{
    gl.Uniform4f(gl.GetUniformLocation(program, var_name), color_ptr.r, color_ptr.g, color_ptr.b, color_ptr.a)
}