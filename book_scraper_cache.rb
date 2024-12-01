require 'sequel'
require 'pg'
require 'nokogiri'
require 'open-uri'

DB = Sequel.connect('postgres://diego:030199@localhost/books_db')

# Crea la tabla de libros si no existe
DB.create_table? :books do
  primary_key :id
  String :title
  String :price
  String :availability
  String :rating
end

class Book < Sequel::Model(:books)
end

CACHE = {}

# Extrae la información de los libros desde la página
def scrape_books
  url = "https://books.toscrape.com/catalogue/page-1.html"
  loop do
    doc = Nokogiri::HTML(URI.open(url))
    books = doc.css('.product_pod')

    books.each do |book|
      title = book.at_css('h3 a')['title']
      price = book.at_css('.price_color').text
      availability = book.at_css('.availability').text.strip
      rating = book.at_css('.star-rating')['class'].split.last

      # Guarda el libro en la base de datos
      Book.create(title: title, price: price, availability: availability, rating: rating)
    end

    next_page = doc.at_css('.next a')
    break unless next_page
    url = "https://books.toscrape.com/catalogue/#{next_page['href']}"
  end
  puts "Datos de libros extraídos y almacenados exitosamente."
end

# Interfaz de línea de comandos
def menu
  loop do
    puts "\n--- MENÚ ---"
    puts "1. Extraer libros de la web"
    puts "2. Buscar libro por título"
    puts "3. Salir"
    print "Selecciona una opción: "

    case gets.chomp
    when "1"
      scrape_books
    when "2"
      print "Introduce el título del libro: "
      title = gets.chomp
      search_book(title)
    when "3"
      puts "¡Adiós!"
      break
    else
      puts "Opción inválida. Intenta de nuevo."
    end
  end
end

def search_book(title)
  # Verificar si el libro ya está en la caché
  if CACHE[title]
    puts "Caché: Mostrando libro desde la caché."
    book = CACHE[title]
  else
    book = Book.where(Sequel.ilike(:title, "%#{title}%")).first
    CACHE[title] = book if book # Si no está se guarda en la caché
  end

  if book
    puts "\nTítulo: #{book[:title]}"
    puts "Precio: #{book[:price]}"
    puts "Disponibilidad: #{book[:availability]}"
    puts "Calificación: #{book[:rating]}"
  else
    puts "Libro no encontrado."
  end
end

menu
