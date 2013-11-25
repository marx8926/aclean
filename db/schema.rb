# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131123155655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "asistencia", primary_key: "int_asistencia_id", force: true do |t|
    t.string   "var_asistencia_asistio", limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "persona_id"
    t.integer  "servicio_id"
  end

  add_index "asistencia", ["persona_id"], name: "index_asistencia_on_persona_id", using: :btree
  add_index "asistencia", ["servicio_id"], name: "index_asistencia_on_servicio_id", using: :btree

  create_table "constantes", primary_key: "int_constante_id", force: true do |t|
    t.string   "var_constante_descripcion", limit: 50
    t.integer  "int_constante_valor"
    t.integer  "int_constante_clase"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diezmos", id: false, force: true do |t|
    t.integer  "int_diezmo_id"
    t.decimal  "dec_diezmo_monto",                precision: 18, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "var_diezmo_peticion", limit: 200
    t.integer  "persona_id"
  end

  add_index "diezmos", ["persona_id"], name: "index_diezmos_on_persona_id", using: :btree

  create_table "direccions", primary_key: "int_direccion_id", force: true do |t|
    t.string   "var_direccion_descripcion", limit: 100
    t.string   "var_direccion_referencia",  limit: 100
    t.float    "dou_direccion_longitud"
    t.float    "dou_direccion_latitud"
    t.string   "var_direccion_estado",      limit: 1
    t.integer  "ubigeo_id"
    t.integer  "persona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "direccions", ["persona_id"], name: "index_direccions_on_persona_id", using: :btree
  add_index "direccions", ["ubigeo_id"], name: "index_direccions_on_ubigeo_id", using: :btree

  create_table "iglesia", primary_key: "int_iglesia_id", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "dat_iglesia_fecCreacion"
    t.string   "var_iglesia_telefono",    limit: 18
    t.string   "var_iglesia_siglas",      limit: 20
    t.string   "var_iglesia_direccion",   limit: 150
    t.string   "var_iglesia_referencia",  limit: 150
    t.float    "dou_iglesia_longitud"
    t.float    "dou_iglesia_latitud"
    t.integer  "ubigeo_id"
  end

  add_index "iglesia", ["ubigeo_id"], name: "index_iglesia_on_ubigeo_id", using: :btree

  create_table "lugars", primary_key: "int_lugar_id", force: true do |t|
    t.string   "var_lugar_descripcion", limit: 100
    t.string   "var_lugar_estado",      limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nivel_crecimientos", primary_key: "int_nivelcrecimiento_id", force: true do |t|
    t.integer  "int_nivelcrecimiento_escala"
    t.integer  "int_nivelcrecimiento_estadoActual"
    t.integer  "persona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nivel_crecimientos", ["persona_id"], name: "index_nivel_crecimientos_on_persona_id", using: :btree

  create_table "ofrendas", primary_key: "int_ofrenda_id", force: true do |t|
    t.decimal  "dec_ofrenda_monto",         precision: 18, scale: 2
    t.datetime "dec_ofrenda_fechaRegistro"
    t.integer  "servicio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ofrendas", ["servicio_id"], name: "index_ofrendas_on_servicio_id", using: :btree

  create_table "personas", primary_key: "int_persona_id", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "var_persona_nombres",       limit: 45
    t.string   "var_persona_apellidos",     limit: 45
    t.integer  "int_persona_edad"
    t.date     "dat_persona_fecNacimiento"
    t.string   "var_persona_sexo",          limit: 1
    t.string   "var_persona_dni",           limit: 10
    t.string   "var_persona_estado",        limit: 1
    t.string   "var_persona_email"
    t.integer  "iglesia_id"
    t.integer  "lugar_id"
  end

  add_index "personas", ["iglesia_id"], name: "index_personas_on_iglesia_id", using: :btree
  add_index "personas", ["lugar_id"], name: "index_personas_on_lugar_id", using: :btree

  create_table "servicios", primary_key: "int_servicio_id", force: true do |t|
    t.string   "var_servicio_nombre", limit: 150
    t.integer  "int_servicio_tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sms", primary_key: "int_sms_id", force: true do |t|
    t.string   "var_sms_mensaje",          limit: 250
    t.datetime "dat_detallesms_fechahora"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "telefonos", primary_key: "int_telefono_id", force: true do |t|
    t.integer  "int_telefono_tipo"
    t.string   "var_telefono_codigo", limit: 5
    t.string   "var_telefono",        limit: 18
    t.integer  "persona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "telefonos", ["persona_id"], name: "index_telefonos_on_persona_id", using: :btree

  create_table "turnos", primary_key: "int_turno_id", force: true do |t|
    t.string   "var_turno_horaInicio", limit: 10
    t.string   "var_turno_horaFin",    limit: 10
    t.integer  "int_turno_dia"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ubigeos", primary_key: "int_ubigeo_id", force: true do |t|
    t.string   "string_ubigeo_descripcion", limit: 50
    t.integer  "int_ubigeo_departamento"
    t.integer  "int_ubigeo_provincia"
    t.integer  "int_ubigeo_distrito"
    t.integer  "int_ubigeo_dependencia"
    t.float    "float_ubigeo_latitud"
    t.float    "float_ubigeo_longitud"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
