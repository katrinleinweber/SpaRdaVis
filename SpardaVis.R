# CSV-Dateien der Sparda-Bank auswerten & visualisieren
# von: Katrin Leinweber
# im: Juni 2016

# lade Pakete
library(ggplot2)
library(scales)   # date_format

# lies CSV ein; runterladen von Sparda Konto-Center > Umsätze > Umsatzsuche, 
# nach Ausweitung des Zeitraums via Umsatzsuche
Sparda <- read.csv2("umsaetze-8535374-2016-09-11-13-59-55.csv", 
                    header    = T, 
                    skip      = 10, 
                    row.names = NULL  # Dank an http://stackoverflow.com/a/8854469/4341322
                    # noetig, weil Buchungs- & Wertstellungstag gleich sind, 
                    # sodass R `duplicate 'row.names'` vermutet, was 
                    # `not allowed` ist :-/
                    )

# durch `row.names = NULL` verrutschte Spaltennamen einmalig zurechtruecken
if (names(Sparda[1]) == "row.names") {
  colnames(Sparda) <- colnames(Sparda)[2:ncol(Sparda)]
}

# falsch encodierten Spaltennamen verbessern
names(Sparda)[5] <- make.names("Waehrung")

# loesche letzte Reihe & Spalte; Dank an http://r.789695.n4.nabble.com/remove-last-row-of-a-data-frame-td4652858.html
Sparda <- Sparda[-nrow(Sparda),]
Sparda <- Sparda[,-ncol(Sparda)]

# korrigiere Datentypen der Spalten 
Sparda$Buchungstag <- as.Date(Sparda$Buchungstag,
                              format = "%d.%m.%Y"
                              )
Sparda$Wertstellungstag <- as.Date(Sparda$Wertstellungstag,
                                   format = "%d.%m.%Y"
                                   )

# entferne Tausenderpunkte & wandle Dezimalkomma in -punkt um
Sparda$Umsatz <- gsub(pattern = "\\.", 
                      replacement = "", 
                      x = Sparda$Umsatz
                      )
Sparda$Umsatz <- gsub(pattern = ",", 
                      replacement = "\\.", 
                      x = Sparda$Umsatz
                      )
Sparda$Umsatz <- as.numeric(Sparda$Umsatz)
