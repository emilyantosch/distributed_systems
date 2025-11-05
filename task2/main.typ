#import "@preview/grape-suite:3.1.0": seminar-paper, german-dates, citation
#import "@preview/equate:0.3.2": equate
#import "@preview/frame-it:1.2.0": *
#import "@preview/codly:1.0.0": *
#show: codly-init.with()

#show: equate.with(breakable: true, sub-numbering: true)
#set math.equation(numbering: "(1.1)")

#let (bsolution, code) = frames(
    bsolution: ("Lösung",),
    code: ("Code",)
)

#show: frame-style(styles.boxy)

#codly(languages: (
  java: (
    name: text(font: "JetBrainsMono NFM", " Java", weight: "bold"),
    icon: text(font: "JetBrainsMono NFM", "\u{e738}", weight: "bold"),
    color: rgb("#CE412B"),
  ),
  c: (
    name: text(font: "JetBrainsMono NFM", " C", weight: "bold"),
    icon: text(font: "JetBrainsMono NFM", "\u{e61e}", weight: "bold"),
    color: rgb("#5612EC"),
  ),
  python: (
    name: text(font: "JetBrainsMono NFM", " Python", weight: "bold"),
    icon: text(font: "JetBrainsMono NFM", "\u{e73c}", weight: "bold"),
    color: rgb("#79C635"),
  )
))

#import seminar-paper: todo, definition, sidenote
#import citation: *

#show: seminar-paper.project.with(
    title: "Einsendeaufgabe 2",
    subtitle: "Kommunikation, Namen und Koordination",

    university: [FernUniversität in Hagen],
    faculty: [Fakultät für Mathematik und Informatik],
    docent: [Prof. Dr. Christian Icking],
    institute: [Kooperative Systeme],
    seminar: [Verteilte Systeme],
    show-declaration-of-independent-work: false,
    semester: german-dates.semester(datetime.today()),

    submit-to: [Eingereicht bei],
    submit-by: [Eingereicht durch],

    author: "Emily Lucia Antosch",
    email: "emilyluciaantosch@web.de",
    address: [
        Hamburg
    ]
)

= Aufgabe 2.1

Ein Client führt RPCs auf einem Einprozessorsystem aus, angesprochene Server
verfügen aber über genügend Prozessorkapazitäten. Setzen wir nun folgende
Zeitanforderungen voraus, um Gesamtzeiten zu berechnen: Bei jedem RPC benötigt
der Client zunächst 5 Millisekunden, um den Server zu lokalisieren, auf dem der
Aufruf ausgeführt werden soll. Marshaling und Unmarshaling kosten jeweils 0,5
Millisekunden, sowohl auf dem Client als auch auf dem Server. Der Server
braucht 10 Millisekunden für die Bearbeitung einer Anfrage. Die lokalen Betriebssysteme
beim Client und beim Server benötigen jeweils 0,5 Millisekunden Rechenzeit,
um eine der Operationen send und receive auszuführen. Die Übertragung einer
Nachricht zwischen den Client und Server dauert 3 Millisekunden. Andere
Zeiten werden zur Vereinfachung ignoriert.

#bsolution[Lösung 1.1.1][



]

#pagebreak()

= Aufgabe 2.2

Erklären Sie kurz, wie Publish-Subscribe-Systeme sich von (klassischen) eng
gekoppelten Systemen unterscheiden.

#bsolution[Lösung 2.2][]

#pagebreak()

= Aufgabe 2.3

#bsolution[Lösung 2.3][]
#pagebreak()

= Aufgabe 2.4

#bsolution[Lösung 2.4][]
#pagebreak()

= Aufgabe 2.5


#bsolution[Lösung 2.5][]
