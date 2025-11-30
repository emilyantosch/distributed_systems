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
    title: "Einsendeaufgabe 1",
    subtitle: "Architekturen und Prozesse",

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

= Aufgabe 1.1
== Aufgabe 1.1.1
Eine Ressource im Internet wird durch einen Universal Resource Locator (URL)
identifiziert. Erklären Sie alle Informationen, die in
$
#link("https://www.fernuni-hagen.de/mi/studium/")
$
enthalten sind.

#bsolution[Lösung 1.1.1][
Die folgenden Infos lassen sich aus der
$
#link("https://www.fernuni-hagen.de/mi/studium/")
$
herauslesen:

- Das Protokoll ist *"https://"* (HyperText Transport Protocol Secure), welches
  für
  - Die Subdomain *"www"*, die eine Unterdomäne von "fernuni-hagen" ist.
  - Den Namen *"fernuni-hagen"* der Webseite, der mittels eines DNS dann in
  eine IP-Adresse umgewandelt wird
  - Die TLD(Top-Level-Domain) *".de"*, welche die Seite mit dem Land
  Deutschland verbindet/identifiziert.
  - Der Pfad *"/mi/studium/"*, welche den User auf eine Unterseite routet. Das
  trailing Slash deutet daraufhin, dass es sich um ein Verzeichnis handelt, was
  dann wahrscheinlich auf `index.html` weiterleitet. ]

== Aufgabe 1.1.2

Inwiefern stellt die Verwendung von URLs eine Möglichkeit dar, Ortstransparenz
zu erreichen? Warum bieten URLs mit Hilfe des DNS auch Replikationstransparenz?

#bsolution[Lösung 1.1.2][
Die Verwendung von URLs stellt eine Möglichkeit dar, Ortstransparenz zu erreichen, indem

1. die Ressourcen nicht nach geographischen Orten, sondern logisch geordnet werden,
2. die URL darüber hinaus Details des Netzwerks und dessen Topologie abstrahiert, muss sich der User nicht mit der IP-Adresse oder der Position des Servers beschäftigen und
3. die URL statisch und unveränderlich bleiben kann, auch wenn die Ressource selbst sich von einem Data Center zu einem anderen bewegt.
]

== Aufgabe 1.1.3

Betrachten wir das E-Mail-System im Internet, wobei die Prozesse Mail User
Agent und Message Transfer Agent (Mail-Server) daran beteiligt sind. Welche
Prozesse gehören zur Anwendungsschicht und welche zur Middleware-Schicht?
Welche Prozesse sind zeitlich entkoppelt (temporally decoupled), aber
referentiell gekoppelt (referentially coupled)?

#bsolution[Lösung 1.1.3][
- Der Prozess _Mail User Agent_ ist Teil der Anwendungsschicht und ist referentiell gekoppelt, aber zeitlich entkoppelt. Der _Mail User Agent_ ist direkter Teil der Anwendung, die dem User bereitgestellt wird. Um eine Nachricht zu senden, muss der _Mail User Agent_ wissen, wohin die Nachricht gehen soll (E-Mail Adresse), da sie sonst nicht dahin kommt, wo sie hin soll. Ein _Mail User Agent_, sowohl beim Senden als auch beim Empfangen muss nicht gleichzeitig aktiv sein, da die Nachricht persistent in der Middleware gespeichert werden.
- Der Prozess _Mail Transfer Agent_ ist Teil der Middleware-Schicht und ist referentiell gekoppelt, aber zeitlich entkoppelt. Der _Mail Transfer Agent_ ist Teil der Middleware-Schicht, die sich darum kümmert, dass die Nachricht, die vom Sender kommt an den Empfänger gelangt. Um eine Nachricht weiterleiten zu können, muss der _Mail Transfer Agent_ wissen, vom wem die Nachricht kommt und wohin die Nachricht gehen soll, weshalb der _Mail Transfer Agent_ referentiell gekoppelt ist. Dabei muss der _Mail Transfer Agent_, solange eine andere Middleware die Nachricht zwischenspeichert, bis der _Mail Transfer Agent_ bereit ist, nicht aktiv sein, wenn der Sender die Nachricht an den Empfänger schickt.
]


#pagebreak()

= Aufgabe 1.2

Erklären Sie kurz, wie Publish-Subscribe-Systeme sich von (klassischen) eng
gekoppelten Systemen unterscheiden.

#bsolution[Lösung 1.2][
Ein Publish-Subscriber Model definiert sich hauptsächlich darüber, dass der
Publisher und der Subscriber stark entkoppelt sind. Der Publisher und der
Subscriber kennen sich häufig nicht mal direkt. Der Publisher veröffentlich bei
einem Event eine Nachricht und ein Subscriber abonniert bestimmte Nachrichten
von Events. Die Kommunikation passiert über Middleware. Meistens müssen
Subscriber und Publisher nicht gleichzeitig aktiv sein. In einem gekoppelten
System kennen die Teilnehmer einander direkt. Kommunikation passiert über ein
Protokoll direkt und beide Teilnehmer müssen zwangsläufig aktiv sein.
]

