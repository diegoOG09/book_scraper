require 'sequel'
require 'pg'
require 'nokogiri'
require 'open-uri'

DB = Sequel.connect('postgres://usuario:password@localhost/books_db')

DB.create_table? :books do
  primary_key :id
  String :title
  String :price
  String :availability
  String :rating
end

class Book < Sequel::Model(:books)
end

# Extraer la info de los libros
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

      # Guardar el libro
      Book.create(title: title, price: price, availability: availability, rating: rating)
    end

    next_page = doc.at_css('.next a')
    break unless next_page
    url = "https://books.toscrape.com/catalogue/#{next_page['href']}"
  end
  puts "-Datos extraidos y almacenados con exito-"
end


# interfaz
def menu
  loop do
    puts "\n--- MENU ---"
    puts "1. Extraer libros de la web"
    puts "2. Buscar libro por titulo"
    puts "3. Salir"
    print "Selecciona una opcion: "

    case gets.chomp
    when "1"
      scrape_books
    when "2"
      print "Introduce el titulo: "
      title = gets.chomp
      search_book(title)
    when "3"
      puts "Adios"
      break
    else
      puts "Opcion invalida. Intentalo de nuevo"
    end
  end
end

def search_book(title)
  book = Book.where(Sequel.ilike(:title, "%#{title}%")).first
  if book
    puts "\nTitulo: #{book[:title]}"
    puts "Precio: #{book[:price]}"
    puts "Disponibilidad: #{book[:availability]}"
    puts "Calificacion: #{book[:rating]}"
  else
    puts "Libro no encontrado"
  end
end

menu
