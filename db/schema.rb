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

ActiveRecord::Schema.define(version: 20151022000659) do

  create_table "caracteristicas", force: :cascade do |t|
    t.string   "nombre",      null: false
    t.string   "valor",       null: false
    t.integer  "producto_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "caracteristicas", ["producto_id"], name: "index_caracteristicas_on_producto_id"

  create_table "categorias", force: :cascade do |t|
    t.string   "nombre",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorias_productos", force: :cascade do |t|
    t.integer  "producto_id"
    t.integer  "categoria_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "categorias_productos", ["categoria_id"], name: "index_categorias_productos_on_categoria_id"
  add_index "categorias_productos", ["producto_id"], name: "index_categorias_productos_on_producto_id"

  create_table "imagenes", force: :cascade do |t|
    t.string   "public_id",   null: false
    t.integer  "producto_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "imagenes", ["producto_id"], name: "index_imagenes_on_producto_id"

  create_table "precios", force: :cascade do |t|
    t.integer  "cantidad_minima", null: false
    t.integer  "precio",          null: false
    t.integer  "producto_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "precios", ["producto_id"], name: "index_precios_on_producto_id"

  create_table "productos", force: :cascade do |t|
    t.string   "nombre",      null: false
    t.text     "descripcion"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "usuario_id"
  end

  add_index "productos", ["usuario_id"], name: "index_productos_on_usuario_id"

  create_table "usuarios", force: :cascade do |t|
    t.string   "provider",                               null: false
    t.string   "uid",                    default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nombre",                                 null: false
    t.string   "imagen"
    t.string   "email",                                  null: false
    t.string   "celular",                                null: false
    t.integer  "reputacion",             default: 0
    t.text     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "usuarios", ["email"], name: "index_usuarios_on_email"
  add_index "usuarios", ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  add_index "usuarios", ["uid", "provider"], name: "index_usuarios_on_uid_and_provider", unique: true

end