#pagebreak()
= Aufgabe 1.3
== Aufgabe 1.3.1

Was ist der Unterschied zwischen vertikaler Verteilung (engl. vertical distribution) und
horizontaler Verteilung (engl. horizontal distribution)?

#bsolution[Lösung 1.3.1][
    - Bei vertikaler Verteilung werden verschiedene Aufgaben eines System auf verschiedene Server verteilt. Dabei übernimmt dann eine Maschine eine bestimmte Aufgabe und eine andere Maschine eine völlig andere, wobei dann Informationen zwischen den Maschinen hin- und hergeschickt werden.
    - Bei der horizontalen Verteilung werden die gleichen Aufgaben auf verschiedene Maschinen verteilt. So hat jede Maschine, die im verteilten System ist, die gleichen Aufgaben und der Load wird einfach über die Maschinen verteilt.
]

== Aufgabe 1.3.2

In einem Peer-to-Peer-System werden Ressourcen von Hosts im Internet angeboten.
Wozu benötigt man ein Overlay-Netzwerk für ein Peer-to-Peer-System?

#bsolution[Lösung 1.3.2][

    In eine P2P-System sind beide Teilnehmer, also Peer 1 und Peer 2
    gleichberechtigt und dienen sowohl als Client und Server. Häufig ist es in
    einem P2P-Netzwerk schwierig, andere Teilnehmer zu finden, eine Verbindung
    herzustellen oder eine Rechte-Struktur aufzubauen. Ein Overlay-Netwerk kann
    dann dabei helfen. Das Overlay-Netzwerk erlaubt effizientes Nachschlagen
    von möglichen Verbindungen und deterministisches Routing von Verbindungen.

]

== Aufgabe 1.3.3

Was ist ein strukturiertes Overlay-Netzwerk?


#bsolution[Lösung 1.3.3][

    Ein sturkturiertes Overlay-Netwerk ist ein Netzwerk, in dem eine
    deterministische Netzwerktopologie das Ansteuern von Nodes (Teilnehmer des
    P2P) unterstützt. Eine Netzwerktopologie kann zum Beispiel Ring oder Gitter
    sein. Dabei stellt das Netzwerk dann die Möglichkeit bereit, dass jeder
    Teilnehmer mittels einer Hash-Funktion angeprochen werden kann und über die
    logische Netzwerktopologie angeprochen werden kann.

]

== Aufgabe 1.3.4

Beim Routing in einem strukturierten Overlay-Netzwerk werden die Nachrichten gemäß
der logischen Verbindung von Peers gesendet. Ist der kürzeste Weg zwischen zwei Peers
im Overlay-Netzwerk immer auch der kürzeste Weg zwischen ihnen im physischen
Netzwerk? Begründen Sie Ihre Antwort.

#bsolution[Lösung 1.3.4][

    Nein, es wird nicht zwangsläufig der kürzeste Weg zwischen zwei Peers im
    Overlay-Netwerk genutzt. Die physische Topologie ist zwar eine Variable,
    die die Topologie des Overlay-Netwerks bestimmen kann, aber es gibt auch
    Fälle, in dem die logische Verteilung von Maschinen im Overlay-Netzwerk
    dazu führt, das logisch weit entfernte Systeme, auch wenn sie direkt
    nebeneinander physisch liegen, logisch über mehrere Nodes geleitet werden.

]

== Aufgabe 1.3.5

Wir betrachten ein System aus super peers und weak peers, das Anfragen zu Dateien
beantworten kann.
- Welche Informationen soll der Index von super peers mindestens speichern?
- Welche Informationen muss ein weak peer beim Eintreten in das System seinem super peer mitteilen?
- Was muss ein super peer tun, wenn sich ein weak peer bei ihm abmeldet?

#bsolution[Lösung 1.3.5][

- Ein Index von Super Peers muss speichern, welche Daten es überhaupt gibt. Es muss aber auch speichern, wo diese Daten im eigenen Netzwerk von Weak Peers zu finden sind.
- Ein Weak Peer muss bei der Registrierung in einem System an den Super Peer melden, wie der Super Peer den Weak Peer erreichen können (Adresse). Und ein Weak Peer muss mitteilen, welche Daten über ihn erreichbar sind.
- Wenn ein Weak Peer das System verlässt, entweder mit Absicht oder durch einen Problem, muss der Super Peer den Weak Peer aus dem Index löschen, ihn aus der Liste der verbundenen Clients löschen und die Menge an verbundenen Clienten anpassen. Wenn der Weak Peer das System mit Absicht verlässt, muss er sein Verlassen beim Super Peer anmelden. Wenn er durch ein Problem offline geht, muss der Super Peer das feststellen und ihn auch aus dem System abmelden.

]

