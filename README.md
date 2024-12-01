# Book Scraper CLI - Extracción y Consulta de Libros

♦️ Este proyecto es un **script en Ruby** que extrae información de libros desde [Books to Scrape](https://books.toscrape.com/), la almacena en una base de datos PostgreSQL y permite consultar los datos a través de una interfaz de línea de comandos (CLI). ♦️

## Funciones 📖

- Extracción de datos de libros como título, precio, disponibilidad y calificación.
- Almacenamiento en una base de datos PostgreSQL.
- Interfaz CLI para consultar información de libros.
- Sistema de caché para optimizar las consultas.
- Pruebas unitarias implementadas con RSpec.

---

## 🛠️ Requisitos

Hay que tener instalados los siguientes programas y librerías antes de comenzar:

- **Ruby** (versión 3.0.2 o superior)
- **Bundler** (gestor de dependencias Ruby)
- **PostgreSQL** (con una base de datos configurada, ususario y contraseña)
- **Gems utilizadas:**
  - `sequel` - ORM para manejar PostgreSQL.
  - `pg` - Conector PostgreSQL.
  - `nokogiri` - Para la extracción de datos HTML.
  - `rspec` - Para pruebas unitarias.

---

## 🚀 Instalación

Sigue estos pasos para instalar y configurar el proyecto:

1. Clona este repositorio:

   ```bash
   git clone https://github.com/tu-usuario/ruby-book-scraper.git
   cd book_scraper
   
2. Instala las dependencias:
   ```bash
   bundle install

3. Configura tu base de datos en el proyecto con tu usuario y password:
   ```bash
   DB = Sequel.connect('postgres://usuario:password@localhost/books_db')

4. Ejecuta el script. Incluí 2 scripts, uno llamado book_scraper.rb y otro book_scraper_cache.rb:
   Uno sin la funcionalidad del caché y otra con
   ![2024-12-01_15-13](https://github.com/user-attachments/assets/9bfd3525-f0de-404c-820a-fa039cf6c719)

   ```bash
   ruby book_scraper.rb
   ruby book_scraper_cache.rb
  Utilizar la opción 1 para llenar la base de datos con los libros.

6. Ejecuta las pruebas:
   ```bash
   rspec spec/book_scraper_spec.rb
