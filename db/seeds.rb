# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"
require "date"


CSV.foreach('db/ubi.csv') do |row|
	Ubigeo.create(
	  :string_ubigeo_descripcion => row[1], 
      :int_ubigeo_departamento => row[2],
      :int_ubigeo_provincia => row[3],
      :int_ubigeo_distrito => row[4],
      :int_ubigeo_dependencia => row[5],
      :float_ubigeo_latitud => row[6],
      :float_ubigeo_longitud => row[7])
end

Lugar.create(
	:var_lugar_descripcion => 'Culto',
	:var_lugar_estado => '1'
	)

Menu.create(
      :var_menu_nombre =>  "persona",
      :var_menu_path => "app.persona_guardar_path",
      :int_menu_nivel => 1,
      :int_new_dep => 1
      )

Menu.create(
      :var_menu_nombre =>  "diezmo",
      :var_menu_path => "app.diezmos_path",
      :int_menu_nivel => 1,
      :int_new_dep => 1
      )

Menu.create(
      :var_menu_nombre =>  "ofrenda",
      :var_menu_path => "app.ofrendas_path" ,
      :int_menu_nivel => 1,
      :int_new_dep => 1
      )
Menu.create(
      :var_menu_nombre =>  "asistencia",
      :var_menu_path => "app.asistencia_path",
      :int_menu_nivel => 1,
      :int_new_dep => 1
      )

Menu.create(
      :var_menu_nombre =>  "informacion",
      :var_menu_path => "informacion",
      :int_menu_nivel => 1,
      :int_new_dep => 1
      )
Menu.create(
      :var_menu_nombre =>  "configuracion",
      :var_menu_path => "configuracion",
      :int_menu_nivel => 1,
      :int_new_dep => 1
      )