#pagebreak()
= Aufgabe 1.4

Betrachten Sie das Python-Programm zur Client/Server-Kommunikation im Buch in
Fig 2.3 (Seite 59, Distributed Systems, Third edition, Version 3.03 (2020)).
Entwickeln Sie daraus ein Client/Server-Programm in Python über TCP, bei dem
der Client durch "send time" nach dem Datum und der Uhrzeit fragt, der Server
dies beantwortet, und der Client die Antwort zur Kontrolle ausgibt. Bringen Sie
Ihr Programm auf Ihrem Computer zum Laufen! Hinweis: Server- und Client-Prozess
können auf demselben Computer laufen, die für diesen Testzweck über die
IP-Nummer 127.0.0.1 (localhost) kommunizieren dürfen. Wählen Sie selbst feste
Portnummern. Python ist eine Programmiersprache, die immer mehr Bedeutung
gewinnt und in der jeder Informatiker Erfahrungen gesammelt haben sollte.

#bsolution[Lösung 1.4][
    #code[Client][
```python
from socket import socket, AF_INET, SOCK_STREAM

s = socket(AF_INET, SOCK_STREAM)

s.connect(("127.0.0.1", 8080))
msg = "send time"
s.send(msg.encode())
data = s.recv(1024)
print(data.decode())
s.close()
```
    ]

    #code[Server][
```python
from socket import socket, AF_INET, SOCK_STREAM
import datetime

s = socket(AF_INET, SOCK_STREAM)
s.bind(("127.0.0.1", 8080))
s.listen(5)
(conn, addr) = s.accept()
while True:
    data = conn.recv(1024)
    if not data:
        break
    msg = data.decode()
    if msg == "send time":
        now = datetime.datetime.now().__str__()
        conn.send(now.encode())
conn.close()
```
    ]
]
#pagebreak()
= Aufgabe 1.5

Wir betrachten einen Server mit einem Cache-Bereich in folgendem vereinfachten
Modell: Der Server bekommt laufend Anfragen, die in 80 % der Fälle mit Hilfe
des Cache in 5 ms beantwortet werden können. Im ungünstigeren Fall (20 %) ist
ein langsamer Festplattenzugriff und deshalb zusätzlich 25 ms nötig, hier also
30 ms pro Anfrage.

- Wie viele Anfragen pro Sekunde kann der Server maximal beantworten, wenn er
  dafür einen einzigen Prozess ohne weitere Threads einsetzt?
Wir überlegen nun, ob es vorteilhaft ist, die Anfragen auf eine feste Zahl
von mehreren parallelen Threads zu verteilen. Die Zeit zur Erzeugung,
Umschaltung und beim Scheduling von Threads soll vernachlässigt werden.

- Wie viele Anfragen pro Sekunde kann der Server höchstens mit Hilfe von
  mehreren Threads beantworten?
- Wie viele Threads sollen sinnvollerweise hier vorgesehen werden?

#bsolution[Lösung 1.5][
Wenn der Server nur einen Thread benutzt, kann er maximal

$ 1000 = x #sym.dot 0,8 #sym.dot 5 + x #sym.dot 0,2 #sym.dot 30 = x #sym.dot 4
+ x #sym.dot 6 = x #sym.dot (4 + 6) = x #sym.dot 10 #sym.arrow x = bold(100) $

Anfragen machen.

Mehrere Threads können durch die CPU-Zeit von $5 "ms"$ maximal

$ (1000 "ms") / (5 "ms/req") = bold(200 "req/s") $

machen.

Um diese Zeit auszureizen, müssen wir festlegen, dass

1. Alle CPU aktiv an etwas arbeiten (busy),
2. Wir genug Threads haben, um die maximale Anzahl an Requests zu erreichen,
3. Wir daher genug Threads für die I/O Wait Time haben.

Am Peak haben wir $200 "req/s" #sym.dot 0,2% = 40 "req/s"$. Damit brauchen wir $40 "req/s" #sym.dot 30 "ms" = 1200 "ms"$ für alle I/O-Operationen und $160 "req/s" #sym.dot 5 "ms" = 800 "ms"$ für alle Cache-Operationen.

Da wir nur von Threads und nicht von CPU-Kernen sprechen, *müssen mindestens 3 Threads laufen*, um die maximale Anzahl von Requests zu machen. Zwei Threads schaffen es in einer Sekunde nicht, mit der Menge an Anfragen fertig zu werden. Bei 3 Threads kümmern sich zwei um I/O und einer um Cache. Vereinfacht schaffen zwei Threads nach $600 "ms"$ alle I/O-Threads zu beseitigen und der dritte Thread hat bereits

$ (600 "ms") / (30 "ms/req") #sym.dot 4 = 80 "req" $

erledigt. Die restlichen $400 "ms"$ reichen dann für die restlichen $80 "req" = (400 "ms") / (5 "ms/req")$ aus.
]
