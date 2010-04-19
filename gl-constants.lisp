;; -*- mode: Lisp; Syntax: Common-Lisp; Package: kt-opengl; -*-
;;;
;;; Copyright (c) 1995,2003 by Kenneth William Tilton.
;;;
;;; Permission is hereby granted, free of charge, to any person obtaining a copy 
;;; of this software and associated documentation files (the "Software"), to deal 
;;; in the Software without restriction, including without limitation the rights 
;;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
;;; copies of the Software, and to permit persons to whom the Software is furnished 
;;; to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be included in 
;;; all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
;;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
;;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
;;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
;;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
;;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
;;; IN THE SOFTWARE.

(in-package #:kt-opengl)

#| blendingfactordest |#
(dfc gl_zero                           0)
(dfc gl_one                            1)
(dfc gl_src_color                      #x0300)
(dfc gl_one_minus_src_color            #x0301)
(dfc gl_src_alpha                      #x0302)
(dfc gl_one_minus_src_alpha            #x0303)
(dfc gl_dst_alpha                      #x0304)
(dfc gl_one_minus_dst_alpha            #x0305)
(dfc gl_dst_color		       #x0306)
(dfc gl_one_minus_dst_color            #x0307)
(dfc gl_src_alpha_saturate             #x0308)

#| pixelcopytype |#
(dfc gl_color                          #x1800)
(dfc gl_depth                          #x1801)
(dfc gl_stencil                        #x1802)

#| pixelformat |#
(dfc gl_color_index                    #x1900)
(dfc gl_stencil_index                  #x1901)
(dfc gl_depth_component                #x1902)
(dfc gl_red                            #x1903)
(dfc gl_green                          #x1904)
(dfc gl_blue                           #x1905)
(dfc gl_alpha                          #x1906)
(dfc gl_rgb                            #x1907)
(dfc gl_rgba                           #x1908)
(dfc gl_luminance                      #x1909)
(dfc gl_luminance_alpha                #x190a)

#| polygons |#
(dfc gl_point                                #x1b00)
(dfc gl_line                                 #x1b01)
(dfc gl_fill                                 #x1b02)
(dfc gl_cw                                   #x0900)
(dfc gl_ccw                                  #x0901)
(dfc gl_front                                #x0404)
(dfc gl_back                                 #x0405)
(dfc gl_polygon_offset_factor                #x8038)
(dfc gl_polygon_offset_units                 #x2a00)
(dfc gl_polygon_offset_point                 #x2a01)
(dfc gl_polygon_offset_line                  #x2a02)
(dfc gl_polygon_offset_fill                  #x8037)

#| lighting |#

(dfc gl_light0                               #x4000)
(dfc gl_light1                               #x4001)
(dfc gl_light2                               #x4002)
(dfc gl_light3                               #x4003)
(dfc gl_light4                               #x4004)
(dfc gl_light5                               #x4005)
(dfc gl_light6                               #x4006)
(dfc gl_light7                               #x4007)
(dfc gl_spot_exponent                        #x1205)
(dfc gl_spot_cutoff                          #x1206)
(dfc gl_constant_attenuation                 #x1207)
(dfc gl_linear_attenuation                   #x1208)
(dfc gl_quadratic_attenuation                #x1209)
(dfc gl_ambient                              #x1200)
(dfc gl_diffuse                              #x1201)
(dfc gl_specular                             #x1202)
(dfc gl_shininess                            #x1601)
(dfc gl_emission                             #x1600)
(dfc gl_position                             #x1203)
(dfc gl_spot_direction                       #x1204)
(dfc gl_ambient_and_diffuse                  #x1602)
(dfc gl_color_indexes                        #x1603)
(dfc gl_front_and_back                       #x0408)
(dfc gl_flat                                 #x1d00)
(dfc gl_smooth                               #x1d01)

#| user clipping planes |#
(dfc gl_clip_plane0                          #x3000)
(dfc gl_clip_plane1                          #x3001)
(dfc gl_clip_plane2                          #x3002)
(dfc gl_clip_plane3                          #x3003)
(dfc gl_clip_plane4                          #x3004)
(dfc gl_clip_plane5                          #x3005)

#| boolean values |#
(dfc gl_false                                #x0)
(dfc gl_true                                 #x1)

#| data types |#
(dfc gl_byte                                 #x1400)
(dfc gl_unsigned_byte                        #x1401)
(dfc gl_short                                #x1402)
(dfc gl_unsigned_short                       #x1403)
(dfc gl_int                                  #x1404)
(dfc gl_unsigned_int                         #x1405)
(dfc gl_float                                #x1406)
(dfc gl_double                               #x140a)
(dfc gl_2_bytes                              #x1407)
(dfc gl_3_bytes                              #x1408)
(dfc gl_4_bytes                              #x1409)

#| primitives |#
(dfc gl_points                               #x0000)
(dfc gl_lines                                #x0001)
(dfc gl_line_loop                            #x0002)
(dfc gl_line_strip                           #x0003)
(dfc gl_triangles                            #x0004)
(dfc gl_triangle_strip                       #x0005)
(dfc gl_triangle_fan                         #x0006)
(dfc gl_quads                                #x0007)
(dfc gl_quad_strip                           #x0008)
(dfc gl_polygon                              #x0009)

#| vertex arrays |#
(dfc gl_vertex_array                         #x8074)
(dfc gl_normal_array                         #x8075)
(dfc gl_color_array                          #x8076)
(dfc gl_index_array                          #x8077)
(dfc gl_texture_coord_array                  #x8078)
(dfc gl_edge_flag_array                      #x8079)
(dfc gl_vertex_array_size                    #x807a)
(dfc gl_vertex_array_type                    #x807b)
(dfc gl_vertex_array_stride                  #x807c)
(dfc gl_normal_array_type                    #x807e)
(dfc gl_normal_array_stride                  #x807f)
(dfc gl_color_array_size                     #x8081)
(dfc gl_color_array_type                     #x8082)
(dfc gl_color_array_stride                   #x8083)
(dfc gl_index_array_type                     #x8085)
(dfc gl_index_array_stride                   #x8086)
(dfc gl_texture_coord_array_size             #x8088)
(dfc gl_texture_coord_array_type             #x8089)
(dfc gl_texture_coord_array_stride           #x808a)
(dfc gl_edge_flag_array_stride               #x808c)
(dfc gl_vertex_array_pointer                 #x808e)
(dfc gl_normal_array_pointer                 #x808f)
(dfc gl_color_array_pointer                  #x8090)
(dfc gl_index_array_pointer                  #x8091)
(dfc gl_texture_coord_array_pointer          #x8092)
(dfc gl_edge_flag_array_pointer              #x8093)
(dfc gl_v2f                                  #x2a20)
(dfc gl_v3f                                  #x2a21)
(dfc gl_c4ub_v2f                             #x2a22)
(dfc gl_c4ub_v3f                             #x2a23)
(dfc gl_c3f_v3f                              #x2a24)
(dfc gl_n3f_v3f                              #x2a25)
(dfc gl_c4f_n3f_v3f                          #x2a26)
(dfc gl_t2f_v3f                              #x2a27)
(dfc gl_t4f_v4f                              #x2a28)
(dfc gl_t2f_c4ub_v3f                         #x2a29)
(dfc gl_t2f_c3f_v3f                          #x2a2a)
(dfc gl_t2f_n3f_v3f                          #x2a2b)
(dfc gl_t2f_c4f_n3f_v3f                      #x2a2c)
(dfc gl_t4f_c4f_n3f_v4f                      #x2a2d)

(defun matrix-mode-symbol (n)
  (ecase n
    (#x1700 'gl_modelview)
    (#x1701 'gl_projection)
    (#x1702 'gl_texture)))

#+test
(assert (eq 'gl_modelview (matrix-mode-symbol #x1700)))

#| matrix mode |#
(dfc gl_modelview                     #x1700)
(dfc gl_projection                     #x1701)
(dfc gl_texture                              #x1702)

#| display lists |#
(dfc gl_compile                              #x1300)
(dfc gl_compile_and_execute                  #x1301)

#| depth buffer |#
(dfc gl_never                                #x0200)
(dfc gl_less                                 #x0201)
(dfc gl_equal                                #x0202)
(dfc gl_lequal                               #x0203)
(dfc gl_greater                              #x0204)
(dfc gl_notequal                             #x0205)
(dfc gl_gequal                               #x0206)
(dfc gl_always                               #x0207)


#| texture mapping |#
(dfc gl_texture_env                          #x2300)
(dfc gl_texture_env_mode                     #x2200)
(dfc gl_texture_wrap_s                       #x2802)
(dfc gl_texture_wrap_t                       #x2803)
(dfc gl_texture_mag_filter                   #x2800)
(dfc gl_texture_min_filter                   #x2801)
(dfc gl_texture_env_color                    #x2201)
(dfc gl_texture_gen_mode                     #x2500)
(dfc gl_texture_border_color                 #x1004)
(dfc gl_texture_width                        #x1000)
(dfc gl_texture_height                       #x1001)
(dfc gl_texture_border                       #x1005)
(dfc gl_texture_components                   #x1003)
(dfc gl_texture_red_size                     #x805c)
(dfc gl_texture_green_size                   #x805d)
(dfc gl_texture_blue_size                    #x805e)
(dfc gl_texture_alpha_size                   #x805f)
(dfc gl_texture_luminance_size               #x8060)
(dfc gl_texture_intensity_size               #x8061)
(dfc gl_nearest_mipmap_nearest               #x2700)
(dfc gl_nearest_mipmap_linear                #x2702)
(dfc gl_linear_mipmap_nearest                #x2701)
(dfc gl_linear_mipmap_linear                 #x2703)
(dfc gl_object_linear                        #x2401)
(dfc gl_object_plane                         #x2501)
(dfc gl_eye_linear                           #x2400)
(dfc gl_eye_plane                            #x2502)
(dfc gl_sphere_map                           #x2402)
(dfc gl_decal                                #x2101)
(dfc gl_modulate                             #x2100)
(dfc gl_nearest                              #x2600)
(dfc gl_linear                               #x2601)

(dfc gl_repeat                               #x2901)
(dfc gl_clamp                                #x2900)
(dfc gl_s                                    #x2000)
(dfc gl_t                                    #x2001)
(dfc gl_r                                    #x2002)
(dfc gl_q                                    #x2003)

#| utility |#
(dfc gl_vendor                               #x1f00)
(dfc gl_renderer                             #x1f01)
(dfc gl_version                              #x1f02)
(dfc gl_extensions                           #x1f03)

#| errors |#
(dfc gl_no_error                             #x0)
(dfc gl_invalid_value                        #x0501)
(dfc gl_invalid_enum                         #x0500)
(dfc gl_invalid_operation                    #x0502)
(dfc gl_stack_overflow                       #x0503)
(dfc gl_stack_underflow                      #x0504)
(dfc gl_out_of_memory                        #x0505)


#| glpush/popattrib bits |#
(dfc gl_current_bit                          #x00000001)
(dfc gl_point_bit                            #x00000002)
(dfc gl_line_bit                             #x00000004)
(dfc gl_polygon_bit                          #x00000008)
(dfc gl_polygon_stipple_bit                  #x00000010)
(dfc gl_pixel_mode_bit                       #x00000020)
(dfc gl_lighting_bit                         #x00000040)
(dfc gl_fog_bit                              #x00000080)
(dfc gl_depth_buffer_bit                     #x00000100)
(dfc gl_accum_buffer_bit                     #x00000200)
(dfc gl_stencil_buffer_bit                   #x00000400)
(dfc gl_viewport_bit                         #x00000800)
(dfc gl_transform_bit                        #x00001000)
(dfc gl_enable_bit                           #x00002000)
(dfc gl_color_buffer_bit                     #x00004000)
(dfc gl_hint_bit                             #x00008000)
(dfc gl_eval_bit                             #x00010000)
(dfc gl_list_bit                             #x00020000)
(dfc gl_texture_bit                          #x00040000)
(dfc gl_scissor_bit                          #x00080000)
(dfc gl_all_attrib_bits                      #x000fffff)


#| gets |#
(dfc gl_current_color                  #x0b00)
(dfc gl_current_index                  #x0b01)
(dfc gl_current_normal                 #x0b02)
(dfc gl_current_texture_coords         #x0b03)
(dfc gl_current_raster_color           #x0b04)
(dfc gl_current_raster_index           #x0b05)
(dfc gl_current_raster_texture_coords  #x0b06)
(dfc gl_current_raster_position        #x0b07)
(dfc gl_current_raster_position_valid  #x0b08)
(dfc gl_current_raster_distance        #x0b09)
(dfc gl_point_smooth                   #x0b10)
(dfc gl_point_size                     #x0b11)
(dfc gl_point_size_range               #x0b12)
(dfc gl_point_size_granularity         #x0b13)
(dfc gl_line_smooth                    #x0b20)
(dfc gl_line_width                     #x0b21)
(dfc gl_line_width_range               #x0b22)
(dfc gl_line_width_granularity         #x0b23)
(dfc gl_line_stipple                   #x0b24)
(dfc gl_line_stipple_pattern           #x0b25)
(dfc gl_line_stipple_repeat            #x0b26)
(dfc gl_list_mode                      #x0b30)
(dfc gl_max_list_nesting               #x0b31)
(dfc gl_list_base                      #x0b32)
(dfc gl_list_index                     #x0b33)
(dfc gl_polygon_mode                   #x0b40)
(dfc gl_polygon_smooth                 #x0b41)
(dfc gl_polygon_stipple                #x0b42)
(dfc gl_edge_flag                      #x0b43)
(dfc gl_cull_face                      #x0b44)
(dfc gl_cull_face_mode                 #x0b45)
(dfc gl_front_face                     #x0b46)
(dfc gl_lighting                       #x0b50)
(dfc gl_light_model_local_viewer       #x0b51)
(dfc gl_light_model_two_side           #x0b52)
(dfc gl_light_model_ambient            #x0b53)
(dfc gl_shade_model                    #x0b54)
(dfc gl_color_material_face            #x0b55)
(dfc gl_color_material_parameter       #x0b56)
(dfc gl_color_material                 #x0b57)
(dfc gl_fog                            #x0b60)
(dfc gl_fog_index                      #x0b61)
(dfc gl_fog_density                    #x0b62)
(dfc gl_fog_start                      #x0b63)
(dfc gl_fog_end                        #x0b64)
(dfc gl_fog_mode                       #x0b65)
(dfc gl_fog_color                      #x0b66)
(dfc gl_depth_range                    #x0b70)
(dfc gl_depth_test                     #x0b71)
(dfc gl_depth_writemask                #x0b72)
(dfc gl_depth_clear_value              #x0b73)
(dfc gl_depth_func                     #x0b74)
(dfc gl_accum_clear_value              #x0b80)
(dfc gl_stencil_test                   #x0b90)
(dfc gl_stencil_clear_value            #x0b91)
(dfc gl_stencil_func                   #x0b92)
(dfc gl_stencil_value_mask             #x0b93)
(dfc gl_stencil_fail                   #x0b94)
(dfc gl_stencil_pass_depth_fail        #x0b95)
(dfc gl_stencil_pass_depth_pass        #x0b96)
(dfc gl_stencil_ref                    #x0b97)
(dfc gl_stencil_writemask              #x0b98)
(dfc gl_matrix_mode                    #x0ba0)
(dfc gl_normalize                      #x0ba1)
(dfc gl_viewport                       #x0ba2)
(dfc gl_modelview_stack_depth          #x0ba3)
(dfc gl_projection_stack_depth         #x0ba4)
(dfc gl_texture_stack_depth            #x0ba5)
(dfc gl_modelview_matrix               #x0ba6)
(dfc gl_projection_matrix              #x0ba7)
(dfc gl_texture_matrix                 #x0ba8)
(dfc gl_attrib_stack_depth             #x0bb0)
(dfc gl_client_attrib_stack_depth      #x0bb1)
(dfc gl_alpha_test                     #x0bc0)
(dfc gl_alpha_test_func                #x0bc1)
(dfc gl_alpha_test_ref                 #x0bc2)
(dfc gl_dither                         #x0bd0)
(dfc gl_blend_dst                      #x0be0)
(dfc gl_blend_src                      #x0be1)
(dfc gl_blend                          #x0be2)
(dfc gl_logic_op_mode                  #x0bf0)
(dfc gl_index_logic_op                 #x0bf1)
(dfc gl_color_logic_op                 #x0bf2)
(dfc gl_aux_buffers                    #x0c00)
(dfc gl_draw_buffer                    #x0c01)
(dfc gl_read_buffer                    #x0c02)
(dfc gl_scissor_box                    #x0c10)
(dfc gl_scissor_test                   #x0c11)
(dfc gl_index_clear_value              #x0c20)
(dfc gl_index_writemask                #x0c21)
(dfc gl_color_clear_value              #x0c22)
(dfc gl_color_writemask                #x0c23)
(dfc gl_index_mode                     #x0c30)
(dfc gl_rgba_mode                      #x0c31)
(dfc gl_doublebuffer                   #x0c32)
(dfc gl_stereo                         #x0c33)
(dfc gl_render_mode                    #x0c40)
(dfc gl_perspective_correction_hint    #x0c50)
(dfc gl_point_smooth_hint              #x0c51)
(dfc gl_line_smooth_hint               #x0c52)
(dfc gl_polygon_smooth_hint            #x0c53)
(dfc gl_fog_hint                       #x0c54)
(dfc gl_texture_gen_s                  #x0c60)
(dfc gl_texture_gen_t                  #x0c61)
(dfc gl_texture_gen_r                  #x0c62)
(dfc gl_texture_gen_q                  #x0c63)
(dfc gl_pixel_map_i_to_i               #x0c70)
(dfc gl_pixel_map_s_to_s               #x0c71)
(dfc gl_pixel_map_i_to_r               #x0c72)
(dfc gl_pixel_map_i_to_g               #x0c73)
(dfc gl_pixel_map_i_to_b               #x0c74)
(dfc gl_pixel_map_i_to_a               #x0c75)
(dfc gl_pixel_map_r_to_r               #x0c76)
(dfc gl_pixel_map_g_to_g               #x0c77)
(dfc gl_pixel_map_b_to_b               #x0c78)
(dfc gl_pixel_map_a_to_a               #x0c79)
(dfc gl_pixel_map_i_to_i_size          #x0cb0)
(dfc gl_pixel_map_s_to_s_size          #x0cb1)
(dfc gl_pixel_map_i_to_r_size          #x0cb2)
(dfc gl_pixel_map_i_to_g_size          #x0cb3)
(dfc gl_pixel_map_i_to_b_size          #x0cb4)
(dfc gl_pixel_map_i_to_a_size          #x0cb5)
(dfc gl_pixel_map_r_to_r_size          #x0cb6)
(dfc gl_pixel_map_g_to_g_size          #x0cb7)
(dfc gl_pixel_map_b_to_b_size          #x0cb8)
(dfc gl_pixel_map_a_to_a_size          #x0cb9)
(dfc gl_unpack_swap_bytes              #x0cf0)
(dfc gl_unpack_lsb_first               #x0cf1)
(dfc gl_unpack_row_length              #x0cf2)
(dfc gl_unpack_skip_rows               #x0cf3)
(dfc gl_unpack_skip_pixels             #x0cf4)
(dfc gl_unpack_alignment               #x0cf5)
(dfc gl_pack_swap_bytes                #x0d00)
(dfc gl_pack_lsb_first                 #x0d01)
(dfc gl_pack_row_length                #x0d02)
(dfc gl_pack_skip_rows                 #x0d03)
(dfc gl_pack_skip_pixels               #x0d04)
(dfc gl_pack_alignment                 #x0d05)
(dfc gl_map_color                      #x0d10)
(dfc gl_map_stencil                    #x0d11)
(dfc gl_index_shift                    #x0d12)
(dfc gl_index_offset                   #x0d13)
(dfc gl_red_scale                      #x0d14)
(dfc gl_red_bias                       #x0d15)
(dfc gl_zoom_x                         #x0d16)
(dfc gl_zoom_y                         #x0d17)
(dfc gl_green_scale                    #x0d18)
(dfc gl_green_bias                     #x0d19)
(dfc gl_blue_scale                     #x0d1a)
(dfc gl_blue_bias                      #x0d1b)
(dfc gl_alpha_scale                    #x0d1c)
(dfc gl_alpha_bias                     #x0d1d)
(dfc gl_depth_scale                    #x0d1e)
(dfc gl_depth_bias                     #x0d1f)
(dfc gl_max_eval_order                 #x0d30)
(dfc gl_max_lights                     #x0d31)
(dfc gl_max_clip_planes                #x0d32)
(dfc gl_max_texture_size               #x0d33)
(dfc gl_max_pixel_map_table            #x0d34)
(dfc gl_max_attrib_stack_depth         #x0d35)
(dfc gl_max_model-view_stack_depth      #x0d36)
(dfc gl_max_name_stack_depth           #x0d37)
(dfc gl_max_projection_stack_depth     #x0d38)
(dfc gl_max_texture_stack_depth        #x0d39)
(dfc gl_max_viewport_dims              #x0d3a)
(dfc gl_max_client_attrib_stack_depth  #x0d3b)
(dfc gl_subpixel_bits                  #x0d50)
(dfc gl_index_bits                     #x0d51)
(dfc gl_red_bits                       #x0d52)
(dfc gl_green_bits                     #x0d53)
(dfc gl_blue_bits                      #x0d54)
(dfc gl_alpha_bits                     #x0d55)
(dfc gl_depth_bits                     #x0d56)
(dfc gl_stencil_bits                   #x0d57)
(dfc gl_accum_red_bits                 #x0d58)
(dfc gl_accum_green_bits               #x0d59)
(dfc gl_accum_blue_bits                #x0d5a)
(dfc gl_accum_alpha_bits               #x0d5b)
(dfc gl_name_stack_depth               #x0d70)
(dfc gl_auto_normal                    #x0d80)
(dfc gl_map1_color_4                   #x0d90)
(dfc gl_map1_index                     #x0d91)
(dfc gl_map1_normal                    #x0d92)
(dfc gl_map1_texture_coord_1           #x0d93)
(dfc gl_map1_texture_coord_2           #x0d94)
(dfc gl_map1_texture_coord_3           #x0d95)
(dfc gl_map1_texture_coord_4           #x0d96)
(dfc gl_map1_vertex_3                  #x0d97)
(dfc gl_map1_vertex_4                  #x0d98)
(dfc gl_map2_color_4                   #x0db0)
(dfc gl_map2_index                     #x0db1)
(dfc gl_map2_normal                    #x0db2)
(dfc gl_map2_texture_coord_1           #x0db3)
(dfc gl_map2_texture_coord_2           #x0db4)
(dfc gl_map2_texture_coord_3           #x0db5)
(dfc gl_map2_texture_coord_4           #x0db6)
(dfc gl_map2_vertex_3                  #x0db7)
(dfc gl_map2_vertex_4                  #x0db8)
(dfc gl_map1_grid_domain               #x0dd0)
(dfc gl_map1_grid_segments             #x0dd1)
(dfc gl_map2_grid_domain               #x0dd2)
(dfc gl_map2_grid_segments             #x0dd3)
(dfc gl_texture_1d                     #x0de0)
(dfc gl_texture_2d                     #x0de1)
(dfc gl_feedback_buffer_pointer        #x0df0)
(dfc gl_feedback_buffer_size           #x0df1)
(dfc gl_feedback_buffer_type           #x0df2)
(dfc gl_selection_buffer_pointer       #x0df3)
(dfc gl_selection_buffer_size          #x0df4)

(dfc gl_client_pixel_store_bit         #x00000001)
(dfc gl_client_vertex_array_bit	       #x00000002)
(dfc gl_client_all_attrib_bits         #xffffffff)

#| render mode |#
(dfc gl_feedback                             #x1c01)
(dfc gl_render                               #x1c00)
(dfc gl_select                               #x1c02)


#| hints |#
(dfc gl_dont_care                            #x1100)
(dfc gl_fastest                              #x1101)
(dfc gl_nicest                               #x1102)
