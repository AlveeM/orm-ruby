# Quote Attributes
# - author
# - content

# quote = Quote.new(author: "John", content: "I love Flutter!")
# quote = Quote.create(author: "Einstein", content: "Doing the same thing over and over and expecting different results is a sign of insanity")

class Quote
  attr_accessor :author, :content
  attr_reader :id

  def initialize(author: , content: , id: nil)
    @id = id
    @author = author
    @content = content
  end

  def save
    quote = Quote.find_by_id(self.id)

    if quote
      self.update
    else
      sql = <<-SQL
        INSERT INTO quotes (author, content)
        VALUES (?, ?)
      SQL
    
      DB[:conn].execute(sql, self.author, self.content)
      
      @id = DB[:conn].last_insert_row_id()
      self
    end
  end

  def update
    sql = <<-SQL
      UPDATE quotes
      SET author = ?, content = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.author, self.content, self.id)
    self
  end
  
  def self.create(author: , content:)
    quote = Quote.new(author: author, content: content)
    quote.save
  end

  def self.all 
    sql = "SELECT * FROM quotes"

    DB[:conn].execute(sql).map do |row|
      Quote.new_from_row(row)
      # id = row[0]
      # author = row[1]
      # content = row[2]
      # Quote.new(id: id, author: author, content: content)
    end
  end

  def self.find_by_id(id) 
    sql = <<-SQL
      SELECT * FROM quotes
      WHERE id = ?
    SQL

    row = DB[:conn].execute(sql, id)[0]

    if row == nil
      nil
    else
      Quote.new_from_row(row)
    end
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS quotes (
        id INTEGER PRIMARY KEY,
        author TEXT,
        content TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  private

  def self.new_from_row(row)
    id = row[0]
    author = row[1]
    content = row[2]
    Quote.new(id: id, author: author, content: content)
  end
end