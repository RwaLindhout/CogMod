
(clear-all)

(define-model beverbende
    
(sgp :v nil :esc t :lf 0.4 :bll 0.5 :ans 0.5 :rt 0 :ncnar nil)

(sgp :show-focus t)

;Sla per positie per speler op wat de upper en lower waarde kunnen zijn en wat avg is. 
(chunk-type card player position lower upper avg)
;Goal chunk houdt de status van de game bij. Maar ook de score van het model en de 3 tegenstanders voor deze ronde
;Dat is dus de schatting van de waarde voor jezelf en de drie andere spelers. 
(chunk-type goal state model-score opp1 opp2 opp3)
;PROBLEM: Hoe ga je bijhouden wat de geschatte waarden van de opponents zijn. Model is inactive namelijk gedurende de beurten van de andere spelers.
;		  Dit zul je dus waarschijnlijk via swift moeten fixen

;SWIFT: Deze chunk is alleen voor het begin van het spel aangezien je dan meekrijgt wat je meest linker en rechter kaart zijn
(chunk-type start-info left right)
;SWIFT: Get the value of the disard card and the first drawn card, then you can decide. 
;If the draw the special card where you can go twice, this chunk will be requested from swift repeatedly. 
(chunk-type moves discard draw)

(add-dm
 (player1 ISA card player 0 position 1 lower 0 upper 9 avg 5)
 (player2 ISA card player 0 position 2 lower 0 upper 9 avg 5)
 (player3 ISA card player 0 position 3 lower 0 upper 9 avg 5)
 (player4 ISA card player 0 position 4 lower 0 upper 9 avg 5)
 (opp11 ISA card player 1 position 1 lower 0 upper 9 avg 5)
 (opp12 ISA card player 1 position 2 lower 0 upper 9 avg 5)
 (opp13 ISA card player 1 position 3 lower 0 upper 9 avg 5)
 (opp14 ISA card player 1 position 4 lower 0 upper 9 avg 5)
 (opp21 ISA card player 2 position 1 lower 0 upper 9 avg 5)
 (opp22 ISA card player 2 position 2 lower 0 upper 9 avg 5)
 (opp23 ISA card player 2 position 3 lower 0 upper 9 avg 5)
 (opp24 ISA card player 2 position 4 lower 0 upper 9 avg 5)
 (opp31 ISA card player 3 position 1 lower 0 upper 9 avg 5)
 (opp32 ISA card player 3 position 2 lower 0 upper 9 avg 5)
 (opp33 ISA card player 3 position 3 lower 0 upper 9 avg 5)
 (opp34 ISA card player 3 position 4 lower 0 upper 9 avg 5)
 
 (goal isa goal) (attending) (count) (counting)(my-turn)(start-game)
 (clear-imaginal)(look-at-cards)(compare-discard)(compare-draw)
  (goal isa goal state start-game)
 )

;(set-all-base-levels 100000 -1000)
(goal-focus goal)

;Helemaal aan het begin van de game zul je naar je twee buitenste kaarten moeten kijken
;Dit komt mee vanuit swift in de vorm van een start-info chunk


;At the very beginning of the game we look at our two outer cards. And these are saved in declarative memory. 
(P start-game
   =goal>
      ISA       goal
      state     start-game
   =action>
      ISA       start-info
      left      =pos1
      right     =pos4
  ?imaginal>
      buffer    empty
      state     free
==>
  =goal>
      ISA       goal
      state     look-at-cards
  =action>
  +imaginal>
      ISA       card
      player    0
      position  1
      lower     nil     ;set to nill indicating that we know the values rather than just an estimate
      upper     nil
      avg       =pos1
   )


;Here we look at the second card and then wait for our turn, so hand over control to the app. 
(P start-game
   =goal>
      ISA       goal
      state     look-at-cards
   =action>
      ISA       start-info
      left      =pos1
      right     =pos4
   ?imaginal>
      buffer    empty
      state     free
==>
  =goal>
      ISA       goal
      state     wait-for-turn
  +imaginal>
      ISA       card
      player    0
      position  4
      lower     nil     ;set to nill indicating that we know the values rather than just an estimate
      upper     nil
      avg       =pos4
   +action>
      ISA       moves
   )
 

 ;SWIFT; Op dit punt zou vanuit swift de goal state naar wait-for-turn moeten worden gezet en in de action buffer mag de bovenste kaart van de draw pile en discard pile. 

 ;Je wil in het begin meekrijgen vanuit swift wat je waarde van de dicard pile is. Dan zul je aan het
 ;begin van de beurt moeten bepalen of je die discard wil gebruiken of niet. Zo niet dan ga je een
 ;request maken via de +action buffer om een kaart te pakken en wacht je tot swift je die waarde geeft. 
 ;adhv daarvan kun je dan bepalen wat je gaat doen met die kaart. 

(P start-my-turn
   =goal>
      ISA         goal
      state       wait-for-turn
   =action>
      ISA         moves
      discard     =discard
      draw        =draw
==>
   =goal>
      state       compare-discard
   =action>   ;No strict harvesting
   +retrieval>
      ISA         card
      player      0
   >  avg         =discard
)

;If we were able to find a card with a higher average than the card from the discard pile in our own deck
;then we take the card from the discard pile and swap. 
;We also let the app know that we made our decision, which can then be shown and we'll wait for our next turn. 
(P take-discard-card
   =goal>
      ISA         goal
      state       compare-discard
   =retrieval>
      ISA         card
      player      0
      position    =pos
   =action>
      ISA         moves
      discard     =discard
      draw        =draw
   ?imaginal>
      buffer    empty
      state     free
==>
  =goal>
      ISA         goal
      state       end-turn
  +imaginal>
      ISA         card
      player      0
      position    pos
      lower       nil     ;set to nill indicating that we know the values rather than just an estimate
      upper       nil
      avg         =discard
  +action>
      action      took-discard
      position    =pos
      value       =discard
  )


;TODO: Hier productions toevoegen met speciale cases voor de drie speciale kaarten. 

;If we were unable to find a card of our own with a higher value than the discard pile we will not take 
;the discard card but rather we will draw a card and look at that. So we will search for a card of our own
;with a higher value as the drawn card. 
(P do-not-take-discard-card
   =goal>
      ISA         goal
      state       compare-discard
   ?retrieval>
     buffer  failure
   =action>
      ISA         moves
      discard     =discard
      draw        =draw
==>
  =goal>
      ISA         goal
      state       compare-draw
   =action>   ;No strict harvesting
   +retrieval>
      ISA         card
      player      0
   >  avg         =draw
  )


;If we found a card with a higher value than the drawn card we will swap and let the app know what we did. 
;We also make a new chunk containing the updated information on which cards we check. 
(P take-draw-card
   =goal>
      ISA         goal
      state       compare-draw
   =retrieval>
      ISA         card
      player      0
      position    =pos
   =action>
      ISA         moves
      discard     =discard
      draw        =draw
   ?imaginal>
      buffer    empty
      state     free
==>
  =goal>
      ISA         goal
      state       end-turn
  +imaginal>
      ISA         card
      player      0
      position    pos
      lower       nil     ;set to nill indicating that we know the values rather than just an estimate
      upper       nil
      avg         =draw
  +action>
      action      took-draw
      position    =pos
      value       =draw
  )


;If we were unable to find a card with a higher score then the draw card we will discard it and end our turn. 
(P do-not-take-draw-card
   =goal>
      ISA         goal
      state       compare-draw
   ?retrieval>
     buffer  failure
   =action>
      ISA         moves
      discard     =discard
      draw        =draw
==>
  =goal>
      ISA         goal
      state       end-turn
   +action>   
      action      discard-draw
      value       =draw
  )


;Hoe ga ik de acties van de andere modellen bekijken? Zoals ik het nu heb bedacht zal het model een actie
;kiezen en vervolgens wachten tot het weer zijn beurt is. Dan houdt je dus geen enkele rekening met andere
;spelers. Voor nu is het wellicht ook beter om eerst een simpele versie te implementeren die alleen naar
;de eigen kaarten kijkt en nog niets met special kaarten doet. 

;DM can direct benaderd worden vanuit Swift, dus wellicht dat dat handiger is dan vanuit ACT-R. Maar ik weet
;niet of dat dan goed gaat met de activaties etc. 


;TODO: Hoe ga ik inbouwen dat het verlagen van onzekerheid bevorderlijk is. Dus ruilen voor middelste twee
;zou een klein beetje voorrang op buitenste moeten hebben. En daarnaast zou je ook nog kunnen kijken naar
;relatieve verschil tussen kaarten ipv alleen maar of die lager is of niet. 

)