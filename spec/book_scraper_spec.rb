require 'sequel'
require 'pg'
require 'nokogiri'
require 'open-uri'
require 'rspec'

# Configuración de la base de datos de prueba
DB = Sequel.connect('postgres://diego:030199@localhost/books_db_test')

# Crea la tabla de libros si no existe (para las pruebas)
DB.create_table? :books do
  primary_key :id
  String :title
  String :price
  String :availability
  String :rating
end

class Book < Sequel::Model(:books)
end

# Simulación de los métodos de extracción
describe 'Book Scraper' do
  # Definimos una caché simple
  CACHE = {}

  before(:each) do
    Book.create(title: "Test Book", price: "10.00", availability: "In Stock", rating: "Five")
  end

  after(:each) do
    Book.dataset.delete # Se eliminan todos los registros
    CACHE.clear         # Se limpia la caché después de cada prueba
  end

  it 'should retrieve a book from the database' do
    book = Book.where(title: 'Test Book').first
    expect(book).not_to be_nil
    expect(book[:title]).to eq("Test Book")
    expect(book[:price]).to eq("10.00")
    expect(book[:availability]).to eq("In Stock")
    expect(book[:rating]).to eq("Five")
  end

  it 'should cache book results for faster access' do
    first_search = Book.where(title: 'Test Book').first
    CACHE['Test Book'] = first_search  # Se almacena el resultado en la caché
    second_search = CACHE['Test Book'] # Se recupera el resultado de la caché

    expect(first_search).to eq(second_search)
  end
end
