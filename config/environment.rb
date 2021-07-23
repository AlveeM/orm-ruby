require "bundler/setup"
Bundler.require

require_all "lib"
require_relative "../db/seeds.rb"

DB = {
  conn: SQLite3::Database.new('./db/quote.db')
}

Quote.create_table
