require 'spec_helper'

describe 'Kook::Outline#kook_outline' do
  it 'provides the expected outline for a slightly complex structure' do
    xhtml = %Q(
    <!DOCTYPE html>
    <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Test XHTML</title>
    </head>

    <body>

        <div>
        <h1>Prologue</h1>
        <p>The prologue!</p>
        <h2>Subprologue</h2>
        <p>The subprologue</h2>
        </div>

        <h1>Chapter 1</h1>
        <p>The first paragraph of Chapter 1.</p>
        <section>
          <p>The text of an untitled section.</p>
        </section>

        <section>
          <h1>Subchapter</h1>
          <p>The text of an titled section.</p>
        </section>

    </body>
    </html>
      )
    
    doc = Nokogiri.XML(xhtml)
    doc.extend(Kook::Outline)

    doc.kook_outline.map{|s| s.heading}.should eql(['Prologue', 'Chapter 1'])
    doc.kook_outline.first.children.map{|s| s.heading}.should eql(['Subprologue'])
    doc.kook_outline.last.children.map{|s| s.heading}.should eql(['Untitled Section','Subchapter'])

  end

  it 'provides the expected outline for MDN example 1' do
    xhtml = %Q(
          <!DOCTYPE html>
    <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
    <head>
    </head>
        <body>

      <div class="section" id="forest-elephants" >
      <h1>Forest elephants</h1>
      <p>In this section, we discuss the lesser known forest elephants.
      ...this section continues...
      <div class="subsection" id="forest-habitat" >
      <h2>Habitat</h2>
      <p>Forest elephants do not live in trees but among them.
      ...this subsection continues...
      </div>
      </div>

      </body>
    </html>
    )

    doc = Nokogiri.XML(xhtml)
    doc.extend(Kook::Outline)

    doc.kook_outline.map{|s| s.heading}.should eql(['Forest elephants'])
    doc.kook_outline.first.children.map{|s| s.heading}.should eql(['Habitat'])
  end

  it 'provides the expected outline for MDN example 2' do

    xhtml = %Q(
          <!DOCTYPE html>
        <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
        <head>

                <title>Test XHTML</title>

        </head>
        <body>

      <section>
          <h1>Forest elephants</h1>
          <section>
            <h1>Introduction</h1>
            <p>In this section, we discuss the lesser known forest elephants.</p>
          </section>
          <section>
            <h1>Habitat</h1>
            <p>Forest elephants do not live in trees but among them.</p>
          </section>
          <aside>
            <p>advertising block</p>
          </aside>

        </section>
        <footer>
          <p>c 2010 The Example company</p>
        </footer>
      </body>
    </html>

      )

      doc = Nokogiri.XML(xhtml)
      doc.extend(Kook::Outline)

      doc.kook_outline.first.children.map{|s| s.heading}.should eql(['Forest elephants'])
      doc.kook_outline.first.children.first.children.map{|s| s.heading}.should eql(['Introduction', 'Habitat', 'Untitled Aside'])

  end

  it 'provides the expected outline for SM example 1' do

    xhtml = %Q(

        <!DOCTYPE html>
        <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
        <head>

                <title>Test XHTML</title>

        </head>
        <body>


      <h1>Horses for sale</h1>

         <h2>Mares</h2>

         <article>
            <h3>Pink Diva</h3>
            <p>Pink Diva has given birth to three Grand National winners.</p>
         </article>

         <article>
            <h3>Ring a Rosies</h3>
            <p>Ring a Rosies has won the Derby three times.</p>
         </article>
       
         <article>
            <h3>Chelsea's Fancy</h3>
            <p>Chelsea's Fancy has given birth to three Gold Cup winners.</p>
         </article>

            </body>
          </html>
      )

      doc = Nokogiri.XML(xhtml)
      doc.extend(Kook::Outline)

      doc.kook_outline.map{|s| s.heading}.should eql(['Horses for sale'])
      doc.kook_outline.first.children.map{|s| s.heading}.should eql(['Mares','Pink Diva', 'Ring a Rosies', 'Chelsea\'s Fancy'])

  end

end