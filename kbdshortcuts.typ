#import "@preview/tablex:0.0.5": *


#let mainfont      = "Charis SIL"

#let color1 = rgb("#6e7b8b")  // LightSteelBlue4
#let color2 = rgb("#008b45")  // SpringGreen4
#let color3 = rgb("#87ceff")  // SkyBlue1
#let colors = (color1, color2, color3)

#set text (font: mainfont, size: 8pt, lang: "en" )
    
#set page( paper: "a4",
    flipped: true,
    columns: 3,
    margin: (left: 1cm, right: 1cm, top: 0.5cm, bottom: 1cm) 
)

#show heading: it => [
  #set align(center)
  #set text(12pt, weight: "bold", font: mainfont)
  #block(it.body)
  #v(5pt)
]


#let mytab(header, e, color1, color2) = {
    tablex(
        columns: (10fr, 7fr),
        rows: (13pt, 10pt),  // first, repeat for rest
        align: left + horizon,
        row-gutter: 0pt,
        stroke: none,
        auto-lines: false,
        fill: (col, row) => if calc.even(row) { color2 } else { white },
        colspanx(2, fill: color1)[#text(9pt, white)[*#header*]],
        ..e.map(
            row => (
                if row.keys().at(0) == "$twocolumn" { 
                    colspanx(2, align: center + horizon)[ #row.values().at(0) ]   } 
                else 
                    { (row.keys().at(0), row.values().at(0)) } )
        ).flatten(),
        //colspanx(2)[],
        hlinex(stroke: color1 + 3pt) //gutter-restrict: top) 
    )
} 

#let k = yaml("keyboard.yaml")

// yaml: dict mit nur einem k-v-pair, der value ist ein array 
// Jeder Eintrag im array ist wieder dict mit nur einem k-v-pair, v ist wieder array 

#let count=0
#for i in k.Kbd {
    let title = i.keys().at(0)    // key des 0ten k-v-pairs
    let list  = i.values().at(0)  // value des 0ten k-v-pairs = array
    let color1 = colors.at(count)
    let color2 = color1.lighten(65%)
    count += 1
     [ = #title ] 
   
    for j in list {
        let chap = j.keys().at(0)
        let entries = j.values().at(0)
        mytab(chap, entries, color1, color2)
        v(8pt)
        v(1fr)
    }
    v(3fr)
    if count < 3  {colbreak()}

}
