# Kook - a limited EPUB 3.0 writing library

Kook is a library that's designed for creating fairly simple EPUB books according to a slightly prescriptive formula, while handling fairly boring tasks like generating a [Table of Contents](http://www.idpf.org/epub/30/spec/epub30-contentdocs.html#sec-xhtml-nav) and ensuring that any referenced images or stylesheets are pulled in.

It generates a Table of Contents according the [HTML5 Outlines](http://www.w3.org/TR/html5/sections.html#headings-and-sections) of the contents of the book as the EPUB 3.0 spec suggests. 

## Example

```ruby
my_book = Kook::Publication.new(title:"My First Book")
my_book.content_documents << Kook::ContentDocument.new_with_path('prologue.xhtml')
my_book.content_documents << Kook::ContentDocument.new_with_path('chapter1.xhtml')
my_book.build_epub('My First Book.epub')
```
This creates a Publication object, adds two content documents and then writes the EPUB.

## Roadmap
### Bugs
- Nokogiri::XML::Document.html5_outline doesn't support hgroup (but this might be dropped from the HTML5 spec anyway)
- HTML5Section class, rather than nested hashes?
- Stop using SecureRandom.uuid and hoping for the best...
- Support all the [Core Media Types](http://www.idpf.org/epub/30/spec/epub30-publications.html#sec-core-media-types) properly.
- Support various metadata properly - different titles, multiple authors and so on.

### Features and Hopes
- Ensure that any referenced fonts are imported.
- Allow the use of kook: URIs in documents, referencing PublicationResources by epub_id or something similar.
- Sort out PublicationResource class structure - move out #new_with_uri etc. to a subclass
- Convert ToC and Cover to ContentDocument subclasses (making it trivial for them to bring in images and stylesheets)
- Provide some sort of hack to extend Sections over several Content Documents (allowing a Volume to take in several Chapters in several books). Perhaps a data attribute?
- Publication#kindle! to mutilate the ContentDocuments as necessary to better support kindlegen/MOBI and its limitations (e.g. <center> elements).

## See Also

### GEPUB
[GEPUB](https://github.com/skoji/gepub) 'provides functionality to create EPUB file, and parsing EPUB file' and has a DSL that 'privides easy and powerful way to create EPUB3 files'. It's almost certainly a better option for you than Kook, if I'm honest.

### eeepub
[eeepub](https://github.com/jugyo/eeepub) is an EPUB 2 generator.

### Rpub
[Rpub](https://github.com/avdgaag/rpub) is a command-line tool that 'generates a collection of plain text input files into an eBook in ePub format'. Notably it also brings in fonts referenced in font-face.

### ruby-epub
[ruby-epub](https://code.google.com/p/ruby-epub/) was a library for writing EPUB 2s. It hasn't been updated since 2010.