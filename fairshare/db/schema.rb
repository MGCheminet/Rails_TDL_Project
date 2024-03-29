# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_19_020658) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "divisiones", force: :cascade do |t|
    t.float "monto"
    t.string "paga"
    t.string "recibe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gastos", force: :cascade do |t|
    t.float "monto"
    t.string "descripcion"
    t.date "fecha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id"
    t.bigint "grupo_id", null: false
    t.index ["grupo_id"], name: "index_gastos_on_grupo_id"
  end

  create_table "grupos", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "created_by"
  end

  create_table "grupos_usuarios", force: :cascade do |t|
    t.bigint "grupo_id", null: false
    t.bigint "usuario_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grupo_id"], name: "index_grupos_usuarios_on_grupo_id"
    t.index ["usuario_id"], name: "index_grupos_usuarios_on_usuario_id"
  end

  create_table "sesions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.datetime "deleted_at"
    t.boolean "blocked"
    t.index ["deleted_at"], name: "index_usuarios_on_deleted_at"
  end

  add_foreign_key "gastos", "grupos"
  add_foreign_key "grupos_usuarios", "grupos"
  add_foreign_key "grupos_usuarios", "usuarios"
end
