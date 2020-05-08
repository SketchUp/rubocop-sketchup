# frozen_string_literal: true

# How to update this file:
#
# FEATURES constant:
#
# 1. Run the `rubocop-changelog` YARD template on the API stubs repository:
#    (https://github.com/SketchUp/rubocop-sketchup/issues/4#issuecomment-370753043)
#
#    yardoc -c -t rubocop-changelog -f text > rubocop-changelog.txt
#
# 2. Prune out any unreleased versions.
#
#
# INSTANCE_METHODS constant:
#
# Manually curated list of method names which are believed to yield few false
# positives. The method names should be names that are not commonly used in
# general context.
#
# Since it's difficult to know what a variable in Ruby code represent by static
# analysis, these methods are assumed to belong to the FEATURES list.
#
# When a new version is released and FEATURES is updated the new methods from
# the new version should be considered for this list.
#
# TODO(thomthom): Investigate if Solargraph's static analysis can be used to
#   provide a more accurate analysis. Not sure how well it works on code bases
#   that isn't well documented with YARD type tags.
#
#
# OBSERVER_METHODS constant:
#
# Currently manually curated.
#
# TODO(thomthom): Tag observer methods in YARD for automatic extraction.

module RuboCop
  module SketchUp
    module Features

      FEATURES = [

        {
          version: 'LayOut 2020.1',
          types: {
            method: [
              'Layout::Document#export',
              'Layout::Grid#clip_to_margins=',
              'Layout::Grid#clip_to_margins?',
              'Layout::Grid#in_front=',
              'Layout::Grid#in_front?',
              'Layout::Grid#major_color=',
              'Layout::Grid#major_spacing=',
              'Layout::Grid#minor_color=',
              'Layout::Grid#minor_divisions=',
              'Layout::Grid#print=',
              'Layout::Grid#show=',
              'Layout::Grid#show_major=',
              'Layout::Grid#show_minor=',
              'Layout::SketchUpModel#camera_modified?',
              'Layout::SketchUpModel#effects_modified?',
              'Layout::SketchUpModel#layers_modified?',
              'Layout::SketchUpModel#reset_camera',
              'Layout::SketchUpModel#reset_effects',
              'Layout::SketchUpModel#reset_layers',
              'Layout::SketchUpModel#reset_style',
              'Layout::SketchUpModel#style_modified?',
            ],
          },
        },

        {
          version: 'SketchUp 2020.1',
          types: {
            method: [
              'Sketchup::Entities#weld',
              'Sketchup::Page#use_hidden_geometry=',
              'Sketchup::Page#use_hidden_geometry?',
              'Sketchup::Page#use_hidden_objects=',
              'Sketchup::Page#use_hidden_objects?',
            ],
          },
        },

        {
          version: 'SketchUp 2020.0',
          types: {
            method: [
              'Geom.tesselate',
              'Sketchup::Layer#display_name',
              'Sketchup::Model#active_path=',
              'Sketchup::Model#drawing_element_visible?',
              'Sketchup::Page#get_drawingelement_visibility',
              'Sketchup::Page#set_drawingelement_visibility',
              'Sketchup::View#text_bounds',
            ],
          },
        },

        {
          version: 'SketchUp 2019.2',
          types: {
            method: [
              'Sketchup.format_volume',
              'Sketchup::Material#owner_type',
              'Sketchup::Selection#invert',
              'Sketchup::Tool#onMouseWheel',
            ],
          },
        },

        {
          version: 'LayOut 2019',
          types: {
            method: [
              'Geom::Point2d#transform',
              'Geom::Point2d#transform!',
              'Geom::Transformation2d#*',
              'Geom::Transformation2d#inverse',
              'Geom::Transformation2d#invert!',
              'Geom::Transformation2d.rotation',
              'Geom::Transformation2d.scaling',
              'Geom::Transformation2d.translation',
              'Geom::Vector2d#transform',
              'Geom::Vector2d#transform!',
              'Layout::Path#winding',
              'Layout::SketchUpModel#dash_scale',
            ],
          },
        },

        {
          version: 'SketchUp 2019',
          types: {
            class: [
              'Sketchup::LineStyle',
              'Sketchup::LineStyles',
            ],
            method: [
              'Sketchup::DimensionLinear#end_attached_to',
              'Sketchup::DimensionLinear#end_attached_to=',
              'Sketchup::DimensionLinear#start_attached_to',
              'Sketchup::DimensionLinear#start_attached_to=',
              'Sketchup::Layer#line_style',
              'Sketchup::Layer#line_style=',
              'Sketchup::LineStyle#name',
              'Sketchup::LineStyles#[]',
              'Sketchup::LineStyles#at',
              'Sketchup::LineStyles#each',
              'Sketchup::LineStyles#length',
              'Sketchup::LineStyles#names',
              'Sketchup::LineStyles#size',
              'Sketchup::LineStyles#to_a',
              'Sketchup::Model#line_styles',
              'Sketchup::Text#attached_to',
              'Sketchup::Text#attached_to=',
              'Sketchup::Tools#active_tool',
            ],
          },
        },

        {
          version: 'LayOut 2018',
          types: {
            class: [
              'Geom::Bounds2d',
              'Geom::OrientedBounds2d',
              'Geom::Point2d',
              'Geom::Transformation2d',
              'Geom::Vector2d',
              'Layout::AngularDimension',
              'Layout::AutoTextDefinition',
              'Layout::AutoTextDefinitions',
              'Layout::ConnectionPoint',
              'Layout::Document',
              'Layout::Ellipse',
              'Layout::Entities',
              'Layout::Entity',
              'Layout::FormattedText',
              'Layout::Grid',
              'Layout::Group',
              'Layout::Image',
              'Layout::Label',
              'Layout::Layer',
              'Layout::LayerInstance',
              'Layout::Layers',
              'Layout::LinearDimension',
              'Layout::LockedEntityError',
              'Layout::LockedLayerError',
              'Layout::Page',
              'Layout::PageInfo',
              'Layout::Pages',
              'Layout::Path',
              'Layout::Rectangle',
              'Layout::SketchUpModel',
              'Layout::Style',
              'Layout::Table',
              'Layout::TableCell',
              'Layout::TableColumn',
              'Layout::TableRow',
            ],
            method: [
              'Geom::Bounds2d#==',
              'Geom::Bounds2d#height',
              'Geom::Bounds2d#initialize',
              'Geom::Bounds2d#lower_right',
              'Geom::Bounds2d#set!',
              'Geom::Bounds2d#to_a',
              'Geom::Bounds2d#upper_left',
              'Geom::Bounds2d#width',
              'Geom::OrientedBounds2d#==',
              'Geom::OrientedBounds2d#lower_left',
              'Geom::OrientedBounds2d#lower_right',
              'Geom::OrientedBounds2d#to_a',
              'Geom::OrientedBounds2d#upper_left',
              'Geom::OrientedBounds2d#upper_right',
              'Geom::Point2d#+',
              'Geom::Point2d#-',
              'Geom::Point2d#==',
              'Geom::Point2d#[]',
              'Geom::Point2d#[]=',
              'Geom::Point2d#clone',
              'Geom::Point2d#distance',
              'Geom::Point2d#initialize',
              'Geom::Point2d#inspect',
              'Geom::Point2d#offset',
              'Geom::Point2d#offset!',
              'Geom::Point2d#set!',
              'Geom::Point2d#to_a',
              'Geom::Point2d#to_s',
              'Geom::Point2d#vector_to',
              'Geom::Point2d#x',
              'Geom::Point2d#x=',
              'Geom::Point2d#y',
              'Geom::Point2d#y=',
              'Geom::Transformation2d#==',
              'Geom::Transformation2d#clone',
              'Geom::Transformation2d#identity?',
              'Geom::Transformation2d#initialize',
              'Geom::Transformation2d#set!',
              'Geom::Transformation2d#to_a',
              'Geom::Vector2d#%',
              'Geom::Vector2d#*',
              'Geom::Vector2d#+',
              'Geom::Vector2d#-',
              'Geom::Vector2d#==',
              'Geom::Vector2d#[]',
              'Geom::Vector2d#[]=',
              'Geom::Vector2d#angle_between',
              'Geom::Vector2d#clone',
              'Geom::Vector2d#cross',
              'Geom::Vector2d#dot',
              'Geom::Vector2d#initialize',
              'Geom::Vector2d#inspect',
              'Geom::Vector2d#length',
              'Geom::Vector2d#length=',
              'Geom::Vector2d#normalize',
              'Geom::Vector2d#normalize!',
              'Geom::Vector2d#parallel?',
              'Geom::Vector2d#perpendicular?',
              'Geom::Vector2d#reverse',
              'Geom::Vector2d#reverse!',
              'Geom::Vector2d#same_direction?',
              'Geom::Vector2d#set!',
              'Geom::Vector2d#to_a',
              'Geom::Vector2d#to_s',
              'Geom::Vector2d#unit_vector?',
              'Geom::Vector2d#valid?',
              'Geom::Vector2d#x',
              'Geom::Vector2d#x=',
              'Geom::Vector2d#y',
              'Geom::Vector2d#y=',
              'Layout::AngularDimension#angle',
              'Layout::AngularDimension#arc_center_point',
              'Layout::AngularDimension#custom_text=',
              'Layout::AngularDimension#custom_text?',
              'Layout::AngularDimension#end_connection_point',
              'Layout::AngularDimension#end_connection_point=',
              'Layout::AngularDimension#end_extent_point',
              'Layout::AngularDimension#end_extent_point=',
              'Layout::AngularDimension#end_offset_length=',
              'Layout::AngularDimension#end_offset_point',
              'Layout::AngularDimension#entities',
              'Layout::AngularDimension#initialize',
              'Layout::AngularDimension#leader_line_type',
              'Layout::AngularDimension#leader_line_type=',
              'Layout::AngularDimension#radius',
              'Layout::AngularDimension#radius=',
              'Layout::AngularDimension#start_connection_point',
              'Layout::AngularDimension#start_connection_point=',
              'Layout::AngularDimension#start_extent_point',
              'Layout::AngularDimension#start_extent_point=',
              'Layout::AngularDimension#start_offset_length=',
              'Layout::AngularDimension#start_offset_point',
              'Layout::AngularDimension#text',
              'Layout::AngularDimension#text=',
              'Layout::AutoTextDefinition#==',
              'Layout::AutoTextDefinition#custom_text',
              'Layout::AutoTextDefinition#custom_text=',
              'Layout::AutoTextDefinition#date_format',
              'Layout::AutoTextDefinition#date_format=',
              'Layout::AutoTextDefinition#display_file_extension=',
              'Layout::AutoTextDefinition#display_file_extension?',
              'Layout::AutoTextDefinition#display_full_path=',
              'Layout::AutoTextDefinition#display_full_path?',
              'Layout::AutoTextDefinition#mandatory?',
              'Layout::AutoTextDefinition#name',
              'Layout::AutoTextDefinition#name=',
              'Layout::AutoTextDefinition#page_number_style',
              'Layout::AutoTextDefinition#page_number_style=',
              'Layout::AutoTextDefinition#start_index',
              'Layout::AutoTextDefinition#start_index=',
              'Layout::AutoTextDefinition#tag',
              'Layout::AutoTextDefinition#type',
              'Layout::AutoTextDefinitions#[]',
              'Layout::AutoTextDefinitions#add',
              'Layout::AutoTextDefinitions#each',
              'Layout::AutoTextDefinitions#index',
              'Layout::AutoTextDefinitions#length',
              'Layout::AutoTextDefinitions#remove',
              'Layout::AutoTextDefinitions#size',
              'Layout::ConnectionPoint#initialize',
              'Layout::Document#==',
              'Layout::Document#add_entity',
              'Layout::Document#auto_text_definitions',
              'Layout::Document#grid',
              'Layout::Document#grid_snap_enabled=',
              'Layout::Document#grid_snap_enabled?',
              'Layout::Document#initialize',
              'Layout::Document#layers',
              'Layout::Document#object_snap_enabled=',
              'Layout::Document#object_snap_enabled?',
              'Layout::Document#page_info',
              'Layout::Document#pages',
              'Layout::Document#path',
              'Layout::Document#precision',
              'Layout::Document#precision=',
              'Layout::Document#remove_entity',
              'Layout::Document#save',
              'Layout::Document#shared_entities',
              'Layout::Document#time_created',
              'Layout::Document#time_modified',
              'Layout::Document#time_published',
              'Layout::Document#units',
              'Layout::Document#units=',
              'Layout::Document.open',
              'Layout::Ellipse#initialize',
              'Layout::Entities#[]',
              'Layout::Entities#each',
              'Layout::Entities#length',
              'Layout::Entities#reverse_each',
              'Layout::Entities#size',
              'Layout::Entity#==',
              'Layout::Entity#bounds',
              'Layout::Entity#document',
              'Layout::Entity#drawing_bounds',
              'Layout::Entity#group',
              'Layout::Entity#layer_instance',
              'Layout::Entity#locked=',
              'Layout::Entity#locked?',
              'Layout::Entity#move_to_group',
              'Layout::Entity#move_to_layer',
              'Layout::Entity#on_shared_layer?',
              'Layout::Entity#page',
              'Layout::Entity#style',
              'Layout::Entity#style=',
              'Layout::Entity#transform!',
              'Layout::Entity#transformation',
              'Layout::Entity#untransformed_bounds',
              'Layout::Entity#untransformed_bounds=',
              'Layout::FormattedText#append_plain_text',
              'Layout::FormattedText#apply_style',
              'Layout::FormattedText#display_text',
              'Layout::FormattedText#grow_mode',
              'Layout::FormattedText#grow_mode=',
              'Layout::FormattedText#initialize',
              'Layout::FormattedText#plain_text',
              'Layout::FormattedText#plain_text=',
              'Layout::FormattedText#rtf',
              'Layout::FormattedText#rtf=',
              'Layout::FormattedText#style',
              'Layout::FormattedText.new_from_file',
              'Layout::Grid#major_color',
              'Layout::Grid#major_spacing',
              'Layout::Grid#minor_color',
              'Layout::Grid#minor_divisions',
              'Layout::Grid#print?',
              'Layout::Grid#show?',
              'Layout::Grid#show_major?',
              'Layout::Grid#show_minor?',
              'Layout::Group#entities',
              'Layout::Group#initialize',
              'Layout::Group#remove_scale_factor',
              'Layout::Group#scale_factor',
              'Layout::Group#scale_precision',
              'Layout::Group#scale_precision=',
              'Layout::Group#scale_units',
              'Layout::Group#scale_units=',
              'Layout::Group#set_scale_factor',
              'Layout::Group#ungroup',
              'Layout::Image#clip_mask',
              'Layout::Image#clip_mask=',
              'Layout::Image#initialize',
              'Layout::Label#connect',
              'Layout::Label#connection_type',
              'Layout::Label#connection_type=',
              'Layout::Label#disconnect',
              'Layout::Label#entities',
              'Layout::Label#initialize',
              'Layout::Label#leader_line',
              'Layout::Label#leader_line=',
              'Layout::Label#leader_line_type',
              'Layout::Label#leader_line_type=',
              'Layout::Label#text',
              'Layout::Label#text=',
              'Layout::Layer#==',
              'Layout::Layer#document',
              'Layout::Layer#layer_instance',
              'Layout::Layer#locked=',
              'Layout::Layer#locked?',
              'Layout::Layer#name',
              'Layout::Layer#name=',
              'Layout::Layer#set_nonshared',
              'Layout::Layer#set_shared',
              'Layout::Layer#shared?',
              'Layout::LayerInstance#==',
              'Layout::LayerInstance#definition',
              'Layout::LayerInstance#entities',
              'Layout::LayerInstance#entity_index',
              'Layout::LayerInstance#reorder_entity',
              'Layout::Layers#[]',
              'Layout::Layers#active',
              'Layout::Layers#active=',
              'Layout::Layers#add',
              'Layout::Layers#each',
              'Layout::Layers#index',
              'Layout::Layers#length',
              'Layout::Layers#remove',
              'Layout::Layers#reorder',
              'Layout::Layers#size',
              'Layout::LinearDimension#auto_scale=',
              'Layout::LinearDimension#auto_scale?',
              'Layout::LinearDimension#connect',
              'Layout::LinearDimension#custom_text=',
              'Layout::LinearDimension#custom_text?',
              'Layout::LinearDimension#disconnect',
              'Layout::LinearDimension#end_connection_point',
              'Layout::LinearDimension#end_connection_point=',
              'Layout::LinearDimension#end_extent_point',
              'Layout::LinearDimension#end_extent_point=',
              'Layout::LinearDimension#end_offset_length=',
              'Layout::LinearDimension#end_offset_point',
              'Layout::LinearDimension#entities',
              'Layout::LinearDimension#initialize',
              'Layout::LinearDimension#leader_line_type',
              'Layout::LinearDimension#leader_line_type=',
              'Layout::LinearDimension#scale',
              'Layout::LinearDimension#scale=',
              'Layout::LinearDimension#start_connection_point',
              'Layout::LinearDimension#start_connection_point=',
              'Layout::LinearDimension#start_extent_point',
              'Layout::LinearDimension#start_extent_point=',
              'Layout::LinearDimension#start_offset_length=',
              'Layout::LinearDimension#start_offset_point',
              'Layout::LinearDimension#text',
              'Layout::LinearDimension#text=',
              'Layout::Page#==',
              'Layout::Page#document',
              'Layout::Page#entities',
              'Layout::Page#in_presentation=',
              'Layout::Page#in_presentation?',
              'Layout::Page#layer_instances',
              'Layout::Page#layer_visible?',
              'Layout::Page#name',
              'Layout::Page#name=',
              'Layout::Page#nonshared_entities',
              'Layout::Page#set_layer_visibility',
              'Layout::PageInfo#bottom_margin',
              'Layout::PageInfo#bottom_margin=',
              'Layout::PageInfo#color',
              'Layout::PageInfo#color=',
              'Layout::PageInfo#display_resolution',
              'Layout::PageInfo#display_resolution=',
              'Layout::PageInfo#height',
              'Layout::PageInfo#height=',
              'Layout::PageInfo#left_margin',
              'Layout::PageInfo#left_margin=',
              'Layout::PageInfo#margin_color',
              'Layout::PageInfo#margin_color=',
              'Layout::PageInfo#output_resolution',
              'Layout::PageInfo#output_resolution=',
              'Layout::PageInfo#print_margins=',
              'Layout::PageInfo#print_margins?',
              'Layout::PageInfo#print_paper_color=',
              'Layout::PageInfo#print_paper_color?',
              'Layout::PageInfo#right_margin',
              'Layout::PageInfo#right_margin=',
              'Layout::PageInfo#show_margins=',
              'Layout::PageInfo#show_margins?',
              'Layout::PageInfo#top_margin',
              'Layout::PageInfo#top_margin=',
              'Layout::PageInfo#width',
              'Layout::PageInfo#width=',
              'Layout::Pages#[]',
              'Layout::Pages#add',
              'Layout::Pages#each',
              'Layout::Pages#index',
              'Layout::Pages#initial',
              'Layout::Pages#initial=',
              'Layout::Pages#length',
              'Layout::Pages#remove',
              'Layout::Pages#reorder',
              'Layout::Pages#size',
              'Layout::Path#append_point',
              'Layout::Path#arc',
              'Layout::Path#circle',
              'Layout::Path#close',
              'Layout::Path#closed?',
              'Layout::Path#end_arrow',
              'Layout::Path#end_point',
              'Layout::Path#initialize',
              'Layout::Path#parametric_length',
              'Layout::Path#point_at',
              'Layout::Path#point_types',
              'Layout::Path#points',
              'Layout::Path#start_arrow',
              'Layout::Path#start_point',
              'Layout::Path#tangent_at',
              'Layout::Path.new_arc',
              'Layout::Rectangle#initialize',
              'Layout::Rectangle#radius',
              'Layout::Rectangle#radius=',
              'Layout::Rectangle#type',
              'Layout::Rectangle#type=',
              'Layout::SketchUpModel#clip_mask',
              'Layout::SketchUpModel#clip_mask=',
              'Layout::SketchUpModel#current_scene',
              'Layout::SketchUpModel#current_scene=',
              'Layout::SketchUpModel#current_scene_modified?',
              'Layout::SketchUpModel#dash_scale=',
              'Layout::SketchUpModel#display_background=',
              'Layout::SketchUpModel#display_background?',
              'Layout::SketchUpModel#entities',
              'Layout::SketchUpModel#initialize',
              'Layout::SketchUpModel#line_weight',
              'Layout::SketchUpModel#line_weight=',
              'Layout::SketchUpModel#model_to_paper_point',
              'Layout::SketchUpModel#perspective=',
              'Layout::SketchUpModel#perspective?',
              'Layout::SketchUpModel#preserve_scale_on_resize=',
              'Layout::SketchUpModel#preserve_scale_on_resize?',
              'Layout::SketchUpModel#render',
              'Layout::SketchUpModel#render_mode',
              'Layout::SketchUpModel#render_mode=',
              'Layout::SketchUpModel#render_needed?',
              'Layout::SketchUpModel#scale',
              'Layout::SketchUpModel#scale=',
              'Layout::SketchUpModel#scenes',
              'Layout::SketchUpModel#view',
              'Layout::SketchUpModel#view=',
              'Layout::Style#dimension_rotation_alignment',
              'Layout::Style#dimension_rotation_alignment=',
              'Layout::Style#dimension_units',
              'Layout::Style#dimension_vertical_alignment',
              'Layout::Style#dimension_vertical_alignment=',
              'Layout::Style#end_arrow_size',
              'Layout::Style#end_arrow_size=',
              'Layout::Style#end_arrow_type',
              'Layout::Style#end_arrow_type=',
              'Layout::Style#fill_color',
              'Layout::Style#fill_color=',
              'Layout::Style#font_family',
              'Layout::Style#font_family=',
              'Layout::Style#font_size',
              'Layout::Style#font_size=',
              'Layout::Style#get_sub_style',
              'Layout::Style#initialize',
              'Layout::Style#pattern_fill_origin',
              'Layout::Style#pattern_fill_origin=',
              'Layout::Style#pattern_fill_path',
              'Layout::Style#pattern_fill_path=',
              'Layout::Style#pattern_fill_rotation',
              'Layout::Style#pattern_fill_rotation=',
              'Layout::Style#pattern_fill_scale',
              'Layout::Style#pattern_fill_scale=',
              'Layout::Style#pattern_filled',
              'Layout::Style#pattern_filled=',
              'Layout::Style#set_dimension_units',
              'Layout::Style#set_sub_style',
              'Layout::Style#solid_filled',
              'Layout::Style#solid_filled=',
              'Layout::Style#start_arrow_size',
              'Layout::Style#start_arrow_size=',
              'Layout::Style#start_arrow_type',
              'Layout::Style#start_arrow_type=',
              'Layout::Style#stroke_cap_style',
              'Layout::Style#stroke_cap_style=',
              'Layout::Style#stroke_color',
              'Layout::Style#stroke_color=',
              'Layout::Style#stroke_join_style',
              'Layout::Style#stroke_join_style=',
              'Layout::Style#stroke_pattern',
              'Layout::Style#stroke_pattern=',
              'Layout::Style#stroke_pattern_scale',
              'Layout::Style#stroke_pattern_scale=',
              'Layout::Style#stroke_width',
              'Layout::Style#stroke_width=',
              'Layout::Style#stroked',
              'Layout::Style#stroked=',
              'Layout::Style#suppress_dimension_units',
              'Layout::Style#suppress_dimension_units=',
              'Layout::Style#text_alignment',
              'Layout::Style#text_alignment=',
              'Layout::Style#text_anchor',
              'Layout::Style#text_anchor=',
              'Layout::Style#text_bold',
              'Layout::Style#text_bold=',
              'Layout::Style#text_color',
              'Layout::Style#text_color=',
              'Layout::Style#text_elevation',
              'Layout::Style#text_elevation=',
              'Layout::Style#text_italic',
              'Layout::Style#text_italic=',
              'Layout::Style#text_underline',
              'Layout::Style#text_underline=',
              'Layout::Style.arrow_type_filled?',
              'Layout::Table#[]',
              'Layout::Table#dimensions',
              'Layout::Table#each',
              'Layout::Table#entities',
              'Layout::Table#get_column',
              'Layout::Table#get_row',
              'Layout::Table#initialize',
              'Layout::Table#insert_column',
              'Layout::Table#insert_row',
              'Layout::Table#merge',
              'Layout::Table#remove_column',
              'Layout::Table#remove_row',
              'Layout::TableCell#data',
              'Layout::TableCell#data=',
              'Layout::TableCell#rotation',
              'Layout::TableCell#rotation=',
              'Layout::TableCell#span',
              'Layout::TableColumn#left_edge_style',
              'Layout::TableColumn#left_edge_style=',
              'Layout::TableColumn#right_edge_style',
              'Layout::TableColumn#right_edge_style=',
              'Layout::TableColumn#width',
              'Layout::TableColumn#width=',
              'Layout::TableRow#bottom_edge_style',
              'Layout::TableRow#bottom_edge_style=',
              'Layout::TableRow#height',
              'Layout::TableRow#height=',
              'Layout::TableRow#top_edge_style',
              'Layout::TableRow#top_edge_style=',
            ],
            module: [
              'Layout',
            ],
          },
        },

        {
          version: 'SketchUp 2018',
          types: {
            class: [
              'Sketchup::ImageRep',
            ],
            method: [
              'Sketchup.send_to_layout',
              'Sketchup::Color#==',
              'Sketchup::DefinitionList#remove',
              'Sketchup::Image#image_rep',
              'Sketchup::ImageRep#bits_per_pixel',
              'Sketchup::ImageRep#color_at_uv',
              'Sketchup::ImageRep#colors',
              'Sketchup::ImageRep#data',
              'Sketchup::ImageRep#height',
              'Sketchup::ImageRep#initialize',
              'Sketchup::ImageRep#load_file',
              'Sketchup::ImageRep#row_padding',
              'Sketchup::ImageRep#save_file',
              'Sketchup::ImageRep#set_data',
              'Sketchup::ImageRep#size',
              'Sketchup::ImageRep#width',
              'Sketchup::Materials#unique_name',
              'Sketchup::Page#include_in_animation=',
              'Sketchup::Page#include_in_animation?',
              'Sketchup::SectionPlane#name',
              'Sketchup::SectionPlane#name=',
              'Sketchup::SectionPlane#symbol',
              'Sketchup::SectionPlane#symbol=',
              'Sketchup::Texture#image_rep',
              'UI.refresh_toolbars',
            ],
          },
        },

        {
          version: 'SketchUp 2017',
          types: {
            class: [
              'Sketchup::Http::Request',
              'Sketchup::Http::Response',
              'Sketchup::InstancePath',
              'UI::HtmlDialog',
              'UI::Notification',
            ],
            method: [
              'Sketchup::Entity#persistent_id',
              'Sketchup::Http::Request#body',
              'Sketchup::Http::Request#body=',
              'Sketchup::Http::Request#cancel',
              'Sketchup::Http::Request#headers',
              'Sketchup::Http::Request#headers=',
              'Sketchup::Http::Request#initialize',
              'Sketchup::Http::Request#method',
              'Sketchup::Http::Request#method=',
              'Sketchup::Http::Request#set_download_progress_callback',
              'Sketchup::Http::Request#set_upload_progress_callback',
              'Sketchup::Http::Request#start',
              'Sketchup::Http::Request#status',
              'Sketchup::Http::Request#url',
              'Sketchup::Http::Response#body',
              'Sketchup::Http::Response#headers',
              'Sketchup::Http::Response#status_code',
              'Sketchup::InputPoint#instance_path',
              'Sketchup::InstancePath#==',
              'Sketchup::InstancePath#[]',
              'Sketchup::InstancePath#each',
              'Sketchup::InstancePath#empty?',
              'Sketchup::InstancePath#include?',
              'Sketchup::InstancePath#initialize',
              'Sketchup::InstancePath#leaf',
              'Sketchup::InstancePath#length',
              'Sketchup::InstancePath#persistent_id_path',
              'Sketchup::InstancePath#root',
              'Sketchup::InstancePath#size',
              'Sketchup::InstancePath#to_a',
              'Sketchup::InstancePath#transformation',
              'Sketchup::InstancePath#valid?',
              'Sketchup::Material#save_as',
              'Sketchup::Materials#load',
              'Sketchup::Model#find_entity_by_persistent_id',
              'Sketchup::Model#instance_path_from_pid_path',
              'Sketchup::ModelObserver#onPidChanged',
              'UI.scale_factor',
              'UI.show_extension_manager',
              'UI::HtmlDialog#add_action_callback',
              'UI::HtmlDialog#bring_to_front',
              'UI::HtmlDialog#center',
              'UI::HtmlDialog#close',
              'UI::HtmlDialog#execute_script',
              'UI::HtmlDialog#initialize',
              'UI::HtmlDialog#set_can_close',
              'UI::HtmlDialog#set_file',
              'UI::HtmlDialog#set_html',
              'UI::HtmlDialog#set_on_closed',
              'UI::HtmlDialog#set_position',
              'UI::HtmlDialog#set_size',
              'UI::HtmlDialog#set_url',
              'UI::HtmlDialog#show',
              'UI::HtmlDialog#show_modal',
              'UI::HtmlDialog#visible?',
              'UI::Notification#icon_name',
              'UI::Notification#icon_name=',
              'UI::Notification#icon_tooltip',
              'UI::Notification#icon_tooltip=',
              'UI::Notification#initialize',
              'UI::Notification#message',
              'UI::Notification#message=',
              'UI::Notification#on_accept',
              'UI::Notification#on_accept_title',
              'UI::Notification#on_dismiss',
              'UI::Notification#on_dismiss_title',
              'UI::Notification#show',
            ],
            module: [
              'Sketchup::Http',
            ],
          },
        },

        {
          version: 'SketchUp 2016 M1',
          types: {
            method: [
              'Sketchup::RegionalSettings.decimal_separator',
              'Sketchup::RegionalSettings.list_separator',
            ],
            module: [
              'Sketchup::RegionalSettings',
            ],
          },
        },

        {
          version: 'SketchUp 2016',
          types: {
            class: [
              'Sketchup::Axes',
            ],
            method: [
              'Sketchup.debug_mode=',
              'Sketchup.debug_mode?',
              'Sketchup::Axes#axes',
              'Sketchup::Axes#origin',
              'Sketchup::Axes#set',
              'Sketchup::Axes#sketch_plane',
              'Sketchup::Axes#to_a',
              'Sketchup::Axes#transformation',
              'Sketchup::Axes#xaxis',
              'Sketchup::Axes#yaxis',
              'Sketchup::Axes#zaxis',
              'Sketchup::ComponentDefinition#count_used_instances',
              'Sketchup::Model#axes',
              'Sketchup::Page#axes',
              'Sketchup::PickHelper#boundingbox_pick',
              'Sketchup::PickHelper#window_pick',
              'Sketchup::Texture#write',
            ],
          },
        },

        {
          version: 'SketchUp 2015',
          types: {
            class: [
              'Sketchup::ClassificationSchema',
              'Sketchup::Classifications',
              'Sketchup::Licensing::ExtensionLicense',
            ],
            method: [
              'Sketchup.is_64bit?',
              'Sketchup::AppObserver#onActivateModel',
              'Sketchup::Camera#center_2d',
              'Sketchup::Camera#fov_is_height?',
              'Sketchup::Camera#is_2d?',
              'Sketchup::Camera#scale_2d',
              'Sketchup::ClassificationSchema#<=>',
              'Sketchup::ClassificationSchema#name',
              'Sketchup::ClassificationSchema#namespace',
              'Sketchup::Classifications#[]',
              'Sketchup::Classifications#each',
              'Sketchup::Classifications#keys',
              'Sketchup::Classifications#length',
              'Sketchup::Classifications#load_schema',
              'Sketchup::Classifications#size',
              'Sketchup::Classifications#unload_schema',
              'Sketchup::ComponentDefinition#add_classification',
              'Sketchup::ComponentDefinition#get_classification_value',
              'Sketchup::ComponentDefinition#remove_classification',
              'Sketchup::ComponentDefinition#set_classification_value',
              'Sketchup::Group#definition',
              'Sketchup::Layers#remove',
              'Sketchup::Licensing.get_extension_license',
              'Sketchup::Licensing::ExtensionLicense#days_remaining',
              'Sketchup::Licensing::ExtensionLicense#error_description',
              'Sketchup::Licensing::ExtensionLicense#licensed?',
              'Sketchup::Licensing::ExtensionLicense#state',
              'Sketchup::Material#colorize_deltas',
              'Sketchup::Material#colorize_type',
              'Sketchup::Material#colorize_type=',
              'Sketchup::Model#classifications',
              'Sketchup::Model#close',
              'Sketchup::Model#find_entity_by_id',
              'UI.select_directory',
            ],
            module: [
              'Sketchup::Licensing',
            ],
          },
        },

        {
          version: 'SketchUp 2014',
          types: {
            class: [
              'LanguageHandler',
              'Sketchup::Console',
              'Sketchup::Dimension',
              'Sketchup::DimensionLinear',
              'Sketchup::DimensionObserver',
              'Sketchup::DimensionRadial',
            ],
            method: [
              'Geom::PolygonMesh#set_uv',
              'LanguageHandler#[]',
              'LanguageHandler#initialize',
              'LanguageHandler#resource_path',
              'LanguageHandler#strings',
              'Sketchup.platform',
              'Sketchup.quit',
              'Sketchup.temp_dir',
              'Sketchup::AppObserver#expectsStartupModelNotifications',
              'Sketchup::AttributeDictionaries#count',
              'Sketchup::AttributeDictionaries#length',
              'Sketchup::AttributeDictionaries#size',
              'Sketchup::AttributeDictionary#count',
              'Sketchup::ComponentInstance#guid',
              'Sketchup::Console#clear',
              'Sketchup::Console#hide',
              'Sketchup::Console#show',
              'Sketchup::Console#visible?',
              'Sketchup::DefinitionList#size',
              'Sketchup::Dimension#add_observer',
              'Sketchup::Dimension#arrow_type',
              'Sketchup::Dimension#arrow_type=',
              'Sketchup::Dimension#has_aligned_text=',
              'Sketchup::Dimension#has_aligned_text?',
              'Sketchup::Dimension#plane',
              'Sketchup::Dimension#remove_observer',
              'Sketchup::Dimension#text',
              'Sketchup::Dimension#text=',
              'Sketchup::DimensionLinear#aligned_text_position',
              'Sketchup::DimensionLinear#aligned_text_position=',
              'Sketchup::DimensionLinear#end',
              'Sketchup::DimensionLinear#end=',
              'Sketchup::DimensionLinear#offset_vector',
              'Sketchup::DimensionLinear#offset_vector=',
              'Sketchup::DimensionLinear#start',
              'Sketchup::DimensionLinear#start=',
              'Sketchup::DimensionLinear#text_position',
              'Sketchup::DimensionLinear#text_position=',
              'Sketchup::DimensionObserver#onTextChanged',
              'Sketchup::DimensionRadial#arc_curve',
              'Sketchup::DimensionRadial#arc_curve=',
              'Sketchup::DimensionRadial#leader_break_point',
              'Sketchup::DimensionRadial#leader_break_point=',
              'Sketchup::DimensionRadial#leader_points',
              'Sketchup::Entities#active_section_plane',
              'Sketchup::Entities#active_section_plane=',
              'Sketchup::Entities#add_dimension_linear',
              'Sketchup::Entities#add_dimension_radial',
              'Sketchup::Entities#add_section_plane',
              'Sketchup::Entities#size',
              'Sketchup::EntitiesObserver#onActiveSectionPlaneChanged',
              'Sketchup::Face#get_texture_projection',
              'Sketchup::Face#set_texture_projection',
              'Sketchup::Group#guid',
              'Sketchup::Image#transformation',
              'Sketchup::Image#transformation=',
              'Sketchup::Layer#color',
              'Sketchup::Layer#color=',
              'Sketchup::Layers#size',
              'Sketchup::LayersObserver#onLayerChanged',
              'Sketchup::Materials#size',
              'Sketchup::Model#save_copy',
              'Sketchup::OptionsManager#length',
              'Sketchup::OptionsProvider#length',
              'Sketchup::Pages#length',
              'Sketchup::RenderingOptions#count',
              'Sketchup::RenderingOptions#length',
              'Sketchup::RenderingOptions#size',
              'Sketchup::SectionPlane#activate',
              'Sketchup::SectionPlane#active?',
              'Sketchup::Selection#size',
              'Sketchup::ShadowInfo#count',
              'Sketchup::ShadowInfo#length',
              'Sketchup::ShadowInfo#size',
              'Sketchup::Styles#length',
              'UI::Toolbar#count',
              'UI::Toolbar#length',
              'UI::Toolbar#size',
              'UI::WebDialog#screen_scale_factor',
            ],
          },
        },

        {
          version: 'SketchUp 2013',
          types: {
            method: [
              'SketchupExtension#extension_path',
              'SketchupExtension#id',
              'SketchupExtension#version_id',
            ],
          },
        },

        {
          version: 'SketchUp 8.0 M2',
          types: {
            class: [
              'Sketchup::ExtensionsManager',
            ],
            method: [
              'Sketchup.extensions',
              'Sketchup.install_from_archive',
              'Sketchup.plugins_disabled=',
              'Sketchup.plugins_disabled?',
              'Sketchup::ExtensionsManager#[]',
              'Sketchup::ExtensionsManager#count',
              'Sketchup::ExtensionsManager#each',
              'Sketchup::ExtensionsManager#keys',
              'Sketchup::ExtensionsManager#length',
              'Sketchup::ExtensionsManager#size',
              'SketchupExtension#check',
              'SketchupExtension#load_on_start?',
              'SketchupExtension#loaded?',
              'SketchupExtension#registered?',
              'SketchupExtension#uncheck',
            ],
          },
        },

        {
          version: 'SketchUp 8.0 M1',
          types: {
            method: [
              'Sketchup.fix_shadow_strings=',
              'Sketchup.fix_shadow_strings?',
              'Sketchup::Color#alpha=',
              'Sketchup::Material#name=',
              'Sketchup::Material#write_thumbnail',
              'Sketchup::Materials#remove',
              'UI::Command#large_icon',
              'UI::Command#menu_text',
              'UI::Command#small_icon',
              'UI::Command#status_bar_text',
              'UI::Command#tooltip',
              'UI::Toolbar#each',
              'UI::Toolbar#name',
            ],
          },
        },

        {
          version: 'SketchUp 8.0',
          types: {
            method: [
              'Sketchup::ComponentInstance#equals?',
              'Sketchup::ComponentInstance#intersect',
              'Sketchup::ComponentInstance#manifold?',
              'Sketchup::ComponentInstance#outer_shell',
              'Sketchup::ComponentInstance#show_differences',
              'Sketchup::ComponentInstance#split',
              'Sketchup::ComponentInstance#subtract',
              'Sketchup::ComponentInstance#trim',
              'Sketchup::ComponentInstance#union',
              'Sketchup::ComponentInstance#volume',
              'Sketchup::EntitiesObserver#onElementModified',
              'Sketchup::Group#equals?',
              'Sketchup::Group#intersect',
              'Sketchup::Group#manifold?',
              'Sketchup::Group#outer_shell',
              'Sketchup::Group#show_differences',
              'Sketchup::Group#split',
              'Sketchup::Group#subtract',
              'Sketchup::Group#trim',
              'Sketchup::Group#union',
              'Sketchup::Group#volume',
              'Sketchup::ModelObserver#onPostSaveModel',
              'Sketchup::ModelObserver#onPreSaveModel',
            ],
          },
        },

        {
          version: 'SketchUp 7.1 M1',
          types: {
            method: [
              'Sketchup::Curve#is_polygon?',
            ],
          },
        },

        {
          version: 'SketchUp 7.1',
          types: {
            method: [
              'Sketchup::Model#georeferenced?',
              'Sketchup::Model#number_faces',
              'Sketchup::View#refresh',
              'UI::WebDialog#write_image',
            ],
          },
        },

        {
          version: 'SketchUp 7.0 M1',
          types: {
            method: [
              'Sketchup::Face#get_glued_instances',
            ],
          },
        },

        {
          version: 'SketchUp 7.0',
          types: {
            method: [
              'Sketchup.break_edges=',
              'Sketchup.break_edges?',
              'Sketchup.is_pro?',
              'Sketchup::AppObserver#onUnloadExtension',
              'Sketchup::Behavior#no_scale_mask=',
              'Sketchup::Behavior#no_scale_mask?',
              'Sketchup::ComponentDefinition#refresh_thumbnail',
              'Sketchup::ComponentDefinition#save_as',
              'Sketchup::ComponentDefinition#save_thumbnail',
              'Sketchup::DefinitionList#load_from_url',
              'Sketchup::Group#local_bounds',
              'Sketchup::Model#active_path',
              'Sketchup::Model#edit_transform',
              'Sketchup::Model#mipmapping=',
              'Sketchup::Model#mipmapping?',
              'Sketchup::ModelObserver#onAfterComponentSaveAs',
              'Sketchup::ModelObserver#onBeforeComponentSaveAs',
              'Sketchup::ModelObserver#onExplode',
              'Sketchup::ModelObserver#onPlaceComponent',
              'Sketchup::Pages#add_matchphoto_page',
              'UI.refresh_inspectors',
              'UI::WebDialog#max_height',
              'UI::WebDialog#max_height=',
              'UI::WebDialog#max_width',
              'UI::WebDialog#max_width=',
              'UI::WebDialog#min_height',
              'UI::WebDialog#min_height=',
              'UI::WebDialog#min_width',
              'UI::WebDialog#min_width=',
              'UI::WebDialog#navigation_buttons_enabled=',
              'UI::WebDialog#navigation_buttons_enabled?',
              'UI::WebDialog#set_full_security',
            ],
          },
        },
      ].freeze

      INSTANCE_METHODS = %i[
        active_path
        active_path=
        active_section_plane
        active_section_plane=
        active_tool
        add_classification
        add_dimension_linear
        add_dimension_radial
        add_matchphoto_page
        add_section_plane
        aligned_text_position
        aligned_text_position=
        arc_curve
        arc_curve=
        attached_to
        attached_to=
        boundingbox_pick
        camera_modified?
        center_2d
        classifications
        clip_to_margins?
        clip_to_margins=
        colorize_deltas
        colorize_type
        colorize_type=
        count_used_instances
        dash_scale
        days_remaining
        drawing_element_visible?
        edit_transform
        effects_modified?
        end_attached_to
        end_attached_to=
        error_description
        expectsStartupModelNotifications
        extension_path
        find_entity_by_id
        find_entity_by_persistent_id
        fov_is_height?
        georeferenced?
        get_classification_value
        get_drawingelement_visibility
        get_glued_instances
        get_texture_projection
        has_aligned_text?
        has_aligned_text=
        icon_name
        icon_name=
        icon_tooltip
        icon_tooltip=
        image_rep
        in_front?
        in_front=
        include_in_animation?
        include_in_animation=
        instance_path
        instance_path_from_pid_path
        is_polygon?
        large_icon
        layers_modified?
        leader_break_point
        leader_break_point=
        leader_points
        line_style
        line_style=
        line_styles
        load_from_url
        load_on_start?
        load_schema
        local_bounds
        lower_left
        lower_right
        major_color=
        major_spacing=
        menu_text
        minor_color=
        minor_divisions=
        mipmapping?
        mipmapping=
        navigation_buttons_enabled?
        navigation_buttons_enabled=
        no_scale_mask?
        no_scale_mask=
        number_faces
        offset_vector
        offset_vector=
        outer_shell
        owner_type
        persistent_id
        persistent_id_path
        refresh_thumbnail
        remove_classification
        reset_camera
        reset_effects
        reset_layers
        reset_style
        same_direction?
        scale_2d
        screen_scale_factor
        set_can_close
        set_classification_value
        set_download_progress_callback
        set_drawingelement_visibility
        set_full_security
        set_on_closed
        set_texture_projection
        set_upload_progress_callback
        set_uv
        show_differences
        show_major=
        show_minor=
        sketch_plane
        small_icon
        start_attached_to
        start_attached_to=
        status_bar_text
        style_modified?
        text_bounds
        unit_vector?
        unload_schema
        upper_left
        upper_right
        winding
        window_pick
      ].freeze

      OBSERVER_METHODS = %i[
        onActivateModel
        onActiveSectionPlaneChanged
        onAfterComponentSaveAs
        onBeforeComponentSaveAs
        onElementModified
        onExplode
        onLayerChanged
        onPidChanged
        onPlaceComponent
        onPostSaveModel
        onPreSaveModel
        onTextChanged
        onUnloadExtension
      ].freeze

    end
  end
end
